---
title: cor – correlation coefficient | Reference | kdb+ and q documentation
description: cor is a q keyword that calculates the correlation coefficient of two numeric lists.
tags: correlation
---
# `cor`

_Correlation_

```syntax
x cor y    cor[x;y]
```

Where `x` and `y` are [conforming](../basics/conformable.md) numeric lists, returns their (Pearson) [correlation](https://en.wikipedia.org/wiki/Pearson_correlation_coefficient) as a float in the range `-1f` to `1f`. Nulls (along with their pairs) are ignored.

```q
q)29 10 54 cor 1 3 9
0.7727746
q)10 29 54 cor 1 3 9
0.9795734
q)1 3 9 cor 1 3 9
1f
q)1 3 9 cor neg 1 3 9
-1f
q)1 3 1 3 cor 1 1 3 3
0f
q)1 1 1 cor 1 3 9
0n
q)1 3 0N cor 1 3 9                  /nulls are ignored
1f

q)1000101000b cor 0010011001b
-0.08908708
```

`cor` is an aggregate function, equivalent to `{cov[x;y]%dev[x]*dev y}`.

`cor` is a [multithreaded primitive](../kb/mt-primitives.md).

## Domain and range

```txt
    B G X H I J E F C S P M D Z N U V T
----------------------------------------
B | f . f f f f f f f . f f f f f f f f
G | . . . . . . . . . . . . . . . . . .
X | f . f f f f f f f . f f f f f f f f
H | f . f f f f f f f . f f f f f f f f
I | f . f f f f f f f . f f f f f f f f
J | f . f f f f f f f . f f f f f f f f
E | f . f f f f f f f . f f f f f f f f
F | f . f f f f f f f . f f f f f f f f
C | f . f f f f f f f . f f f f f f f f
S | . . . . . . . . . . . . . . . . . .
P | f . f f f f f f f . f f f f f f f f
M | f . f f f f f f f . f f f f f f f f
D | f . f f f f f f f . f f f f f f f f
Z | f . f f f f f f f . f f f f f f f f
N | f . f f f f f f f . f f f f f f f f
U | f . f f f f f f f . f f f f f f f f
V | f . f f f f f f f . f f f f f f f f
T | f . f f f f f f f . f f f f f f f f
```

Range: `f`

----

[Mathematics](../basics/math.md)
