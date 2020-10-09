---
title: prd, prds – product and running products | Reference | kdb+ and q documentation
description: prd and prds are q keywords that return respectively the product and the cumulating products of their arguments.
author: Stephen Taylor
---
# `prd`, `prds`

_Product/s_





## `prd`

_Product_

```txt
prd x    prd[x]
```

Where `x` is a numeric list, returns its product.

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
q)prd 101b
0b
q)prd "abc"
'type
```

`prd` is an aggregate function, equivalent to `*/`.


## `prds`

_Products_

```txt
prds x    prds[x]
```

Where `x` is a numeric list, returns the cumulative products of its items. 

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

`prds` is a uniform function, equivalent to `*\`.


## :fontawesome-solid-sitemap: Implicit iteration

`prd` and `prds` apply to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).

```q
q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 21 3;4 5 6)

q)d
a| 10 21 3
b| 4  5  6
q)t
a  b
----
10 4
21 5
3  6
q)k
k  | a  b
---| ----
abc| 10 4
def| 21 5
ghi| 3  6

q)prd d
40 105 18
q)prds d
a| 10 21  3
b| 40 105 18

q)prd t
a| 630
b| 120
q)prds t
a   b
-------
10  4
210 20
630 120

q)prd k
a| 630
b| 120
q)prds k
k  | a   b
---| -------
abc| 10  4
def| 210 20
ghi| 630 120
```

----

:fontawesome-solid-book:
[Multiply](multiply.md)
<br>
:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)
