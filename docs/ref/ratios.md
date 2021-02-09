---
title: ratios between successive items of a list | Reference | kdb+ and q documentation
description: ratios is a q keyword that returns the ratios between successive items of a list.
author: Stephen Taylor
---
# `ratios`






_Ratios between items_

```txt
ratios y     ratios[y]
```

Where `y` is a non-symbolic sortable list, returns the ratios of the underlying values of consecutive pairs of items of `y`.

`ratios` is an aggregate function.

Examples: queries to get returns on prices:

```q
update ret:ratios price by sym from trade
select log ratios price from trade
```

In a query to get price movements:

```q
update diff:deltas price by sym from trade
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


## :fontawesome-solid-sitemap: Implicit iteration

`ratios` applies to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).

```q
q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 21 3;4 5 6)

q)ratios d
a| 10  21        3
b| 0.4 0.2380952 2

q)ratios t
a         b
--------------
10        4
2.1       1.25
0.1428571 1.2

q)ratios k
k  | a         b
---| --------------
abc| 10        4
def| 2.1       1.25
ghi| 0.1428571 1.2
```

## First predecessor

The predecessor of the first item is 1. 

```q
q)ratios 2000 2005 2007 2012 2020
2000 1.0025 1.000998 1.002491 1.003976
```

It may be more convenient to have 1 as the first item of the result.

```q
q)ratios0:{first[x]%':x}
q)ratios0 2000 2005 2007 2012 2020
1 1.0025 1.000998 1.002491 1.003976
```

!!! warning "Subtract Each Divide"

    The derived function `%':` (Divide Each Prior) used to define `ratios` is variadic and can be applied as either a unary or a binary.

    However, `ratios` is supported only as a unary function.
    For binary application, use the derived function.




----
:fontawesome-solid-book:
[Each Prior](maps.md#each-prior),
[`differ`](differ.md),
[Divide](divide.md)
<br>
:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)


