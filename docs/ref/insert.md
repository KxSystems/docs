---
title: insert
description: insert is a q keyword inserts or appends records to a table.
author: Stephen Taylor
keywords: append, insert, kdb+, q, qsql, query, record, sql, table
---
# `insert`





_Insert or append records to a table_

Syntax: `tname insert records`

Where 

-  `tname` is a table name as a symbol atom
-  `records` is one or more records that match the table columns

inserts `records` into the table and returns the new row indexes. 

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

!!! tip "Function-local tables"

    `insert` can insert to global variables only, due to the lookup of the symbol name. If you need to insert to function-local tables, use `table,:data` instead.


<i class="far fa-hand-point-right"></i> 
[`,` Join](join.md)  
Basics: [q-SQL](../basics/qsql.md)


