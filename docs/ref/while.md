# `while`





_Control word: evaluate expression/s while some condition remains true_

Syntax: `while[test;e1;e2;e3;…;en]` 

Where

-   `test` is an expression that evaluates to an atom
-   `e1`, `e2`, … `en` are expressions

unless `test` evaluates to zero, the expressions `e1` to `en` are evaluated, in order. The cycle – evaluate `test`, then the expressions – continues until `test` evaluates to zero. 

```q
q)r:1 1
q)x:10
q)while[x-:1;r,:sum -2#r]
q)r
1 1 2 3 5 8 13 21 34 55 89
```

!!! warning "Control word"

    `while` is not a keyword (function) but a control word.

    It returns no result and cannot be a list item or function argument.


<i class="far fa-hand-point-right"></i> 
[Accumulators – While](accumulators.md#while)  
Basics: [Control](../basics/control.md) 
