---
title: Deferred response – Knowledge Base – kdb+ and q documentation
description: Ideally, for concurrency, all messaging would be async. However, sync messaging is a convenient paradigm for client apps. Hence [-30!x](../basics/internal.md#-30x-deferred-response) was added as a feature in V3.6, allowing processing of a sync message to be ‘suspended’ to allow other messages to be processed prior to sending a response message. 
author: Charles Skelton
keywords: async, concurrency, deferred, kdb+_, q, response, sync
---
# Deferred response

## Overview

Ideally, for concurrency, all messaging would be async. However, sync messaging is a convenient paradigm for client apps. 

You can use [`-30!x`](../basics/internal.md#-30x-deferred-response) to allow processing of a sync message to be ‘suspended’, by indicating the response for the currently-executing sync message to be sent explicitly later. 

This allows other messages to be processed prior to sending a response message. 

You can use `-30!(::)` at any place in the execution path of [`.z.pg`](../ref/dotz.md#zpg-get), start up some work, allow `.z.pg` to complete without sending a response, and then when the workers complete the task, send the response explicitly.

## Example

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

:fontawesome-regular-hand-point-right:
Blog: [Deferred Response](https://kx.com/blog/kdb-q-insights-deferred-response/)

