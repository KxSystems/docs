---
title: uj – union join | Reference | kdb+ and q documentation
description: uj and ujf are q keywords that perform a union join on two tables.
keywords: join, kdb+, q, uj, ujf, union join
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `uj`, `ujf`

_Union join_

```syntax
x uj  y     uj [x;y]
x ujf y     ujf[x;y]
```

Where `x` and `y` are both keyed or both unkeyed tables, returns the union of the columns, filled with nulls where necessary:

- If `x` and `y` are keyed tables (with the same key columns), records in `y` update records in `x` with matching keys, and the other records of `y` are appended
- If `x` and `y` are simple tables, the records of `y` are appended

For example, the union join of two keyed tables keeps every key from both tables and every column from both tables:

```q
q)show x:([k:1 2 3]v:`x1`x2`x3)
k| v
-| --
1| x1
2| x2
3| x3
q)show y:([k:1 2 4]w:`y1`y2`y4)
k| w
-| --
1| y1
2| y2
4| y4
q)x uj y
k| v  w
-| -----
1| x1 y1
2| x2 y2
3| x3
4|    y4
```

The following examples show how `uj` handles columns that the tables share:

```q
q)show s:([]a:1 2;b:2 3;c:5 7)
a b c
-----
1 2 5
2 3 7

q)show t:([]a:1 2 3;b:2 3 7;c:10 20 30;d:"ABC")
a b c  d
--------
1 2 10 A
2 3 20 B
3 7 30 C

q)s,t                            / tables do not conform for ,
'mismatch
  [0]  s,t                            / tables do not conform for ,
        ^

q)s uj t                         / simple, so second table is inserted
a b c  d
--------
1 2 5
2 3 7
1 2 10 A
2 3 20 B
3 7 30 C

q)(2!s) uj 2!t                   / keyed, so matching records are updated
a b| c  d
---| ----
1 2| 10 A
2 3| 20 B
3 7| 30 C
```

`uj` is a [multithreaded primitive](../kb/mt-primitives.md).

!!! note "`uj` generalizes the [`,` Join](join.md) operator."

## `ujf`

The union join of two keyed tables is equivalent to a [left join](lj.md) of the two tables, with the unmatched rows from the second table appended.
As a result, with `uj`, a null in a matching record of `y` overwrites the value in `x`.
`ujf` instead fills from `x` where the value in `y` is null. Since 2017.04.10, the earlier behavior (before V3.0, `uj` filled from `x`) is available in all V3.5 and later versions as `ujf`.

```q
q)show x:([a:1 2]b:`x`y;c:10 20)
a| b c
-| ----
1| x 10
2| y 20
q)show y:([a:1 2]b:``z;c:1 0N)
a| b c
-| ---
1|   1
2| z
q)x uj y
a| b c
-| ---
1|   1
2| z
q)x ujf y
a| b c
-| ----
1| x 1
2| z 20
```

---

[Joins](../basics/joins.md)
<br>

_Q for Mortals_
[§9.9.7 Union Join](/q4m3/9_Queries_q-sql/#997-union-join)

