---
title: sublist
description: sublist is a q keyword that returns a sublist of a list.
author: Stephen Taylor
keywords: kdb+, q, select, sublist
---
# `sublist`





_Select a sublist of a list_

Syntax: `x sublist y`, `sublist[x;y]`

Where 

-  `x` is an integer atom or pair
-  `y` is a list

returns a sublist of `y`. The result contains no more items than are available in `y`.



## Head or tail 

Where `x` is an **integer atom** returns `x` items from the beginning of `y` if positive, or from the end if negative

```q
q)p:2 3 5 7 11
q)3 sublist p                           / 3 from the front
2 3 5
q)10 sublist p                          / only available values
2 3 5 7 11
q)2 sublist `a`b`c!(1 2 3;"xyz";2 3 5)  / 2 keys from a dictionary
a| 1 2 3
b| x y z
q)-3 sublist sp                         / last 3 rows of a table
s p qty
-------
3 1 200
3 3 300
0 4 400
```



## Slice

Where `x` is an **integer pair** returns `x[1]` items from `y`, starting at item `x[0]`.

```q
q)1 2 sublist p  / 2 items starting from position 1
3 5
```


<i class=" far fa-hand-point-right"></i>
Basics: [Selection](../basics/selection.md)

