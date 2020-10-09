---
title: ceiling | Reference | kdb+ and q documentation
description: ceiling is a q keyword that returns the least integer greater than its numeric argument.
---
# `ceiling`


_Round up_

```txt
ceiling x      ceiling[x]
```

Returns the least integer greater than or equal to boolean or numeric `x`. 

```q
q)ceiling -2.1 0 2.1
-2 0 3
q)ceiling 01b
0 1i
```


## :fontawesome-solid-sitemap: Implicit iteration

`ceiling` is an [atomic function](../basics/atomic.md).

```q
q)ceiling(1.2;3.4 5.6)
2
4 6

q)ceiling`a`b!(1.2;3.4 5.6)
a| 2
b| 4 6

q)ceiling([]a:1.2 3.4;b:5.6 7.8)
a b
---
2 6
4 8
```


## :fontawesome-solid-exclamation-triangle: Prior to V3.0

Prior to V3.0, `ceiling` 

-    used [comparison tolerance](../basics/precision.md#comparison-tolerance)
-    accepted datetime (Since V3.0, use `"d"$23:59:59.999+` instead.)

```q
q)ceiling 2 + 10 xexp -12 -13
3 2

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


----
:fontawesome-solid-book: 
[`floor`](floor.md) 
<br>
:fontawesome-solid-book-open: 
[Mathematics](../basics/math.md)