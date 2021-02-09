---
title: Listening port – Basics – kdb+ and q documentation
description: Use the -p command-line option or the \p system command to tell kdb+ to listen to a port. The command-line option and the system command take the same parameters and have the same syntax and semantics.
keywords: ephemeral, kdb+, listen, multi-threaded, port, q, socket, unix
---
# Listening port



Use the `-p` [command-line option](cmdline.md) or the `\p` [system command](syscmds.md) to tell kdb+ to listen to a port. The command-line option and the system command take the same parameters.

```txt
\p [rp,][hostname:][portnumber|servicename]
-p [rp,][hostname:](portnumber|servicename)
```

Where

-   `portnumber` is an integer or long infinity
-   `servicename` is defined in `/etc/services`

kdb+ will listen to `portnumber` or the port number of `servicename` on all interfaces, or on `hostname` only if specified.
The port must be available and the process must have permission for the port.

Where no parameter is specified in the system command, the listening port is reported.
The default is 0 (no listening port).

```q
q)\p
0i
```

Use for [client/server](../kb/client-server.md), e.g. kdbc(JDBC ODBC), HTTP (HTML XML TXT CSV).

Given a servicename, q will look up its port number in `/etc/services`.

```q
q)\p commplex-main  / servicename
q)\p
5000i
```

!!! tip "If you know the process is for clients on the localhost only, choose localhost:port for maximum security."


## Load balancing

Optional parameter `rp` enables the use of the `SO_REUSEPORT` socket option, which is available in newer versions of many operating systems, including Linux (kernel version 3.9 and later). This socket option allows multiple sockets (kdb+ processes) to listen on the same IP address and port combination. The kernel then load-balances incoming connections across the processes. (Since V3.5.)

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


## Multi-threaded port

A negative port sets a [multi-threaded](../basics/peach.md) port and if used it must be the initial and only mode of operation, i.e. do not dynamically switch between positive port and negative port.


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
<br>
:fontawesome-solid-graduation-cap:
[Multithreaded input mode](../kb/multithreaded-input.md)
