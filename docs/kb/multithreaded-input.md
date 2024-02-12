---
title: Multithreaded input queue mode – Knowledge Base – kdb+ and q documentation
description: By default, kdb+ is single-threaded, and processes incoming queries sequentially. An additional mode exists, designed for serving in-memory static data to an externally constrained number of clients only; it is not intended for use as a gateway, or serving mutable data, or data from disk. Each incoming connection is executed in its own thread, and is unable to update globals – it is purely functional in the sense that the execution of a query should not have side-effects.
keywords: input, kdb+, mode, multithreaded, q, queue
---
# Multithreaded input queue mode




By default, kdb+ is single-threaded, and processes incoming queries sequentially.

An additional mode exists, designed for serving in-memory static data to an externally constrained number of clients only; it is not intended for use as a gateway, or serving mutable data, or data from disk. Each incoming connection is executed in its own thread, and is unable to update globals – it is purely functional in the sense that the execution of a query should not have side-effects.

There can be a maximum of 1020 concurrent connections, with each connection requiring a minimum of 64MB, the real amount depending on the working space required by the query being executed. Each connection has its own thread, which is reading, calculating or writing a response. In addition, there is the main thread, which monitors stdin, invokes [`.z.ts`](../ref/dotz.md#zts-timer) on timer expiry and monitors other socket descriptors. (There should not be any). 

Updates to globals are allowed only if they occur from within [`.z.ts`](../ref/dotz.md#zts-timer), or via a socket listed in [`.z.W`](../ref/dotz.md#zw-handles). Updates should not be frequent, as they wait for completion of exiting queries and block new queries (using multiple-read single-write lock), thus slowing processing speeds. If an attempt is made to update globals from threads other than main, a `'no update` error is issued.

The switching in and out of this mode now checks to avoid the situation where the main thread could have a socket open, and sockets being processed in other threads simultaneously.

Multithreaded input queue mode is active when the port for incoming connections is specified as negative, e.g. for startup

```bash
$ q -p -5000
```

Multithreaded input mode supports WebSockets and HTTP (but not TLS) since 4.1t 2021.03.30. TLS support available since 4.1t 2023.12.14.
A custom [`.z.ph`](../ref/dotz.md#zph-http-get) which does not update global state should be used with HTTP. 


## Restrictions

Some of the restrictions are:

1.  queries are unable to update globals
2.  [`.z.po`](../ref/dotz.md#zpo-open) is not called on connect
3.  [`.z.pc`](../ref/dotz.md#zpc-close) is not called on disconnect
4.  [`.z.W`](../ref/dotz.md#zw-handles) has a view on main thread sockets only
5.  cannot send async messages
6.  views can be recalculated from the main thread only

The use of sockets from within those threads is allowed only for the [one-shot sync request](../ref/hopen.md#one-shot-request) and HTTP client request (TLS/SSL support added in 4.1t 2023.11.10). These can be inefficient, as it opens, queries and closes each time. Erroneous socket usage is blocked and signals a `nosocket` error.

In multithreaded input mode, the seed for the random-number generator used for threads other than the main thread is based on the socket descriptor for that connection; these threads are transient – destroyed when the socket is closed, and no context is carried over for new threads/connections.
