---
title: upsert | Reference | kdb+ and q documentation
description: upsert is a q keyword that adds records to a table or updates matching ones.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `upsert`

_Update or append records in a table_

```syntax
x upsert y    upsert[x;y]
```

Where 

- `x` is a table, the name of a table as a symbol atom, or a file handle to a serialized or splayed table
- `y` is zero or more records

`upsert` adds the records to the table, as described in the following sections.

The records `y` can be either:

- Lists with types that match `type each x cols x`
- A table with columns that are members of `cols x` and have corresponding types

If `x` is the name of a table or a file handle, `upsert` updates the table in place and returns `x`. Otherwise, it returns the updated table.

If `x` names a table that does not exist, `upsert` creates a global table from `y`. If `x` is a file handle to a table that does not exist, `upsert` writes `y` to that file.

## Simple table

If `x` is a simple table, `upsert` appends the new records. If `y` is a table, it must also be simple.

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

If `x` is keyed, `upsert` updates the existing records whose keys match records in `y`, and inserts the rest.

If `y` is a table, it can be keyed or unkeyed.

```q
q)a:([s:`q`w]r:1 2;u:5 6)
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

q)show a:([s:`q`w`e]r:1 2 3;u:5 6 7)         / keyed table
s| r u
-| ---
q| 1 5
w| 2 6
e| 3 7

q)/ Update `q and `e, insert new `r; return new table
q)a upsert ([s:`e`r`q]r:30 4 10;u:70 8 50)    / keyed table as records
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

!!! note "Upserting can remove [attributes](set-attribute.md)"

    As with tables in memory, the unique and sorted attributes are kept only while the data still satisfies them, and the parted attribute is removed.
    Upserting to a splayed table also removes the grouped attribute.

----

[`insert`](insert.md),
[Join](join.md)
<br>
 
[Joins](../basics/joins.md),
[qSQL](../basics/qsql.md),
[Tables](../kb/faq.md) 
<br>
 
_Q for Mortals_
[§9.2 Upsert](/q4m3/9_Queries_q-sql/#92-upsert)
