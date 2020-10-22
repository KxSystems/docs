---
title: tan, atan – tangent and arctangent | Reference | kdb+ and q documentation
description: tan and atan are q keywords that return the tangent or arctangent of their argument.
author: Stephen Taylor
---
# `tan`, `atan`



_Tangent and arctangent_


```txt
tan x     tan[x]
atan x    atan[x]
```

Where `x` is a numeric, returns 

`tan`
: the [tangent](https://en.wikipedia.org/wiki/Tangent) of `x`, taken to be in radians. Integer arguments are promoted to floating point. Null is returned if the argument is null or infinity.

: The function is equivalent to `{(sin x)%cos x}`.

`atan`
: the [arctangent](https://en.wikipedia.org/wiki/Inverse_trigonometric_functions#Basic_properties) of `x`; that is, the value whose tangent is `x`. 

: The result is in radians and lies between $-\frac{\pi}{2}$ and $\frac{\pi}{2}$. The range is approximate due to rounding errors.

```q
q)tan 0 0.5 1 1.5707963 2 0w                    / tangent
0 0.5463025 1.557408 3.732054e+07 -2.18504 0n

q)atan 0.5                                      / arctangent
0.4636476
q)atan 42
1.546991
```


## :fontawesome-solid-sitemap: Implicit iteration

`tan` and `atan` are [atomic functions](../basics/atomic.md).

```q
q)tan (.2;.3 .4)
0.20271
0.3093362 0.4227932

q)atan (.2;.3 .4)
0.1973956
0.2914568 0.3805064

q)tan `x`y`z!3 4#til[12]%10
x| 0         0.1003347 0.20271   0.3093362
y| 0.4227932 0.5463025 0.6841368 0.8422884
z| 1.029639  1.260158  1.557408  1.96476
```


----

:fontawesome-solid-book:
[`cos` and `acos`](cos.md),
[`sin` and `asin`](sin.md)
<br>
:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)

