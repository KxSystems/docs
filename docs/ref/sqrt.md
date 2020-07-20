---
title: sqrt – Reference – kdb+ and q documentation
description: sqrt is a q keyword that returns the square root of its argument.
author: Stephen Taylor
keywords: kdb+, math, mathematics, q, root, square root
---
# `sqrt`




_Square root_

Syntax: `sqrt x`, `sqrt[x]`

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
```

An atomic function.

## Domain and range
```txt
domain b g x h i j e f c s p m d z n u v t
range  f . f f f f f f f . f f f z f f f f
```

Range: `fz`

:fontawesome-solid-book: 
[`exp`](exp.md), 
[`log`](log.md), 
[`xexp`](exp.md#xexp), 
[`xlog`](log.md#xlog) 
<br>
:fontawesome-solid-book-open: 
[Mathematics](../basics/math.md)