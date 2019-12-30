---
title: Connect and disconnect files and processes | Reference | kdb+ and q documentation
description: hopen and hclose are q keywords for connecting and disconnecting files and processes.
author: Stephen Taylor
keywords: asynchronous, bytes, close, compressed, delete, erase, fifo, file, filehandle, filepath, filesize, filesystem, folder, handle, hclose, hcount, hdel, hopen, hostname, hsym, ip address, ipc, kdb+, named pipe, open, os, pipe, port, process, q, query, request, size, socket, ssl, symbol, timeout, tls
---
# `hopen`, `hclose`


<pre markdown="1" class="language-txt">
[`hopen`](#hopen)   connect a process or file
[`hclose`](#hclose)  disconnect a process or file
</pre>


Kdb+ communicates with the file system and other processes through [handles](../basics/handles.md).

<i class="fas fa-book-open"></i>
[File system](../basics/files.md),
[Interprocess communication](../basics/ipc.md)


## `hopen`

Syntax: `hopen x`, `hopen[x]`

Where `x` is one of 

-   a _process symbol_
-   a 2-item list of a process symbol and a timeout in milliseconds
-   a [file symbol](../basics/glossary.md#file-symbol) or (since V3.6 2017.09.26) [filename](../basics/glossary.md#filename)

opens communication to a file or a process, and returns a handle.


### Processes

A _process symbol_ has the form:

TCP
: `` `:host:port[:user:password]`` 
: `host` can be a hostname or IP address; omitted, it denotes the localhost

Unix domain socket
: `` `:unix://port[:user:password] `` 
: (Since V3.4.) Unix domain sockets can have significantly lower latency and higher throughput than a localhost TCP connection

SSL/TLS
: `` `:tcps://host:port[:user:password] `` 
: <i class="fas fa-graduation-cap"></i> [SSL/TLS](../kb/ssl.md)

User and password are required if the server session has been started with the [`-u`](../basics/cmdline.md#-u-usr-pwd-local) or [`-U`](../basics/cmdline.md#-u-usr-pwd) command line options, and are passed to [`.z.pw`](dotz.md#zpw-validate-user) for (optional) additional processing.

The optional timeout applies to the initial connection, not subsequent use of it.

```q
q)h:hopen `:10.43.23.198:5010                    / IP address
q)h:hopen `:mydb.us.com:5010                     / hostname
q)h:hopen `::5010                                / localhost
q)h:hopen 5010                                   / localhost
q)h:hopen `:unix://5010                          / localhost, Unix domain socket
q)h:hopen `:tcps://mydb.us.com:5010              / SSL/TLS with hostname
q)h:hopen (`:mydb.us.com:5010:elmo:sesame;10000) / full arg list, 10s timeout
```

To send messages to the remote process:

```q
q)h"2+2"          / synchronous (GET)   
4
q)(neg h)"a:2"    / asynchronous (SET)
```

If only one synchronous query/request is to be run, then the single-shot synchronous request can be used to open a connection, send the query, get the results, then close the connection. It is more efficient to keep a connection open if there is an opportunity to re-use it for other queries.

```q
q)`:mydb.us.com:5010:elmo:sesame "1+1"
2
```

<i class="fas fa-book"></i> 
[`.Q.Xf`](dotq.md#qxf-create-file) (create file)
<br>
<i class="fas fa-graduation-cap"></i> 
[Client-server](../kb/client-server.md)


### Files

```q
q)hdat:hopen `:f.dat             / data file (bytes)
q)htxt:hopen `:c:/q/test.txt     / text file
```

Passing char vectors instead of symbols avoids interning of such symbols.
This is useful if embedding frequently-changing tokens in the username or password fields.

For IPC compatibility, it serializes to `{hopen x}`. e.g.

```q
q)hopen each(`:mysymbol;":mycharvector";`:localhost:5000;":localhost:5000";(`:localhost:5000;1000);(":localhost:5000";1000))
```

To append to these files, the syntax is the same as for IPC:

```q
q)r:hdat 0x2324
q)r:htxt "some text\n"
q)r:htxt ` sv("asdf";"qwer")
```


### Fifo/named pipes

V3.4 Unix builds have support for reading from a Fifo/named pipe, where the `hopen` argument has the form `` `:fifo://filename``.

<i class="fas fa-book-open"></i>
[File system](../basics/files.md),
[Client-server](../kb/client-server.md), 
[Named pipes](../kb/named-pipes.md)<br>
<i class="fas fa-graduation-cap"></i>
[SSL/TLS](../kb/ssl.md)



## `hclose`

Syntax: `hclose x`, `hclose[x]`

Where `x` is a file or process handle, closes communication to it and destroys the handle. 
(The corresponding integer can no longer be applied to an argument.)

```q
q)h:hopen `::5001
q)h"til 5"
0 1 2 3 4
q)hclose h
q)h"til 5"
': Bad file descriptor
```

Async connections: pending data on the handle is not sent prior to closing. 
If flushing is required prior to close, this must be done explicitly. 
(Since V3.6 2019.09.19)

```q
q)neg[h][];hclose h; 
```

!!! warning "Before V3.6 2019.09.19"

    If the handle refers to a websocket, `hclose` blocks until any pending data on the handle has been sent.

