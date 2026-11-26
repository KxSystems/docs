---
title: ratios between successive items of a list | Reference | kdb+ and q documentation
description: ratios is a q keyword that returns the ratios between successive items of a list.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `ratios`

_Ratios between items_

```syntax
ratios y     ratios[y]
```

Where `y` is a numeric or temporal list, returns the ratios of the underlying values of consecutive pairs of items of `y`, as floats.

`ratios` is a uniform function.

The following queries calculate returns on prices:

```q
update ret:ratios price by sym from trade
select log ratios price from trade
```

## Implicit iteration

`ratios` applies to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).

```q
q)kt:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 21 3;4 5 6)

q)ratios d
a| 10  21        3
b| 0.4 0.2380952 2

q)ratios t
a         b
--------------
10        4
2.1       1.25
0.1428571 1.2

q)ratios kt
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

You might prefer 1 as the first item of the result.

```q
q)ratios0:{first[x]%':x}
q)ratios0 2000 2005 2007 2012 2020
1 1.0025 1.000998 1.002491 1.003976
```

!!! warning "Divide Each Prior"

    `ratios` is defined with the derived function `%':` (Divide Each Prior), which is variadic: you can apply it as either a unary or a binary.

    However, you can apply `ratios` only as a unary function.
    For binary application, use the derived function.

    ```q
    q)2 ratios 3 4
    'type
      [0]  2 ratios 3 4
           ^
    q)2%':3 4
    1.5 1.333333
    ```

----

[Each Prior](maps.md#each-prior),
[`deltas`](deltas.md),
[`differ`](differ.md),
[Divide](divide.md),
[`signum`](signum.md)
<br>

[Mathematics](../basics/math.md)
