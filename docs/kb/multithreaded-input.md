# Multithreaded input queue mode

By default, q is single-threaded, and processes incoming queries sequentially.

An additional mode exists, designed for serving in-memory static data to an externally constrained number of clients only; it is not intended for use as a gateway, or serving mutable data, or data from disk. Each incoming connection is executed in its own thread, and is unable to update globals – it is purely functional in the sense that the execution of a query should not have side-effects.

There can be a maximum of 1020 concurrent connections, with each connection requiring a minimum of 64Mb, the real amount depending on the working space required by the query being executed. Each connection has its own thread, which is either reading, calculating or writing a response; in addition there is the main thread, which monitors stdin, invokes `.z.ts` on timer expiry and monitors other socket descriptors. (There should not be any). 

Updates to globals are not allowed unless they occur from within `.z.ts`, and even then they should not be frequent as the timer expiry waits for completion of exiting queries, blocking new queries (using multiple-read single-write lock). If an attempt is made to update globals from threads other than main, they should get a `'no update` error. If an update came in via the console, or via a socket being processed by the main thread, currently these updates are not thread-safe.

The switching in and out of this mode now checks to avoid the situation where the main thread could have a socket open, and sockets being processed in other threads simultaneously.

Multithreaded input queue mode is active when the port for incoming connections is specified as negative, e.g. for startup
```bash
q -p -5000
```


## Restrictions

Some of the restrictions are:

1.  queries are unable to update globals
2.  `.z.pc` is not called on disconnect
3.  `.z.W` has a view on main thread sockets only
4.  cannot send async messages
5.  cannot serve HTTP requests
6.  views can be recalculated from the main thread only

The use of sockets from within those threads is not allowed for anything other than the [single-shot sync request](/basics/filewords/#hopen), which is the only socket op supported in multithreaded mode. (Inefficient as it opens, queries and closes each time).