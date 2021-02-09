---
title: reciprocal of a number | Reference | kdb+ and q documentation
description: reciprocal is a q keyword that returns the reciprocal of a number.
author: Stephen Taylor
keywords: divide, division, divisor, kdb+, math, mathematics, numerator, q
---
# `reciprocal`





_Reciprocal of a number_

```txt
reciprocal x    reciprocal[x]
```

Returns the reciprocal of numeric `x` as a float.

```q
q)reciprocal 0 0w 0n 3 10
0w 0 0n 0.3333333 0.1
q)reciprocal 1b
1f
```

## :fontawesome-solid-sitemap: Implicit iteration

`reciprocal` is an [atomic function](../basics/atomic.md).

```q
q)reciprocal (12;13 14)
0.08333333
0.07692308 0.07142857

q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 21 3;4 5 6)

q)reciprocal d
a| 0.1  0.04761905 0.3333333
b| 0.25 0.2        0.1666667

q)reciprocal t
a          b
--------------------
0.1        0.25
0.04761905 0.2
0.3333333  0.1666667

q)reciprocal k
k  | a          b
---| --------------------
abc| 0.1        0.25
def| 0.04761905 0.2
ghi| 0.3333333  0.1666667
```


## Domain and range

```txt
domain b g x h i j e f c s p m d z n u v t
range  f . f f f f f f f . p f f z f f f f
```

Range: `fpz`

----
:fontawesome-solid-book: 
[`div`](div.md), 
[Divide](divide.md) 
<br>
:fontawesome-solid-book-open: 
[Mathematics](../basics/math.md)

