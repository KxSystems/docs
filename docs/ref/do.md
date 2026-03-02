---
title: do control word | Reference | kdb+ and q documentation
description: do is a q control word that evaluates one or more expressions a set number of times.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: control, evaluate, expression, kdb+, q
---
# `do`




_Evaluate expression/s some number of times_

```syntax
do[count;e1;e2;e3;…;en]
```

Control construct. Where 

-   `count` is a non-negative integer
-   `e1`, `e2`, … `en` are expressions

the expressions `e1` to `en` are evaluated, in order, `count` times.

The result of `do` is always the [generic null](identity.md#null).

Continued fraction for $\pi$, for 7 steps:

```q
q)r:()
q)t:2*asin 1
q)do[7;r,:q:floor t;t:reciprocal t-q]
q)r
3 7 15 1 292 1 1
```


!!! warning "`do` is not a function but a control construct. It cannot be iterated or projected."


## Name scope

The brackets of the expression list do not create lexical scope.
Name scope within the brackets is the same as outside them.

----
 
[Accumulators – Do](accumulators.md#do),
[`if`](if.md),
[`while`](while.md)
<br>
 
[Controlling evaluation](control.md) 
<br>

_Q for Mortals_
[§10.1.6 `do`](../learn/q4m/10_Execution_Control.md#1016-do)
