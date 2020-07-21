---
title: do control word | Reference | kdb+ and q documentation
description: do is a q control word that evaluates one or more expressions a set number of times.
author: Stephen Taylor
keywords: control, evaluate, expression, kdb+, q
---
# `do`




_Evaluate expression/s some number of times_

```txt
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
:fontawesome-solid-book: 
[Accumulators – Do](accumulators.md#do),
[`if`](if.md),
[`while`](while.md)
<br>
:fontawesome-solid-book-open: 
[Controlling evaluation](../basics/control.md) 
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§10.1.5 `do`](/q4m3/10_Execution_Control/#1015-do)
