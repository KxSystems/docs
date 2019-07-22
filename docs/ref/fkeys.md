---
title: fkeys
description: fkeys is a q keyword that returns the foreign-key columns of a table.
author: Stephen Taylor
keywords: column, foreign key, kdb+, q, table
---
# `fkeys`

_Foreign-key columns of a table_



Syntax: `fkeys x`, `fkeys[x]`

Where `x` is a table, returns a dictionary that maps foreign-key columns to their tables.

```q
q)f:([x:1 2 3]y:10 20 30)
q)t:([]a:`f$2 2 2;b:0;c:`f$1 1 1)
q)meta t
c| t f a
-| -----
a| i f
b| i
c| i f
q)fkeys t
a| f
c| f
```


<i class="far fa-hand-point-right"></i>
Basics: [Metadata](../basics/metadata.md)