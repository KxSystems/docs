---
title: distinct – unique items of a list | Reference | kdb+ and q documentation
description: distinct is a q keyword that returns the nub (the unique items) of a list.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `distinct`

_Unique items of a list_

```syntax
distinct x    distinct[x]
```

Where `x` is a list, returns the distinct (unique) items of `x` in the order of their first occurrence.
The result does _not_ have the [unique attribute](set-attribute.md) set.

```q
q)distinct 2 3 7 3 5 3
2 3 7 5
```

For a table, its distinct rows are returned.

```q
q)distinct flip `a`b`c!(1 2 1;2 3 2;"aba")
a b c
-----
1 2 a
2 3 b
```

It does not use [comparison tolerance](precision.md)

```q
q)\P 14
q)distinct 2 + 0f,10 xexp -13
2 2.0000000000001
```

`distinct` is a [multithreaded primitive](mt-primitives.md).

```txt
domain: B G X H I J E F C S P M D Z N U V T
range:  B G X H I J E F C S P M D Z N U V T
```

## Errors

error | cause
------|----------------
type  | `x` is an atom

----

[`.Q.fu`](dotq.md#fu-apply-unique) (apply unique)
<br>

[Precision](precision.md),
[Search](by-topic.md#search)
