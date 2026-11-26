---
title: tables – Reference – kdb+ and q documentation
description: tables is a q keyword that returns a list of tables in a namespace.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: kdb+, metadata, q, table
---
# `tables`




_List of tables in a namespace_

```syntax
tables x    tables[x]
```

Where `x` is the name of a namespace as a symbol, returns a sorted list of the tables in `x` as a symbol vector. Keyed tables are included.

```q
q)trade:([]sym:`a`b;price:1 2f)
q)quote:([]sym:`a`b;bid:1 2f;ask:2 3f)
q)master:([sym:`a`b]name:("Alpha";"Beta"))
q)tables `.         / tables in root namespace
`master`quote`trade
q)tables[]          / default is root namespace
`master`quote`trade
q).work.trade:trade / assign table in work namespace
q)tables `.work     / tables in work
,`trade
```

---

[Metadata](../basics/metadata.md)
