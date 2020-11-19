---
title: Interprocess communication | Basics | kdb+ and q documentation
description: TCP/IP is used for communicating between processes. The protocol is extremely simple, as is the message format.
keywords: async, block, buffer, communication, flush, hopen, interprocess, ip, ipc, kdb+, message, port, process, protocol, q, queue, socket, sync, tcp
---
# :fontawesome-solid-handshake: Interprocess communication



_Simple, powerful, fast_

<div markdown="1" class="typewriter">
[\p](syscmds.md#listening-port)  [-p](cmdline.md#listening-port)          listen to port
[hopen hclose](../ref/hopen.md)    open/close connection
[.z](../ref/dotz.md)              handle message (callbacks)
</div>

A kdb+ process can communicate with other processes through TCP/IP, which is baked in to the q language. 

:fontawesome-brands-superpowers: 
[Fusion interfaces](../interfaces/fusion.md)
<br>
:fontawesome-solid-handshake: 
[Clients for kdb+](../interfaces/c-client-for-q.md) 

!!! tip "This page discusses TCP/IP sockets, but there are other types of IPC, that use the familiar open/request/close paradigm. All use [`hopen`](../ref/hopen.md#) to connect."

:fontawesome-solid-book-open:
[Connection handles](handles.md),
[File system](files.md)


## Listen to a port

To start a kdb+ process listening on a port, use the [command `\p port`](syscmds.md#p-port)
```q
q)\p 5001
```

or start the q process with the [`-p` port command line parameter](cmdline.md#-p-listening-port):

```bash
$ q -p 5001
```

This process is now awaiting incoming connections via TCP/IP. To stop the process listening on a port, instruct it to listen on port 0:

```q
q)\p 0
```

Another kdb+ process can connect to this process with [`hopen`](../ref/hopen.md):

```q
q)h:hopen `::5001
q)h  /h is the socket (an OS file descriptor)
3i
```


## Send messages

Send messages from the client to the server using the [connection handle](handles.md) returned from `hopen`.

There are three message types: async, sync, and response.


### Async message (set)

Serializes and puts a message on the output queue for handle `h`, and does not block client. A negative handle signifies async.

```q
q)neg[h]"a:10" / on the remote instance, sets the variable a to 10
```

To ensure an async message is sent immediately, flush the pending outgoing queue for handle `h` with

```q
q)neg[h][] 
```

which blocks until pending outgoing messages on handle `h` have been written to the socket.

To ensure an async message has been processed by the remote, follow with a sync chaser, e.g.

```q
q)h"";
```

You may consider increasing the size of TCP send/receive buffers on your system to reduce the amount of blocking whilst trying to write into a socket.  


### Sync request (get)

Sends any pending outgoing (async) messages on `h`, sends the sync request message, and processes any pending incoming messages on `h` until a response (or error) message is received.

```q
q)h"2+2" / this is sent to the remote process for calculation
4
```

A useful shorthand for a one-shot get is:

```q
q)`::5001 "1+1"
2
```

!!! warning "Nesting sync requests is not recommended: response messages may be out of request order."


### Response message (get response)

Sent automatically by the listening process on completing a sync (get) request.


## Handle messages

Message handlers on the server are defined in the [`.z` namespace](../ref/dotz.md). Their default values can be overridden. The default handler for both sync and async messages is `value`:

```q
.z.pg:value / port get - for sync messages
.z.ps:value / port set - for async messages
```

These can be made a little more interesting by inserting some debug info. 

Dump the handle, IP address, username, timestamp and incoming request to stdout, execute the request and return:

```q
.z.pg:{0N!(.z.w;.z.a;.z.u;.z.p;x);value x}
```

To detect when a connection opens, simply override the port open handler, `.z.po`:

```q
/ dump the port open handle to stdout
.z.po:{0N!(`` `portOpen;x``);} 
```

To detect when a connection is closed from the remote end, override the port close handler, `.z.pc`:

```q
/ dump the handle that has just been closed to stdout
.z.pc:{0N!(`` `portClosed;x``);} 
```

:fontawesome-solid-book: 
[`.z`](../ref/dotz.md) namespace
<br>
:fontawesome-solid-graduation-cap: 
[Using `.z`](../kb/using-dotz.md) for more resources, including contributed code for tracing and monitoring


## Block, queue, flush

To block until any message is received on handle `h`

```q
r:h[] / store message in r
```

Messages can be queued for sending to a remote process through using async messaging. Kdb+ will queue the serialized message in user space, later writing it to the socket as the remote end drains the message queue. One can see how many messages are queued on a handle and their sizes as a dictionary through the command variable [`.z.W`](../ref/dotz.md#zw-handles "handles").

Sometimes it is useful to send a large number of aysnc messages, but then to block until they have all been sent. This can be achieved through using async flush – invoked as `neg[h][]` or `neg[h](::)`. If you need confirmation that the remote end has received and processed the async messages, chase them with a sync request, e.g. `h""` – the remote end will process the messages on a socket in the order that they are sent.


## Users

Access control and authentication is supported through using the [`-U` command-line option](cmdline.md#-u-usr-pwd) to specify a file of users and passwords, and [`.z.pw`](../ref/dotz.md#zpw-validate-user) for further integration with enterprise standards such as LDAP. Access control is possible through overriding the message handlers and inspecting the incoming requests for function calls, and validating whether the user is allowed to call such functions.


## Protocol

The protocol is extremely simple, as is the message format. 

One can see what a TCP/IP message looks like by using `-8!object`, which generates the byte vector for the [serialization](../kb/serialization.md) of the object.

This information is provided for debugging and troubleshooting only.


### Handshake

After a client has opened a socket to the server, it sends a null-terminated ASCII string `"username:password\N"` where `\N` is a single byte (0…3) which represents the client’s capability with respect to compression, timestamp|timespan and UUID, e.g. `"myname:mypassword\3"`. 
(Since 2012.05.29.) 

- If the server rejects the credentials, it closes the connection immediately. 
- If the server accepts the credentials, it sends a single-byte response which represents the common capability. 

Kdb+ recognizes these capability bytes:

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
-   Size of compressed data is less than &frac12; the size of uncompressed data

The compression/decompression algorithms are proprietary and implemented as the `compress` and `uncompress` methods in `c.java`. The message validator does not validate the integrity of compressed messages.

HTTP server supports gzip compression via `Content-Encoding: gzip` for responses to `form?…`-style requests.
The response payload must be 2,000+ chars and the client must indicate support via `Accept-Encoding: gzip` in the HTTP header.
(Since V4.0 2020.03.17.)

The HTTP client supports gzip content, and `.Q.hg`, `.Q.hp`, and `.Q.hmb` indicate this in the request via the HTTP header `Accept-Encoding: gzip`.
(Since V4.0 2020.03.17.)



!!! note "Enumerations are automatically converted to values before sending through IPC."

----

:fontawesome-solid-book:
[`hopen`, `hclose`](../ref/hopen.md),
[`hsym`](../ref/hsym.md)
<br>
[`.h` namespace](../ref/doth.md) for markup  
[`.z` namespace](../ref/dotz.md) for callback functions
<br> 
[`.Q.addr`](../ref/dotq.md#qaddr-ip-address) (IP address), 
[`.Q.hg`](../ref/dotq.md#qhg-http-get) (HTTP get), 
[`.Q.host`](../ref/dotq.md#qhost-hostname) (hostname), 
[`.Q.hp`](../ref/dotq.md#qhp-http-post) (HTTP post)
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
:fontawesome-regular-map:
[Kdb+ and WebSockets](../wp/websockets/index.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§11.6 Interprocess Communication](/q4m3/11_IO/#116-interprocess-communication)
