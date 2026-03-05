---
title: abs – absolute value | Reference | kdb+ and q documentation
description: abs is a q keyword that returns the absolute value of its argument
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `abs`

_Absolute value_

```syntax
abs x    abs[x]
```

Where `x` is a numeric, returns
the absolute value of `x`.
`x` is returned if `x` is null.
`abs` also works with temporal values, where it operates on the underlying numeric (refer to the examples below).

```q
q)abs -1.0
1f
q)abs 10 -43 0N
10 43 0N
q)abs 1999.01.01
2000.12.31
// if we convert these to longs, we can observe they're opposite
q)"j"$1999.01.01 2000.12.31 
-365 365
```

`abs` is a [multithreaded primitive](../kb/mt-primitives.md).

## Implicit iteration

`abs` is an [atomic function](../basics/atomic.md).

```q
q)abs(10;20 -30)
10
20 30
```

It applies to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).

## Domain and range

```txt
domain b g x h i j e f c s p m d z n u v t
range  i . i h i j e f i . p m d z n u v t
```

Range: `ihjefpmdznuvt`

----

[`signum`](signum.md)
<br>

[Mathematics](../basics/math.md)
