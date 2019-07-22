---
title: File and process handles
description: hclose, hcount, hdel, hopen, and hsym are q keywords for working with file and process handles.
author: Stephen Taylor
keywords: asynchronous, bytes, close, compressed, delete, erase, fifo, file, filehandle, filepath, filesize, filesystem, folder, handle, hclose, hcount, hdel, hopen, hostname, hsym, ip address, ipc, kdb+, named pipe, open, os, pipe, port, process, q, query, request, size, socket, ssl, symbol, timeout, tls
---
# `hclose`, `hcount`, `hdel`, `hopen`, `hsym`

_File and process handles_




## `hcount`

_File size_

Syntax: `hcount x`, `hcount[x]`

Returns as a long integer the size in bytes of file `x`.

```q
q)hcount`:c:/q/test.txt
42j
```

On a compressed file returns the size of the original uncompressed file.

<i class="far fa-hand-point-right"></i>
Basics: [File system](../basics/files.md), 


## `hdel`

_Delete a file or folder_

Syntax: `hdel x`, `hdel[x]`

Where `x` is a file or folder symbol, deletes it.

```q
q)hdel`:test.txt   / delete test.txt in current working directory
`:test.txt
q)hdel`:test.txt   / should generate an error
'test.txt: No such file or directory
```

!!! warning "`hdel` can delete folders only if empty"

    <pre><code class="language-q">
    q)hdel\`:mydir
    '​mydir​. OS reports: Directory not empty
      [0]  hdel\`:​mydir​
    </code></pre>

!!! tip "Delete a folder and its contents"

    To delete a folder and its contents, [recursively](dotz.md)

    <pre><code class="language-q">
    ​/diR gets recursive dir listing​
    q)diR:{$[11h=type d:key x;raze x,.z.s each\` sv/:x,/:d;d]}
    ​/hide power behind nuke​
    q)​nuke:hdel​ ​each​ ​​desc diR​@​ / desc sort!​
    ​q)nuke\`:mydir
    </code></pre>

For a general visitor pattern with `hdel`

```q
​q)visitNode:{if[11h=type d:key y;.z.s[x]each` sv/:y,/:d;];x y}
q)nuke:visitNode[hdel]
```

<i class="far fa-hand-point-right"></i>
Basics: [File system](../basics/files.md), 


## `hopen`

_Open a file or process handle_

Syntax: `hopen x`, `hopen[x]`

Where `x` is one of 

-   a process handle
-   a 2-item list of a process handle and a timeout in milliseconds
-   a filename: symbol or (since V3.6 2017.09.26) string

opens a file or a process handle, and returns a positive integer handle.

A _process handle_ has the form:

TCP
: `` `:host:port[:user:password]`` 
: `host` can be a hostname or IP address; omitted, it denotes the localhost

Unix domain socket
: `` `:unix://port[:user:password] `` 
: (Since V3.4.) Unix domain sockets can have significantly lower latency and higher throughput than a localhost TCP connection

SSL/TLS
: `` `:tcps://host:port[:user:password] `` 
: <i class="far fa-hand-point-right"></i> Knowledge Base: [SSL/TLS](../kb/ssl.md)

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

<i class="far fa-hand-point-right"></i> 
.Q: [`.Q.Xf`](dotq.md#qxf-create-file) (create file)  
Knowledge Base: [Client-server](../kb/client-server.md)


### File handles

A file handle is used for writing to a file. The `hopen` argument is a symbol or (since V3.6 2017.09.26) string filename:

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

<i class="far fa-hand-point-right"></i> 
Basics: [File system](../basics/files.md),
[Client-server](../kb/client-server.md), 
[Named pipes](../kb/named-pipes.md)  
Knowledge Base: [SSL/TLS](../kb/ssl.md)



## `hclose`

_Close a file or process handle_

Syntax: `hclose x`, `hclose[x]`

Close file or process handle `x`.

```q
q)h:hopen `::5001
q)h"til 5"
0 1 2 3 4
q)hclose h
q)h"til 5"
': Bad file descriptor
```

If the handle refers to 

-   an **IPC socket**, any pending data on that handle is not sent prior to closing
-   a **websocket handle**, `hclose` blocks until any pending data on the handle has been sent

<i class="far fa-hand-point-right"></i>
Basics: [File system](../basics/files.md), 
[IPC](../basics/ipc.md)


## `hsym`

_Convert symbol to file handle_

Syntax: `hsym x`,`hsym[x]`

Converts symbol `x` into a file name, or valid hostname, or IP address. Since V3.1, `x` can be a symbol list.

```q
q)hsym`c:/q/test.txt
`:c:/q/test.txt
q)hsym`10.43.23.197
`:10.43.23.197
```


<i class="far fa-hand-point-right"></i>
Basics: [File system](../basics/files.md)
