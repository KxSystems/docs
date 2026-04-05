---
title: and – Reference – kdb+ and q documentation
description: and is a q keyword that returns the logical AND of its flag arguments
author: Stephen Taylor
---

# `and`

_Lesser of two values, logical AND_

```syntax
x and y       and[x;y]
x & y         &[x;y]
```

Returns the [lesser](../basics/comparison.md) of the underlying values of `x` and `y`.
In the case of boolean values, it is equivalent to the AND operator.

```q
q)2 and 3
2
q)1010b and 1100b  /logical AND with booleans
1000b
q)"sat" and "cow"
"cat"
```

`and` is a [multithreaded primitive](../kb/mt-primitives.md).

:fontawesome-solid-book: 
[Lesser](lesser.md)


