---
title: upsert
description: upsert is a q keyword that adds new records to a table.
author: Stephen Taylor
keywords: kdb+, q, query, qsql, records, sql, table, update, upsert
---
# `upsert`





_Add new records to a table_

Syntax: `table upsert new_records`

If the table is keyed, any new records that match on key are updated. Otherwise, new records are inserted.

If the table is passed by reference, it is updated in place. Otherwise the updated table is returned.

```q
q)show a:([s:`q`w`e]r:1 2 3;u:5 6 7)
s| r u
-| ---
q| 1 5
w| 2 6
e| 3 7
q)a upsert ([s:`e`r`q]r:30 4 10;u:70 8 50)    / update `q and `e, insert new `r
s| r  u                                       / returning new table
-| -----
q| 10 50
w| 2  6
e| 30 70
r| 4  8
q)`a upsert ([s:`e`r`q]r:30 4 10;u:70 8 50)   / same but updating table in place
`a
```


!!! warning "Cond is not supported inside q-SQL expressions"

    Enclose in a lambda or use [Vector Conditional](vector-conditional.md) instead.

    <i class="far fa-hand-point-right"></i>
    [q-SQL](../basics/qsql.md#cond)


<i class="far fa-hand-point-right"></i> 
[Join](join.md)  
Basics: [Joins](../basics/joins.md),
[q-SQL](../basics/qsql.md)  
_Q for Mortals_: [§9.2 Upsert](/q4m3/9_Queries_q-sql/#92-upsert)