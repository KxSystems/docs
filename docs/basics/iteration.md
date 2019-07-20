---
title: Iteration
description: The primary means of iteration in q are atomic functions, the map iterators Each and its variants, and the accumulating iterators Scan and Over.
author: Stephen Taylor
keywords: accumulating, atomic, each, iteration, iterator, kdb+, q, over, scan
---
# Iteration



The primary means of iteration in q are 

-   atomic functions
-   the **map iterators**: Each and its variants
-   the **accumulating iterators** Scan and Over


## Atomic functions

[Atomic functions](atomic.md) apply to atoms in their arguments, and preserve structure to arbitrary depth.

Many of the q operators that take numerical arguments are atomic. 

The arguments of an atomic function must _conform_: 
they must be lists with the same count, or atoms.

When an atom argument is applied to a list, it is applied to every item.

```q
q)2 3 4 + 5 6 7          / same-count lists
7 9 11
q)2 + 3 4 5              / atom and list
5 6 7
```

This is called _scalar extension_. It applies at every level of nesting.

```q
q)2+(3 4;`a`b`c!5 6 7;(8 9;10;11 12 13);14)
5 6
`a`b`c!7 8 9
(10 11;12;13 14 15)
16
```


## Iterators

The [iterators](../ref/iterators.md) are unary operators. 
They take values as arguments and derive functions that apply them repeatedly.

!!! detail "Value"

    A [applicable value](glossary.md#applicable-value) is a q object that can be indexed or applied to one or more arguments:

    -   function: operator, keyword, lambda, or derived function
    -   list: vector, mixed list, matrix, or table
    -   dictionary
    -   file- or process handle

The iterators can be applied postfix, and almost always are. 
For example, the Over iterator `/` applied to the Add operator `+` derives the function `+/`, which reduces a list by summing it.

```q
q)(+/)2 3 4 5
14
```

There are two groups of iterators: maps and accumulators.


### Maps

The [maps](../ref/maps.md) – Each, Each Left, Each Right, Each Prior, and Each Parallel – apply a map to each item of a list or dictionary.

```q
q)count "zero"                             / count the chars (items) in a string
4
q)(count')("The";"quick";"brown";"fox")    / count each string
3 5 5 3
```


### Accumulators

The [accumulators](../ref/accumulators.md) – Scan and Over – apply a value successively, first to the argument, then to the results of successive applications. 


## Control words

The control words [`if`, `do`, and `while`](control.md) also enable iteration, but are rarely required. 



