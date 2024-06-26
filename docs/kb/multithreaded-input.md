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

Multithreaded input queue mode is active when the port for incoming connections is specified as [negative](../basics/listening-port.md#negative-ports), e.g. for startup

```bash
$ q -p -5000
```
