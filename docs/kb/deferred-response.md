---
title: Deferred response
description: Ideally, for concurrency, all messaging would be async. However, sync messaging is a convenient paradigm for client apps. Hence -30!x was added as a feature in V3.6, allowing processing of a sync message to be ‘suspended’ to allow other messages to be processed prior to sending a response message. 
author: Charles Skelton
keywords: async, concurrency, deferred, kdb+_, q, response, sync
---
# Deferred response




Ideally, for concurrency, all messaging would be async. However, sync messaging is a convenient paradigm for client apps. Hence `-30!x` was added as a feature in V3.6, allowing processing of a sync message to be ‘suspended’ to allow other messages to be processed prior to sending a response message. 

How it works: `-30!(::)` indicates the response for the currently-executing sync message will be sent explicitly later via `-30!(handle;isError;msg)`.

You can use `-30!(::)` at any place in the execution path of [`.z.pg`](../ref/dotz.md#zpg-get), start up some work, allow `.z.pg` to complete without sending a response, and then when the workers complete the task, send the response explicitly.

Kdb+ tracks which handles are expecting a response. If you try to send a response to a handle that is not expecting one, you’ll see

```q
q).z.W / list of socket handles being monitored by kdb+ main thread
8i 
q)-30!(8i;0b;`hello`world) / try to send a response of (0b;`hello`world)
'Handle 8 was not expecting a response msg
  [0]  -30!(8i;0b;`hello`world)
          ^
```

and if the handle is not a member of [`.z.W`](../ref/dotz.md#zw-handles), you’ll observe a `'domain` error.

Below is a simple script to demonstrate the mechanics of `-30!x` in a gateway. Further error checking, [`.z.pc`](../ref/dotz.md#zpc-close), timeouts, sequence numbers, load-balancing, etc., are left as an exercise for the reader.

```q
workerHandles:hopen each 6000 6001 / open handles to worker processes

pending:()!() / keep track of received results for each clientHandle

/ this example fn joins the results when all are received from the workers
reduceFunction:raze

/ each worker calls this with (0b;result) or (1b;errorString) 
callback:{[clientHandle;result] 
 pending[clientHandle],:enlist result; / store the received result
 / check whether we have all expected results for this client
 if[count[workerHandles]=count pending clientHandle; 
   / test whether any response (0|1b;...) included an error
   isError:0<sum pending[clientHandle][;0]; 
   result:pending[clientHandle][;1]; / grab the error strings or results
   / send the first error or the reduced result
   r:$[isError;{first x where 10h=type each x};reduceFunction]result; 
   -30!(clientHandle;isError;r); 
   pending[clientHandle]:(); / clear the temp results
 ]
 }

.z.pg:{[query]
  remoteFunction:{[clntHandle;query]
    neg[.z.w](`callback;clntHandle;@[(0b;)value@;query;{[errorString](1b;errorString)}])
  };
  neg[workerHandles]@\:(remoteFunction;.z.w;query); / send the query to each worker
  -30!(::); / defer sending a response message i.e. return value of .z.pg is ignored
 }
```

<i class="far fa-hand-point-right"></i> 
Basics: [Internal `-30!x`](../basics/internal.md#-30x-deferred-response)  
[Namespace `.z`](../ref/dotz.md)

