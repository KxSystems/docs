---
title: keys, xkey
description: keys and xkey are q keywords that get or set the key columns of a table. 
author: Stephen taylor
keyword: kdb+, key, key columns, keyed table, q
---
# `keys`, `xkey`

_Get or set key column/s of a table_




## `keys`

_Key column/s of a table_

Syntax: `keys x`, `keys[x]`

Where `x` is a table (by value or reference), returns as a symbol vector the primary key column/s of `x` – empty if none.

```q
q)\l trade.q        / no keys
q)keys trade
`symbol$()
q)keys`trade
`symbol$()
q)`sym xkey`trade   / define a key
q)keys`trade
,`sym
```



## `xkey`

_Set specified columns as primary keys of a table_

Syntax: `x xkey y`, `xkey[x;y]`

Where symbol atom or vector `x` lists columns in table `y`, which is passed by 

-   value, returns 
-   reference, updates 

`y` with `x` set as the primary keys.

```q
q)\l trade.q
q)keys trade
`symbol$()            / no primary key
q)`sym xkey trade     / return table with primary key sym
sym| time         price size
---| -----------------------
a  | 09:30:00.000 10.75 100
q)keys trade         / trade has not changed
`symbol$()
q)`sym xkey `trade   / pass trade by reference updates the table in place
`trade
q)keys trade         / sym is now primary key of trade
,`sym
```

<i class="far fa-hand-point-right"></i> 
[`.Q.ff`](dotq.md#qff-append-columns) (append columns)  
Basics: [Dictionaries & tables](../basics/dictsandtables.md),
[Metadata](../basics/metadata.md)