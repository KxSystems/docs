---
title: xgroup – Reference – kdb+ and q documentation
description: xgroup is a q keyword that groups a table by values in selected columns.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: column, group, kdb+, q, xgroup
---
# `xgroup`

_Group a table by values in selected columns_

```syntax
x xgroup y    xgroup[x;y]
```

Where

- `y` is a table passed by value
- `x` is a symbol atom or vector of column names in `y`

returns `y` grouped by `x`.
It is equivalent to `select … by` on `y`, except that `xgroup` groups all the remaining columns, so you don't need to list them.
If `y` is a keyed table, it is unkeyed first, so its key columns are grouped too.

```q
q)`a`b xgroup ([]a:0 0 1 1 2;b:`a`a`c`d`e;c:til 5)
a b| c
---| ---
0 a| 0 1
1 c| ,2
1 d| ,3
2 e| ,4

q)t:([]sym:`a`b`a`c`b;px:1 2 3 4 5;qty:10 20 30 40 50)
q)`sym xgroup t                  / group by column sym
sym| px  qty
---| ---------
a  | 1 3 10 30
b  | 2 5 20 50
c  | ,4  ,40

q)select px,qty by sym from t    / equivalent select statement
sym| px  qty
---| ---------
a  | 1 3 10 30
b  | 2 5 20 50
c  | ,4  ,40

q)ungroup `sym xgroup t          / ungroup flattens the groups
sym px qty
----------
a   1  10
a   3  30
b   2  20
b   5  50
c   4  40
```

!!! warning "Duplicate keys or column names"

    Duplicate keys in a dictionary or duplicate column names in a table cause sorts and grades to return unpredictable results.

----

[`group`](group.md),
[`ungroup`](ungroup.md)
<br>

[Dictionaries & tables](../basics/dictsandtables.md)
