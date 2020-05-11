---
title: reverse – Reference – kdb+ and q documentation
description: reverse is a q keyword that reverses the order of a list or dictionary.
keywords: dictionary, entry, item, list, kdb+, q, reverse
---
# `reverse`





_Reverse the order of a list or dictionary_

Syntax: `reverse x`, `reverse[x]`

Returns the items of `x` in reverse order.

```q
q)reverse 1 2 3 4
4 3 2 1
```

On atoms, returns the atom; on dictionaries, reverses the keys; and on tables, reverses the columns.

```q
q)d:`a`b!(1 2 3;"xyz")
q)reverse d
b| x y z
a| 1 2 3
q)reverse each d
a| 3 2 1
b| z y x
q)reverse flip d
a b
---
3 z
2 y
1 x
```


:fontawesome-regular-hand-point-right: 
[`rotate`](rotate.md)