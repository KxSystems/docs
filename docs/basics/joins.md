---
title: Joins | Basics | kdb+ and q documentation
description: A join combines data from two tables, or from a table and a dictionary. Some joins are keyed, in that columns in the first argument are matched with the key columns of the second argument. Some joins are as-of, where a time column in the first argument specifies corresponding intervals in a time column of the second argument. Such joins are not keyed.
keywords: aj, asof, coalesce, equi-join, inner join, join, kdb+, keyed, left join, plus join, q, union join, upsert, window join, wj, wj1
---
# Joins



<div markdown="1" class="typewriter">
Keyed:                As of:
 [ej](../ref/ej.md)        equi        [aj aj0](../ref/aj.md)      as-of
 [ij ijf](../ref/ij.md)    inner       [ajf ajf0](../ref/aj.md)
 [lj ljf](../ref/lj.md)    left        [asof](../ref/asof.md)        simple as-of
 [pj](../ref/pj.md)        plus        [wj wj1](../ref/wj.md)      window
 [uj ujf](../ref/uj.md)    union
 [upsert](../ref/upsert.md)                [, Join](../ref/join.md)               [^ Coalesce](../ref/coalesce.md)
</div>


A _join_ combines data from two tables, or from a table and a dictionary.

Some joins are _keyed_, in that columns in the first argument are matched with the key columns of the second argument.

Some joins are _as-of_, where a time column in the first argument specifies corresponding intervals in a time column of the second argument. Such joins are not keyed.

In each case, the result has the merge of columns from both arguments. Where necessary, rows are filled with nulls or zeroes.


## Keyed joins

[`^`](../ref/coalesce.md) Coalesce
: The Coalesce operator merges keyed tables ignoring nulls

[`ej`](../ref/ej.md) Equi join
: Similar to `ij`, where the columns to be matched are given as a parameter.

[`ij` `ijf`](../ref/ij.md) Inner join
: Joins on the key columns of the second table. The result has one row for each row of the first table that matches the key columns of the second table.

`,` Join
: The [Join](../ref/join.md)  operator `,` joins tables and dictionaries as well as lists. For tables `x` and `y`:

    -   `x,y` is `x upsert y`
    -   `x,'y` joins records to records
    -   `x,\:y` is `x lj y` <!-- (since V2.7 2011.01.24) -->

[`lj` `ljf`](../ref/lj.md) Left join
: Outer join on the key columns of the second table. The result has one row for each row of the first table. Null values are used where a row of the first table has no match in the second table. This is now built-in to `,\:`.
(Reverse the arguments to make a right outer join.)

[`pj`](../ref/pj.md) Plus join
: A variation on left join. For each matching row, values from the second table are added to the first table, instead of replacing values from the first table.

[`uj` `ujf`](../ref/uj.md) Union join
: Uses all rows from both tables. If the second table is not keyed, the result is the catenation of the two tables. Otherwise, the result is the left join of the tables, catenated with the unmatched rows of the second table.

[`upsert`](../ref/upsert.md)
: Can be used to join two tables with matching columns (as well as add new records to a table). If the first table is keyed, any records that match on key are updated. The remaining records are appended.


## As-of joins

In each case, the time column in the first argument specifies \[) intervals in the second argument.

[`wj`, `wj1`](../ref/wj.md) Window join
: The most general forms of as-of join. Function parameters aggregate values in the time intervals of the second table. In `wj`, prevailing values on entry to each interval are considered. In `wj1`, only values occurring within each interval are considered.

[`aj`,`aj0`,`ajf`,`ajf0`](../ref/aj.md) As-of join
: Simpler window joins where only the last value in each interval is used. In the `aj` result, the time column is from the first table, while in the `aj0` result, the time column is from the second table.

[`asof`](../ref/asof.md)
: A simpler `aj` where all columns (or dictionary keys) of the second argument are used in the join.


## Implicit joins

A foreign key is made by enumerating over the column/s of a keyed table.

Where a primary key table `m` has a key column `k` and a table `d` has a column `c` and foreign key linking to `k`, a left join is implicit in the query

```q
select m.k, c from d
```

This generalizes to multiple foreign keys in `d`. 

:fontawesome-brands-github:
[Suppliers and parts database `sp.q`](https://github.com/KxSystems/kdb/blob/master/sp.q)

```q
q)\l sp.q
+`p`city!(`p$`p1`p2`p3`p4`p5`p6`p1`p2;`london`london`london`london`london`lon..
(`s#+(,`color)!,`s#`blue`green`red)!+(,`qty)!,900 1000 1200
+`s`p`qty!(`s$`s1`s1`s1`s2`s3`s4;`p$`p1`p4`p6`p2`p2`p4;300 200 100 400 200 300)

q)select sname:s.name, qty from sp
sname qty
---------
smith 300
smith 200
smith 400
smith 200
clark 100
smith 100
jones 300
jones 400
blake 200
clark 200
clark 300
smith 400
```

Implicit joins extend to the situation in which the targeted keyed table itself has a foreign key to another keyed table.

```q
q)emaster:([eid:1001 1002 1003 1004 1005] currency:`gbp`eur`eur`gbp`eur)
q)update eid:`emaster$1001 1002 1005 1004 1003 from `s
`s

q)select s.name, qty, s.eid.currency from sp
name  qty currency
------------------
smith 300 gbp
smith 200 gbp
smith 400 gbp
smith 200 gbp
clark 100 gbp
smith 100 gbp
jones 300 eur
jones 400 eur
blake 200 eur
clark 200 gbp
clark 300 gbp
smith 400 gbp
```

:fontawesome-solid-street-view:
_Q for Mortals_
[§9.9.1 Implicit Joins](/q4m3/9_Queries_q-sql/#991-implicit-join)



----
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.9 Joins](/q4m3/9_Queries_q-sql/#99-joins)