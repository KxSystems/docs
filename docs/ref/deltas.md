---
title: deltas – differences between adjacent list items | Reference | kdb+ and q documentation
description: deltas is a q keyword that returns the differences between adjacent list items.
keywords: diff, difference, item, kdb+, list, q
---
# `deltas`

_Differences between adjacent list items_





```txt
deltas x    deltas[x]
```

Where `x` is a numeric or temporal vector, returns differences between consecutive pairs of its items.

```q
q)deltas 1 4 9 16
1 3 5 7
q)deltas 2000 2005 2007 2012 2020
2000 5 2 5 8
```

The predecessor of the first item is 0. 
It is often more convenient to have 0 as the first item of the result.

```q
q)deltas0:{first[x]-':x}
q)deltas0 2000 2005 2007 2012 2020
0 5 2 5 8
```

In a query to get price movements:

```q
q)update diff:deltas price by sym from trade
```

With [`signum`](signum.md) to count the number of up/down/same ticks:

```q
q)select count i by signum deltas price from trade
price| x
-----| ----
-1   | 247
0    | 3
1    | 252
```

!!! warning "Subtract Each Prior"

    The derived function `-':` (Subtract Each Prior) used to defined `deltas` is variadic and can be applied as either a unary or a binary.

    However, `deltas` is supported only as a unary function.
    For binary application, use the derived function.


----

:fontawesome-solid-book:
[Each-prior](maps.md#each-prior), [`differ`](differ.md), [`ratios`](ratios.md)


