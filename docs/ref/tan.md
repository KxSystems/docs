---
title: tan, atan
description: tand and atan are q keyowsrd that return the tangent or arctangent of their argument.
author: Stephen Taylor
keywords: atan, arctan, tan, tangent, kdb+, math, mathematics, q, trigonometry
---
# `tan`, `atan`



_Tangent and arctangent_

## `tan`

_Tangent_

Syntax: `tan x`, `tan[x]`

Returns the [tangent](https://en.wikipedia.org/wiki/Tangent) of `x`, taken to be in radians. Integer arguments are promoted to floating point. Null is returned if the argument is null or infinity.

```q
q)tan 0 0.5 1 1.5707963 2 0w
0 0.5463025 1.557408 3.732054e+07 -2.18504 0n
```


## `atan`

_Arctangent_

Syntax: `atan x`, `atan[x]`

Returns the [arctangent](https://en.wikipedia.org/wiki/Inverse_trigonometric_functions#Basic_properties) of `x`; that is, the value whose tangent is `x`. The result is in radians and lies between $-{\pi}{2}$ and ${\pi}{2}$. The range is approximate due to rounding errors.

```q
q)atan 0.5
0.4636476
q)atan 42
1.546991
```


<i class="far fa-hand-point-right"></i>
Basics: [Mathematics](../basics/math.md)

