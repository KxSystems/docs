---
title: in
description: in is a q keyword that flags whether its left argument is an item in its right argument.
author: Stephen Taylor
date: June 2019
keywords: in, kdb+, q, search
---
# `in`




Syntax: `x in y`, `in[x;y]`

Where

x                     | y              | result
----------------------|----------------|---------------------------------
atom or vector        | atom or vector | boolean for each item of `x`: whether it is an item of `y`
atom, vector, or list | list           | boolean atom: whether `x` is an item of `y`
list                  | atom or vector | `x in\:y`

Where `x` and `y` are both atoms or 1-lists, `x in y` is equivalent to `x=y`.

```q
q)"x" in "a"                                    / atom in atom
0b
q)"x" in "acdexyz"                              / atom in vector
1b
q)"wx" in "acdexyz"                             / vector in vector
01b
q)"wx" in ("acdexyz";"abcd";"wx")               / vector in list
1b
q)("ab";"cd") in (("ab";"cd");0 1 2)            / list in list
1b
```

In the third rule above (list in vector) `in` simply recurses into the list until atoms or vectors are found and the first rule can be applied.

```q
q)("acdexyz";"abcd";"wx") in "wx"               / list in vector
0000100b
0000b
11b
q)("acdexyz";(("abcd";"efg");"wx")) in "wx"     / nested list in vector
0000100b
((0000b;000b);11b)
```


!!! tip "`in` is often used with `select`"

```q
q)\l sp.q
q)select from p where city in `paris`rome
p | name  color weight city
--| ------------------------
p2| bolt  green 17     paris
p3| screw blue  17     rome
p5| cam   blue  12     paris
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

<i class="far fa-hand-point-right"></i>
[`except`](except.md),
[`inter`](inter.md),
[`union`](union.md)  
Basics: [Search](../basics/search.md)

