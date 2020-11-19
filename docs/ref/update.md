---
title: update keyword | Reference | kdb+ and q documentation
description: update is a qSQL query template that adds rows or columns to a table.
author: Stephen Taylor
keywords: columns, kdb+, q, query, qsql, rows, sql, update
---
# `update`




_Add or amend rows or columns of a table or entries in a dictionary_

!!! info "`update` is a qSQL query template and varies from regular q syntax."

For the Update operator `!`, see 
:fontawesome-solid-book-open:
[Functional SQL](../basics/funsql.md)



## Syntax

<div markdown="1" class="typewriter">
update _p<sub>s</sub>_ [by _p<sub>b</sub>_] from _t<sub>exp</sub>_ [where _p<sub>w</sub>_]
</div>

:fontawesome-solid-book-open:
[qSQL query templates](../basics/qsql.md)


## From phrase

!!! warning "`update` will not modify a splayed table on disk."


## Select phrase

Names in the [Select phrase](../basics/qsql.md#select-phrase) refer to new or modified columns in the table expression. 

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

New values must have the type of the column being amended.

If the query adds a new column it will have values only as determined by the Where phrase. At other positions, it will have nulls of the column’s type. 



## By phrase

The [By phrase](../basics/qsql.md#by-phrase) applies the update along groups. 
This is most useful with aggregate and uniform functions.

With an aggregate function, the entire group gets the value of the aggregation on the group.

```q
q)update avg weight by city from p
p | name  color weight city
--| -------------------------
p1| nut   red   15     london
p2| bolt  green 14.5   paris
p3| screw blue  17     rome
p4| screw red   15     london
p5| cam   blue  14.5   paris
p6| cog   red   15     london
```

A uniform function is applied along the group in place. This can be used, for example, to compute cumulative volume of orders.

```q
q)update cumqty:sums qty by s from sp
s p  qty cumqty
---------------
0 p1 300 300
0 p2 200 500
0 p3 400 900
0 p4 200 1100
3 p5 100 100
0 p6 100 1200
1 p1 300 300
1 p2 400 700
2 p2 200 200
3 p2 200 300
3 p4 300 600
0 p5 400 1600
```


## Cond

Cond is not supported inside query templates: 
see [qSQL](../basics/qsql.md#cond).



----
:fontawesome-solid-book:
[`delete`](delete.md),
[`exec`](exec.md),
[`select`](select.md)
<br>
:fontawesome-solid-book-open:
[qSQL](../basics/qsql.md),
[Functional SQL](../basics/funsql.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.5 The `update` template](/q4m3/9_Queries_q-sql/#95-the-update-template)
