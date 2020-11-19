---
title: inter – Reference – kdb+ and q documentation
description: inter is a q keyword that returns the intersection of two lists or dictionaries.
author: Stephen Taylor
keywords: inter, intersection, kdb+, q, select
---
# `inter`




_Intersection of two lists or dictionaries_

Syntax: `x inter y`, `inter[x;y]`

Where `x` and `y` are lists or dictionaries, uses the result of `x in y` to return items or entries from `x`.

```q
q)1 3 4 2 inter 2 3 5 7 11
3 2
```

Returns common values from dictionaries.

```q
q)show x:(`a`b)!(1 2 3;`x`y`z)
a| 1 2 3
b| x y z
q)show y:(`a`b`c)!(1 2 3;2 3 5;`x`y`z)
a| 1 2 3
b| 2 3 5
c| x y z
q)
q)x inter y
1 2 3
x y z
q)
```

Returns common rows from simple tables.

```q
q)show x:([]a:`x`y`z`t;b:10 20 30 40)
a b
----
x 10
y 20
z 30
t 40
q)show y:([]a:`y`t`x;b:50 40 10)
a b
----
y 50
t 40
x 10
q)x inter y
a b
----
x 10
t 40
```

:fontawesome-regular-hand-point-right: 
[`in`](in.md), [`within`](within.md)  
Basics: [Selection](../basics/by-topic.md#selection)
