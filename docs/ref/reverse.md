---
title: reverse the order of items in a list or dictionary | Reference | kdb+ and q documentation
description: reverse is a q keyword that reverses the order of items in a list or dictionary.
---
# `reverse`





_Reverse the order of items of a list or dictionary_

```txt
reverse x    reverse[x]
```

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

----
:fontawesome-solid-book: 
[`rotate`](rotate.md)