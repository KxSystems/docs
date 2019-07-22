---
title: do
description: do is a q control word that evaluates one or more expressions a set number of times.
author: Stephen Taylor
keywords: control, evaluate, expression, kdb+, q
---
# `do`




_Control word: evaluate expression/s some number of times_

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

!!! warning "Control word"

    `do` is not a keyword (function) but a control word.

    It returns [Identity](identity.md) `(::)`.


<i class="far fa-hand-point-right"></i> 
[Accumulators – Do](accumulators.md#do)  
Basics: [Control](../basics/control.md) 
