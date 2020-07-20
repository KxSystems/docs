---
title: ungroup | Reference | kdb+ and q documentation
description: ungroup is a q keyword that, where x is a table, in which some cells are lists, but for any row, all lists are of the same length, returns the normalized table, with one row for each item of a lists.
author: Stephen Taylor
keywords: kdb+, q, qsql, query, select, sql, table, ungroup
---
# `ungroup`




Syntax: `ungroup x`, `ungroup[x]`

Where `x` is a table, in which some cells are lists, but for any row, all lists are of the same length, returns the normalized table, with one row for each item of a lists.

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

Typically used on the result of `xgroup` or `select`.

```q
q)\l sp.q
q)show t:select p,qty by s from sp where qty>200
s | p            qty
--| ------------------------
s1| `p$`p1`p3`p5 300 400 400
s2| `p$`p1`p2    300 400
s4| `p$,`p4      ,300

q)ungroup t
s  p  qty
---------
s1 p1 300
s1 p3 400
s1 p5 400
s2 p1 300
s2 p2 400
s4 p4 300
```

:fontawesome-solid-book:
[`group`](group.md),
[`select`](select.md),
[`xgroup`](xgroup.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.3.4.2 Grouping without Aggregation](/q4m3/9_Queries_q-sql/#9342-grouping-without-aggregation)
