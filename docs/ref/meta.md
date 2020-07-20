---
title: meta | Reference | kdb+ and q documentation
description: meta is a q keyword that returns metadata for a table.
author: Stephen Taylor
keywords: kdb+, meta, metadata, q, table
---
# `meta`




_Metadata for a table_

Syntax: `meta x`, `meta[x]`

Where `x` is a table (by value or reference) returns a table keyed by column name, with columns:

-   `c` – column name
-   `t` – data type
-   `f` – foreign key (enums)
-   `a` – attribute

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


:fontawesome-solid-book-open:
[Metadata](../basics/metadata.md)