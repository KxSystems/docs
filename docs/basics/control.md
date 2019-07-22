---
title: Controlling evaluation
description: Evaluation in q is controlled by [iterators](../ref/iterators.md) for iteration ; conditional evaluation; explicit return from a lambda; signalling and trapping errors; and control words.
author: Stephen Taylor
keywords: control, control words, distributive, evaluation, iterate, kdb+, operator, progressive, q, unary, word
---
# Controlling evaluation






Evaluation is controlled by 

-   [iterators](../ref/iterators.md) for iteration 
-   conditional evaluation
-   explicit return from a lambda
-   signalling and trapping errors
-   control words


## Iterators

[Iterators](../ref/iterators.md) are the primary means of iterating in q.


### Maps

The [maps](../ref/maps.md) Each, Each Left, Each Right, Each Parallel, and Each Prior are [iterators](../ref/iterators.md) that apply [values](glossary.md#applicable-value) across the items of lists and dictionaries. 


### Accumulators

The [accumulators](../ref/accumulators.md) Scan and Over are iterators that apply values _progressively_: that is, first to argument/s, then progressively to the result of each evaluation. 

For unary values, they have three forms, known as Converge, Do, and While. 


### Case

There is no `case` or `switch` control word in q. Use the [Case](../ref/maps.md#case) iterator instead. Or a dictionary.


## Conditional evaluation

Syntax: `?[x;y;z]`

[Cond](../ref/cond.md) returns `z` when `x` is zero; else `y`.

Two arguments are evaluated: `x` and either `y` or `z`.

[Vector Conditional](../ref/vector-conditional.md) does something similar for lists of arguments, but evaluates all three arguments. 


## Explicit return

Syntax: `:x`

The result of a lambda is the last expression in its definition, unless the last expression is empty or an assignment, in which case the lambda returns the generic null `::`.

`:x` has a lambda terminate and return `x`.

```q
q)foo:{if[0>type x;:x]; x cross x}
q)foo 2 3
2 2
2 3
3 2
3 3
q)foo 3
3
```

## Signalling and trapping errors

[Signal](../ref/signal.md) will exit the lambda under evaluation and signal an error to the expression that invoked it. 

```q
q)goo:{if[0>type x;'`type]; x cross x}
q)goo 2 3
2 2
2 3
3 2
3 3
q)goo 3
'type
  [0]  goo 3
       ^
```

[Trap and Trap At](../ref/apply.md#trap) set traps to catch errors. 


## Control words


[`do`](../ref/do.md)

: evaluate some expression/s some number of times

[`exit`](../ref/exit.md)

: terminate kdb+

[`if`](../ref/if.md)

: evaluate some expression/s if some condition holds 

[`while`](../ref/while.md)

: evaluate some expression/s while some condition holds

!!! tip "iteration"

    Control words are little used in practice for iteration.
    [Iterators](../ref/iterators.md) are more commonly used.

<i class="far fa-hand-point-right"></i> Iterators:  
[Maps](../ref/maps.md) – Each, Each Left, Each Right, Each Parallel, Each Prior<br>
[Accumulators](../ref/accumulators.md) – Converge, Do, While


### Common errors

!!! warning "Control words are not functions, and return as a result only Identity."

A common error is forgetting to terminate with a semi-colon. 

The result of `if`, `do`, and `while` is [Identity](../ref/identity.md), `(::)`, which allows one mistakenly to write code such as `a:if[1b;42]43` (instead use [Cond](../ref/cond.md)), or `a:0b;if[a;0N!42]a:1b` – the sequence is not as intended!


