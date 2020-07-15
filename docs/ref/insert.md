---
title: insert keyword | Reference | kdb+ and q documentation
description: insert is a q keyword that inserts or appends records to a table.
author: Stephen Taylor
keywords: append, insert, kdb+, q, qsql, query, record, sql, table
---
# `insert`




_Insert or append records to a table_

Syntax: `` `x insert y``, ``insert[`x;y]``

Where 

-  `x` is a table 
-  `y` is one or more records that match the columns of `x`; **or** if `x` is undefined, a table

inserts `y` into `x` and returns the new row indexes. 

!!! warning "The left argument is the name of a table as a symbol atom."

```q
q)show x:([a:`x`y];b:10 20)
a| b
-| --
x| 10
y| 20

q)`x insert (`z;30)
,2

q)x
a| b
-| --
x| 10
y| 20
z| 30

q)tnew
'tnew
  [0]  tnew
       ^
q)`tnew insert ([c1:`a`b];c2:10 20)
0 1
q)tnew
c1| c2
--| --
a | 10
b | 20
```

If the table is keyed, the new records must not match existing keys.

```q
q)`x insert (`z;30)
'insert
```

Several records may be appended at once:

```q
q)`x insert (`s`t;40 50)
3 4
q)x
a| b
-| --
x| 10
y| 20
z| 30
s| 40
t| 50
```

!!! tip "`insert` can insert to global variables only."

    If you need to insert to function-local tables, use [`x,:y`](assign.md#assign-through-operator) or [Update](../basics/funsql.md#update) instead.


## Type

Values in `y` must match the type of corresponding columns in `x`; otherwise, q signals a `type` error.

Empty columns in `x` with general type assume types from the first record inserted. 

```q
q)meta u:([] name:(); age:())
c   | t f a
----| -----
name|
age |
q)`u insert (`tom`dick;30 40)
0 1
q)meta u
c   | t f a
----| -----
name| s
age | j
```


## Foreign keys

If `x` has foreign key/s the corresponding values of `y` are checked to ensure they appear in the primary key column/s pointed to by the foreign key/s. 
A `cast` error is signalled if they do not.


## Errors

```txt
cast     y value not in foreign key
insert   y key value defined in x
type     y value wrong type
```

!!! tip "With keyed tables, consider [`upsert`](upsert.md) as an alternative."

----
:fontawesome-solid-book: 
[`,` Join](join.md),
[`upsert`](upsert.md)
<br>
:fontawesome-solid-book-open: 
[q-SQL](../basics/qsql.md)


