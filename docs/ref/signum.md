---
title: signum
description: signum is a q keyword that returns 1, 0,or -1 according to the sign of its argument.
author: Stephen Taylor
keywords: kdb+, q, sign, signum
---
# `signum`




Syntax: `signum x`, `signum[x]` 

Returns -1, 0 or 1 where `x` is negative, zero or positive respectively. Applies itemwise to lists, dictionaries and tables, and to all data types except symbol. Returns -1 for nulls. 
```q
q)signum -2 0 1 3
-1 0 1 1
q)signum (0n;0N;0Nt;0Nd;0Nz;0Nu;0Nv;0Nm;0Nh;0Nj;0Ne)
-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1
```

`signum` is an atomic function. 

<!-- FIXME Examples for dictionaries and tables -->

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


<i class="far fa-hand-point-right"></i> 
[`abs`](abs.md)  
Basics: [Mathematics](../basics/math.md)