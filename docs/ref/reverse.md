---
title: reverse the order of items in a list or dictionary | Reference | kdb+ and q documentation
description: reverse is a q keyword that reverses the order of items in a list or dictionary.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `reverse`

_Reverse the order of items of a list or dictionary_

```syntax
reverse x    reverse[x]
```

Returns the items of `x` in reverse order.

```q
q)reverse 1 2 3 4
4 3 2 1
```

Where `x` is

- an atom, returns `x`
- a dictionary, reverses the order of its entries
- a table, reverses the order of its rows

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

----

[`rotate`](rotate.md)
