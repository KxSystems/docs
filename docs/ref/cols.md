---
title: cols, xcol, xcols | Reference | kdb+ and q documentation
description: cols, xcol and xcols are q keywords. cols returns the column names of a table. xcol renames tablecolumns. xcols reorders table columns. 
author: Stephen Taylor
---
# `cols`, `xcol`, `xcols`


_Table columns_



## `cols`

_Column names of a table_

```syntax
cols x    cols[x]
```

Where `x` is a 

-    table
-    the name of a table as a symbol atom
-    a filesymbol for a splayed table

returns as a symbol vector its column names. 

```q
q)\l trade.q
q)cols trade            /value
 `time`sym`price`size
q)cols`trade            /reference
 `time`sym`price`size
```


## `xcol`

_Rename table columns_

```syntax
x xcol y    xcol[x;y]
```

Where `y` is a table, passed by value, and `x` is 

-   a **symbol vector** of length no greater than `count cols y` returns `y` with its first `count x` columns renamed
-   a **dictionary** (since V3.6 2018.08.24) formed from two symbol vectors, of which the keys are all the names of columns of `y`, returns `y` with columns renamed according to the dictionary

```q
q)\l trade.q
q)cols trade
`time`sym`price`size
q)`Time`Symbol xcol trade                   / rename first two columns
Time         Symbol price size
------------------------------
09:30:00.000 a      10.75 100
q)trade:`Time`Symbol`Price`Size xcol trade  / rename all and assign
q)cols trade
`Time`Symbol`Price`Size
q)(`a`c!`A`C)xcol([]a:();b:();c:())         / rename selected columns
A b C
-----
```

:fontawesome-solid-street-view:
_Q for Mortals_
[§9.8.1 `xcol`](/q4m3/9_Queries_q-sql/#981-xcol)


## `xcols`

_Reorder table columns_

```syntax
x xcols y    xcols[x;y]
```

Where 

-   `y` is a simple table, passed by value
-   `x` is a symbol vector of some or all of `y`’s column names

returns `y` with `x` as its first column/s.

```q
q)\l trade.q
q)cols trade
`time`sym`price`size
q)trade:xcols[reverse cols trade;trade]  / reverse cols and reassign trade
q)cols trade
`size`price`sym`time
q)cols trade:`sym xcols trade            / move sym to the front
`sym`size`price`time
```

:fontawesome-solid-street-view:
_Q for Mortals_
[§9.8.2 `xcols`](/q4m3/9_Queries_q-sql/#982-xcols)


----
:fontawesome-solid-book: 
[`meta`](meta.md), 
[`.Q.V`](dotq.md#qv-table-to-dict) (table to dictionary)
<br>
:fontawesome-solid-book-open:
[Dictionaries](../basics/dictsandtables.md), 
[Metadata](../basics/metadata.md)
<br>
:fontawesome-solid-graduation-cap:
[Tables](../kb/faq.md)