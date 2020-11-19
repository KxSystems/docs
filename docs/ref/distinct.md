---
title: distinct – unique items of a list | Reference | kdb+ and q documentation
description: distinct is a q keyword that returns the nub (the unique items) of a list.
author: Stephen Taylor
---
# `distinct`




_Unique items of a list_

```txt
distinct x    distinct[x]
```

Where `x` is a list returns the distinct (unique) items of `x` in the order of their first occurrence.
The result does _not_ have the [unique attribute](set-attribute.md) set. 

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


## Errors

error | cause
------|----------------
rank  | `x` is an atom


----

:fontawesome-solid-book:
[`.Q.fu`](dotq.md#qfu-apply-unique) (apply unique)
<br>
:fontawesome-solid-book-open:
[Precision](../basics/precision.md), 
[Search](../basics/by-topic.md#search) 