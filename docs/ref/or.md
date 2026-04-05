---
title: or – Reference – kdb+ and q documentation
description: or is a q keyword that performs a logical OR.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: and, greater, kdb+, logic, or, q
---
# `or`

_Greater of two values, logical OR_

```syntax
x or y    or[x;y]
x | y     |[x;y]
```

Returns the [greater](../basics/comparison.md) of the underlying values of `x` and `y`.
In the case of boolean values, it is equivalent to the OR operator.

```q
q)2 or 3
3
q)1010b or 1100b  /logical OR with booleans
1110b
q)"sat" or "cow"
"sow"
```

`or` is a [multithreaded primitive](../kb/mt-primitives.md).

:fontawesome-solid-book:
[Greater](greater.md)


