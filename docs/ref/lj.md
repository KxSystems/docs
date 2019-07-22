---
title: lj
description: lj is a q keyword that performs a left join.
keywords: join, kdb+, left, left join, lj, ljf, q
---
# `lj`, `ljf` 

_Left join_





Syntax: `x lj y`, `lj[x;y]`  
Syntax: `x ljf y`, `ljf[x;y]`

Where 

-   `x` and `y` are tables
-   `y` is keyed
-   the key column/s of `y` are columns of `x`

returns `x` and `y` joined on the key columns of `y`. 

For each record in `x`, the result has one record with the columns of `y` joined to columns of `y`:

-   if there is a matching record in `y`, it is joined to the `x` record; common columns are replaced from `y`.
-   if there is no matching record in `y`, common columns are left unchanged, and new columns are null

```q
q)show x:([]a:1 2 3;b:`I`J`K;c:10 20 30)
a b c
------
1 I 10
2 J 20
3 K 30
q)show y:([a:1 3;b:`I`K]c:1 2;d:10 20)
a b| c d
---| ----
1 I| 1 10
3 K| 2 20
q)x lj y
a b c  d
---------
1 I 1  10
2 J 20
3 K 2  20
```

The `y` columns joined to `x` are given by:

```q
q)y[select a,b from x]
c d
----
1 10
2 20
```


## Changes in V3.0

Since V3.0, the `lj` operator is a cover for `,\:` (Join Each Left) that allows the left argument to be a keyed table. `,\:` was introduced in V2.7 2011.01.24.

Prior to V3.0, `lj` had similar behavior, with one difference - when there are nulls in the right argument, `lj` in V3.0 uses the right-argument null, while the earlier version left the corresponding value in the left argument unchanged:

```q
q)show x:([]a:1 2;b:`x`y;c:10 20)
a b c
------
1 x 10
2 y 20
q)show y:([a:1 2]b:``z;c:1 0N)
a| b c
-| ---
1|   1
2| z
q)x lj y        / kdb+ 3.0
a b c
-----
1   1
2 z
q)x lj y        / kdb+ 2.8 
a b c
------
1 x 1
2 z 20
```

Since 2014.05.03, the earlier version is available in all V3.x versions as `ljf`.


<i class="far fa-hand-point-right"></i> 
Basics: [Joins](../basics/joins.md)

