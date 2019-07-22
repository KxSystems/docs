---
title: Matrix Multiply, mmu
description: Matrix Multiply is a q operator that performs matrix multiplication; mmu is a q keyword that is a wrapper for it.
author: Stephen Taylor
keywords: kdb+, mathematics, matrix, multiply, q, tensors
---

<div markdown="1" style="float:right">
![Matrix multiplication](../img/matrix-multiplication.png)
</div>

# `S` Matrix Multiply, `mmu`




_Matrix multiply, dot product_

Syntax: `x mmu y`, `mmu[x;y]`  
Syntax: `x$y`, `$[x;y]` 

Where `x` and `y` are both float vectors or matrixes, returns their  matrix- or dot-product.

`x` and `y` must conform: `count y` must match

-   `count x` where `x` is a vector
-   `count first x` where `x` is a matrix

```q
q)a:2 4#2 4 8 3 5 6 0 7f
q)b:4 3#"f"$til 12
q)a mmu b
87 104 121
81 99  117
q)c:3 3#2 4 8 3 5 6 0 7 1f
q)1=c mmu inv c
100b
010b
001b
q)(1 2 3f;4 5 6f)$(7 8f;9 10f;11 12f)
58  64
139 154
q)1 2 3f$4 5 6f  /dot product of two vectors
32f
```


## Working in parallel

Use slave threads via `peach`.

```q
q)mmu[;b]peach a
87 104 121
81 99  117
```

<i class="far fa-hand-point-right"></i> 
[`$` dollar](overloads.md#dollar)  
Basics: [Mathematics](../basics/math.md)  
Wikipedia: [Matrix multiplication](https://en.wikipedia.org/wiki/Matrix_multiplication)