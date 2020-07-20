---
title: Interprocess communications – Starting kdb+ – Learn – kdb+ and q documentation
description: How to set up interprocess communications between kdb+ processes
hero: <i class="fas fa-graduation-cap"></i> Starting kdb+
keywords: kdb+, q, start, tutorial, 
---
# Interprocess communications



A production kdb+ system may have several kdb+ processes, possibly on several machines. These communicate via TCP/IP. Any kdb+ process can communicate with any other process as long as it is accessible on the network and is listening for connections.

-   a _server_ process listens for connections and processes any requests
-   a _client_ process initiates the connection and sends commands to be executed

Client and server can be on the same machine or on different machines. A process can be both a client and a server.

A communication can be _synchronous_ (wait for a result to be returned) or _asynchronous_ (no wait and no result returned).


## Initialize server

A kdb+ server is initialized by specifying the port to listen on, with either a command-line parameter or a session command.

```bash
..$ q -p 5001          / command line
```
```q
q)\p 5001              / session command
```


## Communication handle

A _communication handle_ is a symbol that starts with `:` and has the form:

```q
`:[server]:port
```

where the server is optional, and `port` is a port number. The server need not be given if on the same machine. Examples:

```q
`::5001                    / server on same machine as client
`:genie:5001               / server on machine genie
`:198.168.1.56:5001        / server on given IP address
`:www.example.com:5001     / server at www.example.com
```

The function `hopen` starts a connection, and returns an integer _connection handle_. This handle is used for all subsequent client requests. 

```q
q)h:hopen `::5001
q)h "3?20"
1 12 9
q)hclose h
```


## Synchronous/asynchronous

Where the connection handle is used as defined (it will be a positive integer), the client request is synchronous. In this case, the client waits for the result from the server before continuing execution. The result from the server is the result of the client request.

Where the negative of the connection handle is used, the client request is asynchronous. In this case, the request is sent to the server, but the client does not wait or get a result from the server. This is done when a result is not required by the client.

```q
q)h:hopen `::5001
q)(neg h) "a:3?20"          / send asynchronously, no result
q)(neg h) "a"               / again no result
q)h "a"                     / synchronous, with result
0 17 14
```


## Message formats

There are two message formats:

-   a string containing a q expression to be executed on the server
-   a list (function; arg<sub>1</sub>; arg<sub>2</sub>; ...) where the function is to be applied with the given arguments

```q
q)h "2 3 5 + 10 20 30"         / send q expression
12 23 35
q)h (+;2 3 5;10 20 30)         / send function and its arguments
12 23 35
```

If a function name is given, this is called on the server.

```q
q)h ("mydef";2 3 5;10 20 30)   / call function mydef with these arguments
```

There are examples in the [Realtime Database](tick.md) chapter, where a process receives a data feed and posts to subscribers by calling an update function in the subscriber.


## HTTP connections

A kdb+ server can also be accessed via HTTP. To try this, run a kdb+ server on your machine with port 5001. Then, load a Web browser, and go to `http://localhost:5001`. You can now see the names defined in the base context.
