---
title: Greater Than, At Least
description: Greater Than and At Least are q operators that compare their arguments.
author: Stephen Taylor
keywords: comparison, greater-than, greater-than-or-equal, kdb+, q
---
# `>` Greater Than <br>`>=` At Least




Syntax: `x > y` , `<[x;y]`  
Syntax: `x >= y`, `<=[x;y]`

Returns `1b` where (items of) `x` are greater than (or at least) `y`.

```q
q)(3;"a")>(2 3 4;"abc")
100b
000b
q)(3;"a")>=(2 3 4;"abc")
110b
100b
```

Greater Than and At Least are atomic functions.

With booleans:

```q
q)0 1 >/:\: 0 1
00b
10b
q)0 1 >=/:\: 0 1
10b
11b
```

<i class="far fa-hand-point-right"></i> 
[Less Than, Up To](less-than.md)  
Basics: [Comparison](../basics/comparison.md)
