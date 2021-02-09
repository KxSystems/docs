---
title: in | Reference | kdb+ and q documentation
description: in is a q keyword that flags whether its left argument is an item in its right argument.
author: Stephen Taylor
date: Noveber 2020
---
# `in`


_Whether x is an item of y_


```txt
x in y    in[x;y]
```

Where `y` is 

-   an **atom or vector** of the same type as `x`, returns whether atoms of `x` are items of `y`
-   a **list**, returns as a boolean atom whether `x` is an item of `y`

Where `y` is an atom or vector, comparison is [left-atomic](../basics/glossary.md#left-atomic-function).

```q
q)"x" in "a"                                    / atom in atom
0b
q)"x" in "acdexyz"                              / atom in vector
1b
q)"wx" in "acdexyz"                             / vector in vector
01b
q)("abc";("def";"ghi");"jkl")in "bed"           / list in vector
010b
(110b;000b)
000b
```

Where `y` is a list there is no iteration through `x`.

```q
q)"wx" in ("acdexyz";"abcd";"wx")               / vector in list
1b
q)("ab";"cd") in (("ab";"cd");0 1 2)            / list in list
1b
q)any ("ab";"cd") ~/: (("ab";"cd");0 1 2)
1b
```

Further examples:

```q
q)1 3 7 6 4 in 5 4 1 6        / which of x are in y
10011b
q)1 2 in (9;(1 2;3 4))        / no item of x is in y
00b
q)1 2 in (1 2;9)              / 1 2 is an item of y
1b
q)1 2 in ((1 2;3 4);9)        / 1 2 is not an item of y
0b
q)(1 2;3 4) in ((1 2;3 4);9)  / x is an item of y
1b
```


## Queries

`in` is often used with [`select`](select.md).

```q
q)\l sp.q
q)select from p where city in `paris`rome
p | name  color weight city
--| ------------------------
p2| bolt  green 17     paris
p3| screw blue  17     rome
p5| cam   blue  12     paris
```


## :fontawesome-solid-exclamation-triangle: Mixed argument types

Optimized support for atom or 1-list `y` allows a wider input type mix.

```q
q)1 2. in 2
01b
q)1 2. in 1#2
01b
q)1 2. in 0#2
'type
  [0]  1 2. in 0#2
            ^
q)1 2. in 2#2
'type
  [0]  1 2. in 2#2
            ^
```

There is no plan to extend that to vectors of any length, and it might be removed in a future release.

!!! danger "We strongly recommend avoiding relying on this."



## Mixed argument ranks

!!! warning "Results for mixed-rank arguments are not intuitive"

```q
q)3 in (1 2;3)
0b
q)3 in (3;1 2)
1b
```

Instead use [Match](match.md):

```q
q)any ` ~/: (1 2;`)
1b
```



----
:fontawesome-solid-book:
[`except`](except.md),
[`inter`](inter.md),
[`union`](union.md)
<br>
:fontawesome-solid-book-open:
[Search](../basics/by-topic.md#search)

