---
title: Iteration | Basics | kdb+ and q documentation
description: The primary means of iteration in q are its keywords and operators, the map iterators Each and its variants, and the accumulating iterators Scan and Over.
author: Stephen Taylor
keywords: accumulating, atomic, each, iteration, iterator, kdb+, q, over, scan
---
# Iteration



The primary means of iteration in q are 

-   [implicit](implicit-iteration.md) in its operators and keywords
-   the **map iterator** [Each](../ref/maps.md#each) and its variants distribute evaluation through data structures
-   the **accumulating iterators** Scan and Over control successive iterations, where the result of one evaluation becomes an argument to the next
-   the control words `do` and `while`


## Implicit iteration

Most operators and keywords have iteration [built into them](implicit-iteration.md).

!!! warning "A common beginner error is to specify iteration where it is already implicit"



## Iterators

The [iterators](../ref/iterators.md) are unary operators. 
They take values as arguments and derive functions that apply them repeatedly.

!!! detail "Value"

    An [applicable value](glossary.md#applicable-value) is a q object that can be indexed or applied to one or more arguments:

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

The control words [`do`, and `while`](control.md) also enable iteration, but are rarely required. 

!!! tip "Do as little as possible"

    First see if the iteration you want is already implicit in the operators and keywords.

    If not, use the map and accumulator iterators to specify the iteration you need.

    If you find yourself using the `do` or `while` control words, you probably missed something.

    > “I’ll say no more than necessary. If that.”<br>
    — ‘Chili’ Palmer in _Get Shorty_.

---
:fontawesome-solid-hand-point-right:
[Implicit iteration](implicit-iteration.md)



