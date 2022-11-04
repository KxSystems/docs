---
title: A load-balancing kdb+ server | Knowledge Base | kdb+ and q documentation
description: The primary server starts secondary servers; clients send requests to the primary server which chooses a secondary server with low CPU load, and forwards the request there. 
---
# A load-balancing kdb+ server






The script 
:fontawesome-brands-github: 
[KxSystems/kdb/e/mserve.q](https://github.com/KxSystems/kdb/blob/master/e/mserve.q) 
can be used to start a load-balancing kdb+ server. The primary server starts a number of secondary servers (in the same host). Clients then send requests to the primary server which, transparently to the client, chooses a secondary server with low CPU load, and forwards the request there.

This set-up is useful for read operations, such as queries on historical databases. Each query is executed in one of the secondary threads, hence writes are not replicated.


## Starting the primary server

The arguments are the number of secondary servers, and the name of a q script that will be executed by the secondary servers at start-up. Typically this script will read in a database from disk into memory.

```bash
$ q mserve.q -p 5001 2 startup.q
```


## Client request

In the client, connect to the server with `hopen`

```q
q)h: hopen `:localhost:5001
```

Synchronous messages are executed at the primary server.

```q
q)h "xs: til 9"
q)h "xs"
0 1 2 3 4 5 6 7 8
```

Asynchronous messages are forwarded to one of the secondary servers, transparently to the client. The code below issues an asynchronous request, then blocks on the handle waiting for a result to be returned. This is called _deferred synchronous_.

```q
q)(neg h) "select sym,price from trade where size > 50000" ; h[]
```

Deferred synchronous requests can also be made from non-q clients. 
For example, the 
<!-- FIXME -->
[example grid viewer](../interfaces/java-client-for-q.md#example-grid-viewer-using-swing) 
code can be modified to issue a deferred synchronous request rather than a synchronous request by sending an async request and blocking on the handle in exactly the same way. The line

```java
model.setFlip((c.Flip) c.k(query));
```

should be modified to

```java
c.ks(query);
model.setFlip((c.Flip) c.k());
```


## Source code

The complete source code for `mserve.q` is quite short, reproduced here for convenience.

```q
/ start secondary servers
{value"\\q ",.z.x[1]," -p ",string x}each p:(value"\\p")+1+til"I"$.z.x 0;

/ unix (comment out for windows)
\sleep 1

/ connect to secondary servers
h:neg hopen each p;h@\:".z.pc:{exit 0}";h!:()

/ fields queries. assign query to least busy secondary server
.z.ps:{$[(w:neg .z.w)in key h;[h[w;0]x;h[w]:1_h w];                    /response
 [h[a?:min a:count each h],:w;a("{(neg .z.w)@[value;x;`error]}";x)]]}  /request
```

