---
title: upsert | Reference | kdb+ and q documentation
description: upsert is a q keyword that adds new records to a table.
author: Stephen Taylor
---
# `upsert`





_Overwrite or append records to a table_

```syntax
x upsert y    upsert[x;y]
```

Where 

-   `x` is a table, or the name of a table as a symbol atom, or the name of a splayed table as a directory handle
-   `y` is zero or more records

the records are upserted into the table.

The record/s `y` may be either 

-   lists with types that match `type each x cols x`
-   a table with columns that are members of `cols x` and have corresponding types

If `x` is the name of a table, it is updated in place. Otherwise the updated table is returned.

If `x` is the name of a table as a symbol atom (or the name of a splayed table as a directory handle) that does not exist in the file system, it is written to file.


## Simple table

If the table is simple, new records are appended.
If the records are in a table, it must be simple.

```q
q)t:([]name:`tom`dick`harry;age:28 29 30;sex:`M)

q)t upsert (`dick;49;`M)
name  age sex
-------------
tom   28  M
dick  29  M
harry 30  M
dick  49  M

q)t upsert((`dick;49;`M);(`jane;23;`F))
name  age sex
-------------
tom   28  M
dick  29  M
harry 30  M
dick  49  M
jane  23  F

q)`t upsert ([]age:49 23;name:`dick`jane)
`t
q)t
name  age sex
-------------
tom   28  M
dick  29  M
harry 30  M
dick  49
jane  23
```


## Keyed table

If the table is keyed, any new records that match on key are updated. Otherwise, new records are inserted.

If the right argument is a table it may be keyed or unkeyed.

```q
q)a upsert (`e;30;70)                         / single record
s| r  u
-| -----
q| 1  5
w| 2  6
e| 30 70

q)a upsert ((`e;30;70);(`r;40;80))            / multiple records
s| r  u
-| -----
q| 1  5
w| 2  6
e| 30 70
r| 40 80

q)show a:([]s:`q`w`e;r:1 2 3;u:5 6 7)         / simple table
s| r u
-| ---
q| 1 5
w| 2 6
e| 3 7

q)/update `q and `e, insert new `r; return new table
q)a upsert ([s:`e`r`q]r:30 4 10;u:70 8 50)    / keyed table
s| r  u                                       
-| -----
q| 10 50
w| 2  6
e| 30 70
r| 4  8

q)`a upsert ([s:`e`r`q]r:30 4 10;u:70 8 50)   / same but update table in place
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
[qSQL](../basics/qsql.md),
[Tables](../kb/faq.md) 
<br>
:fontawesome-solid-street-view: 
_Q for Mortals_
[§9.2 Upsert](/q4m3/9_Queries_q-sql/#92-upsert)