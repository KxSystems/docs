---
title: sqrt – square root | Reference | kdb+ and q documentation
description: sqrt is a q keyword that returns the square root of its argument.
author: Stephen Taylor
---
# `sqrt`




_Square root_

```txt
sqrt x    sqrt[x]
```

Returns as a float where `x` is numeric and

-   non-negative, the square root of `x`
-   negative or null, null
-   real or float infinity, `0w`
-   any other infinity, the square root of the largest value for the datatype

```q
q)sqrt -1 0n 0 25 50
0n 0n 0 5 7.071068

q)sqrt 12:00:00.000000000
6572671f

q)sqrt 0Wh
181.0166

q)sqrt 101b
1 0 1f
```


## :fontawesome-solid-sitemap: Implicit iteration

`sqrt` is an [atomic function](../basics/atomic.md).

```q
q)sqrt (10;20 30)
3.162278
4.472136 5.477226

q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 21 3;4 5 6)

q)sqrt d
a| 3.162278 4.582576 1.732051
b| 2        2.236068 2.44949

q)sqrt t
a        b
-----------------
3.162278 2
4.582576 2.236068
1.732051 2.44949

q)sqrt k
k  | a        b
---| -----------------
abc| 3.162278 2
def| 4.582576 2.236068
ghi| 1.732051 2.44949
```

## Domain and range

```txt
domain b g x h i j e f c s p m d z n u v t
range  f . f f f f f f f . f f f z f f f f
```

Range: `fz`

----
:fontawesome-solid-book: 
[`exp`](exp.md), 
[`log`](log.md), 
[`xexp`](exp.md#xexp), 
[`xlog`](log.md#xlog) 
<br>
:fontawesome-solid-book-open: 
[Mathematics](../basics/math.md)