---
title: tables – Reference – kdb+ and q documentation
description: tables is a q keyword that returns a list of tables in a namespace.
author: Stephen Taylor
keywords: kdb+, metadata, q, table
---
# `tables`




_List of tables in a namespace_

Syntax: `tables x`, `tables[x]`

Where `x` is a reference to a namespace, returns as a symbol vector a sorted list of the tables in `x`

```q
q)\l sp.q
q)tables `.       / tables in root namespace
`p`s`sp
q)tables[]        / default is root namespace
`p`s`sp
q).work.tab:sp    / assign table in work namespace
q)tables `.work   / tables in work
,`tab
```


:fontawesome-regular-hand-point-right:
Basics: [Metadata](../basics/metadata.md)