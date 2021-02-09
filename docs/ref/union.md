---
title: union join of two tables | Reference | kdb+ and q documentation
description: union is a q keyword that returns the union of two lists.
author: Stephen Taylor
---
# `union`





_Union of two lists_

```txt
x union y    union[x;y]
```

Where `x` and `y` are lists or atoms, returns a list of the distinct items of its combined arguments, i.e. `distinct x,y`.

```q
q)1 2 3 3 6 union 2 4 6 8
1 2 3 6 4 8
q)distinct 1 2 3 3 6, 2 4 6 8      / same as distinct on join
1 2 3 6 4 8

q)t0:([]x:2 3 5;y:"abc")
q)t1:([]x:2 4;y:"ad")
q)t0 union t1                      / also on tables
x y
---
2 a
3 b
5 c
4 d
q)(distinct t0,t1)~t0 union t1
1b
```


----
:fontawesome-solid-book:
[`in`](in.md), [`inter`](inter.md), [`within`](within.md)
<br>
:fontawesome-solid-book:
[Select](../basics/by-topic.md#selection)


