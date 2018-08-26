---
title: Left join
keywords: join, kdb+, left join, lj, ljf, q
---

# `lj`, `ljf` 




_Left join_

Syntax: `t1 lj t2`, `lj[t1;t2]`  
Syntax: `t1 ljf t2`, `ljf[t1;t2]`

Where `t1` and `t2` are tables, `t2` is keyed, and the key column/s of `t2` are columns of `t1`, returns `t1` and `t2` joined on the key columns of `t2`. 
For each record in `t1`, the result has one record with the columns of `t1` joined to columns of `t2`:

-   if there is a matching record in `t2`, it is joined to the `t1` record. Common columns are replaced.
-   if there is no matching record in `t2`, common columns are left unchanged, and new columns are null

```q
q)show x:([]a:1 2 3;b:`x`y`z;c:10 20 30)
a b c
------
1 x 10
2 y 20
3 z 30
q)show y:([a:1 3;b:`x`z]c:1 2;d:10 20)
a b| c d
---| ----
1 x| 1 10
3 z| 2 20
q)x lj y
a b c  d
---------
1 x 1  10
2 y 20
3 z 2  20
```

The `t2` columns joined to `t1` are given by:

```q
q)y[select a,b from x]
c d
----
1 10
2 20
```


## Changes in V3.0

Since V3.0, the `lj` operator is a cover for `,\:` (_comma join_) that allows the left argument to be a keyed table. `,\:` was introduced in V2.7 2011.01.24.

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

