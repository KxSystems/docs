---
title: sin, asin
description: sin and asin are q keywords that return (respectively) the sin and arcsine of their argument. 
author: Stephen Taylor
keywords: asin, arcsine, sin, sine, kdb+, math, mathematics, q, trigonometry
---
# `sin`, `asin`

_Sine, Arcsine_





## `sin`

_Sine_

Syntax: `sin x`, `sin[x]`

Returns the [sine](https://en.wikipedia.org/wiki/Sine) of `x`, taken to be in radians. The result is between `-1` and `1`, or null if the argument is null or infinity.

```q
q)sin 0.5
0.4794255
q)sin 1%0
0n
```


## `asin`

Syntax: `asin x`, `asin[x]`

Returns the [arcsine](https://en.wikipedia.org/wiki/Inverse_trigonometric_functions#Basic_properties) of `x`; that is, the value whose sine is `x`. The result is in radians and lies between $-\frac{\pi}{2}$ and $\frac{\pi}{2}$. (The range is approximate due to rounding errors).

Null is returned if the argument is not between -1 and 1.

```q
q)asin 0.8
0.9272952
```



<i class="far fa-hand-point-right"></i>
[`cos`, `acos`](cos.md)  
Basics: [Mathematics](../basics/math.md)

