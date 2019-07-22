---
title: prd, prds
description: prd and prds are q keywords that return respectively the product and the cumulating products of their arguments.
author: Stephen Taylor
keywords: aggregate, kdb+, multiply, product, products, q, statistics, uniform
---
# `prd`, `prds`

_Product/s_





## `prd`

_Product_

Syntax: `prd x`, `prd[x]` (aggregate)

Product: where `x` is

-   a simple numeric list, returns the product of the items of `x`
-   an atom, returns `x`
-   a list of numeric lists, returns their products

Nulls are treated as 1s.

```q
q)prd 7                    / product of atom (returned unchanged)
7
q)prd 2 3 5 7              / product of list
210
q)prd 2 3 0N 7             / 0N is treated as 1
42
q)prd (1 2 3 4;2 3 5 7)    / product of list of lists
2 6 15 28
q)prd "abc"
'type
```

`prd` is an aggregate function.


## `prds`

_Products_

Syntax: `prds x`, `prds[x]`

Where `x` is a numeric list, returns the cumulative products of its items. The product of an atom is itself. Nulls are treated as 1s.

```q
q)prds 7                     / atom is returned unchanged
7
q)prds 2 3 5 7               / cumulative products of list
2 6 30 210
q)prds 2 3 0N 7              / 0N is treated as 1
2 6 6 42
q)prds (1 2 3;2 3 5)         / cumulative products of list of lists
1 2 3                        / same as (1 2 3;1 2 3 * 2 3 5)
2 6 15
q)prds "abc"                 / type error if list is not numeric
'type
```

`prds` is a uniform function. 

<i class="far fa-hand-point-right"></i> 
Basics: [Mathematics](../basics/math.md)
