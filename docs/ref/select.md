---
title: select keyword, Select operator | Reference | kdb+ and q documentation
description: select and Select are (respectively) a q keyword and operator that select all or part of a table, possibly with new columns.
author: Stephen Taylor
keywords: column, kdb+, q, qsql, query, select, sql, table
---
# `select`





_Select all or part of a table, possibly with new columns_

!!! info "`select` is a qSQL query template and varies from regular q syntax."

For the Select operator `?`, see 
:fontawesome-solid-book-open:
[Functional SQL](../basics/funsql.md)


## Syntax


Below, square brackets mark optional elements.

<pre markdown="1" class="language-txt">
select [_L<sub>exp</sub>_] [_p<sub>s</sub>_] [by _p<sub>b</sub>_] from _t<sub>exp</sub>_ [where _p<sub>w</sub>_]
</pre>

:fontawesome-solid-book-open:
[qSQL syntax](../basics/qsql.md)


The `select` query returns a table for both [call-by-name and call-by-value](../basics/qsql.md#from-phrase).


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

The [Select phrase](../basics/qsql.md#select-phrase) specifies the columns of the result table, one per subphrase. 

Absent a Select phrase, all the columns of the table expression are returned.
(Unlike SQL, no `*` wildcard is required.)

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

A [computed column](../basics/qsql.md#computed-columns) in the Select phrase cannot be referred to in another subphrase. 


## Limit expression

To limit the returned results you can include a limit expression _L<sub>exp</sub>_

```q
select[n]
select[m n]
select[order]
select[n;order]
select distinct
```

where 

-   `n` limits the result to the first `n` rows of the selection if positive, or the last `n` rows if negative 
-   `m` is the number of the first row to be returned: useful for stepping through query results one block of `n` at a time
-   `order` is a column (or table) and sort order: use `<` for ascending, `>` for descending

```q
select[3;>price] from bids where sym=s,size>0
```

This would return the three best prices for symbol `s` with a size greater than 0.

This construct works on in-memory tables but not on memory-mapped tables loaded from splayed or partitioned files. 

!!! tip "Performance"

    `select[n]` applies the Where phrase on all rows of the table, and takes the first `n` rows, before applying the Select phrase. 

    So if you are paging it is better to store the result of the query somewhere and `select[n,m]` from there, rather than run the filter again.

`select distinct` returns only unique records in the result.


## By phrase

A `select` query that includes a By phrase returns a keyed table.
The key columns are those in the By phrase; values from other columns are grouped, i.e. nested. 

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

-   are included in the result and need not be specified in the Select phrase
-   can include computed columns

:fontawesome-solid-globe:
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

Where there is a [By phrase](../basics/qsql.md#by-phrase), and no sort order is specified, the result is sorted ascending by its key.


## Cond

[Cond](cond.md) is not supported inside query templates: 
see [qSQL](../basics/qsql.md#cond).



----
:fontawesome-solid-book:
[`delete`](delete.md),
[`exec`](exec.md),
[`update`](update.md)
<br>
:fontawesome-solid-book-open:
[qSQL](../basics/qsql.md),
[Functional SQL](../basics/funsql.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.3 The `select` Template](/q4m3/9_Queries_q-sql/#93-the-select-template) 
