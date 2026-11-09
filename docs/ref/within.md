---
title: within tests whether one argument is within the bounds defined by the other | Reference | kdb+ and q documentation
description: within is a q keyword that tests whether one argument is within the bounds defined by the other.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `within`

_Check bounds_

```syntax
x within y    within[x;y]
```

Where

- `x` is an atom or list of sortable types
- `y` is a pair of lower and upper bounds, or a pair of lists of lower and upper bounds that conform to `x`

returns a boolean for each item of `x` indicating whether it is within the inclusive bounds given by `y`.

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
q)5 within 5 5           / bounds are inclusive
1b
q)5 within 6 2           / lower bound greater than upper bound
0b
```

The result conforms to `x` and to the items of `y`.

```q
q)5 within (1 2 6;3 5 7)
010b
q)2 5 6 within (1 2 6;3 5 7)
111b
q)(1 3 10 6 4;"acyxmpu") within ((2;"b");(6;"r"))
01011b
0100110b
```

`within` is a [multithreaded primitive](../kb/mt-primitives.md).

----

[`except`](except.md),
[`in`](in.md),
[`inter`](inter.md),
[`union`](union.md)
<br>

[Search](../basics/by-topic.md#search)
