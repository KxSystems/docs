---
title: update keyword | Reference | kdb+ and q documentation
description: update is a qSQL query template that adds rows or columns to a table.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: columns, kdb+, q, query, qsql, rows, sql, update
---
# `update`

_Add or amend rows or columns of a table or entries in a dictionary_

!!! info "`update` is a qSQL query template and varies from regular q syntax."

For the Update operator `!`, see [Functional SQL](../basics/funsql.md).

## Syntax

<div markdown="1" class="typewriter">
update _p~s~_ [by _p~b~_] from _t~exp~_ [where _p~w~_]
</div>


[qSQL query templates](../basics/qsql.md)

## From phrase

!!! warning "`update` does not modify a splayed table on disk."

`update` on a splayed table returns the result in memory, and leaves the table on disk unchanged.
Since 4.1t 2021.06.04, when running with [secondary threads](../basics/syscmds.md#s-number-of-secondary-threads), updates from a splayed table and from `path@tablename` use [`peach`](each.md) to load columns.

```q
q)`:mysplay/ set ([]a:1 2 3)
`:mysplay/
q)update x:0 from get`:mysplay
a x
---
1 0
2 0
3 0
q)get`:mysplay
a
-
1
2
3
```

## Select phrase

Names in the [Select phrase](select.md#select-phrase) refer to new or modified columns in the table expression.

```q
q)t:([] name:`tom`dick`harry; age:28 29 35)
q)update eye:`blue`brown`green from t
name  age eye
---------------
tom   28  blue
dick  29  brown
harry 35  green
```

## Where phrase

The [Where phrase](../basics/qsql.md#where-phrase) restricts the scope of updates.

```q
q)t:([] name:`tom`dick`harry; hair:`fair`dark`fair; eye:`green`brown`gray)
q)t
name  hair eye
----------------
tom   fair green
dick  dark brown
harry fair gray

q)update eye:`blue from t where hair=`fair
name  hair eye
----------------
tom   fair blue
dick  dark brown
harry fair blue
```

When the Where phrase selects some of the rows, new values must have the type of the column being amended.

```q
q)update eye:1 from t where hair=`fair
'type
  [0]  update eye:1 from t where hair=`fair
                                      ^
```

If the query adds a new column, it has values only at the positions selected by the Where phrase. At other positions, it has nulls of the column’s type.

```q
q)update age:30 from t where hair=`fair
name  hair eye   age
--------------------
tom   fair green 30
dick  dark brown
harry fair gray  30
```

## By phrase

The [By phrase](select.md#by-phrase) applies the update along groups.
This is most useful with aggregate and uniform functions.

With an aggregate function, the entire group gets the value of the aggregation on the group.

```q
q)p:([p:`p1`p2`p3`p4`p5`p6] name:`nut`bolt`screw`screw`cam`cog; weight:12 17 17 14 12 19f; city:`london`paris`rome`london`paris`london)
q)update avg weight by city from p
p | name  weight city
--| -------------------
p1| nut   15     london
p2| bolt  14.5   paris
p3| screw 17     rome
p4| screw 15     london
p5| cam   14.5   paris
p6| cog   15     london
```

A uniform function is applied along the group in place. For example, you can use it to compute the cumulative volume of orders.

```q
q)sp:([]s:`s1`s1`s2`s1`s2`s3;qty:300 200 400 200 100 300)
q)update cumqty:sums qty by s from sp
s  qty cumqty
-------------
s1 300 300
s1 200 500
s2 400 400
s1 200 700
s2 100 500
s3 300 300
```

A By phrase is not supported when updating a dictionary, and signals a `type` error. (Since 4.1 2024.04.29; previously the By phrase was ignored.)

## Cond

Cond is not supported inside query templates. Refer to [Cond in qSQL](../basics/qsql.md#cond).

----

[`delete`](delete.md),
[`exec`](exec.md),
[`select`](select.md)
<br>

[qSQL](../basics/qsql.md),
[Functional SQL](../basics/funsql.md)
<br>

_Q for Mortals_
[§9.5 The `update` template](/q4m3/9_Queries_q-sql/#95-the-update-template)
