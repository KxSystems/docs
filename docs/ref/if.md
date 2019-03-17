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

    It returns no result and cannot be a list item or function argument.


<i class="far fa-hand-point-right"></i>
[Cond](cond.md), [Vector Conditional](vector-conditional.md)  
Basics: [Control](../basics/control.md) 
