---
title: ungroup normalizes a table | Reference | kdb+ and q documentation
description: ungroup is a q keyword that normalizes a table whose cells contain lists, returning one row for each item of the lists.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `ungroup`

_Normalize a table_

```syntax
ungroup x    ungroup[x]
```

Where `x` is a table in which some columns contain lists and, in each row, all these lists have the same length, returns the normalized table, with one row for each item of the lists.
`ungroup` drops rows where these lists are empty. If `x` is a keyed table, `ungroup` unkeys it first.

```q
q)p:((enlist 2);5 7 11;13 17)
q)r:((enlist"A");"CDE";"FG")

q)show t:([]s:`a`b`c;p;q:10 20 30;r)
s p      q  r
-----------------
a ,2     10 ,"A"
b 5 7 11 20 "CDE"
c 13 17  30 "FG"

q)ungroup t             / flatten lists p and r
s p  q  r
---------
a 2  10 A
b 5  20 C
b 7  20 D
b 11 20 E
c 13 30 F
c 17 30 G
```

You typically use `ungroup` on the result of `xgroup` or `select … by`.

```q
q)tr:([]sym:`c`a`b`a`c;px:1 2 3 4 5;qty:10 20 30 40 50)
q)show t:select px,qty by sym from tr where qty>10
sym| px  qty
---| ---------
a  | 2 4 20 40
b  | ,3  ,30
c  | ,5  ,50

q)ungroup t
sym px qty
----------
a   2  20
a   4  40
b   3  30
c   5  50
```

!!! warning "`ungroup` is not the exact inverse of grouping"

    Grouping collects the records for each key together, and `select … by` also sorts on the keys. A subsequent `ungroup` returns the records grouped (and possibly sorted) by the grouped columns, not in their original order.

----

[`group`](group.md),
[`select`](select.md),
[`xgroup`](xgroup.md)
<br>

_Q for Mortals_
[§9.3.4.2 Grouping without Aggregation](/q4m3/9_Queries_q-sql/#9342-grouping-without-aggregation)
