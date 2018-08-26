---
title: Greater Than (or Equal)
keywords: comparison, greater-than, greater-than-or-equal, kdb+, q
---

# `>` `>=` Greater Than (or Equal)



Syntax: `x > y`  
Syntax: `x >= y`

This atomic binary operator returns `1b` where (items of) `x` are greater than (or equal) `y`.

```q
q)(3;"a")>(2 3 4;"abc")
100b
000b
q)(3;"a")>=(2 3 4;"abc")
110b
100b
```

<i class="far fa-hand-point-right"></i> Basics: [Six comparison operators](../basics/comparison.md)
