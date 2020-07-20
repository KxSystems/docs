---
title: ceiling | Reference | kdb+ and q documentation
description: ceiling is a q keyword that returns the least integer greater than its numeric argument.
keywords: ceiling, floor, kdb+, math, mathematics, q
---
# `ceiling`


_Round up_


Syntax: `ceiling x`, `ceiling[x]`

Returns the least integer greater than or equal to boolean or numeric `x`. 

```q
q)ceiling -2.1 0 2.1
-2 0 3
q)ceiling 01b
0 1i
```

`ceiling` is an atomic function.


## Comparison tolerance

Prior to V3.0, `ceiling` used [comparison tolerance](../basics/precision.md#comparison-tolerance).

```q
q)ceiling 2 + 10 xexp -12 -13
3 2
```


## Datetime

Prior to V3.0, `ceiling` accepted datetime. 
Since V3.0, use `"d"$23:59:59.999+` instead.

```q
q)ceiling 2010.05.13T12:30:59.999 /type error since V3.0
2010.05.14
q)"d"$23:59:59.999+ 2010.05.13T12:30:59.999
2010.05.14
```


## Domain and range

```txt
domain b g x h i j e f c s p m d z n u v t
range  i . i h i j j j i . . . . . . . . .
```
Range: `hij`


:fontawesome-solid-book: 
[`floor`](floor.md) 
<br>
:fontawesome-solid-book-open: 
[Mathematics](../basics/math.md)