---
title: exec, Exec
description: exec is a q keyword that returns selected rows and columns from a table. Exec is a q operator that does the same in functional SQL.
author: Stephen Taylor
keywords: kdb+, q, table
---
# `exec`, `?` Exec



_Return selected rows and columns from a table_


## `exec`

Syntax: `exec [{cols}] from t [where {cond}]`

```q
q)\l sp.q
q)exec qty from sp /list 
300 200 400 200 100 100 300 400 200 200 300 400
q)exec (qty;s) from sp /list per column 
300 200 400 200 100 100 300 400 200 200 300 400
s1  s1  s1  s1  s4  s1  s2  s2  s3  s4  s4  s1
q)exec qty, s from sp /dict by column name
qty| 300 200 400 200 100 100 300 400 200 200 300 400
s  | s1  s1  s1  s1  s4  s1  s2  s2  s3  s4  s4  s1
q)exec sum qty by s from sp /dict by key 
s1| 1600
s2| 700
s3| 200
s4| 600
q)exec q:sum qty by s from sp /xtab:list!table 
  | q
--| ----
s1| 1600
s2| 700
s3| 200
s4| 600
q)exec sum qty by s:s from sp /table!list 
s |
--| ----
s1| 1600
s2| 700
s3| 200
s4| 600
q)exec qty, s by 0b from sp /table
qty s
------
300 s1
200 s1
400 s1
200 s1
100 s4
100 s1
300 s2
400 s2
200 s3
200 s4
300 s4
400 s1
q)exec q:sum qty by s:s from sp
s | q
--| ----
s1| 1600
s2| 700
s3| 200
s4| 600
```


!!! warning "Cond is not supported inside q-SQL expressions"

    Enclose in a lambda or use [Vector Conditional](vector-conditional.md) instead.

    <i class="far fa-hand-point-right"></i>
    [q-SQL](../basics/qsql.md#cond)



<i class="far fa-hand-point-right"></i>
_Q for Mortals_: [§9.4 The `exec` Template](/q4m3/9_Queries_q-sql/#94-the-exec-template)  
Basics: [q-SQL](../basics/qsql.md)


## `?` Exec

<i class="far fa-hand-point-right"></i>
Basics: [Functional SQL](../basics/funsql.md#exec)

