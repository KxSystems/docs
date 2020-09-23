---
title: over, scan – wrappers for the Over and Scan accumulating iterators | Reference | kdb+ and q documentation
description: over and scan are q keywords that are wrappers for the Over and Scan accumulating iterators.
author: Stephen Taylor
date: March 2019
---
# `over`, `scan`




The keywords `over` and `scan` are covers for the accumulating iterators, [Over and Scan](accumulators.md).
It is good style to use `over` and `scan` with unary and binary values.

Just as with Over and Scan, `over` and `scan` share the same syntax and perform the same computation; but while `scan` returns the result of each evaluation, `over` returns only the last.

See the [Accumulators](accumulators.md) for a more detailed discussion.


## Converge

```txt
 v1 over x    over[v1;x]        v1 scan x    scan[v1;x]
(vv)over x    over[vv;x]       (vv)scan x    scan[vv;x]
```

Where

-   `v1` is a unary [applicable value](../basics/glossary.md#applicable-value)
-   `vv` is a [variadic](../basics/variadic.md) applicable value

applies the value progressively to `x`, then to `v1[x]` (or `vv[x]`), and so on, until the result matches (within [comparison tolerance](../basics/precision.md#comparison-tolerance)) either

-   the previous result; or
-   `x`.

```q
q)n:("the ";("quick ";"brown ";("fox ";"jumps ";"over ");"the ");("lazy ";"dog."))
q)raze over n
"the quick brown fox jumps over the lazy dog."
q)(,/)over n
"the quick brown fox jumps over the lazy dog."
q){x*x} scan .01
0.01 0.0001 1e-08 1e-16 1e-32 1e-64 1e-128 1e-256 0
```

See the [Accumulators](accumulators.md) for more detail,
and for the related forms Do and While.



## MapReduce, Fold

```txt
v2 over x   over[v2;x]        v2 scan x   scan[v2;x]
```

Where `v2` is a binary [applicable value](../basics/glossary.md#applicable-value), applies `v2` progressively between successive items.

`scan[v2;]` is a [uniform function](../basics/glossary.md#uniform-function) and `over[v2;]` is an [aggregate function](../basics/glossary.md#aggregate-function).

```q
q)(+) scan 1 2 3 4 5
1 3 6 10 15
q)(*) over 1 2 3 4 5
120
```

See the [Accumulators](accumulators.md) for a more detailed discussion.


## Keywords

Q has keywords for common projections of `scan` and `over`.
For example, `sums` is `scan[+;]` and `prd` is `over[*;]`.

Good q style prefers these keywords;
i.e. `prd` rather than `over[*;]` or `*/`.

```txt
keyword  equivalents
---------------------------------------
all      over[and;]   &/  Minimum Over
any      over[or;]    |/  Maximum Over
max      over[|;]     |/  Maximum Over
maxs     scan[|;]     |\  Maximum Scan
min      over[&;]     &/  Minimum Over
mins     scan[&;]     &\  Minimum Scan
prd      over[*;]     */  Multiply Over
prds     scan[*;]     *\  Multiply Scan
raze     over[,;]     ,/  Join Over
sum      over[+;]     +/  Add Over
sums     scan[+;]     +\  Add Scan
```


----
:fontawesome-solid-book:
[Accumulators](accumulators.md)
