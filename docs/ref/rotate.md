---
title: rotate shifts the items of a list to the left or right | Reference | kdb+ and q documentation
description: rotate is a q keyword that shifts the items of a list to the left or right.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `rotate`

_Shift the items of a list to the left or right_

```syntax
x rotate y    rotate[x;y]
```

Where

- `x` is an integer atom
- `y` is a list or table

returns `y` rotated by `x` items.
Rotation is to the left for positive `x`, and to the right for negative `x`.
Rotation is cyclic, so where `x` is greater than `count y`, `rotate` rotates `y` by `x mod count y`.

```q
q)2 rotate 2 3 5 7 11    / rotate a list
5 7 11 2 3
q)-2 rotate 2 3 5 7 11
7 11 2 3 5
q)7 rotate 2 3 5 7 11    / same as 2 rotate
5 7 11 2 3
q)t:([]a:1 2 3;b:"xyz")
q)1 rotate t             / rotate a table
a b
---
2 y
3 z
1 x
q)0 1 -1 rotate' 3 4#til 12
0  1 2 3
5  6 7 4
11 8 9 10
```

`rotate` is a uniform function.

----

[`reverse`](reverse.md)
