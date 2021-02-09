---
title: abs – absolute value | Reference | kdb+ and q documentation
description: abs is a q keyword that returns the absolute value of its argument
author: Stephen Taylor
---
# `abs`




_Absolute value_

```txt
abs x    abs[x]
```

Where `x` is a numeric or temporal, returns 
the absolute value of `x`. 
Null is returned if `x` is null.

```q
q)abs -1.0
1f
q)abs 10 -43 0N
10 43 0N
```


## :fontawesome-solid-sitemap: Implicit iteration

`abs` is an [atomic function](../basics/atomic.md).

```q
q)abs(10;20 -30)
10
20 30
```

It applies to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).


## Domain and range

```txt
domain b g x h i j e f c s p m d z n u v t
range  i . i h i j e f i . p m d z n u v t
```

Range: `ihjefpmdznuvt`

----
:fontawesome-solid-book: 
[`signum`](signum.md) 
<br>
:fontawesome-solid-book-open: 
[Mathematics](../basics/math.md)