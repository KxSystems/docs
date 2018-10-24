---
author: Samantha Gallagher
date: October 2018
keywords: embedpy, foreign, install, kdb+, learning, library, machine, python, q
title: Machine learning – using embedPy to apply LASSO regression
---

# EmbedPy basics





In this section, we introduce some core elements of embedPy that will be
used in the LASSO regression problem that follows. 

<i class="far fa-hand-point-right"></i>
[Full documentation for embedPy](/ml/embedpy)


## Installing embedPy in kdb+

Download the embedPy package from
GitHub:
<i class="fab fa-github"></i>
[KxSystems/embedPy](https://github.com/kxsystems/embedpy)

Follow the instructions in `README.md` for installing the interface. 
Load `p.q` into kdb+ through either:

-   the command line: `$ q p.q`
-   the q session: `q)\l p.q` 


## Executing Python code from a q session

Python code can be executed in a q session by either using the `p)`
prompt, or the `.p` namespace:

```q
q)p)def add1(arg1): return arg1+1
q)p)print(add1(10))
11
q).p.e"print(add1(5))"
6
q).p.qeval"add1(7)"                       / print Python result
8
```


## Interchanging variables

Python objects live in the embedded Python memory space. In q, these are
foreign objects that contain pointers to the Python objects. They can be
stored in q as variables, or as parts of lists, tables, and
dictionaries, and will display `foreign` when inspected in the q
console. Foreign objects cannot be serialized by kdb+ or passed over
IPC; they must first be converted to q.

This example shows how to convert a Python variable into a foreign object
using `.p.pyget`. A foreign object can be converted into q by using
`.p.py2q`:

```q
q)p)var1=2
q).p.pyget`var1
foreign
q).p.py2q .p.pyget`var1
2
```


## Foreign objects

Whilst foreign objects can be passed back and forth between q and Python and operated on by Python, they cannot be operated on by q directly. Instead, they must be converted to q data. 
To make it easy to convert back and forth between q and Python representations a foreign object can be wrapped as an embedPy object using `.p.wrap`

```q
q)p:.p.wrap .p.pyget`var1
q)p
{[f;x]embedPy[f;x]}[foreign]enlist
```

Given an embedPy object representing Python data, the underlying data
can be returned as a foreign object or q item:

```q
q)x:.p.eval"(1,2,3)"                / Define Python object
q)x
{[f;x]embedPy[f;x]}[foreign]enlist
q)x`.                               / Return the data as a foreign object
foreign
q)x`                                / Return the data as q
1 2 3
```


## Edit Python objects from q

Python objects are retrieved and executed using `.p.get`. This will return
either a q item or foreign object. There is no need to keep a copy of a
Python object in the q memory space; it can be edited directly.

The first parameter of `.p.get` is the Python object name, and the second
parameter is either `<` or `>`, which will return q or foreign objects
respectively. The following parameters will be the input parameters to
execute the Python function.

This example shows how to call a Python function with one input
parameter, returning q:

```q
q)p)def add2(x): res = x+2; return(res);
q).p.get[`add2;<]                    / < returns q
k){$[isp x;conv type[x]0;]x}.[code[code;]enlist[;;][foreign]]`.p.q2pargsenlist
q).p.get[`add2;<;5]                  / get and execute func, return q
7
q).p.get[`add2;>;5]                  / get execute func, return foreign object
foreign
q)add2q:.p.get`add2                  / define as q function, return an embedPy object
q)add2q[3]`                          / call function, and convert result to q
5
```


## Python keywords

EmbedPy allows keyword arguments to be specified, in any order, using
`pykw`:

```q
q)p)def times_args(arg1, arg2): res = arg1 * arg2; return(res)
q).p.get[`times_args;<;`arg2 pykw 10; `arg1 pykw 3]
30
```


## Importing Python libraries

To import an entire Python library, use `.p.import` and call individual
functions:

```q
q)np:.p.import`numpy
q)v:np[`:arange;12]
q)v`
0 1 2 3 4 5 6 7 8 9 10 11
```

Individual packages or functions are imported from a Python library by
specifying them during the import command.

```q
q)arange:.p.import[`numpy]`:arange    / Import function
q)arange 12
{[f;x]embedPy[f;x]}[foreign]enlist
q)arange[12]`
0 1 2 3 4 5 6 7 8 9 10 11
q)p)import numpy as np                # Import package using Python syntax
q)p)v=np.arange(12)
q)p)print(v)
[ 0 1 2 3 4 5 6 7 8 9 10 11]
q)stats:.p.import[`scipy.stats]       / Import package using embedPy syntax
q)stats[`:skew]
{[f;x]embedPy[f;x]}[foreign]enlist
```


