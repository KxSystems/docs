---
title: Connect and disconnect files and processes | Reference | kdb+ and q documentation
description: hopen and hclose are q keywords for connecting and disconnecting files and processes.
author: Stephen Taylor
---
# `hopen`, `hclose`


<pre markdown="1" class="language-txt">
[`hopen`](#hopen)   connect a process or file
[`hclose`](#hclose)  disconnect a process or file
</pre>


Kdb+ communicates with the [file system](../basics/files.md) and other processes through

-   one-shot functions
-   [handles](../basics/handles.md) to persistent connections

Connections are opened and closed respectively by `hopen` and `hclose`.


## :fontawesome-solid-handshake: `hopen`

_Open a connection to a file or process_

```txt
hopen filehandle
hopen processhandle
hopen (communicationhandle;timeout)
hopen port
```

Where

-   `filehandle` is a symbol atom (or string since V3.6 2017.09.26)
-   `communicationhandle` is a symbol atom (or string since V3.6 2017.09.26)
-   `timeout` is milliseconds as an integer
-   `port` is a local port number as an integer atom

conencts to a file object or a communication handle, and returns a connection handle as an int.

```q
hopen ":path/to/file.txt"                   / filehandle
hopen `:unix://5010                         / localhost, Unix domain socket
hopen(":10.43.23.198:5010";10000)           / IP address and timeout
hopen 5010                                  / local port number
```

For IPC compatibility, it serializes to `{hopen x}.` e.g.

```q
hopen each(`:mysymbol;
        ":mycharvector";
        `:localhost:5000;
        ":localhost:5000";
        (`:localhost:5000;1000);
        (":localhost:5000";1000))
```


## :fontawesome-solid-handshake-slash: `hclose`

_Close a connection to a file or process_

```txt
hclose x     hclose[x]
```

Where `x` is a connection handle, closes the connection, and destroys the handle.
The corresponding integer can then no longer be applied to an argument.

```q
q)show h:hopen `::5001
3i
q)h"til 5"
0 1 2 3 4
q)hclose h
q)h"til 5"
': Bad file descriptor
```

Async connections: pending data on the connection handle is not sent prior to closing.
If flushing is required prior to close, this must be done explicitly.
(Since V3.6 2019.09.19)

```q
q)neg[h][];hclose h;
```

!!! info "`hclose` before V3.6 2019.09.19"

    If the handle refers to a WebSocket, `hclose` blocks until any pending data on the connection handle has been sent.


## :fontawesome-solid-database: Files

If a filehandle specifies a non-existent filepath, it is created, including directories.

```q
q)hdat:hopen ":f.dat"             / data file (bytes)
q)htxt:hopen ":c:/q/test.txt"     / text file
```

??? tip "Passing strings instead of symbols avoids interning of such symbols."

    This is useful if embedding frequently-changing tokens in the username or password fields.

!!! warning "Do not use colons in a file-path. It conflicts with the pattern used to identify a process."

To append to these files, the syntax is the same as for IPC:

```q
q)r:hdat 0x2324
q)r:htxt "some text\n"
q)r:htxt ` sv("asdf";"qwer")
```


## :fontawesome-solid-handshake: Processes

### Communication handles

A communication handle specifies a network resource, and may include authentication credentials for it. There are four forms.

TCP
: `` `:host:port[:user:password]``
: `host` can be a hostname or IP address; omitted, it denotes the localhost

Unix domain socket
: `` `:unix://port[:user:password] ``
: (Since V3.4.) Unix domain sockets can have significantly lower latency and higher throughput than a localhost TCP connection

SSL/TLS
: `` `:tcps://host:port[:user:password] ``
: :fontawesome-solid-graduation-cap: [SSL/TLS](../kb/ssl.md)

Fifo/named pipe

: `` `:fifo://filename``
: On Unix builds since V3.4.


```q
hopen `:10.43.23.198:5010                    / IP address
hopen ":mydb.us.com:5010"                    / hostname
hopen `::5010                                / localhost
hopen 5010                                   / localhost
hopen `:unix://5010                          / localhost, Unix domain socket
hopen `:tcps://mydb.us.com:5010              / SSL/TLS with hostname
hopen (`:mydb.us.com:5010:elmo:sesame;10000) / full arg list, 10s timeout
```

User and password are required if the server session has been started with the [`-u`](../basics/cmdline.md#-u-usr-pwd-local) or [`-U`](../basics/cmdline.md#-u-usr-pwd) command line options, and are passed to [`.z.pw`](dotz.md#zpw-validate-user) for (optional) additional processing.

The optional timeout applies to the initial connection, not subsequent use of it.

To send messages to the remote process:

```q
q)h"2+2"          / synchronous (GET)
4
q)(neg h)"a:2"    / asynchronous (SET)
```


### :fontawesome-solid-thumbs-up: One-shot request

If only one synchronous query/request is to be run, then the one-shot synchronous request can be used to connect, send the query, get the results, then disconnect.

```q
q)`:mydb.us.com:5010:elmo:sesame "1+1"
2
```

It is more efficient to keep a connection open if there is an opportunity to re-use it for other queries.



----
:fontawesome-solid-book:
[`.Q.Xf`](dotq.md#qxf-create-file) (create file)
<br>
:fontawesome-solid-book-open:
[Communication handle](../basics/glossary.md#communication-handle),
[Connection handle](../basics/glossary.md#connection-handle),
[File system](../basics/files.md),
[Interprocess communication](../basics/ipc.md)
<br>
:fontawesome-solid-graduation-cap:
[Client-server](../kb/client-server.md),
[Named pipes](../kb/named-pipes.md),
[SSL/TLS](../kb/ssl.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§11.6.2 Opening a Connection Handle](/q4m3/11_IO/#1162-opening-a-connection-handle)
