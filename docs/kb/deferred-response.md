---
title: Deferred response – Knowledge Base – kdb+ and q documentation
description: Ideally, for concurrency, all messaging would be async. However, sync messaging is a convenient paradigm for client apps. Hence [-30!x](../basics/internal.md#-30x-deferred-response) was added as a feature in V3.6, allowing processing of a sync message to be ‘suspended’ to allow other messages to be processed prior to sending a response message. 
author: Charles Skelton
keywords: async, concurrency, deferred, kdb+_, q, response, sync
---
# Deferred response

## Overview

Ideally, for concurrency, all messaging would be async. However, sync messaging is a convenient paradigm for client apps. 

On the server side of client request, [`.z.pg`](../ref/dotz.md#zpg-get) handles the sync request, performs the required task and returns the outcome.

The sync callback [`.z.pg`](../ref/dotz.md#zpg-get) can be redefined to implement custom logic for an sync request. By using [`-30!x`](../basics/internal.md#-30x-deferred-response), `.z.pg` does not need to return the outcome. It is used to flag that the outcome will be returned later and the callback can return without any response being sent to the client.
Once the result is ready, call [`-30!x`](../basics/internal.md#-30x-deferred-response) again to send the data to the waiting client.

This allows other messages to be processed prior to sending a response message. 

## Example

There are many situations in which deferred responses can be applied. 
For this example, we will show 2 worker nodes that will perform the requested work for the client. 
The client will communicate via a gateway.

The gateway will use custom logic that uses deferred response, in order to send request to the 2 worker nodes and respond later when all responses have been received. 
This allows the gateway to service other clients while the worker nodes perform their task. Only when the 2 worker nodes reply, is the amalgamated response sent to the client.
The instances will be run on the same machine for simplicity of the example, but it can be altered to run on multiple machines.

### Workers

Start 2 worker nodes. Each will contain a very small table with different data so that we can easily identify the data received by the client. In practise, this could be an extremely large dataset.

Start one worker node to listen on port 6000, e.g. `q -p 6000`
```q
q)t:([]a:1 2 3;b:4 5 6)
```
Start one worker node to listen on port 6001, e.g. `q -p 6001`
```q
q)t:([]a:11 12 13;b:14 15 16)
```

### Gateway 

Below is a simple script to demonstrate the mechanics of `-30!x` in a gateway, via a custom script `gateway.q`

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

Run the gateway script and listen to port 5000 for client requests i.e. `q gateway.q -p 5000`

Further error checking, [`.z.pc`](../ref/dotz.md#zpc-close), timeouts, sequence numbers, load-balancing, etc., are left as an exercise for the reader.

### Client

Run kdb+ (`q`) and connect to the gateway. The gateway will pass the instruction to both worker nodes. 
Only when both worker nodes reply, is the [`raze`](../ref/raze.md) function applied to both sets of data to form a single data set. It is then returned to the client.

```q
q)h:hopen 5000
q)h"select from t"
a  b
-----
11 14
12 15
13 16
1  4
2  5
3  6
```

:fontawesome-regular-hand-point-right:
Blog: [Deferred Response](https://kx.com/blog/kdb-q-insights-deferred-response/)

