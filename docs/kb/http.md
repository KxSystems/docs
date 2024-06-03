---
title: HTTP – Knowledge Base – kdb+ and q documentation
description: How to work with HTTP in q
keywords: browser, http, https, kdb+, q, web
---
# :fontawesome-solid-handshake: HTTP

## HTTP client

### Creating HTTP requests

kdb+ has helper methods that provide functionality as described in the linked reference material:

* [.Q.hg](../ref/dotq.md#hg-http-get) for performing a HTTP GET, where a query string can be sent in the URL
* [.Q.hp](../ref/dotq.md#hp-http-post) for performing a HTTP POST, where data transmitted is sent in the request body

e.g.
```q
q)/ perform http post
q).Q.hp["http://httpbin.org/post";.h.ty`txt]"my data"
"{\n  \"args\": {}, \n  \"data\": \"my data\", \n  \"files\": {}, \n  \"form\": {}, \n  \"headers\": {\n    \"Accept-Encoding\": \"gzip\", \n    \"Content-Length\": \"7\", \n    \"Content-Type\": \"text/plain\", \n    \"Host\": \"httpbin.org\", \n    \"X-Amzn-Trace-Id\": \"Root=1-665711e1-19e62fef6b6e4d192a9a7096\"\n  }, \n  \"json\": null, \n  \"origin\": \"78.147.173.108\", \n  \"url\": \"http://httpbin.org/post\"\n}\n"
q)/ request gzipped data, which is unzipped & returned in json and formatted appropriately
q).j.k .Q.hg "http://httpbin.org/gzip"
gzipped| 1b
headers| `Accept-Encoding`Host`X-Amzn-Trace-Id!("gzip";"httpbin.org";"Root=1-665710aa-50bd49d724b532913348a62a")
method | "GET"
origin | "78.147.173.108"
```

In addition, kdb+ provides a low level HTTP request mechanism:

```q
`:http://host:port "string to send as HTTP request"
```

which returns the HTTP response as a string. 

An HTTP request generally consists of:

* a request line (URL, method, protocol version), terminated by a carriage return and line feed, 
* zero or more header fields (field name, colon, field value), terminated by a carriage return and line feed
* an empty line (consisting of a carriage return and a line feed) 
* an optional message body

e.g.

```q
q)/ perform HTTP DELETE
q)`:http://httpbin.org "DELETE /anything HTTP/1.1\r\nConnection: close\r\nHost: httpbin.org\r\n\r\n"
"HTTP/1.1 200 OK\r\ndate: Wed, 29 May 2024 12:23:54 GMT\r\ncontent-type: application/json\r\ncontent-length: 290\r\nconnection: close\r\nserver: gunicorn/19.9.0\r\naccess-control-allow-origin: *\r\naccess-control-allow-credentials: true\r\n\r\n{\n  \"args\": {},...
q)postdata:"hello"
q)/ perform HTTP POST (inc Content-length to denote the payload size)
q)`:http://httpbin.org "POST /anything HTTP/1.1\r\nConnection: close\r\nHost: httpbin.org\r\nContent-length: ",(string count postdata),"\r\n\r\n",postdata
"HTTP/1.1 200 OK\r\ndate: Wed, 29 May 2024 13:08:41 GMT\r\ncontent-type: application/json\r\ncontent-length: 321\r\nconnection: close\r\nserver: gunicorn/19.9.0\r\naccess-control-allow-origin: *\r\naccess-control-allow-credentials: true\r\n\r\n{\n  \"args\": {}, \n  \"data\": \"hello\"...
```

An HTTP response typically consists of:

* a status line (protocol version, status code, reason), terminated by a carriage return and line feed
* zero or more header fields (field name, colon, field value), terminated by a carriage return and line feed
* an empty line (consisting of a carriage return and a line feed)
* an optional message body

e.g.

```q
q)/ x will be complete HTTP response
q)x:`:http://httpbin.org "DELETE /delete HTTP/1.1\r\nConnection: close\r\nHost: httpbin.org\r\n\r\n"
q)/ seperate body from headers, get body
q)@["\r\n\r\n" vs x;1]
"{\n  \"args\": {}, \n  \"data\": \"\", \n  \"files\": {}, \n  \"form\": {}, \n  \"headers\": {\n    \"Host\": \"httpbin.org\", \n    \"X-Amzn-Trace-Id\": \"Root=1-66572924-7396cee34f268fcd406e94d5\"\n  }, \n  \"json\": null, \n  \"origin\": \"78.147.173.108\", \n  \"url\": \"http://httpbin.org/delete\"\n}\n"
```

!!! note "If a server uses chunked transfer encoding, the response will be constructed from the chunks prior to returning (since V3.3 2014.07.31)"

:fontawesome-regular-map:
[HTTP](https://en.wikipedia.org/wiki/HTTP)


### SSL/TLS

To use SSL/TLS, kdb+ should first be [configured to use SSL/TLS](ssl.md). For any request requiring SSL/TLS, replace `http` with `https`.

## HTTP Server

kdb+ has an in-built service capable of handling HTTP/HTTPS requests.

### Listening Port

When kdb+ is [configured](../basics/listening-port.md) to listen on a port, it uses the same port as that serving kdb+ IPC and websocket connections.

### SSL/TLS

HTTPS can be handled once kdb+ has been [configured to use SSL/TLS](ssl.md).

### Authentication / Authorization

Client requests can be authenticated/authorized using [.z.ac](../ref/dotz.md#zac-http-auth). 
This allows kdb+ to be customised with a variety of mechanisms for securing HTTP requests  e.g. LDAP, OAuth2, OpenID Connect, etc.

### Request Handling

HTTP request handling is customized by using the following callbacks:

* [.z.ph](../ref/dotz.md#zph-http-get) for HTTP GET
* [.z.pp](../ref/dotz.md##zpp-http-post) for HTTP POST
* [.z.pm](../ref/dotz.md##zpp-http-post) for HTTP OPTIONS/PATCH/PUT/DELETE

#### Default .z.ph handling

The default implementation of .z.ph displays all variables and views. For example, starting kdb+ listening on port (`q -p 8080`) and visiting `http://localhost:8080` from a web browser on the same machine, displays all created variables/views).

Providing q code as a GET param causes it to be evaluated eg. `http://localhost:8080?1+1` returns `2`. 

[.h.HOME](../ref/doth.md#hhome-webserver-root) can be set to be the webserver root in order to serve files contained in the directory e.g.
creating an HTML file index.html in directory `/webserver/` and setting `.h.HOME="/webserver"` allows the file to be viewed via  `http://localhost:8080/index.html'.

:fontawesome-regular-map:
[Restricting HTTP queries](../wp/permissions/index.md#restricting-http-queries)
<br>
:fontawesome-regular-map:
[Custom web server](custom-web.md)

### Keep-Alive

Persistent connections to supported clients can be enabled via [.h.ka](../ref/doth.md#hka-http-keepalive)

### Compression

HTTP server supports gzip compression via `Content-Encoding: gzip` for responses to `form?…`-style requests.
The response payload must be 2,000+ chars and the client must indicate support via `Accept-Encoding: gzip` in the HTTP header.
(Since V4.0 2020.03.17.)

## HTTP Markup

The [.h namespace](../ref/doth.md) provides a range of markup and HTTP protocol formatting tools.

----
:fontawesome-solid-street-view:
_Q for Mortals_
[§11.7.1 HTTP Connections](/q4m3/q4m3/11_IO/#1171-http-connections)
