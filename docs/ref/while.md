---
title: while control word | Reference | kdb+ and q documentation
description: while is a q control word that governs iteration.
author: Stephen Taylor
keywords: condition, control, iteration, kdb+, q, while
---
# `while`





_Evaluate expression/s while some condition remains true_

Syntax: `while[test;e1;e2;e3;…;en]`

Control construct. Where

-   `test` is an expression that evaluates to an atom of integral type
-   `e1`, `e2`, … `en` are expressions

unless `test` evaluates to zero, the expressions `e1` to `en` are evaluated, in order. The cycle – evaluate `test`, then the expressions – continues until `test` evaluates to zero.

```q
q)r:1 1
q)x:10
q)while[x-:1;r,:sum -2#r]
q)r
1 1 2 3 5 8 13 21 34 55 89
```

The result of `while` is always the [generic null](identity.md#null).

!!! warning "`while` is not a function but a control construct. It cannot be iterated or projected."


## Name scope

The brackets of the expression list do not create lexical scope.
Name scope within the brackets is the same as outside them.

----
:fontawesome-solid-book:
[Accumulators – While](accumulators.md#while),
[`do`](do.md),
[`if`](if.md)
<br>
:fontawesome-solid-book-open:
[Controlling evaluation](../basics/control.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§10.1.6 `while`](/q4m3/10_Execution_Control/#1016-while)
