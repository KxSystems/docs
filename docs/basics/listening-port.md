---
title: Listening port – Basics – kdb+ and q documentation
description: Use the -p command-line option or the \p system command to tell kdb+ to listen to a port. The command-line option and the system command take the same parameters and have the same syntax and semantics.
keywords: ephemeral, kdb+, listen, multi-threaded, port, q, socket, unix
---
# Listening port

Use the [`-p` command-line option](cmdline.md#-p-listening-port) or the [`\p` system command](syscmds.md#p-listening-port) to tell kdb+ to listen to a port. The command-line option and the system command take the same parameters.

```txt
\p [rp,][hostname:][portnumber|servicename]
-p [rp,][hostname:](portnumber|servicename)
```

Where

-   `portnumber` is an integer or long infinity
-   `servicename` is defined in `/etc/services`

kdb+ will listen to `portnumber` or the port number of `servicename` on all interfaces, or on `hostname` only if specified.
The port must be available and the process must have permission for the port.

As of 4.1t 2022.11.01 (or 4.0 2022.10.26) a port range can be specified in place of a portnumber. The range of ports is inclusive and tried in a random order. A service name can be used instead of each port number. Using 0W to choose a free ephemeral port can be more efficient (where suitable).

```q
q)\p 80/85
q)\p
81
```

Where no parameter is specified in the system command, the listening port is reported.
The default is 0 (no listening port).

```q
q)\p
0i
```

Given a servicename, q will look up its port number in `/etc/services`.

```q
q)\p commplex-main  / servicename
q)\p
5000i
```

!!! tip "If you know the process is for clients on the localhost only, choose localhost:port for maximum security."

## Preventing connections

To stop the process listening on a port at runtime, instruct it to listen on port 0:

```q
q)\p 0
```

By default, kdb+ won't listen to a port unless a port is specified.

## Load balancing

Optional parameter `rp` enables the use of the `SO_REUSEPORT` socket option, which is available in newer versions of many operating systems, including Linux (kernel version 3.9 and later). This socket option allows multiple sockets (kdb+ processes) to listen on the same IP address and port combination. The kernel then load-balances incoming connections across the processes. (Since V3.5.)

:fontawesome-solid-graduation-cap:
[Socket sharding with kdb+ and Linux](../wp/socket-sharding/index.md)

:fontawesome-solid-graduation-cap:
[A load-balancing kdb+ server](../kb/load-balancing.md)


## Ephemeral port

A `portnumber` of `0W` means pick a random available port within the range 32768–60999.

```q
q)\p 5010     / set port 5010
q)\p
5010
q)\p 0W       / pick a random available port within the range 32768 - 60999
q)\p
45512
q)\p 0        / turn off listening port
```

## Port range

An inclusive range of ports can be used in place of a `portnumber`, to randomly use an available port within the given range (since V3.5/3.6 2023.03.13,V4.0 2022.10.26,V4.1 2022.11.01). A service name can be used instead of a port number within the range. Note that the ephemeral port option also provides the ability to choose from a range of ports.

```q
q)\p 2000/2010            / use a free port between 2000 and 2010
q)\p -2000/2010           / use a free port between 2000 and 2010 in multithreaded mode
q)\p myhost:2000/2010     / use a free port between 2000 and 2010, using given hostname
```

## Multi-threaded input mode

A negative port sets a multi-threaded port and if used it must be the initial and only mode of operation, 
i.e. do not dynamically switch between positive port and negative port.

When active, each IPC connection will create a new thread for its sole use.
Each connection uses its own heap with a minimum of 64MB, the real amount depending on the working space required by the query being executed. 
[`\ts`](syscmds.md#ts-time-and-space) can be used to find the memory requirement of a query.
It is designed for serving in-memory static data to an externally constrained number of clients. It is not intended for use as a gateway, or serving mutable data.

Note that there are a number of restrictions in multithreaded mode:

* queries are unable to update globals
* [.z.po](../ref/dotz.md#zpo-open) is not called on connect
* [.z.pc](../ref/dotz.md#zpc-close) is not called on disconnect
* [.z.W](../ref/dotz.md#zw-handles) has a view on main thread sockets only
* Cannot send async message
* Views can be recalculated from the main thread only
* Uncompressed pages will not be shared between threads (i.e. same situation as with starting a separate hdb for each request). 

The main thread is allowed to update globals. The main thread is responsible for reading from stdin (i.e. the console) and executing any loaded scripts on start-up.
It also invokes [.z.ts](../ref/dotz.md#zts-timer) on [timer expiry](syscmds.md#t-timer). 
Any connections made via IPC from the main thread, can be monitored
for callbacks (for example via an [async callback](../kb/callbacks.md)) which in turn can update globals.
While the main thread is processing an update (for example, a timer firing or console input) none of the connection threads will be processing any input.
Updates should not be frequent, as they wait for completion of exiting queries and block new queries (using multiple-read single-write lock), thus slowing processing speeds. 
If an attempt is made to update globals from threads other than main, a 'no update error is issued.

Multithreaded input mode supports WebSockets and HTTP (but not TLS) since 4.1t 2021.03.30. 
TLS support available since 4.1t 2023.12.14. A custom [.z.ph](../ref/dotz.md#zph-http-get) which does not update global state should be used with HTTP.

The use of sockets from within those threads is allowed only for the one-shot sync request and HTTP client request (TLS/SSL support added in 4.1t 2023.11.10). 
These can be inefficient, as it opens, queries and closes each time. Erroneous socket usage is blocked and signals a nosocket error.

In multithreaded input mode, the seed for the random-number generator used for threads other than the main thread is based on the socket descriptor for that connection; 
these threads are transient – destroyed when the socket is closed, and no context is carried over for new threads/connections.

## Unix domain socket

Setting the listening port with `-p 5000`  in addition to listening on TCP port 5000, also creates a UDS (Unix domain socket) on `/tmp/kx.5000`.
You can disable listening on the UDS, or change the default path from `/tmp` using environment variable `QUDSPATH`.

```q
q)/ disable listening on unix domain socket
q)system"p 0";setenv[`QUDSPATH;""];system"p 6000"
q)/ use /home/kdbuser as path
q)system"p 0";setenv[`QUDSPATH;"/home/kdbuser"];system"p 6000"
```

V3.5+ uses abstract namespace for Unix domain sockets on Linux to avoid file-permission issues in `/tmp`.

N.B. hence V3.5 cannot connect to V3.4 using UDS.

```q
q)hopen`:unix://5000
```

On macOS:

```q
q)\p 5000
q)\ls /tmp/kx*
"/tmp/kx.5000"
q)system"p 0";setenv[`QUDSPATH;""];system"p 5000"
q)\ls /tmp/kx*
ls: /tmp/kx*: No such file or directory
'os
q)system"p 0";setenv[`QUDSPATH;"/tmp/kxuds"];system"p 5000"
'cannot listen on uds /tmp/kxuds/kx.5000. OS reports: No such file or directory
  [0]  system"p 0";setenv[`QUDSPATH;"/tmp/kxuds"];system"p 5000"
                                                  ^
q)\mkdir /tmp/kxuds
q)system"p 0";setenv[`QUDSPATH;"/tmp/kxuds"];system"p 5000"
q)\ls /tmp/kxuds
"kx.5000"
```


## Security

Once you open a port in q session, it is open to all connections, including HTTP requests. 

!!! tip "In a production environment secure any process with an open port."


---
:fontawesome-solid-book:
[`hopen`](../ref/hopen.md)
<br>
:fontawesome-solid-book-open:
Command-line options [`-e`](cmdline.md#-e-tls-server-mode),
[`-p`](cmdline.md#-p-listening-port); 
system command [`\p`](syscmds.md#p-listening-port)
