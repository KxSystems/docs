---
title: cos
description: cos and acos are q keywords. They return the cosine and arccosine respectively of their numeric argument.
author: Stephen Taylor
keywords: acos, arccosine, cos, kdb+, math, mathematics, q, trigonometry
---
# `cos`, `acos`


_Cosine, Arccosine_





## `cos`

_Cosine_

Syntax: `cos x`, `cos[x]`

Returns the [cosine](https://en.wikipedia.org/wiki/Trigonometric_functions#cosine) of `x`, taken to be in radians. The result is between `-1` and `1`, or null if the argument is null or infinity.

```q 
q)cos 0.2
0.9800666
q)min cos 10000?3.14159265
-1f
q)max cos 10000?3.14159265
1f
```




## `acos`

_Arccosine_

Syntax: `acos x`, `acos[x]`

Returns the [arccosine](https://en.wikipedia.org/wiki/Inverse_trigonometric_functions#Basic_properties) of `x`; that is, the value whose cosine is `x`. The result is in radians and lies between 0 and &pi;. (The range is approximate due to rounding errors).

Null is returned if the argument is not between -1 and 1.

```q
q)acos -0.4
1.982313
```


<i class="far fa-hand-point-right"></i>
[`sin`, `asin`](sin.md)  
Basics: [Mathematics](../basics/math.md)

