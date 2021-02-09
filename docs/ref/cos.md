---
title: cos, acos – cosine and arccosine | Reference | kdb+ and q documentation
description: cos and acos are q keywords. They return the cosine and arccosine respectively of their numeric argument.
author: Stephen Taylor
---
# `cos`, `acos`


_Cosine, arccosine_





```txt
cos x     cos[x]
acos x    acos[x]
```

Where `x` is a numeric, returns 

`cos`

: the [cosine](https://en.wikipedia.org/wiki/Trigonometric_functions#cosine) 
of `x`, taken to be in radians. The result is between `-1` and `1`, or null if the argument is null or infinity.

`acos`

: the [arccosine](https://en.wikipedia.org/wiki/Inverse_trigonometric_functions#Basic_properties) of `x`; that is, the value whose cosine is `x`. The result is in radians and lies between 0 and &pi;. (The range is approximate due to rounding errors).
Null is returned if the argument is not between -1 and 1.

```q
q)cos 0.2                       / cosine
0.9800666
q)min cos 10000?3.14159265
-1f
q)max cos 10000?3.14159265
1f

q)acos -0.4                     / arccosine
1.982313
```


## :fontawesome-solid-sitemap: Implicit iteration

`cos` and `acos` are [atomic functions](../basics/atomic.md).

```q
q)cos (.2;.3 .4)
0.9800666
0.9553365 0.921061

q)acos (.2;.3 .4)
1.369438
1.266104 1.159279
```



----
:fontawesome-solid-book:
[`sin`, `asin`](sin.md)
<br>
:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)

