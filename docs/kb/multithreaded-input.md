---
title: Multithreaded input queue mode
description: By default, kdb+ is single-threaded, and processes incoming queries sequentially. An additional mode exists, designed for serving in-memory static data to an externally constrained number of clients only; it is not intended for use as a gateway, or serving mutable data, or data from disk. Each incoming connection is executed in its own thread, and is unable to update globals – it is purely functional in the sense that the execution of a query should not have side-effects.
keywords: input, kdb+, mode, multithreaded, q, queue
---
# Multithreaded input queue mode




By default, kdb+ is single-threaded, and processes incoming queries sequentially.

An additional mode exists, designed for serving in-memory static data to an externally constrained number of clients only; it is not intended for use as a gateway, or serving mutable data, or data from disk. Each incoming connection is executed in its own thread, and is unable to update globals – it is purely functional in the sense that the execution of a query should not have side-effects.

There can be a maximum of 1020 concurrent connections, with each connection requiring a minimum of 64MB, the real amount depending on the working space required by the query being executed. Each connection has its own thread, which is either reading, calculating or writing a response; in addition there is the main thread, which monitors stdin, invokes `.z.ts` on timer expiry and monitors other socket descriptors. (There should not be any). 

Updates to globals are allowed only if they occur from within `.z.ts`, or via a socket listed in `.z.W`, and even then they should not be frequent, as these wait for completion of exiting queries, blocking new queries (using multiple-read single-write lock). If an attempt is made to update globals from threads other than main, they should get a `'no update` error.

The switching in and out of this mode now checks to avoid the situation where the main thread could have a socket open, and sockets being processed in other threads simultaneously.

Multithreaded input queue mode is active when the port for incoming connections is specified as negative, e.g. for startup

```bash
$ q -p -5000
```


## Restrictions

Some of the restrictions are:

1.  queries are unable to update globals
2.  `.z.pc` is not called on disconnect
3.  `.z.W` has a view on main thread sockets only
4.  cannot send async messages
5.  cannot serve HTTP requests
6.  views can be recalculated from the main thread only

The use of sockets from within those threads is not allowed for anything other than the [single-shot sync request](../ref/handles.md#hopen), which is the only socket opening supported in multithreaded mode. (Inefficient, as it opens, queries and closes each time).

In multithreaded input mode, the seed for the random-number generator used for threads other than the main thread is based on the socket descriptor for that connection; these threads are transient – destroyed when the socket is closed, and no context is carried over for new threads/connections.