---
title: Plus join
keywords: join, kdb+, pj,plus join, q
---

# `pj` 




_Plus join_

Syntax: `t1 pj t2`, `pj[t1;t1]`

Where `t1` and `t2` are tables, `t2` is keyed, and the key column/s of `t2` are columns of `t1`, returns `t1` and `t2` joined on the key columns of `t2`.

`pj` adds matching records in `t2` to those in `t1`, by adding common columns, other than the key columns. These common columns must be of appropriate types for addition.

For each record in `t1`:

-   if there is a matching record in `t2` it is added to the `t1` record.
-   if there is no matching record in `t2`, common columns are left unchanged, and new columns are zero.

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
q)x pj y
a b c  d
---------
1 x 11 10
2 y 20 0
3 z 32 20
```

In the example above, `pj` is equivalent to `` x+0^y[`a`b#x] `` (compute the value of `y` on `a` and `b` columns of `x`, fill the result with zeros and add to `x`).


<i class="far fa-hand-point-right"></i> 
Basics: [Joins](../basics/joins.md)

