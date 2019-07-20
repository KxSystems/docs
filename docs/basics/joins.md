---
title: Joins
description: A join combines data from two tables, or from a table and a dictionary. Some joins are keyed, in that columns in the first argument are matched with the key columns of the second argument. Some joins are as-of, where a time column in the first argument specifies corresponding intervals in a time column of the second argument. Such joins are not keyed.
keywords: aj, asof, coalesce, equi-join, inner join, join, kdb+, keyed, left join, plus join, q, union join, upsert, window join, wj, wj1
---
# Joins







A _join_ combines data from two tables, or from a table and a dictionary.

Some joins are _keyed_, in that columns in the first argument are matched with the key columns of the second argument.

Some joins are _as-of_, where a time column in the first argument specifies corresponding intervals in a time column of the second argument. Such joins are not keyed.

In each case, the result has the merge of columns from both arguments. Where necessary, rows are filled with nulls or zeroes.


### Keyed joins

[`^`](../ref/coalesce.md) Coalesce
: Merge two tables

[`ej`](../ref/ej.md) Equi join
: Similar to `ij`, where the columns to be matched are given as a parameter.

[`ij` `ijf`](../ref/ij.md) Inner join
: Joins on the key columns of the second table. The result has one row for each row of the first table that matches the key columns of the second table.

[`lj` `ljf`](../ref/lj.md) Left join 
: Joins on the key columns of the second table. The result has one row for each row of the first table. Null values are used where a row of the first table has no match in the second table. This is now built-in to `,\:`.

[`pj`](../ref/pj.md) Plus join 
: A variation on left join. For each matching row, values from the second table are added to the first table, instead of replacing values from the first table.

[`uj` `ujf`](../ref/uj.md) Union join
: Uses all rows from both tables. If the second table is not keyed, the result is the catenation of the two tables. Otherwise, the result is the left join of the tables, catenated with the unmatched rows of the second table.

[`upsert`](../ref/upsert.md) 
: Can be used to join two tables with matching columns (as well as add new records to a table). If the first table is keyed, any records that match on key are updated. The remaining records are appended.

!!! tip "Join operator"

    The [Join](../ref/join.md)  operator `,` joins tables and dictionaries as well as lists. For tables `t1` and `t2`:
    
    -   `t1,t2` is `t1 upsert t2`
    -   `t1,'t2` joins records to records
    -   `t1,\:t2` is `t1 lj t2` (since V2.7 2011.01.24)


### As-of joins

In each case, the time column in the first argument specifies \[) intervals in the second argument.

[`wj`, `wj1`](../ref/wj.md) Window join
: The most general forms of as-of join. Function parameters aggregate values in the time intervals of the second table. In `wj`, prevailing values on entry to each interval are considered. In `wj1`, only values occurring within each interval are considered.

[`aj`,`aj0`](../ref/aj.md) As-of join
: Simpler window joins where only the last value in each interval is used. In the `aj` result, the time column is from the first table, while in the `aj0` result, the time column is from the second table.

[`asof`](../ref/asof.md) 
: A simpler `aj` where all columns (or dictionary keys) of the second argument are used in the join.


