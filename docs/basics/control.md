---
title: Controlling evaluation
keywords: control, control words, distributive, evaluation, iterate, kdb+, operator, progressive, q, , unary, word
---

# Controlling evaluation




Evaluation is controlled by 

-   [extenders](../ref/extenders.md) for iteration 
-   conditional evaluation
-   explicit return from a lambda
-   signalling and trapping errors
-   control words


## Extenders

These are the primary means of iterating in q.


### Distributors

The [distributors](../ref/distributors.md) Each, Each Left, Each Right, Each Parallel, and Each Prior are extenders that apply maps across the items of lists and dictionaries. 


### Progressors

The [progressors](../ref/progressors.md) Scan and Over are extenders that apply maps _progressively_: that is, first to argument/s, then progressively to the result of each evaluation. 

For unary maps, they have three forms, known as Converge, Do, and While. 


### Case

There is no `case` or `switch` control word in q. Use the [Case](../ref/case.md) operator instead. Or a dictionary.


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

Control words are rarely used in practice. 

!!! note "Control words are not functions, cannot be arguments or list items, and do not return results."


### `do`

Syntax: `do[count;e1;e2;e3;…;en]`

Where 

-   `count` is a positive integer
-   `e1`, `e2`, … `en` are expressions

the expressions `e1` to `en` are evaluated, in order, `count` times.

Continued fraction for $\pi$, for 7 steps:

```q
q)r:()
q)t:2*asin 1
q)do[7;r,:q:floor t;t:reciprocal t-q]
q)r
3 7 15 1 292 1 1
```

`do` can be used for accurate timing of expressions, e.g. time log of first 100,000 numbers, over 100 trials:

```q
q)\t do[100;log til 100000]
396
```

<i class="far fa-hand-point-right"></i> [Progressors – Do](../ref/progressors.md#do)


### `if` 

Syntax: `if[test;e1;e2;e3;…;en]` 

-   `test` is an expression that evaluates to an atom
-   `e1`, `e2`, … `en` are expressions

unless `test` evaluates to zero, the expressions `e1` to `en` are evaluated, in order

```q
q)a:100
q)r:""
q)if[a>10;a:20;r:"true"]
q)a
20
q)r
"true"
```


### `while` 

Syntax: `while[test;e1;e2;e3;…;en]` 

-   `test` is an expression that evaluates to an atom
-   `e1`, `e2`, … `en` are expressions

Unless `test` evaluates to zero, the expressions `e1` to `en` are evaluated, in order. The cycle – evaluate `test`, then the expressions – continues until ``test` evaluates to zero. 

```q
q)r:1 1
q)x:10
q)while[x-:1;r,:sum -2#r]
q)r
1 1 2 3 5 8 13 21 34 55 89
```

<i class="far fa-hand-point-right"></i> [Progressors – While](../ref/progressors.md#while)
