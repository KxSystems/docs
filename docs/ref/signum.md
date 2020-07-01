---
title: signum | Reference | kdb+ and q documentation
description: signum is a q keyword that returns 1, 0,or -1 according to the sign of its argument.
author: Stephen Taylor
keywords: kdb+, q, sign, signum
---
# `signum`




Syntax: `signum x`, `signum[x]` 

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

An atomic function. 

Find counts of price movements by direction:

```q
q)select count i by signum deltas price from trade
```


## Domain and range

```txt
domain b g x h i j e f c s p m d z n u v t
range  i . i i i i i i i . i i i i i i i i
```

Range: `i`


:fontawesome-solid-book: 
[`abs`](abs.md) 
<br>
:fontawesome-solid-book-open: 
[Mathematics](../basics/math.md)