---
title: distinct
description: distinct is a q keyword that returns the nub (the unique items) of a list.
author: Stephen Taylor
keywords: distinct, kdb+, list, q, search, unique
---
# `distinct`




_Unique items of a list_

Syntax: `distinct x`, `distinct[x]` 

Where `x` is a list returns the distinct (unique) items of `x` in the order of their first occurrence.

```q
q)distinct 2 3 7 3 5 3
2 3 7 5
```

Returns the distinct rows of a table.

```q
q)distinct flip `a`b`c!(1 2 1;2 3 2;"aba")
a b c
-----
1 2 a
2 3 b
```

It does not use [comparison tolerance](../basics/precision.md)

```q
q)\P 14
q)distinct 2 + 0f,10 xexp -13
2 2.0000000000001
```


<i class="far fa-hand-point-right"></i> 
[`.Q.fu`](dotq.md#qfu-apply-unique) (apply unique)  
Basics: [Precision](../basics/precision.md), 
[Search](../basics/search.md) 


## Errors

error | cause
------|----------------
rank  | `x` is an atom
