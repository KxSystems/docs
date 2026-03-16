---
title: deltas – differences between adjacent list items | Reference | kdb+ and q documentation
description: deltas is a q keyword that returns the differences between adjacent list items.
keywords: diff, difference, item, kdb+, list, q
---
# `deltas`

_Differences between adjacent list items_

```syntax
deltas x    deltas[x]
```

Where `x` is a numeric or temporal vector, returns differences between consecutive pairs of its items, with the first item of the result being the first item of `x`.

```q
q)deltas 1 4 9 16
1 3 5 7
q)t:([]time:2020.01.01D09:00:00+1000*til 6; sym:`GOOG`AAPL`AAPL`GOOG`AAPL`GOOG; price:51 54 54 52 53 53)
q)show t:update diff:deltas price by sym from t
time                          sym  price diff
---------------------------------------------
2020.01.01D09:00:00.000000000 GOOG 51    51
2020.01.01D09:00:00.000001000 AAPL 54    54
2020.01.01D09:00:00.000002000 AAPL 54    0
2020.01.01D09:00:00.000003000 GOOG 52    1
2020.01.01D09:00:00.000004000 AAPL 53    -1
2020.01.01D09:00:00.000005000 GOOG 53    1
```

Use with [`signum`](signum.md) to count the number of up/down/same ticks:

```q
q)/ The sign of the price movements
q)select movement:signum deltas price by sym from t
sym | movement
----| --------
AAPL| 1 0 -1
GOOG| 1 1 1

q)/ It always starts with 1, so we will drop that
q)select movement:1_ signum deltas price by sym from t
sym | movement
----| --------
AAPL| 0 -1
GOOG| 1 1

q)/ Ungroup so we can do a second query more easily
q)ungroup select movement:1_ signum deltas price by sym from t
sym  movement
-------------
AAPL 0
AAPL -1
GOOG 1
GOOG 1
q)select count i by sym, movement from ungroup select movement:1_ signum deltas price by sym from t
sym  movement| x
-------------| -
AAPL -1      | 1
AAPL 0       | 1
GOOG 1       | 2
```

```txt
domain: B G X H I J E F C S P M D Z N U V T
range:  i . i i i j e f . . n i i f n u v t
```

## First predecessor

The predecessor of the first item is 0.

```q
q)deltas 2000 2005 2007 2012 2020
2000 5 2 5 8
```

It may be more convenient to have 0 as the first item of the result.

```q
q)deltas0:{first[x]-':x}
q)deltas0 2000 2005 2007 2012 2020
0 5 2 5 8
```

!!! warning "Subtract Each Prior"

    The derived function `-':` (Subtract Each Prior) used to define `deltas` is variadic and can be applied as either a unary or a binary.

    However, `deltas` is supported only as a unary function.
    For binary application, use the derived function.

----

[`deltas`](deltas.md),
[`differ`](differ.md),
[Each Prior](maps.md#each-prior),
[`ratios`](ratios.md)
