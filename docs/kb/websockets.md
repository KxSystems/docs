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
To customise the kdb+ websocket server, define the [`.z.ws`](../ref/dotz.md#zws-websockets) function to your chosen logic.
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

### Connection handles

Data should be sent [async](../basics/ipc.md#async-message-set) to a websocket connection.

When no longer required, connection handles are closed using [`hclose`](../ref/hopen.md#hclose).

As communication is async, if you wish to flush any pending data prior to close, see the following example where h is a connection handle:
```q
q)neg[h][] / flush any pending data (blocks til all data sent)
q)hclose h / close handle
```

### Authentication / Authoriation

In order to initialize a WebSocket connection, a WebSocket ‘handshake’ must be successfully made between the client and server processes. 
First, the client sends a HTTP request to the server to upgrade from the HTTP protocol to the WebSocket protocol.

Client HTTP requests can be authenticated/authorized using [.z.ac](../ref/dotz.md#zac-http-auth).
This allows kdb+ to be customized with a variety of mechanisms for securing HTTP requests  e.g. LDAP, OAuth2, OpenID Connect, etc.

## WebSocket client

A WebSocket API exists for a number of languages (inc a native JavaScript WebSocket API), and web browsers are often used as WebSocket clients.
Since V3.2t 2014.07.26, q can also create a WebSocket connection, i.e. operate as a client as well as a server.

The [`.z.ws`](../ref/dotz.md#zws-websockets) function will be called by the client for every server message.
`.z.ws` must be defined before opening a WebSocket.

To open a client connection to a server, use the following syntax:
```q
(`$":ws://host:port")"GET / HTTP/1.1\r\nHost: host:port\r\n\r\n"
```
For example, to establish a connection with a web server running on 127.0.0.1 (port 80), with the URI '/subscribe/wss' and virtual host www.kdb-testbox.com, run the following command:
```q
(`$":ws://127.0.0.1:80")"GET /subscribe/wss HTTP/1.1\r\nHost: www.kdb-testbox.com\r\n\r\n"
```

If successful, it returns a two-item list of (handle;HTTP response), as follows:
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

In the server q session, listen on a chosen port (e.g. 5000) and define a callback that replies with a string to client
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

### Connection handles

Use as per server [connection handles](#connection-handles).

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
To decode a *serialized* string using q, use [`-9!`](../basics/internal.md#-9x-from-bytes) and to encode, use [`-8!`](../basics/internal.md#-8x-to-bytes).

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

## Real-time Demo

This section will present a simple example in which some tables will be
updated in the browser in real-time, as shown:

![](img/image5.jpg)<br/>
<small>_The web page shows the last quote and trade values for
each symbol, and gives the user the ability to filter the syms
in view_</small>

### Setup

1. Download files from [https://github.com/kxcontrib/websocket/tree/master/AppendixB](https://github.com/kxcontrib/websocket/tree/master/AppendixB)
2. Run `q pubsub.q`. It will create the q interface for the WebSocket connections and contains a simple pubsub mechanism to push data to clients when there are updates
3. Run `q fh.q`. This will generate dummy trade and quote data and push it to the pubsub process. The script can be edited to change the number of symbols and frequency of updates.
4. Open `websockets.html` in your browser. This will connect to kdb+ and display trade data in real-time, which can be filtered.

### Explanation

The idea behind the pubsub mechanism here is that a client will make
subscriptions to specific functions and provide parameters that they
should be executed with. The subscription messages we send to the server
will be sent as query strings so our `.z.ws` message handler is defined to
simply evaluate them.
```q
q).z.ws:{value x}
```
Next, we initialize the trade and quote tables and `upd` function to mimic
a simple Real-Time Subscriber, along with a further table called `subs`,
which we will use to keep track of subscriptions.
```q
// subs table to keep track of current subscriptions
q)subs:2!flip `handle`func`params`curData!"is**"$\:()
```
The `subs` table will store the handle, function name and function
parameters for each client. As we only want to send updates to a
subscriber when something has changed, we store the current data held by
each subscriber so that we can compare against it later.

The functions that can be called and subscribed to by clients through
the WebSocket should be defined as necessary. In this example, we have
defined a simple function that will return a list of distinct syms that
will be used to generate the filter checkboxes on the client and
additional functions to display the last record for each sym in both the
trade and quote tables. The aforementioned trade and quote table
functions will also accept an argument by which to filter the data if it
is present.
```q
//subscribe to something
sub:{`subs upsert(.z.w;x;enlist y)}
//publish data according to subs table
pub:{
  row:(0!subs)[x];
  (neg row[`handle]) .j.j (value row[`func])[row[`params]]
  }
// trigger refresh every 1000ms
.z.ts:{pub each til count subs}
\t 1000
```
The subfunction will handle new subscriptions by upserting the handle,
function name and function parameters into the `subs` table. `.z.wc` will
handle removing subscriptions from the table whenever a connection is
dropped.

The `pub` function is responsible for publishing data to the client. It
takes an argument that refers to a row index in the `subs` table and uses
it to get the subscriptions function, the parameters to use when calling
that function and the handle that it will use in sending the result to
the client. Before doing so, it will also use `.j.j` to parse the result
into a JSON string. The client can then parse the JSON into a JavaScript
object upon arrival as it did in the earlier example. The `pub` function
itself will be called on a timer every second for each row in the `subs`
table.

One thing that is important to be consider whenever using
WebSockets is that the JavaScript `onmessage` function needs a way in
which to identify different responses from one another. Each different
response could have a different data structure that will need to be
handled differently. Perhaps some data should be used in populating
charts while other data for updating a table. If an identifier is
present, it can be used to ensure each response is handled accordingly.
In this example, the responses `func` value acts as our identifier. We can
look at the `func` value and from that determine which function should be
called in order to handle the associated data.
```js
ws.onmessage = function(e) {
    /*parse message from JSON String into Object*/
    var d = JSON.parse(e.data);
    /*
        depending on the messages func value,
        pass the result to the appropriate handler function
    */
    switch(d.func){
        case 'getSyms'   : setSyms(d.result);   break;
        case 'getQuotes' : setQuotes(d.result); break;
        case 'getTrades' : setTrades(d.result);
    }
};
```
The rest of the JavaScript code for the client has been seen in previous
examples. The tables that update in the browser are simply being redrawn
every time the client receives a new response for the appropriate table.

The end result is a simplistic, interactive, real-time web application
showing the latest trade and quote data for a range of symbols. Its
intention is to help readers understand the basic concepts of kdb+ and
WebSocket integration.


:fontawesome-solid-book: 
[Namespace `.h`](../ref/doth.md)

----
:fontawesome-solid-street-view:
_Q for Mortals_
[§11.7.2 Basic WebSockets](/q4m3/11_IO/#1172-basic-websockets)
