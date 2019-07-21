---
title: Callbacks
desacription: The construct of an asynchronous remote call with callback is not built into interprocess communication (IPC) syntax in q, but it is not difficult to implement. We explain here how to do this with simple examples that are easily generalized.
keywords: callback, kdb+, q
---
# Callbacks






The construct of an asynchronous remote call with callback is not built into interprocess communication (IPC) syntax in q, but it is not difficult to implement. We explain here how to do this with simple examples that are easily generalized.

To begin, we establish the following environment and terminology. A client process wishes to make an async call to a q function `proc` on a separate q process, the server, listening on some port, say 5042. In our examples, we assume that the following utility functions are on both the client and the server:

```q
q)echo:{0N!x;}
q)add:{echo x+y}
```

The `echo` utility uses `0N!` to force its argument to the console (i.e., stdout) and then sinks its result to avoid duplicate display in some circumstances.


## Overview

Callback implementation is straightforward if you understand basic IPC in kdb+. 

<i class="far fa-hand-point-right"></i> 
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

Finally, in the remote function obtain the open handle of the calling process from the system variable `.z.w`. Use this link back to the caller to invoke the callback function.


## Example 1

In the simplest case, the client makes an asynchronous call to a unary “remote” function on the server, passing the name of a unary function in its workspace for the remote function to call once it completes. For those who know about such things, the callback represents a _continuation_ for the remote function.

Define `proc` on the server as,

```q
q)proc:{echo x; h:.z.w; (neg h) (y; 43)}
```

In this case, the data for `proc` is passed in the implicit parameter `x` and the callback function name is passed in the implicit parameter `y`. Here the expression `echo x` stands for the actual calculations performed on the server.

Now execute the following on the client. (Note that the sample communication handle assumes that the server process is listening on port 5042 on the same machine as the client. Substitute your actual values.)
```q
q)h:hopen `::5042
q)(neg h) (`proc; 42; `echo)
  ...
q)hclose h
```

This says make an async call to the remote function `proc` , passing it the argument 42 and the symbol `` `echo`` representing the name of the callback function.

The result is that 42 is displayed on the server and then 43 is displayed on the client.


## Example 2

If you need to call a remote function that has more than two data parameters, you cannot use implicit parameters on the server as above. You can either define explicit parameters or encapsulate the arguments in a list. We show the latter here.

Define the following on the server,

```q
q)add3:{x+y+z}
q)proc3:{ echo r:add3 . x; (neg .z.w) (y; r)}
```

Here the data for `proc3` is passed as a list in the implicit parameter `x` , while the callback function name is passed as `y`. Note the use of [`.` (Apply)](../ref/apply.md) to evaluate a non-unary function on a list of arguments.

Now execute the following on the client.

```q
q)(neg h) (`proc3; 1 2 3; `echo)
```

This expression makes an async call to the remote function `proc3`, passing it the list argument `1 2 3` and the symbol `` `echo`` representing the name of the callback function.

The result is that 6 is displayed on the server and then 6 is displayed on the client.


## Example 3

An arbitrary function on the server will not have the appropriate signature to accept a callback. We show here a simple wrapper function that permits any reasonable multivalent function to be called asynchronously with its result returned to the caller.

Define the following on the server.

```q
q)add3:{x+y+z}
q)marshal:{(neg .z.w) (z; (value x) . y)}
```

Here the function `marshal` expects the name of a non-unary function in the first parameter, an argument list for the wrapped function in the second argument and the name of the callback function used to pass back the result in the third argument.

Now execute the following on the client.

```q
q)(neg h) (`marshal; `add3; 1 2 3; `echo)
```

This expression makes an async call to the remote function `marshal`, asking it to invoke the remote function `add3` with list argument `1 2 3` and to pass the result back to `echo`.

The result is that the list is summed on the server and then 6 is displayed on the client.


## Example 4

It is also possible to send a function to be executed remotely on the server using an alternative form of IPC. In this case, nothing needs to be defined on the server in advance. Here we show an example sending an anonymous function that returns its value to the client. 

!!! warning

    Give careful consideration before allowing this style IPC in a production environment as a client can bring down an unprotected server.

Execute the following on the client.

```q
q)(neg h) ({(neg .z.w) (z; x*y)}; 6; 7; `echo)
```

This expression makes an async call sending: 

- a function that multiplies two arguments and returns the result with a callback
- the arguments 6 and 7
- and the name of `echo` for the callback

The result is that 6 and 7 are multiplied on the server and then 42 is displayed on the client.
