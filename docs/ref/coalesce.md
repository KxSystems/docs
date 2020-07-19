---
title: Coalesce operator | Reference | kdb+ and q documentation
description: Coalesce is a q operator that merges keyed tables.
keywords: coalesce, join, kdb+,q
---
# `^` Coalesce





_Merge keyed tables ignoring nulls_

Syntax: `x^y`, `^[x;y]`

Where `x` and `y` are keyed tables, returns them merged.
With no nulls in `y`, the result is the same as for [Join](join.md).

```q
q)kt1:([k:1 2 3] c1:10 20 30;c2:`a`b`c)
q)kt2:([k:3 4 5] c1:300 400 500;c2:`cc`dd`ee)

q)kt1^kt2
k| c1  c2
-| ------
1| 10  a
2| 20  b
3| 300 cc
4| 400 dd
5| 500 ee

q)(kt1^kt2) ~ kt1,kt2
1b
```

:fontawesome-solid-book: 
[`^` Fill](fill.md) where `x` and `y` are lists or dictionaries

When `y` has null column values, the column values of `x` are updated only with non-null values of `y`.

```q
q)kt3:([k:2 3] c1:0N 3000;c2:`bbb`)
q)kt3
k| c1   c2
-| --------
2|      bbb
3| 3000

q)kt1,kt3
k| c1   c2
-| --------
1| 10   a
2|      bbb
3| 3000

q)kt1^kt3
k| c1   c2
-| --------
1| 10   a
2| 20   bbb
3| 3000 c
```

The performance of Coalesce is slower than that of Join since each column value of `y` must be checked for null.

----
:fontawesome-solid-book-open: 
[Joins](../basics/joins.md) 

