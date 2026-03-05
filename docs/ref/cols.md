---
title: cols, xcol, xcols | Reference | kdb+ and q documentation
description: cols, xcol and xcols are q keywords. cols returns the column names of a table. xcol renames tablecolumns. xcols reorders table columns. 
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `cols`, `xcol`, `xcols`

_Table columns_

## `cols`

_Column names of a table_

```syntax
cols x    cols[x]
```

Where `x` is a

- table
- the name of a table as a symbol atom
- a filesymbol for a splayed table

returns its column names as a symbol vector.

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

Where `y` is a table passed by value, and `x` is

- a **symbol vector** of length no greater than `count cols y` returns `y` with its first `count x` columns renamed
- a **dictionary** (since V3.6 2018.08.24) formed from two symbol vectors, returns `y` with the columns in `key x` renamed as `value x`

```q
q)t:([]a:3 4 5; b:6 7 8; c:`z`u`i)
q)`d`e xcol t                               / rename first two columns
d e c
-----
3 6 z
4 7 u
5 8 i
q)([a:`A;c:`C]) xcol t                        / rename selected columns
A b C
-----
3 6 z
4 7 u
5 8 i
q)([q:`r]) xcol t              / nonexistent column names in key x signal a length error
'length
  [0]  ([q:`r]) xcol t
```

_Q for Mortals_
[§9.8.1 `xcol`](/q4m3/9_Queries_q-sql/#981-xcol)

## `xcols`

_Reorder table columns_

```syntax
x xcols y    xcols[x;y]
```

Where

- `y` is a simple table passed by value
- `x` is a symbol vector of some or all of `y`’s column names (can also be an atom)

returns `y` with `x` as its first column/s.

```q
q)t:([]a:3 4 5; b:6 7 8; c:`z`u`i)
q)`b xcols t
b a c
-----
6 3 z
7 4 u
8 5 i
q)t:xcols[reverse cols t;t]              / reverse cols and reassign
q)cols t
`c`b`a
```

_Q for Mortals_
[§9.8.2 `xcols`](/q4m3/9_Queries_q-sql/#982-xcols)

----

[Dictionaries](../basics/dictsandtables.md),
[Metadata](../basics/metadata.md)
<br>

[Tables](../kb/faq.md)
