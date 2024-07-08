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
kdb+ can receive messages over TCP, UDS (unix domain sockets), named pipes or a range of 3rd party middlewares (e.g. Kafka, Solace, etc)

## Connecting

A kdb+ process can connect to another using [`hopen`](../ref/hopen.md) e.g: to start a kdb+ process listening on port 5000

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

The max number of connections is defined by the system limit for protocol (operating system configurable). Prior to 4.1t 2023.09.15, the limit was hardcoded to 1022.
After the limit is reached, you see the error `'conn` on the server process. All successfully opened connections remain open.

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

The basic method used to execute a query via IPC is sending the query as a string as in the above example. 
A function can also be executed on the server by passing a [parse tree](parsetrees.md) to the handle: a list with the function as first item, followed by its arguments.

To execute a function defined on the *client side*, simply pass the function name so it will be resolved before sending. 

To execute a function defined on the *server side*, pass the function name as a symbol.

For example, run the following to create a server instance with a function called 'add':
```q
q)\p 5000
q)add:{x+y}           / define a function 'add' on the server
```
Using a seperate kdb+ instance, connect to the server and execute the functions:
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

A sync message can also be sent on a short-lived connection. 
When sending multiple messages, this is less efficient than [using a pre-existing connection](#sync-request-get) due to the effort of repeated connections/disconnections.

A useful shorthand for a one-shot get is:

```q
q)`::5001 "1+1"
2
```

Since V4.0 2020.03.09, a one-shot query can be run with a timeout (in milliseconds), as in the second example below:

```q
q)`::4567"2+2"
4
q)`::[(`::4567;100);"1+1"]
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

As per [sync messages](#sync-request-get), you can replace the string repesenting the code to execute as a list that forms a parse tree.

Since the process is not waiting for a response, async querying is critical in situations where waiting for an unresponsive subscriber is unacceptable, e.g. in a tickerplant.

You may consider increasing the size of TCP send/receive buffers on your system to reduce the amount of blocking whilst trying to write into a socket.

#### Flushing

Messages can be queued for sending to a remote process through using async messaging. 
kdb+ will queue the serialized message in user space, later writing it to the socket as the remote end drains the message queue. 

One can see how many messages are queued on a handle and their sizes as a dictionary through the command variable [`.z.W`](../ref/dotz.md#zw-handles "handles").

Sometimes it is useful to send a large number of aysnc messages, but then to block until they have all been sent. 
This can be achieved through using async flush – invoked as `neg[h][]` or `neg[h](::)`. 

If you need confirmation that the remote end has received and processed the async messages, chase them with a sync request, 
e.g. `h""` – the remote end will process the messages on a socket in the order that they are sent.

!!! note "flushing can also be achieved by sending a synchronous message on the same handle: this will confirm execution as all messages are processed in the order they are sent"

#### Broadcast

Much of the overhead of sending a message via IPC is in serializing the data before sending. 
It is possible to ‘async broadcast’ the same message to multiple handles using the internal [-25!](internal.md#-25x-async-broadcast) function. 
This will serialize the message once and send to all handles to reduce CPU and memory load.

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

Basic access control and authentication is supported through using the [-u](cmdline.md#-u-usr-pwd-local)/[-U](cmdline.md#-u-usr-pwd) command-line option to specify a file of users and passwords.

In order to provide further customizations of the authentication process, [.z.pw](../ref/dotz.md#zpw-validate-user) callback is called immediately after successful –u/-U authentication (if specified at startup – otherwise .z.pw is the first authentication check done by a kdb+ process). The ability to set .z.pw to user defined function, allows allows integration with enterprise standards such as LDAP, Kerberos, OpenID Connect,etc

Finer grained authorization can be implemented by tracking user info with active handles, and customizing sync/async callbacks for user-level permissioning.

:fontawesome-regular-map:
[Permissions with kdb+](../wp/permissions/index.md "White paper")

## Tracking connections

A list of current connections can be viewed using [.z.H](../ref/dotz.md#zh-active-sockets). A more detailed list is achieved via [-38!](internal.md#-38x-socket-table).

Further tracking of connections on a server (tracking client connections) can be accomplished using customized implementations of [.z.po](../ref/dotz.md#zpo-open) and [.z.pc](../ref/dotz.md#zpc-close)

## Protocol

The protocol is extremely simple, as is the message format. 

One can see what a TCP/IP message looks like by using [`-8!object`](internal.md#-8x-to-bytes), which generates the byte vector for the [serialization](../kb/serialization.md) of the object.

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

The compression/decompression algorithms are proprietary and implemented as the `compress` and `uncompress` methods in `c.java`. The message validator does not validate the integrity of compressed messages.

!!! note "Enumerations are automatically converted to values before sending through IPC."

----

:fontawesome-solid-book:
[`hopen`, `hclose`](../ref/hopen.md),
[`hsym`](../ref/hsym.md)
<br>
[`.z` namespace](../ref/dotz.md) for callback functions
<br> 
[`.Q.addr`](../ref/dotq.md#addr-ip-address) (IP address), 
[`.Q.host`](../ref/dotq.md#host-hostname) (hostname), 
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
