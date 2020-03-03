---
title: Multi-threading – Machine Learning – kdb+ and q documentation
description: Documentation for the execution of work across multiple processes via embedPy or q.
author: Diane O'Donoghue
date: March 2020
keywords: machine learning, ml, utilitites, multi-threading, kdb+, q
---
# <i class="fas fa-share-alt"></i> Multiprocess distribution framework


<i class="fab fa-github"></i>
[KxSystems/ml](https://github.com/kxsystems/ml/)


The framework described below is designed to provide a user friendly interface for the execution of both q and Python code across multiple processes. This is currently utilized in both the FRESH and cross-validation procedures outlined within this toolkit by default provided the process is located on a defined port and with a specified number of slave processes.

The following workflow shows how FRESH could be initialized exclusively in such a manor and not as part of the loading of the entire toolkit.

 - Initialize a q process with four workers on a user-defined central port.

``` bash
$ q ml/ml.q -s -4 -p 1234
```

The above command sets 4 slave processes with the central process on port 1234. The below must be executed to load the relevant functionality contained in `util/mproc.q` and to load the appropriate functionality for the FRESH algorithm on each of the processes

```q
q).ml.loadfile`:util/mproc.q
q).ml.mproc.init[abs system"s"]enlist".ml.loadfile`:fresh/init.q"
```

This results in the following architecture

![Figure 1](../img/multiprocess.png)

If the central process is initialized as above and the toolkit in its entirity is loaded both FRESH and cross validation will make use of this architecture multi-processed by default.

While general purpose in nature, this framework is particularly useful when distributing Python.

The primary difficulty with Python distribution surrounds Python’s use of a Global Interpreter Lock (GIL). This limiting execution of Python bytecode to a single thread at a time. We can subvert this by either wrapping the Python functionality within a q lambda or by converting the Python functionality to a byte stream using Python ‘pickle’ and passing these to the worker processes for execution. Both of these options are possible within the framework outlined here.

This method is not restricted to functions contained only within the ml library, but can be be used to distribute any function q or otherwise across worker processes. This can be seen in the example below.

### `mproc.init`

_Distributes functions to worker processes_

Syntax: `mproc.init[n;x]`

Where 

- `n` is the number of processes open
- `x` is a string of the function to be passed to the process


```q 
// Create the following file in the ($QHOME/%QHOME%)/ml
$ cat multip.q

// write an function to create evenly spaced arrays with 5 values
// between two numbers 
npf:{.p.import[`numpy][`:linspace][0;x;5]}
func:{npf[x]`}
```

Initialise a q process with multiple workers

```q
$ q ml/ml.q -s -4 -p 5001

q).ml.loadfile`:init.q
q).ml.loadfile`:multip.q

// Check this function exists in the central process
q)func
{npf[x]`}

// Execute on central process
q)func each 1+til 3
0 0.25 0.5 0.75 1
0 0.5  1   1.5  2
0 0.75 1.5 2.25 3
// attempt to execute over distributed processes fails due to function not existing on processes
q)func peach 1+til 3
'func
  [0]  fnc peach til 3

// load this functionality on each process
q).ml.mproc.init[abs system"s"]enlist".ml.loadfile`:multip.q"

// distribute execution
q)func peach 1+til 3
0 0.25 0.5 0.75 1
0 0.5  1   1.5  2
0 0.75 1.5 2.25 3
```
