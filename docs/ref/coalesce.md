---
title: Coalesce
description: Coalesce is a q operator that merge keyed tables.
keywords: coalesce, join, kdb+,q
---
# `^` Coalesce






_Merge keyed tables_

Syntax: `t1 ^ t2`, `^[t1;t2]`

Where `t1` and `t2` are keyed tables, 
returns them merged.

```q
q)kt1:([k:1 2 3] c1:10 20 30;c2:`a`b`c)
q)kt2:([k:3 4 5] c1:300 400 500;c2:`cc`dd`ee)
q)kt1,kt2
k| c1  c2
-| ------
1| 10  a
2| 20  b
3| 300 cc
4| 400 dd
5| 500 ee

q)kt1^kt2
k| c1  c2
-| ------
1| 10  a
2| 20  b
3| 300 cc
4| 400 dd
5| 500 ee
```

When `t2` has null column values, the column values of `t1` are only updated with non-null values of the right operand.

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


!!! note "Speed"

    The performance of `^` is slower than that of `,` since each column value of the right operand must be checked for null.


<i class="far fa-hand-point-right"></i> 
Basics: [Joins](../basics/joins.md)  
[`^` Fill](fill.md) where `x` and `y` are lists or dictionaries

