---
title: abs
description: abs is a q keyword that returns the absolute value of its argument
author: Stephen Taylor
keywords: abs, absolute, kdb+, math, mathematics, q
---
# `abs`




_Absolute value_

Syntax: `abs x`, `abs[x]`

Returns the absolute value of boolean or numeric `x`. Null is returned if `x` is null.

```q
q)abs -1.0
1f
q)abs 10 -43 0N
10 43 0N
```

`abs` is an atomic function.

## Domain and range

```txt
domain b g x h i j e f c s p m d z n u v t
range  i . i h i j e f i . p m d z n u v t
```

Range: `ihjefpmdznuvt`

<i class="far fa-hand-point-right"></i> 
[`signum`](signum.md)  
Basics: [Mathematics](../basics/math.md)