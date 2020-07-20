---
title: reciprocal | Reference | kdb+ and q documentation
description: reciprocal is a q keyword that returns the reciprocal of a number.
author: Stephen Taylor
keywords: divide, division, divisor, kdb+, math, mathematics, numerator, q
---
# `reciprocal`





_Reciprocal of a number_

Syntax: `reciprocal x`, `reciprocal[x]` 

Returns the reciprocal of numeric `x`.

```q
q)reciprocal 0 0w 0n 3 10
0w 0 0n 0.3333333 0.1
```

An atomic function.


## Domain and range

```txt
domain b g x h i j e f c s p m d z n u v t
range  f . f f f f f f f . p f f z f f f f
```

Range: `fpz`

:fontawesome-solid-book: 
[`div`](div.md), 
[Divide](divide.md) 
<br>
:fontawesome-solid-book-open: 
[Mathematics](../basics/math.md)

