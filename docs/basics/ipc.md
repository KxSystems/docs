---
title: Interprocess communication | Developing | kdb+ and q documentation
description: TCP/IP is used for communicating between processes. The protocol is extremely simple, as is the message format.
---
# :fontawesome-solid-handshake: Interprocess communication



_Simple, powerful, fast_

<div markdown="1" class="typewriter">
[\p](syscmds.md#listening-port)  [-p](cmdline.md#listening-port)          listen to port
[hopen hclose](../ref/hopen.md)    open/close connection
[.z](../ref/dotz.md)              handle message (callbacks)
</div>

A kdb+ process can communicate with other processes through TCP/IP, which is baked into the q language. 

:fontawesome-brands-superpowers: 
[Fusion interfaces](../interfaces/index.md#fusion-interfaces)
<br>
:fontawesome-solid-handshake: 
[Clients for kdb+](../interfaces/c-client-for-q.md) 

!!! tip "This page discusses TCP/IP sockets, but there are other types of IPC, that use the familiar open/request/close paradigm. All use [`hopen`](../ref/hopen.md#) to connect."

:fontawesome-solid-book-open:
[Connection handles](handles.md),
[File system](files.md)


## Listen for connections

A kdb+ process can define a [listening port](listening-port.md) at start-up or at runtime. 
kdb+ can receive messages over TCP, UDS (unix domain sockets), named pipes or a range of third party middlewares (for example, Kafka, Solace, and so on).

## Connecting

A kdb+ process can connect to another using [`hopen`](../ref/hopen.md). For example, to start a kdb+ process listening on port 5000.

```bash
$ q -p 5001
```
another kdb+ process can connect to this process with [`hopen`](../ref/hopen.md):

```q
q)h:hopen `::5001
q)h                 /h is the socket (an OS file descriptor)
3i
```

Sync messages can also be sent without a pre-existing connection using [one-shot](#one-shot-message).

The maximum number of connections is defined by the system limit for protocol (operating system configurable). Prior to 4.1t 2023.09.15, the limit was hardcoded to 1022.
After the limit is reached, you see the error `'conn` on the server process. All successfully opened connections remain open.

!!! note "It is important to use [`hclose`](../ref/hopen.md#hclose) once finished with any connection. Connections do not automatically close if their associated handle is deleted."

## Closing connections

Client or server connections can be closed using [`hclose`](../ref/hopen.md#hclose).

## Message format

Where `h` is the socket, the message may be a string or list.

```q
q)h"2+2"   /string
4

q)h(+;2;2) /list
4
```

Use the list format to pass local functions and data to the receiver.

```q
q)h"fn:{2+x}" /Set function fn on receiver
q)fn:{4+x} /Set local function fn

q)h(`fn;2) /Receiver definition of fn called
4

q)h("fn";2) /Receiver definition of fn called
4

q)h(fn;2) /Local fn passed to receiver for evaluation
6

q)v:10
q)h(`fn;v) /Passing variable as argument
12

q)h({x+y};2;3) /Extend the list to pass more arguments
5
```

## Send messages

Send messages from the client to the server using the [connection handle](handles.md) returned from `hopen`.

There are three message types: sync, async, and response.

### Sync request (get)

Performs the following:

1. sends any pending outgoing (async) messages on `h`
1. sends the sync request message
1. processes any pending incoming messages on `h` until a response (or error) message is received

```q
q)h"2+2" / this is sent to the remote process for calculation
4
```

The method shown above is sending the query as a string.
You can also execute a function on the server by passing a list with the function as first item, followed by its arguments.

```q
q)h:hopen 5000
q)h("+";2;2)
4
```

!!! tip "Default handling of a sync message"
    [`.z.pg`](../ref/dotz.md#zpg-get) is called on the server when any message is received. 
    The default processing calls [`value`](../ref/value.md) with the provided message. Using `value`, the processing for the two messages above would be:
    ```q
    q)value "2+2"
    4
    q)value ("+";2;2)
    4
    ```

To execute a function defined on the *client side*, pass the function name so it is resolved before sending. 

To execute a function defined on the *server side*, pass the function name as a symbol.

For example, run the following to create a server instance with a function called 'add':
```q
q)\p 5000
q)add:{x+y}           / define a function 'add' on the server
```
Using a separate kdb+ instance, connect to the server and execute the functions:
```q
q)add:{x+2*y}         / define a function 'add' on the client
q)h:hopen 5000        / connect to the server
q)h(add;2;3)          / pass the client function 'add' to the server and execute, passing 2 parameters
8
q)h(`add;2;3)         / execute the 'add' function as defined on the server, passing 2 parameters
5
```

!!! warning "Nesting sync requests is not recommended: response messages may be out of request order."

#### One-shot message

A sync message can also be sent on a short-lived connection (called a [one-shot](../ref/hopen.md#one-shot-request)). 
When sending multiple messages, this is less efficient than [using a pre-existing connection](#sync-request-get) due to the effort of repeated connections/disconnections.

A useful shorthand for a one-shot get is:

```q
q)`::5001 "1+1" 
2
```
which is equivalent to 
```q
q)`:localhost:5001 "1+1"
2
```

#### Interrupting requests

It is possible to interrupt a long-running sync query with `kill -s INT *PID*`. As with the previous example, any subsequent attempt to communicate across this handle will fail.

```q
q)h"system\"sleep 30\""
'rcv handle: 4. OS reports: Interrupted system call
  [0]  h"system\"sleep 30\""
       ^
q)
q)h"a"
'Cannot write to handle 4. OS reports: Bad file descriptor
  [0]  h"a"
       ^
```

### Response message (get response)

Sent automatically by the listening process on completing a sync (get) request.

### Async message (set)

Serializes and puts a message on the output queue for handle `h`, and does not block client nor wait for any response message. A negative handle signifies async.

```q
q)neg[h]"a:10" / on the remote instance, sets the variable a to 10
```

Similar to [sync messages](#sync-request-get), you can replace the string representing the code to execute as a list. 
The following example uses [`0N!`](../ref/display.md) to echo data provided to the servers console

```q
q)neg[h]("0N!";22)
```

Since the process is not waiting for a response, async querying is critical in situations where waiting for an unresponsive subscriber is unacceptable, for example, in a tickerplant.

You may consider increasing the size of TCP send/receive buffers on your system to reduce the amount of blocking whilst trying to write into a socket.

#### Flushing

Messages can be queued for sending to a remote process through using async messaging. 
kdb+ queues the serialized message in user space, later writing it to the socket as the remote end drains the message queue. 

You can see the queue size using [-38!](internal.md#-38x-socket-table), or [`.z.W`](../ref/dotz.md#zw-handles "handles") for all handles.

Sometimes it is useful to send a large number of aysnc messages, but then to block until they have all been sent. 
This can be achieved through using async flush – invoked as `neg[h][]` or `neg[h](::)`. 

If you need confirmation that the remote end has received and processed the async messages, use a sync request. For example, `h""` – the remote end processes the messages on a socket in the order that they are sent.

!!! note "Flushing can also be achieved by sending a synchronous message on the same handle. This confirms execution as all messages are processed in the order they are sent."

#### Broadcast

Much of the overhead of sending a message using IPC is in serializing the data before sending. 
It is possible to ‘async broadcast’ the same message to multiple handles using the internal [-25!](internal.md#-25x-async-broadcast) function. This serializes the message once and send to all handles to reduce CPU and memory load.

#### Deferred sync

Deferred sync is when a message is sent asynchronously to the server using the negative handle and executes a function which includes an instruction 
to return the result though the handle to the client process ([`.z.w`](../ref/dotz.md#zw-handle)), again asynchronously. 

After the client sends its async request it [blocks](#async-blocking) on the handle waiting for a result to be returned.

For example, start a kdb+ to act as a server
```q
q)\p 5000
q)add:{x+y+z}
q)proc:{neg[.z.w](add . x)}      / wrapper function for client comms
```
then run a kdb+ instance to connect to the server
```q
q)h:hopen 5000
q)neg[h](`proc;1 2 3);res:h[];   / call 'proc' on server, wait for reply
q)res
6
```

## Handle messages

Message handlers on the server are defined in the [`.z` namespace](../ref/dotz.md). Their default values can be overridden. 
The following callback functions are provided which can be set to a user defined function if desired:

* [`.z.pw`](../ref/dotz.md#zpw-validate-user) for [user validation](#authentication-authorization)
* [`.z.po`](../ref/dotz.md#zpo-open) called when a connection to a kdb+ session has been initialized
* [`.z.pg`](../ref/dotz.md#zpg-get) called for a sync request
* [`.z.ps`](../ref/dotz.md#zps-set) called for a async request
* [`.z.pc`](../ref/dotz.md#zpc-close) called after a connection has been closed

The default values of these callback can be restored using [`\x`](syscmds.md#x-expunge).

These can be made a little more interesting by inserting some debug info. 

Dump the handle, IP address, username, timestamp and incoming request to stdout, execute the request and return:

```q
.z.pg:{0N!(.z.w;.z.a;.z.u;.z.p;x);value x}
```

To detect when a connection opens, simply override the port open handler, `.z.po`:

```q
/ dump the port open handle to stdout
.z.po:{0N!(`portOpen;x);} 
```

To detect when a connection is closed from the remote end, override the port close handler, `.z.pc`:

```q
/ dump the handle that has just been closed to stdout
.z.pc:{0N!(`portClosed;x);} 
```

:fontawesome-solid-book: 
[`.z`](../ref/dotz.md) namespace
<br>
:fontawesome-solid-graduation-cap: 
[Using `.z`](../kb/using-dotz.md) for more resources, including contributed code for tracing and monitoring

### Async blocking

To block until any async message is received on handle `h`

```q
r:h[] / store message in r
```


## Authentication / Authorization

Basic access control and authentication is supported by using the [-u](cmdline.md#-u-usr-pwd-local)/[-U](cmdline.md#-u-usr-pwd) command-line option to specify a file of users and passwords. The [.z.pw](../ref/dotz.md#zpw-validate-user) callback is called immediately after successful –u/-U authentication.

If the -u/-U command-line options are not used, the .z.pw callback is executed for each new connection.

The ability to set .z.pw to user defined function, allows allows integration with enterprise standards such as LDAP, Kerberos, OpenID Connect,etc

Finer grained authorization can be implemented by tracking user information with active handles and customizing sync/async callbacks for user-level permissioning, for example, server with protected functions for sync calls.

```q
q)\p 5000
q)allowedFns:(`func1;`func2;`func3;+;-) / list of allowed function/ops to call
q)checkFn:{if[not x in allowedFns;'(.Q.s1 x)," not allowed"];}
q)validatePT:{if[0h=t:type x;if[(not 0h=type first x)&1=count first x;checkFn first x;];.z.s each x where 0h=type each x;];}
q).z.pg:{if[10h=type x;x:parse x;];validatePT x;eval x}
```

client trying to access protected functions:
```q
q)h:hopen 5000
q)h"1+1"
2
q)h"1*1"
'* not allowed
  [0]  h"1*1"
       ^
```

!!! note
    Ticker plants and other high-volume message sources, such as feed handlers, generally insert data using `.z.ps`. To manage such high volumes, the handles of those processes should be used to avoid the overhead of these validation checks. That is, feeds and tickerplants could be viewed as trusted processes.

:fontawesome-regular-map:
[Permissions with kdb+](../wp/permissions/index.md "White paper")
<br>
:fontawesome-regular-map:
[Using .z](../kb/using-dotz.md)

## Tracking connections

A list of current connections can be viewed using [.z.H](../ref/dotz.md#zh-active-sockets). A more detailed list is achieved via [-38!](internal.md#-38x-socket-table).

Further tracking of connections on a server (tracking client connections) can be accomplished using customized implementations of [.z.po](../ref/dotz.md#zpo-open) and [.z.pc](../ref/dotz.md#zpc-close).

## Protocol

The protocol is extremely simple, as is the message format. 

You can see what a TCP/IP message looks like by using [`-8!object`](internal.md#-8x-to-bytes), which generates the byte vector for the [serialization](../kb/serialization.md) of the object.

This information is provided for debugging and troubleshooting only.


### Handshake

After a client has opened a socket to the server, it sends a null-terminated ASCII string `"username:password\N"` where `\N` is a single byte (0…3) which represents the client’s capability with respect to compression, timestamp|timespan and UUID, e.g. `"myname:mypassword\3"`. 
(Since 2012.05.29.) 

- If the server rejects the credentials, it closes the connection immediately. 
- If the server accepts the credentials, it sends a single-byte response which represents the common capability. 

kdb+ recognizes these capability bytes:

byte | effect
:---:|------------------------------------------------------
0    | (V2.5) no compression, no timestamp, no timespan, no UUID
1..2 | (V2.6-2.8) compression, timestamp, timespan
3    | (V3.0) compression, timestamp, timespan, UUID
4    | reserved
5    | support msgs >2GB; vectors must each have a count ≤ 2 billion
6    | support msgs >2GB and vectors may each have a count > 2 billion

!!! warning "Java and C# have array length limits which make capabilities 5 and 6 inviable with their current object models."


### Compression

For releases since 2012.05.29, kdb+ and the C-API will compress an outgoing message if

-   Uncompressed serialized data has a length greater than 2000 bytes
-   Connection is not `localhost`
-   Connection is not 127.0.0.1
-   Connection is not using UDS (Unix Domain Socket)
-   Connection does not resolve to being localhost (since 4.1t 2021.06.04)
-   Size of compressed data is less than &frac12; the size of uncompressed data

The compression/decompression algorithms are proprietary and implemented as the `compress` and `uncompress` methods in the [Java API](https://github.com/kxsystems/javakdb). The message validator does not validate the integrity of compressed messages.

!!! note "Enumerations are automatically converted to values before sending through IPC."

----

:fontawesome-solid-book:
[`hopen`, `hclose`](../ref/hopen.md),
[`hsym`](../ref/hsym.md)
<br>
[`.z` namespace](../ref/dotz.md) for callback functions
<br> 
[`.Q.addr`](../ref/dotq.md#addr-iphost-as-int) (IP/host as int), 
[`.Q.host`](../ref/dotq.md#host-ip-to-hostname) (IP to hostname), 
<br>
:fontawesome-solid-book-open:
[Connection handles](handles.md)
<br>
:fontawesome-solid-graduation-cap:
[Serialization examples](../kb/serialization.md)
<br>
:fontawesome-solid-graduation-cap:
[WebSockets](../kb/websockets.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§11.6 Interprocess Communication](/q4m3/11_IO/#116-interprocess-communication)
