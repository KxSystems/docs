---
title: til returns the first natural numbers | Reference | kdb+ and q documentation
description: til is a q keyword that returns the natural numbers up to its argument.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `til`

_First `x` natural numbers_

```syntax
til x    til[x]
```

Where `x` is a non-negative boolean, byte, short, int, or long atom, returns a vector of the first `x` natural numbers, starting from 0. A negative `x` signals a `domain` error.

```q
q)til 0
`long$()
q)til 1b
,0
q)til 5
0 1 2 3 4
q)til 5f
'type
  [0]  til 5f
       ^
```

`til` and [`key`](key.md) are synonyms, but by convention only `til` is used for this purpose.

`til` is a [multithreaded primitive](../kb/mt-primitives.md).

----

[Mathematics](../basics/math.md)
