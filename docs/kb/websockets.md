---
title: WebSockets – Knowledge Base – kdb+ and q documentation
description: How to work with WebSockets in q
keywords: browser, json, kdb+, q, websockets, javascript
---
# :fontawesome-solid-handshake: WebSockets

kdb+ supports the WebSocket protocol since [V3.0](../releases/ChangesIn3.0.md)

WebSockets provide a protocol between a client and server which runs over a persistent TCP connection. 
The client-server connection can be kept open as long as needed and can be closed by either the client or the server. 

This open connection allows bi-directional, full-duplex messages to be sent over the single TCP socket connection.
The connection allows data transfer in both directions, and both client and server can send messages simultaneously. 

WebSockets were designed to be implemented in web browsers and web servers, but they can be used by any client or server application. 
The ability for bi-directional real-time functionality means it provides a basis for creating real-time applications on both web and mobile platforms.

All messages sent across a WebSocket connection are asynchronous.

## WebSocket server

To enable kdb+ to accept websocket connection, simply start a q session [listening on a port](../basics/listening-port.md) of your choice.

The [`.z.ws`](../ref/dotz.md#zws-websockets) function will be called by the server for every client message.
To customise the kdb+ websocket server, define the [`.z.ws`](../ref/dotz.md#zws-websockets) function to your choosen logic.
Note that [`.z.w`](../ref/dotz.md#zw-handle) is used for obtaining the current connection handle, which represents the client connection when called within the `.z.ws` callback.

[.z.wo](../ref/dotz.md#zwo-websocket-open) and [.z.wc](../ref/dotz.md#zwc-websocket-close) are used to define callback functions in the event of a client connection opening or closing respectively.
These have no default action, and can be customised with user required logic e.g. for tracking connections

```q
q)activeWSConnections: ([] handle:(); connectTime:())

//x argument supplied to .z.wc & .z.wo is the connection handle
q).z.wo:{`activeWSConnections upsert (x;.z.t)}
q).z.wc:{ delete from `activeWSConnections where handle =x}

//websocket connects
q)activeWSConnections
handle connectTime
-------------------
548 13:15:24.737

//websocket disconnects
q)activeWSConnections
handle connectTime
------------------
```

The internal function [-38!](../basics/internal.md#-38x-socket-table) can also be used to view current WebSocket connections and connection handles.

### Example

To start a q session listening on port 5000, which then handles any websocket requests by echoing whatever it receives:

```q
q)\p 5000
q).z.ws:{neg[.z.w] x}
```

The handler `{neg[.z.w]x}` echoes the message back to the client.

Download 
:fontawesome-brands-github: 
[KxSystems/cookbook/ws.htm](https://github.com/KxSystems/cookbook/blob/master/ws.htm), 
a simple WebSocket client, and open it in a WebSocket-capable browser. You should see something like this:

![ws.htm](../img/websocket-wso.png)

Now click _connect_ and type e.g. `4+til 3` in the edit box. Hit Enter or click _send_. Note that it is echoed in the output text area.

![echo](../img/websocket-echo.png)

The example can be enhanced further, to run any q code typed into the browser. In your q session, redefine .z.ws:

```q
.z.ws:{neg[.z.w].Q.s value x}
```

Then try typing `4+til 3` in the edit box and click _send_. You will see a result this time:

![result](../img/websocket-result.png)

To catch any bad q code that is submitted, redo the definition of .z.ws to [trap errors](../ref/apply.md#trap-at):

```q
.z.ws:{neg[.z.w]@[.Q.s value@;x;{"`",x,"\n"}]}
```

### Authentication / Authoriation

In order to initialize a WebSocket connection, a WebSocket ‘handshake’ must be successfully made between the client and server processes. 
First, the client sends a HTTP request to the server to upgrade from the HTTP protocol to the WebSocket protocol.

Client HTTP requests can be authenticated/authorized using [.z.ac](../ref/dotz.md#zac-http-auth).
This allows kdb+ to be customized with a variety of mechanisms for securing HTTP requests  e.g. LDAP, OAuth2, OpenID Connect, etc.

## WebSocket client

Since V3.2t 2014.07.26, q can also create a WebSocket connection, i.e. operate as a client as well as a server.

The [`.z.ws`](../ref/dotz.md#zws-websockets) function will be called by the client for every server message.
`.z.ws` must be defined before opening a WebSocket.

To open a client connection to a server, use the following syntax:
```q
(`$":ws://host:port")"GET / HTTP/1.1\r\nHost: host:port\r\n\r\n"
```
If successful it will return a 2-item list of (handle;HTTP response), e.g.
```q
(3i;"HTTP/1.1 101 Switching Protocols\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-WebSocket-Accept: HSmrc0sMlYUkAGmm5OPpG2HaGWk=\r\nSec-WebSocket-Extensions: permessage-deflate\r\n\r\n")
```
If the protocol upgrade from HTTP to WebSocket failed, it returns the 2-item list, with the handle as `0Ni`, e.g.

```q
(0Ni;"HTTP/1.1 400 Bad Request\r\nContent-Type: text/html; charset=UTF-8...")
```
Any other error is signalled as usual, e.g.
```q
'www.nonexist.badcom: No route to host
```

To use SSL/TLS, kdb+ should first be [configured to use SSL/TLS](ssl.md). For any request requiring SSL/TLS, replace `ws://host:port` with `wss://host:port`.
An alternative is to use stunnel, and open from kdb+ to that stunnel with `ws://`. 

Both client and server support permessage-deflate compression.

[.z.wc](../ref/dotz.md#zwc-websocket-close) is used to define callback functions in the event of a client connection closing.
This have no default action, and can be customised with user required logic. The callback function [.z.wo](../ref/dotz.md#zwo-websocket-open) is not used with client initiated connections.

### Example

Open 2 terminal windows, one for the websocket server, and one for the client.

In the server q session, listen on a choosen port (e.g. 5000) and define a callback that replies with a string to client
```q
q)\p 5000
q).z.ws:{neg[.z.w] "server replied with ",$[10=type x;x;raze string x];}
```
In the client q session, define a callback to echo incoming messages and connect to the server
```q
q).z.ws:{0N!"Client Received Msg:";0N!x;}
q)r:(`$":ws://127.0.0.1:5000")"GET / HTTP/1.1\r\nHost: 127.0.0.1:5000\r\n\r\n"
q)r
6i
"HTTP/1.1 101 Switching Protocols\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-WebSocket-Accept: HSmrc0sMlYUkAGmm5OPpG2HaGWk=\r\nSec-WebSocket-Extensions: permessage-deflate\r\n\r\n"
```
The client can then send a message to the server using:
```q
q)neg[r[0]]"test" / a char vector
q)neg[r[0]]0x010203 / a bytevector
```
The client should then see the reply received from the server echoed to the terminal.

### Authentication

As the HTTP header can be customised as part of the connection string, various means of authentication can be implemented (e.g. adding bearer token, cookie, etc).

The client connection also allows username:password to be specified for [basic access authentication](https://en.wikipedia.org/wiki/Basic_access_authentication#Client_side). e.g.
```q
q)`:ws://username:password@127.0.0.1:5001 "GET / HTTP/1.1\r\nHost: 127.0.0.1:5001\r\n\r\n"
```

## JavaScript serialization

[`c.js`](https://github.com/KxSystems/kdb/blob/master/c/c.js)  provides functions `serialize` and `deserialize` to simplify IPC between the browser and a kdb+ server. 

### Example

An example, [`wslogin.htm`](https://github.com/KxSystems/cookbook/blob/master/wslogin.htm) shows how to send a JavaScript dictionary to kdb+. It receives a dictionary and replies with a vector of strings to the browser (the dictionaries values).
To decode a *serialized* string using q, use [`-9!`](../basics/internal.md#-9x-from-bytes) and to encode, use [`-8!`](../basics/internal.md##-8x-to-bytes).

To run this example

1.  start the server listening on port 5000 and define the callback to deserialize the dictionary, and reply with the serialized dictionary values. Note: to handle both byte and char, check for the type of the input.
```q
q)\p 5000
q).z.ws:{neg[.z.w] -8!value -9!x;}
```
1.  download `wslogin.htm` and `c.js` to the same location
1.  open `wslogin.htm` in your browser
1.  client the `login` button. The will cause the browser to serialise its data and send to kdb+. The kdb+ server will receive a byte vector of an encoded kdb+ dictionary. The kdb+ server will then deserialise the dictionary, and reply to the browser with the values found within the dictionary (for display in its text box). The dictionary has the following form:
```q
`u`p!("user";"At0mbang.")`
```
and therefore, it will reply with the serialised form of the dictionary values e.g.
```q
("user";"At0mbang.")
```

This example works, because the default `.z.ws` echoes the byte vector over the WebSocket.

:fontawesome-solid-download: Downloads:

-   :fontawesome-brands-github: [KxSystems/kdb/c/c.js](https://github.com/KxSystems/kdb/blob/master/c/c.js)
-   :fontawesome-brands-github: [KxSystems/cookbook/wslogin.htm](https://github.com/KxSystems/cookbook/blob/master/wslogin.htm)


## JSON

JSON can be parsed and generated using functions found within the [.j namespace](../ref/dotj.md).

## Compression

V3.2t 2014.05.08 added ‘permessage-deflate’ WebSockets compression. One way to observe whether compression is active on a connection is to observe the queued data. For example

```q
/ generate some compressible data
q)v:10000#.Q.a 
/ queue 1000 msgs to an existing websocket handle
/ and observe the queue
q)\ts do[1000;(-5)v];show sum each .z.W
5| 10004000
6| 0
14 20610976
/ now do same again, but this time with a handle which requested compression
q)\ts do[1000;(-6)v];show sum each .z.W
5| 0
6| 47022
94 4354944
```

Here we can see the uncompressed data was quicker to add to the queue, and consumed more memory overall. The compressed data took longer to queue, and in this case was 200× smaller. Compression speed and ratio achieved will depend on your data.

In Chrome you can also observe the network handshake in _View&gt;Developer&gt;Developer tools_; a successful negotiation will have `“Sec-WebSocket-Extensions:permessage-deflate”` in the HTTP response header.

Since 4.1 2024.03.12, 4.0 2024.03.04 websocket compression is disabled if kdb+ receives the `sec-websocket-protocol` http header with value `kxnodeflate`, for example client javascript:

```js
ws=new WebSocket(url),"kxnodeflate");
```

## Secure sockets: stunnel

[Stunnel](https://en.wikipedia.org/wiki/Stunnel) :fontawesome-brands-wikipedia-w: will provide secure sockets (TLS/SSL) using the OpenSSL library. Stunnel will take any WebSocket server, HTTP server, or similar and secure it – you get `https://` and `wss://` for free.

:fontawesome-brands-github: 
[cesanta/ssl_wrapper](https://github.com/cesanta/ssl_wrapper)


## UTF-8 encoding

The WebSocket requires that text is UTF-8 encoded. If you try to send invalidly encoded text it will signal `'utf8`.

:fontawesome-solid-book: 
[Namespace `.h`](../ref/doth.md)

----
:fontawesome-regular-map:
[kdb+ and WebSockets](../wp/websockets/index.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§11.7.2 Basic WebSockets](/q4m3/11_IO/#1172-basic-websockets)
