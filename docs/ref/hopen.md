# `hopen`



_Open a file or process handle_

Syntax: `hopen x`, `hopen[x]`

Where `x` is one of 

-  a process handle
-  a 2-item list of a process handle and a timeout in milliseconds
-  a filename

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
: <i class="far fa-hand-point-right"></i> Knowledge Base: [SSL/TLS](/kb/ssl/)

User and password are required if the server session has been started with the [`-u`](cmdline/#-u-usr-pwd-local) or [`-U`](cmdline/#-u-usr-pwd) command line options, and are passed to [`.z.pw`](dotz/#zpw-validate-user) for (optional) additional processing.

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
[Client-server](../kb/client-server.md), 
[`.Q.Xf`](dotq.md#qxf-create-file) (create file)


## File handles

A file handle is used for writing to a file. The `hopen` argument is a symbol filename:

```q
q)hdat:hopen `:f.dat             / data file (bytes)
q)htxt:hopen `:c:/q/test.txt     / text file
</code></pre>
To append to these files, the syntax is the same as for IPC:
<pre><code class="language-q">
q)r:hdat 0x2324
q)r:htxt "some text\n"
q)r:htxt ` sv("asdf";"qwer")
```


## Fifo/named pipes

V3.4 Unix builds have support for reading from a Fifo/named pipe, where the `hopen` argument has the form `` `:fifo://filename``.

<i class="far fa-hand-point-right"></i> 
[File system](../basics/files.md),
[Client-server](../kb/client-server.md), 
[Named pipes](../kb/named-pipes.md), 
[SSL/TLS](../kb/ssl.md)

