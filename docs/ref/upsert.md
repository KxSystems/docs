---
title: upsert | Reference | kdb+ and q documentation
description: upsert is a q keyword that adds new records to a table.
author: Stephen Taylor
keywords: kdb+, q, query, qsql, records, sql, table, update, upsert
---
# `upsert`





_Add new records to a table_

Syntax: `x upsert y`, `upsert[x;y]`

Where 

-   `x` is a table, or the name of a table as a symbol atom, or the name of a splayed table as a directory handle
-   `y` is one or more records with types matching `x`, or a table with conforming columns

If `x` is the name of a table, it is updated in place. Otherwise the updated table is returned.

## Simple table

```q
q)t:([] name:`tom`dick`harry; age:28 29 30)

q)t upsert (`dick;49)                           / single record
name  age
---------
tom   28
dick  29
harry 30
dick  49

q)t upsert ((`dick;49);(`jane;23))              / two records
name  age
---------
tom   28
dick  29
harry 30
dick  49
jane  23

q)`t upsert ([] name:`dick`jane; age:49 23)     / table
`t
q)t
name  age
---------
tom   28
dick  29
harry 30
dick  49
jane  23
```


## Keyed table

If the table is keyed, any new records that match on key are updated. Otherwise, new records are inserted.

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


## Serialized table

```q
q)`:data/tser set ([] c1:`a`b; c2:1.1 2.2)
`:data/tser
q)`:data/tser upsert (`c; 3.3)
`:data/tser

q)get `:data/tser
c1 c2
------
a  1.1
b  2.2
c  3.3
```

Upserting to a serialized table reads the table into memory, updates it, and writes it back to file. 


## Splayed table

```q
q)`:data/tsplay/ set ([] c1:`sym?`a`b; c2:1.1 2.2)
`:data/tsplay/
q)`:data/tsplay upsert (`sym?`c; 3.3)
`:data/tsplay
q)select from `:data/tsplay
c1 c2
------
a  1.1
b  2.2
c  3.3
```

Upserting to a splayed table appends new values to the column files. 

!!! note "Upserting to a serialized or splayed table removes any [attributes](set-attribute.md) set. "

----

!!! warning "Cond is not supported inside q-SQL expressions"

    Enclose in a lambda or use [Vector Conditional](vector-conditional.md) instead.


:fontawesome-solid-book: 
[`insert`](insert.md), 
[Join](join.md) 
<br>
:fontawesome-solid-book-open: 
[Joins](../basics/joins.md),
[q-SQL](../basics/qsql.md) 
<br>
:fontawesome-solid-street-view: 
_Q for Mortals_
[§9.2 Upsert](/q4m3/9_Queries_q-sql/#92-upsert)