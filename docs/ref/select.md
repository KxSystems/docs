---
title: select keyword, Select operator | Reference | kdb+ and q documentation
description: select and Select are (respectively) a q keyword and operator that select all or part of a table, possibly with new columns.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: column, kdb+, q, qsql, query, select, sql, table
---
# `select`





_Select all or part of a table, possibly with new columns_

!!! info "`select` is a qSQL query template and varies from regular q syntax."

For the Select operator `?`, see [Functional SQL](../basics/funsql.md).

## Syntax

In the following syntax, square brackets mark optional elements.

<div markdown="1" class="typewriter">
select [_L~exp~_] [_p~s~_] [by _p~b~_] from _t~exp~_ [where _p~w~_]

where

_L~exp~_  Limit expression
_p~s~_    Select phrase
_p~b~_    By phrase
_t~exp~_  Table expression
_p~w~_    Where phrase
</div>


[qSQL syntax](../basics/qsql.md)


The `select` query returns a table for both [call-by-name and call-by-value](../basics/qsql.md#from-phrase).

Since 4.1t 2021.03.30, select from [partitioned tables](../kb/partition.md) maps relevant columns within each partition in parallel when running with [secondary threads](../basics/syscmds.md#s-number-of-secondary-threads).

A `select` from [partitioned tables](../kb/partition.md) maps relevant columns within each partition in parallel when running with [secondary threads](../basics/syscmds.md#s-number-of-secondary-threads).

## Minimal form

The minimal form of the query returns the evaluated table expression.

```q
q)tbl:([] id:1 1 2 2 2;val:100 200 300 400 500)
q)select from tbl
id val
------
1  100
1  200
2  300
2  400
2  500
```


## Select phrase

The Select phrase specifies the columns of the result table, one per subphrase.

Without a Select phrase, the query returns all the columns of the table expression.
(Unlike SQL, q doesn't use a `*` wildcard.)

```q
q)t:([] c1:`a`b`c; c2:10 20 30; c3:1.1 2.2 3.3)

q)select c3, c1 from t
c3  c1
------
1.1 a
2.2 b
3.3 c

q)select from t
c1 c2 c3
---------
a  10 1.1
b  20 2.2
c  30 3.3
```

Another subphrase cannot refer to a [computed column](../basics/qsql.md#computed-columns) in the Select phrase.

```q
q)select a:c2*2, b:a+1 from t
'a
  [0]  select a:c2*2, b:a+1 from t
                        ^
```

## Limit expression

To limit the returned results, you can include a limit expression _L~exp~_:

```q
select[n]
select[m n]
select[order]
select[n;order]
select distinct
```

where 

- `n` limits the result to the first `n` rows of the selection if positive, or the last `n` rows if negative
- `m` is the number of the first row to return: useful for stepping through query results one block of `n` at a time
- `order` is a column (or table) and sort order: use `<` for ascending, `>` for descending

The following query returns the three best prices for symbol `s` with a size greater than 0.

```q
q)bids:([]sym:`a`a`a`b`a;price:10 12 11 20 13;size:100 0 200 300 50)
q)s:`a
q)select[3;>price] from bids where sym=s,size>0
sym price size
--------------
a   13    50
a   11    200
a   10    100
q)select[1 2] from bids     / 2 rows starting from row 1
sym price size
--------------
a   12    0
a   11    200
```

This construct works on in-memory and memory-mapped splayed tables, but not on partitioned tables, where it signals `'nyi`.

!!! tip "Performance"

    `select[n]` applies the Where phrase to all rows of the table, and takes the first `n` rows, before applying the Select phrase.

    If you're paging through results, store the query result and use `select[m n]` on it instead of running the filter again.

`select distinct` returns only unique records in the result.


## By phrase

A `select` query that includes a By phrase returns a keyed table.
The key columns are those in the By phrase; values from other columns are grouped, that is, nested.

```q
q)k:`a`b`a`b`c
q)v:10 20 30 40 50

q)select c2 by c1 from ([]c1:k;c2:v)
c1| c2
--| -----
a | 10 30
b | 20 40
c | ,50

q)v group k   / compare the group keyword
a| 10 30
b| 20 40
c| ,50
```

Unlike in SQL, columns in the By phrase

- are included in the result, so you don't need to specify them in the Select phrase
- can include computed columns

[The SQL `GROUP BY` statement](https://www.w3schools.com/sql/sql_groupby.asp)

The [`ungroup`](ungroup.md) keyword reverses the grouping, though the original order is lost. 

```q
q)ungroup select c2 by c1 from ([]c1:k;c2:v)
c1 c2
-----
a  10
a  30
b  20
b  40
c  50
```

```q
q)t:([] name:`tom`dick`harry`jack`jill;sex:`m`m`m`m`f;eye:`blue`green`blue`blue`gray)
q)t
name  sex eye
---------------
tom   m   blue
dick  m   green
harry m   blue
jack  m   blue
jill  f   gray

q)select name,eye by sex from t
sex| name                 eye
---| ------------------------------------------
f  | ,`jill               ,`gray
m  | `tom`dick`harry`jack `blue`green`blue`blue

q)select name by sex,eye from t
sex eye  | name
---------| ---------------
f   gray | ,`jill
m   blue | `tom`harry`jack
m   green| ,`dick
```

A By phrase with no Select phrase returns the last row in each group.

```q
q)select by sex from t
sex| name eye
---| ---------
f  | jill gray
m  | jack blue
```

If a query has a By phrase and no sort order, q sorts the result in ascending order by its key.


## Cond

Query templates don't support [Cond](cond.md). For details, see [qSQL](../basics/qsql.md#cond).

----

[`delete`](delete.md),
[`exec`](exec.md),
[`update`](update.md)
<br>

[qSQL](../basics/qsql.md),
[Functional SQL](../basics/funsql.md)
<br>

_Q for Mortals_
[§9.3 The `select` Template](/q4m3/9_Queries_q-sql/#93-the-select-template) 
