---
title: floor | Reference | kdb+ and q documentation
description: floor is a q keyword that returns the greatest integer smaller than its argument.
author: Stephen taylor
keywords: floor, kdb+, math, mathematics, maximum, q
---
# `floor`

_Round down_



```syntax
floor x    floor[x]
```

Returns the greatest integer less than or equal to numeric `x`. 

```q
q)floor -2.1 0 2.1
-3 0 2
```


## :fontawesome-solid-sitemap: Implicit iteration

`floor` is an [atomic function](../basics/atomic.md).

```q
q)floor(1.2;3.4 5.6)
1
3 5

q)floor`a`b!(1.2;3.4 5.6)
a| 1
b| 3 5

q)floor([]a:1.2 3.4;b:5.6 7.8)
a b
---
1 5
3 7
```

```txt
domain: b g x h i j e f c s p m d z n u v t
range:  . . . h i j j j c s . . . s . . . .
```

## :fontawesome-solid-exclamation-triangle: Prior to V3.0

Prior to V3.0, `floor` 

-   used [comparison tolerance](../basics/precision.md#comparison-tolerance)
-   accepted datetime (Since V3.0, use `"d"$` instead.)

```q
q)floor 2 - 10 xexp -12 -13
1 2

q)floor 2009.10.03T13:08:00.222  /type error since V3.0
2009.10.03
q)"d"$2009.10.03T13:08:00.222
2009.10.03
```


## Domain and range

```txt
domain b g x h i j e f c s p m d z n u v t
range  . . . h i j j j c s . . . . . . . .
```

Range: `hijcs`


----
:fontawesome-solid-book: 
[`ceiling`](ceiling.md) 
<br>
:fontawesome-solid-book-open: 
[Mathematics](../basics/math.md)