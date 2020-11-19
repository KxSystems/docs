---
title: Matrix Multiply, mmu – Reference – kdb+ and q documentation
description: Matrix Multiply is a q operator that performs matrix multiplication; mmu is a q keyword that is a wrapper for it.
author: Stephen Taylor
---

![Matrix multiplication](../img/matrix-multiplication.png)
{: style="float:right"}

# `$` Matrix Multiply, `mmu`




_Matrix multiply, dot product_

```txt
x mmu y    mmu[x;y]
x$y        $[x;y]
```

Where `x` and `y` are both float vectors or matrixes, returns their  matrix- or dot-product.

`count y` must match

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

Use secondary threads via `peach`.

```q
q)mmu[;b]peach a
87 104 121
81 99  117
```

----
:fontawesome-solid-book:
[Overloads of `$`](overloads.md#dollar)
<br>
:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)
<br>
:fontawesome-brands-wikipedia-w:
[Matrix multiplication](https://en.wikipedia.org/wiki/Matrix_multiplication "Wikipedia")