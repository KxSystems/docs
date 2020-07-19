---
title: within keyword | Reference | kdb+ and q documentation
description: within is a q keyword that tests whether one argument is within the bounds defined by the other.
author: Stephen Taylor
keywords: kdb+, ordered pair, q, search, within
---
# `within`





_Check bounds_


Syntax: `x within y`, `within[x;y]`

Where 

-   `x` is an atom or list of sortable type/s
-   `y` is an ordered pair (i.e. `(</)y` is true), or the flip of a list of ordered pairs of the same count and type/s as `x`, the result is a boolean for each item of `x` indicating whether it is within the inclusive bounds given by `y`.

```q
q)1 3 10 6 4 within 2 6
01011b
q)"acyxmpu" within "br"  / chars are ordered
0100110b
q)select sym from ([]sym:`dd`ccc`ccc) where sym within `c`d
sym
---
ccc
ccc
```

`within` is a left-uniform function: its result conforms to its left argument.

```q
q)5 within (1 2 6;3 5 7)
010b
q)2 5 6 within (1 2 6;3 5 7)
111b
q)(1 3 10 6 4;"acyxmpu") within ((2;"b");(6;"r"))
01011b
0100110b
```

----
:fontawesome-solid-book: 
[`except`](except.md), 
[`in`](in.md), 
[`inter`](inter.md), 
[`union`](union.md) 
<br>
:fontawesome-solid-book-open: 
[Search](../basics/search.md)


