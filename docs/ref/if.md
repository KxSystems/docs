---
title: if control word | Reference | kdb+ and q documentation
description: if is a q control construct for conditional evaluation of one or more expressions.
author: Stephen Taylor
keywords: condition, control, evaluate, kdb+, q
---
# `if`




_Evaluate expression/s under some condition_

```txt
if[test;e1;e2;e3;…;en]
```

Control construct. Where

-   `test` is an expression that evaluates to an atom of integral type
-   `e1`, `e2`, … `en` are expressions

unless `test` evaluates to zero, the expressions `e1` to `en` are evaluated, in order.

The result of `if` is always the [generic null](identity.md#null).

```q
q)a:100
q)r:""
q)if[a>10;a:20;r:"true"]
q)a
20
q)r
"true"
```

!!! warning "`if` is not a function but a control construct. It cannot be iterated or projected."

`if` is often preferred to [Cond](cond.md) when a test guards a side effect, such as amending a global.

A common use is to catch special or invalid arguments to a function.

```q
foo:{[x;y]
  if[type[x]<0; :x];            / no-op for atom x
  if[count[y]<>3; '"length"];   / invalid y
  ..
  }
```


## Name scope

The brackets of the expression list do not create lexical scope.
Name scope within the brackets is the same as outside them.

!!! warning "Setting local variables using `if` can have [unintended consequences](../basics/function-notation.md#name-scope)."

----
:fontawesome-solid-book:
[Cond](cond.md),
[`do`](do.md),
[`while`](while.md),
[Vector Conditional](vector-conditional.md)
<br>
:fontawesome-solid-book-open:
[Controlling evaluation](../basics/control.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§10.1.4 `if`](/q4m3/10_Execution_Control/#1014-if)
