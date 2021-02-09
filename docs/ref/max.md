---
title: Maximums | Reference | kdb+ and q documentation
description: max, maxs, and mmax are q keywords that return respectively the largest item from a list or dictionary, the cumulative maximums, and the moving maximums.
author: Stephen Taylor
---
# `max`, `maxs`, `mmax`





## `max`

_Maximum_

```txt
max x    max[x]
```

Where `x` is a non-symbol sortable list, returns the maximum of its items.
The maximum of an atom is itself. 

Nulls are ignored, except that if the items of `x` are all nulls, the result is negative infinity.

```q
q)max 2 5 7 1 3
7
q)max "genie"
"n"
q)max 0N 5 0N 1 3                  / nulls are ignored
5
q)max 0N 0N                        / negative infinity if all null
-0W
q)select max price by sym from t   / use in a select statement
```

`max` is an aggregate function. It is equivalent to `|/`.



## `maxs`

_Maximums_

```txt
maxs x    maxs[x]
```

Where `x` is a non-symbol sortable list, returns the running maximums of its prefixes. 

Nulls are ignored, except that initial nulls are returned as negative infinity.

```q
q)maxs 2 5 7 1 3
2 5 7 7 7
q)maxs "genie"
"ggnnn"
q)maxs 0N 5 0N 1 3         / initial nulls return negative infinity
-0W 5 5 5 5
```

`maxs` is a uniform function. It is equivalent to `|\`.


## `mmax`

_Moving maximums_

```txt
x mmax y    mmax[x;y]
```

Where

-   `x` is a positive int atom
-   `y` is a non-symbol sortable list

returns the `x`-item moving maximums of `y`, with nulls after the first replaced by the preceding maximum. The first `x` items of the result are the maximums of the items so far, and thereafter the result is the moving maximum.

```q
q)3 mmax 2 7 1 3 5 2 8
2 7 7 7 5 5 8
q)3 mmax 0N -3 -2 0N 1 0  / initial null returns negative infinity
-0W -3 -2 -2 1 1          / remaining nulls replaced by preceding max
```

`mmax` is a uniform function.


## :fontawesome-solid-sitemap: Implicit iteration

`max`, `maxs`, and `mmax` apply to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).

```q
q)max`a`b!(10 21 3;4 5 6)
10 21 6
q)max flip`a`b!(10 21 3;4 5 6)
a| 21
b| 6

q)maxs`a`b!(10 21 3;4 5 6)
a| 10 21 3
b| 10 21 6
q)maxs flip`a`b!(10 21 3;4 5 6)
a  b
----
10 4
21 5
21 6

q)2 mmax flip`a`b!(10 21 3;4 5 6)
a  b
----
10 4
21 5
21 6
q)2 mmax`a`b!(10 21 3;4 5 6)
a| 10 21 3
b| 10 21 6

q)2 mmax ([k:`abc`def`ghi]a:10 21 3;b:4 5 6)
k  | a  b
---| ----
abc| 10 4
def| 21 5
ghi| 21 6
```


## Aggregating nulls

`avg`, `min`, `max` and `sum` are special: they ignore nulls, in order to be similar to SQL92.
But for nested `x` these functions preserve the nulls.

```q
q)max (1 2;0N 4)
1 4
```


----
:fontawesome-solid-book:
[Greater Than](greater-than.md)
<br>
:fontawesome-solid-book-open:
[Comparison](../basics/comparison.md),
[Mathematics](../basics/math.md)
<br>
:fontawesome-solid-graduation-cap:
[Sliding windows](../kb/programming-idioms.md#how-do-i-apply-a-function-to-a-sequence-sliding-window)

