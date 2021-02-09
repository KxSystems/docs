---
title: signum – the sign of a number | Reference | kdb+ and q documentation
description: signum is a q keyword that returns 1, 0,or -1 according to the sign of its argument.
author: Stephen Taylor
---
# `signum`




```txt
signum x    signum[x]
```

Where `x` (or its underlying value for temporals) is

-   null or negative, returns `-1i`
-   zero, returns `0i`
-   positive, returns `1i`

```q
q)signum -2 0 1 3
-1 0 1 1i

q)signum (0n;0N;0Nt;0Nd;0Nz;0Nu;0Nv;0Nm;0Nh;0Nj;0Ne)
-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1i

q)signum 1999.12.31
-1i
```

Find counts of price movements by direction:

```q
select count i by signum deltas price from trade
```


## :fontawesome-solid-sitemap: Implicit iteration

`signum` is an [atomic function](../basics/atomic.md).

```q
q)signum(10;-20 30)
1i
-1 1i

q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 -21 3;4 5 -6)

q)signum d
a| 1 -1 1
b| 1 1  -1

q)signum t
a  b
-----
1  1
-1 1
1  -1

q)signum k
k  | a  b
---| -----
abc| 1  1
def| -1 1
ghi| 1  -1
```


## Domain and range

```txt
domain b g x h i j e f c s p m d z n u v t
range  i . i i i i i i i . i i i i i i i i
```

Range: `i`

----
:fontawesome-solid-book: 
[`abs`](abs.md) 
<br>
:fontawesome-solid-book-open: 
[Mathematics](../basics/math.md)