---
title: meta – metadata for a table| Reference | kdb+ and q documentation
description: meta is a q keyword that returns metadata for a table.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `meta`




_Metadata for a table_

```syntax
meta x    meta[x]
```

Where `x` is a 

-   table in memory or memory mapped (by value or reference) 
-   filesymbol for a splayed table

returns a table keyed by column name, with columns:

```txt
c   column name
t   data type
f   foreign key (enums)
a   attribute
```

```q
q)\l trade.q
q)show meta trade
c    | t f a
-----| -----
time | t
sym  | s
price| f
size | i
q)show meta `trade
c    | t f a
-----| -----
time | t
sym  | s
price| f
size | i
q)`sym xasc`trade;   / sort by sym thereby setting the `s attribute
q)show meta trade
c    | t f a
-----| -----
time | t
sym  | s   s
price| f
size | i
```

The `t` column denotes the column type. A lower-case letter indicates atomic entry and an upper-case letter indicates a list.

```q
q)show u:([] code:`F1; vr:(enlist 2.3))
code vr
--------
F1   2.3
q)meta u
c   | t f a
----| -----
code| s
vr  | f
q)show v:([] code:`F2; vr:(enlist (5.4; 43.2)))
code vr
-------------
F2   5.4 43.2
q)meta v
c   | t f a
----| -----
code| s
vr  | F
```
!!! warning "The result of `meta` does not tell you whether a table in memory can be [splayed](../kb/splayed-tables.md), only the first item in each column is examined"

A splayed table with a symbol column needs its corresponding sym list.

```q
kdb+ 0.1.2 2025.10.18 Copyright (C) 1993-2025 Kx Systems
...

q)load `:db/sym  / required for meta to describe db/tr
`sym
q)meta `:db/tr
c    | t f a
-----| -----
date | d
time | u
vol  | j
inst | s
price| f
```

Loading (memory mapping) a database handles this. 

```bash
❯ q db
```
```q
kdb+ 0.1.2 2025.10.18 Copyright (C) 1993-2025 Kx Systems
...

q)\v
`s#`sym`tr
q)meta tr
c    | t f a
-----| -----
date | d
time | u
vol  | j
inst | s
price| f
```


---

[Metadata](../basics/metadata.md)
<br>

[Splayed tables](../kb/splayed-tables.md)
