---
title: Multi-threading – Machine Learning – kdb+ and q documentation
description: The toolkit two files called mproc.q and mprocw.q which are used for multi-thread processing within the toolkit
author: Diane O'Donoghue
date: March 2020
keywords: machine learning, ml, utilitites, multi-threading, kdb+, q
---
# <i class="fas fa-share-alt"></i> Multiprocess distribution framework


<i class="fab fa-github"></i>
[KxSystems/ml](https://github.com/kxsystems/ml/)


Multithreading has been utilized in both the FRESH and cross-validation libraries by loading in the script `util/mproc.q`. This framework supports distribution of both q and Python code. In order to initialise a process using multiple processes, the following steps are followed:

 - Initialize a q process with four workers on a user-defined central port.

``` bash
$ q ml/ml.q -s -4 -p 1234
```

The above command sets 4 processes using port 1234

- Load the library ( .ml.loadfile`:util/mproc.q)  into the main process.

- Call .ml.mproc.init to create and initialize worker processes, e.g. to initialize workers with the FRESH library, call

```q
.ml.mproc.init[abs system"s"]enlist".ml.loadfile`:fresh/init.q"
```

Which results in the following architecture

![Figure 1](../img/multiprocess.png)

Using this process results in functions within the FRESH and cross validation libraries to be peached across the defined number of ports and main port. 

This can be initialised using:

**Fresh**

```q
q)\l ml/ml.q            // initialize ml.q on the console
q).ml.loadfile`:fresh/init.q           // initialize fresh
```

**Cross-Validation process**

```q
q)\l ml/ml.q            // initialize ml.q on the console
q).ml.loadfile`:xval/init.q           // initialize cross-validation
```

While general purpose in nature, this framework is particularly important when distributing Python.

The primary difficulty with Python distribution surrounds Python’s use of a Global Interpreter Lock (GIL). This limits the execution of Python bytecode to one thread at a time, thus making distributing Python more complex than its q counterpart. We can subvert this by either wrapping the Python functionality within a q lambda or by converting the Python functionality to a byte stream using Python ‘pickle’ and passing these to the worker processes for execution. Both of these options are possible within the framework outlined here.

This method is not restricted to functions contained only within the ml library, but can be be used to distribute any function across worker processes. This can be seen in the example below.


### `mproc.init`

_Distributes functions to worker processes_

Syntax: `mproc.init[n;x]`

Where 

- `n` is the number of processes open
- `x` is a string of the function to be passed to the process


```q 
$ cat ml/multip.q

npf:{np:.p.import`numpy;
     np[`:array][x]}

fnc:{npf[x]`}
```

Initialise a q process with multiple workers

```q
$ q ml/ml.q -s -4 -p 5001

q).ml.loadfile`:init.q
q).ml.loadfile`:multip.q

q)fnc
{npf[x]`}

q)fnc each til 10
0 1 2 3 4 5 6 7 8 9
q)fnc peach til 10
'npf
  [0]  fnc peach til 10

q).ml.mproc.init[abs system"s"]enlist".ml.loadfile`:multip.q"

q)fnc peach til 10
0 1 2 3 4 5 6 7 8 9
```
