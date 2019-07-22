---
title: if
description: if is a q control word for conditional evaluation of one or more expressions.
author: Stephen Taylor
keywords: condition, control, evaluate, kdb+, q
---
# `if`




_Control word: evaluate expression/s under some condition_

Syntax: `if[test;e1;e2;e3;…;en]` 

Where

-   `test` is an expression that evaluates to an atom
-   `e1`, `e2`, … `en` are expressions

unless `test` evaluates to zero, the expressions `e1` to `en` are evaluated, in order.

```q
q)a:100
q)r:""
q)if[a>10;a:20;r:"true"]
q)a
20
q)r
"true"
```

!!! warning "Control word"

    `if` is not a keyword (function) but a control word.

    It returns [Identity](identity.md) `(::)`.

!!! warning "Assigning a local variable within a code branch"

    `if` is often preferred to [Cond](cond.md) when a test guards a side effect, such as amending a global. 
    But setting local variables using `if` can have [unintended consequences](../basics/function-notation.md#name-scope).


<i class="far fa-hand-point-right"></i>
[Cond](cond.md), [Vector Conditional](vector-conditional.md)  
Basics: [Control](../basics/control.md) 
