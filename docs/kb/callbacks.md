---
title: Asynchronous Callbacks – Knowledge Base – kdb+ and q documentation
description: The construct of an asynchronous remote call with callback is not built into interprocess communication (IPC) syntax in q, but it is not difficult to implement. We explain here how to do this with simple examples that are easily generalized.
keywords: async, remote, ipc, callback, kdb+, q
---
# Asynchronous Callbacks

## Overview

The construct of an asynchronous remote call with callback is not built into interprocess communication (IPC) syntax in q, but it is not difficult to implement. 

Callback implementation is straightforward if you understand basic IPC in kdb+. 

:fontawesome-regular-hand-point-right: 
Basics: [Interprocess Communication](../basics/ipc.md)  
_Q for Mortals_: [§11.6 Interprocess Communication](/q4m3/11_IO/#116-interprocess-communication)

Here are some points to keep in mind.

First, be sure to employ async calls on both the client and the server; otherwise, a deadlock can ensue. For example, due to the single-threaded nature of q, if the client makes a synch call, the attempt to call back to the client from the server function blocks because the original synch call is still being processed and will consequently wait forever. (Recall that an async call uses `neg h` where `h` is an open connection handle.)

Second, it is safest to make remote calls with the IPC form that calls a function by name. One such approach is

```q
q)(neg h) (`proc; arg1;..;argn ; `callback)
```

Here `` `proc`` is a symbol representing the name of the “remote” function to be called, `arg1`, … , `argn` are the data arguments to be passed to the remote calculation and `` `callback`` is a symbol containing the name of the client function for `proc` to call back. If the remote function takes no argument, pass `::` as its argument.

Next, ensure that the “remote” function on the server is expecting the name of the callback routine as one of its arguments. For example, a call of the form given in the previous paragraph assumes that `proc` has the signature,

```q
q)proc:{[arg1;  ;argn ; callname]  }
```

Finally, in the remote function, obtain the open handle of the calling process from the system variable [`.z.w`](../ref/dotz.md#zw-handle). Use this link back to the caller to invoke the callback function.

## Examples

These examples use `0N!` to force its argument to the console (i.e., stdout) and then sinks its result to avoid duplicate display in some circumstances.

### Unary function

In the simplest case, the client makes an asynchronous call to a unary “remote” function on the server, 
passing the name of a unary function in its workspace for the remote function to call once it completes. 
For those who know about such things, the callback represents a _continuation_ for the remote function.

Create a kdb+ instance to act as a server, by listening on a port and defining a `proc` on the server as,

```q
q)\p 5000                                           / listen on port 5000
q)serverFunc:{0N!x;}                                / server function
q)proc:{serverFunc x; h:.z.w; (neg h) (y; 43)}      / function for client to call
```

In this case, the data for `proc` is passed in the implicit parameter `x` and the callback function name is passed in the implicit parameter `y`. 
Here the expression `serverFunc x` stands for the actual calculations performed on the server.

Now execute the following on the client. 
Note that the sample communication handle assumes that the server process is listening on port 5000 on the same machine as the client. Substitute your actual values.
```q
q)clientFunc:{0N!x;}
q)h:hopen `::5000
q)(neg h) (`proc; 42; `clientFunc)
  ...
q)hclose h
```

This says make an async call to the remote function `proc` , passing it the argument 42 and the symbol `` `clientFunc`` representing the name of the callback function.

The result is that 42 is displayed on the server and then 43 is displayed on the client.


### Function with multiple parameters

If you need to call a remote function that has more than two data parameters, you cannot use implicit parameters on the server as above. You can either define explicit parameters or encapsulate the arguments in a list. We show the latter here.

Define the following on the server,

```q
q)\p 5000                                           / listen on port 5000
q)add3:{x+y+z}                                      / server function
q)proc3:{ echo r:add3 . x; (neg .z.w) (y; r)}       / function for client to call
```

Here the data for `proc3` is passed as a list in the implicit parameter `x` , while the callback function name is passed as `y`. 
Note the use of [`.` (Apply)](../ref/apply.md) to evaluate a non-unary function on a list of arguments.

Now execute the following on the client.

```q
q)clientFunc:{0N!x;}
q)h:hopen `::5000
q)(neg h) (`proc3; 1 2 3; `clientFunc)
  ...
q)hclose h
```

This expression makes an async call to the remote function `proc3`, passing it the list argument `1 2 3` and the symbol `` `clientFunc`` representing the name of the callback function.

The result is that 6 is displayed on the server and then 6 is displayed on the client.


### Function wrapper

An arbitrary function on the server does not have the appropriate signature to accept a callback. This example shows a simple wrapper function that permits any reasonable multivalent function to be called asynchronously with its result returned to the caller.

Define the following on the server.

```q
q)\p 5000                                           / listen on port 5000
q)add3:{x+y+z}                                      / server function
q)marshal:{(neg .z.w) (z; (value x) . y)}           / function for client to call
```

Here the function `marshal` expects the name of a non-unary function in the first parameter, an argument list for the wrapped function in the second argument and the name of the callback function used to pass back the result in the third argument.

Now execute the following on the client.

```q
q)clientFunc:{0N!x;}
q)h:hopen `::5000
q)(neg h) (`marshal; `add3; 1 2 3; `clientFunc)
  ...
q)hclose h
```

This expression makes an async call to the remote function `marshal`, asking it to invoke the remote function `add3` with list argument `1 2 3` and to pass the result back to `clientFunc`.

The result is that the list is summed on the server and then 6 is displayed on the client.


### Anonymous functions

It is also possible to send a function to be executed remotely on the server using an alternative form of IPC. 
In this case, nothing needs to be defined on the server in advance. Here we show an example sending an anonymous function that returns its value to the client. 

Start a kdb+ server listening on a choosen port e.g.

```bash
$ q -p 5000
```

Execute the following on the client.

```q
q)clientFunc:{0N!x;} 
q)h:hopen `::5000
q)(neg h) ({(neg .z.w) (z; x*y)}; 6; 7; `clientFunc)
```

This expression makes an async call sending: 

- a function that multiplies two arguments and returns the result with a callback
- the arguments 6 and 7
- and the name of `clientFunc` for the callback

The result is that 6 and 7 are multiplied on the server and then 42 is displayed on the client.

!!! warning

    Give careful consideration before using this style IPC in a production environment as a client can bring down an unprotected server. A kdb+ server can be protected by [authorising](../basics/ipc.md#authentication-authorization) which services are permitted to run.


