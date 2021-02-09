---
title: sin, asin – sine and arcsine | Reference | kdb+ and q documentation
description: sin and asin are q keywords that return (respectively) the sin and arcsine of their argument.
author: Stephen Taylor
---
# `sin`, `asin`

_Sine, arcsine_





```txt
sin x     sin[x]
asin x    asin[x]
```

Where `x` is a numeric, returns 

`sin`
: the [sine](https://en.wikipedia.org/wiki/Sine) of `x`, taken to be in radians. The result is between `-1` and `1`, or null if the argument is null or infinity.

`asin`
: the [arcsine](https://en.wikipedia.org/wiki/Inverse_trigonometric_functions#Basic_properties) of `x`; that is, the value whose sine is `x`. The result is in radians and lies between $-\frac{\pi}{2}$ and $\frac{\pi}{2}$. (The range is approximate due to rounding errors).
Null is returned if the argument is not between -1 and 1.

```q
q)sin 0.5       / sine
0.4794255
q)sin 1%0
0n

q)asin 0.8      / arcsine
0.9272952
```


## :fontawesome-solid-sitemap: Implicit iteration

`sin` and `asin` are [atomic functions](../basics/atomic.md).

```q
q)sin (.2;.3 .4)
0.1986693
0.2955202 0.3894183

q)asin (.2;.3 .4)
0.2013579
0.3046927 0.4115168

q)sin `x`y`z!3 4#til[12]%10
x| 0         0.09983342 0.1986693 0.2955202
y| 0.3894183 0.4794255  0.5646425 0.6442177
z| 0.7173561 0.7833269  0.841471  0.8912074
```


----
:fontawesome-solid-book:
[`cos`, `acos`](cos.md)
<br>
:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)

