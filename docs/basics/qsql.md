---
title: Q-SQL
description: Q-SQL expressions have their own syntax rules, with optional dependent clauses, by, from and where. Q-SQL column lists are comma-separated lists of column names, not symbol vectors, and can include definitions of new, derived columns. 
keywords: exec, delete, kdb+, q, query, select, sql, update, upsert
---
# Q-SQL



Q-SQL expressions have their own syntax rules, with optional dependent clauses, `by`, `from` and `where`. Q-SQL column lists are comma-separated lists of column names, not symbol vectors, and can include definitions of new, _derived_ columns. 


## Call by value, call by reference

In q-SQL expressions, where a table is called

- by value, the expression returns a result
- by reference, the table is _replaced_ as a side effect, and its name returned

```q
q)t1:t2:([]a:1 2;b:3 4)
q)update a:neg a from t1
a  b
----
-1 3
-2 4
q)t1~t2
1b
q)update a:neg a from `t1
`t1
q)t1~t2
0b
```


<i class="far fa-hand-point-right"></i> 
_Q for Mortals_: [§9.0 Queries: q-sql](/q4m3/9_Queries_q-sql/#90-overview)


keyword                      | semantics
-----------------------------|------------------------------------------
[`delete`](../ref/delete.md) | Delete rows or columns from a table
[`exec`](../ref/exec.md)     | Return columns from a table, possibly with new columns
[`fby`](../ref/fby.md)       | Aggregate subgroups
[`select`](../ref/select.md) | Return part of a table, possibly with new columns
[`update`](../ref/select.md) | Add rows or columns to a table
[`upsert`](../ref/select.md) | Add new records to a table, update existing records


## Functional forms

The q-SQL templates all have [functional forms](funsql.md), which can be used without performance penalty. 


## Cond

[Cond](../ref/cond.md) is not supported inside q-SQL expressions.

```q
q)u:([]a:raze ("ref/";"kb/"),\:/:"abc"; b:til 6)
q)select from u where a like $[1b;"ref/*";"kb/*"]
'rank
  [0]  select from u where a like $[1b;"ref/*";"kb/*"]
                                  ^
```

Enclose in a lambda

```q
q)select from u where a like {$[x;"ref/*";"kb/*"]}1b
a       b
---------
"ref/a" 0
"ref/b" 2
"ref/c" 4
```

or use the [Vector Conditional](../ref/vector-conditional.md) instead.
