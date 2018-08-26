---
title: Less Than (or Equal)
keywords: comparison, kdb+, less-than, less-than-or-equal, q
---

# `<` `<=` Less Than (or Equal)



Syntax: `x < y`  
Syntax: `x <= y` 

This atomic binary operator returns `1b` where (items of) `x` are less than (or equal) `y`.

```q
q)(3;"a")<(2 3 4;"abc")
001b
000b
q)(3;"a")<=(2 3 4;"abc")
011b
111b
```

<i class-"far fa-hand-point-right"></i> Basics: [Six comparison operators](../basics/comparison.md)
