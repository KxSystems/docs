# A Survey of kdb+



_A survey of the distinctive features of kdb+ and the q language._

Different programming languages often have similar features. 
They do similar things in similar ways.
Such similarities can make it easier to acquire a new language. 
They can also make it harder to see what is distinctive about it. 

This introduction surveys some distinctive features of kdb+ and the q language.
It might suit you if you are already familiar with several programming languages, and want to know what is special about q. 
It is not designed for learning q, but if you are learning the language and finding aspects of it mysterious, it might provide useful insight.

## Other tutorials

-   [A brief introduction](/tutorials/first-steps) for an informal introduction to q
-   [Understanding q](/tutorials/understanding) for a systematic exploration of the language
-    [_Q for Mortals_](http://code.kx.com/qfm3) for a textbook, especially detailed discussion of qSQL and database operations


## Arrays are functions

A key concept of kdb+ is that lists and functions are both _mappings_.

-   A function is a map from its domain/s to its range
-   A list is a map from its indexes to its items 
-   A dictionary (a list of key-value pairs) is a map from its keys to its values 

```q
q)sqrs:0 1 4 9 16 25
q)sqrs[2 4]
4 16
q)sqr:{x*x}
q)sqr[2 4]
4 16
```
The syntax reflects this. If `m` is a matrix, then `m[3;4]` is the fifth item on the fourth row. 
```q
q)m
0 0 0  0  0  0
0 1 2  3  4  5
0 2 4  6  8  10
0 3 6  9  12 15
0 4 8  12 16 20
0 5 10 15 20 25
q)m[3;4]
12
q)*[3;4]
12
```
Indexing and function application are two sides of the same coin. 
In certain contexts, lists and functions can usefully be substituted for each other.


## Application and indexing are functional

> Everything begins with a dot.  
> — _Vassily Kandinsky_

Application and indexing are _both_ functional, and they are the _same_ function.
That function is the so-called _ur_-function, written `.` and pronounced _dot_.
```q
q)m . 3 4
12
q){x*y} . 3 4
12
```
Other forms of indexing and application are syntactic sugar.
```q
q)m[3;4]
12
q)3*4
12
```


## Atomic

Many primitive functions are atomic: they apply itemwise to or between their arguments to whatever depth of nesting at which the arguments conform.
```q
q)(1 2 3;4 5)+((10 20;15;42 43 44);7)
(11 21;17;45 46 47)
11 12
```
Much iteration is implicit. 


## Dictionaries and tables

Dictionaries and tables are first-class objects and within the domain of many primitives.
For example, the maximum of two dictionaries is an upsert of the higher values.
```q
q)l               / log
ibm | 2017.12
msft| 2018.01
aapl| 2016.03
q)c               / changes
ibm | 2016.12
aapl| 2018.02
q)l or c          / latest
ibm | 2017.12
msft| 2018.01
aapl| 2018.02
```


## Use of handles

In the previous example the expression `l or c` (also written `l|c`) _returns_ the result of the upsert. 

Writing `l|:c` _performs_ the upsert, amending `l`. 

`l` might be a variable in memory, or a database handle, in which case the database is amended. 

Code that works in memory also works on disk.


## Adverbs

Adverbs are primitive higher-order functions. 
They take maps as their arguments and return derived functions, or _derivatives_.
```q
q)+/[3 4 5]
9
```
The derivative `+/` sums the items of its argument. 

The derivative `m\`, where `m` is a transition matrix, applies a finite-state machine to a list of inputs. 

Most iteration not implicit in the use of atomic functions is achieved by adverbs. Control structures are rarely used.

As a result, kdb+ operations are highly parallelizable. 


## qSQL

==FIXME==