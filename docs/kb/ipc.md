---
title: Interprocess communication
description: This page discusses TCP/IP sockets, but there are other types of IPC, that use the familiar open/request/close paradigm and all use hopen to connect. 
keywords: async, block, buffer, communication, flush, hopen, interprocess, ip, ipc, kdb+, message, port, q, queue, socket, sync, tcp
---
# Interprocess communication



Simple, powerful and fast.

This page discusses TCP/IP sockets, but there are other types of IPC, that use the familiar open/request/close paradigm and all use [`hopen`](../ref/handles.md#hopen) to connect. 

To start a kdb+ process listening on a port, use the [command `\p port`](../basics/syscmds.md#p-port):
```q
q)\p 5001
```

or start the q process with the [`-p` port command line parameter](../basics/cmdline.md#-p-listening-port):

```bash
$ q -p 5001
```

This process is now awaiting incoming connections via TCP/IP. To stop the process listening on a port, instruct it to listen on port 0:

```q
q)\p 0
```

Another kdb+ process can connect to this process with [`hopen`](../ref/handles.md#hopen):

```q
q)h:hopen `::5001
q)h  /h is the socket (an OS file descriptor)
3i
```


## Messages

Messages can now be sent from the client to the server using the handle returned from `hopen`.

There are [3 message types](../basics/ipc.md): async, sync, and response.


### Async message (set)

serializes and puts a message on the output queue for handle `h`, and does not block client. A negative handle signifies async.

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

A useful shorthand for a single-shot get is:

```q
q)`::5001 "1+1"
2
```

Nesting sync requests is not recommended since in such scenarios response messages may be out of request order.


### Response message (get response)

Sent automatically by the listening process on completing a sync (get) request.


## `.z`

There are message handlers on the server that can be overridden. The default handler for both sync and async handlers is `value`:

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
.z.po:{0N!(`portOpen;x);} / dump the port open handle to stdout
```

To detect when a connection is closed from the remote end, override the port close handler, `.z.pc`:

```q
.z.pc:{0N!(`portClosed;x);} / dump the handle that has just been closed to stdout
```

<i class="far fa-hand-point-right"></i> 
[Using `.z`](using-dotz.md) for more resources on `.z` including contributed code for tracing and monitoring


## Block, queue, flush

To block until any message is received on handle `h`

```q
r:h[] / store message in r
```

Messages can be queued for sending to a remote process through using async messaging. Kdb+ will queue the serialized message in user space, later writing it to the socket as the remote end drains the message queue. One can see how many messages are queued on a handle and their sizes as a dictionary through the command variable [`.z.W`](../ref/dotz.md#zw-handles "handles").

Sometimes it is useful to send a large number of aysnc messages, but then to block until they have all been sent. This can be achieved through using async flush – invoked as `neg[h][]` or `neg[h](::)`. If you need confirmation that the remote end has received and processed the async messages, chase them with a sync request, e.g. `h""` – the remote end will process the messages on a socket in the order that they are sent.


## Users

Access control and authentication is supported through using the [`-U` command-line option](../basics/cmdline.md#-u-usr-pwd) to specify a file of users and passwords, and [`.z.pw`](../ref/dotz.md#zpw-validate-user) for further integration with enterprise standards such as LDAP. Access control is possible through overriding the message handlers and inspecting the incoming requests for function calls, and validating whether the user is allowed to call such functions.

