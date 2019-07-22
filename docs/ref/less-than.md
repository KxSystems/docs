---
title: Less Than, Up To
description: Less Than and Up To are q operators that compare the values of their arguments.
author: Stephen Taylor
keywords: comparison, kdb+, less-than, less-than-or-equal, q, up to
---
# `<` Less Than<br>`<=` Up To




Syntax: `x < y`, `<[x;y]`  
Syntax: `x <= y`, `<=[x;y]`

Returns `1b` where (items of) `x` are less than (or up to) `y`.

```q
q)(3;"a")<(2 3 4;"abc")
001b
000b
q)(3;"a")<=(2 3 4;"abc")
011b
111b
```

With booleans:

```q
q)0 1 </:\: 0 1
01b
00b
q)0 1 <=/:\: 0 1
11b
01b
```

<i class-"far fa-hand-point-right"></i> 
[Greater Than, At Least](greater-than.md)  
Basics: [Comparison](../basics/comparison.md)
