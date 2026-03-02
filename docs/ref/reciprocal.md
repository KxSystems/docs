---
title: reciprocal of a number | Reference | KDB-X and q documentation
description: reciprocal is a q keyword that returns the reciprocal of a number.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: divide, division, divisor, KDB-X, math, mathematics, numerator, q
---

# `reciprocal`

_Reciprocal of a number_

```syntax
reciprocal x    reciprocal[x]
```

Returns the reciprocal of numeric `x` as a float.

```q
q)reciprocal 0 0w 0n 3 10
0w 0 0n 0.3333333 0.1
q)reciprocal 1b
1f
```

`reciprocal` is a [multithreaded primitive](mt-primitives.md).

## Implicit iteration

`reciprocal` is an [atomic function](atomic.md).

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

[`div`](div.md),
[Divide](divide.md)
<br>

[Mathematics](math.md)
