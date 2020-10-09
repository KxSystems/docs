---
title: sum, sums, msum, wsum – sum, cumulative sums, moving sums, and weighted sum of a list | Reference | kdb+ and q documentation
description: sum, sums, msum, and wsum are q keywords athat return (respectively) the sum, cumulative sums, moving sums, and weighted sum of their argument.
author: Stephen Taylor
---
# `sum`, `sums`, `msum`, `wsum`

_Totals – simple, running, moving, and weighted_




## `sum`

_Total_

```txt
sum x    sum[x]
```

Where `x` is

-   a simple numeric list, returns the sums of its items
-   an atom, returns `x`
-   a list of numeric lists, returns their sums
-   a dictionary with numeric values

Nulls are treated as zeros.

```q
q)sum 7                         / sum atom (returned unchanged)
7
q)sum 2 3 5 7                   / sum list
17
q)sum 2 3 0N 7                  / 0N is treated as 0
12
q)sum (1 2 3 4;2 3 5 7)         / sum list of lists
3 5 8 11                        / same as 1 2 3 4 + 2 3 5 7
q)sum `a`b`c!1 2 3
6
q)\l sp.q
q)select sum qty by s from sp   / use in select statement
s | qty
--| ----
s1| 1600
s2| 700
s3| 200
s4| 600
q)sum "abc"                     / type error if list is not numeric
'type
q)sum (0n 8;8 0n) / n.b. sum list of vectors does not ignore nulls
0n 0n
q)sum 0n 8 / the vector case was modified to match sql92 (ignore nulls)
8f
q)sum each flip(0n 8;8 0n) /do this to fall back to vector case
8 8f
```

`sum` is an aggregate function, equivalent to `+/`.


## `sums`

_Running totals_

```txt
sums x    sums[x]
```

Where `x` is a numeric or temporal list, returns the cumulative sums of the items of `x`.

The sum of an atom is itself. Nulls are treated as zeros.

```q
q)sums 7                        / cumulative sum atom (returned unchanged)
7
q)sums 2 3 5 7                  / cumulative sum list
2 5 10 17
q)sums 2 3 0N 7                 / 0N is treated as 0
2 5 5 12
q)sums (1 2 3;2 3 5)            / cumulative sum list of lists
1 2 3                           / same as (1 2 3;1 2 3 + 2 3 5)
3 5 8
q)\l sp.q
q)select sums qty by s from sp  / use in select statement
s | qty
--| --------------------------
s1| 300 500 900 1100 1200 1600
s2| 300 700
s3| ,200
s4| 100 300 600
q)sums "abc"                    / type error if list is not numeric
'type
```

`sums` is a uniform function, equivalent to `+\`.



## `msum`

_Moving sums_

```txt
x msum y    msum[x;y]
```

Where

-  `x` is a positive int atom
-  `y` is a numeric list

returns the `x`-item moving sums of `y`, with nulls replaced by zero. The first `x` items of the result are the sums of the terms so far, and thereafter the result is the moving sum.

```q
q)3 msum 1 2 3 5 7 11
1 3 6 10 15 23
q)3 msum 0N 2 3 5 0N 11     / nulls treated as zero
0 2 5 10 8 16
```

`msum` is a uniform function.


## `wsum`

_Weighted sum_

```txt
x wsum y    wsum[x;y]
```

Where `x` and `y` are numeric lists, returns the weighted sum of the products of `x` and `y`. When both `x` and `y` are integer lists, they are first converted to floats. 

```q
q)2 3 4 wsum 1 2 4   / equivalent to sum 2 3 4 * 1 2 4f
24f

q)2 wsum 1 2 4       / equivalent to sum 2 * 1 2 4
14

q)(1 2;3 4) wsum (500 400;300 200)
1400 1600
```

`wsum` is an aggregate function, equivalent to `{sum x*y}`.

:fontawesome-solid-graduation-cap:
[Sliding windows](../kb/programming-idioms.md#how-do-i-apply-a-function-to-a-sequence-sliding-window)
<br>
:fontawesome-brands-wikipedia-w:
[Weighted sum](https://en.wikipedia.org/wiki/Weight_function "Wikipedia")


## :fontawesome-solid-sitemap: Implicit iteration

`sum`, `sums`, and `msum` apply to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).
`wsum` applies to dictionaries.

```q
q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 21 3;4 5 6)

q)sum d
14 26 9
q)sum t
a| 34
b| 15
q)sum k
a| 34
b| 15

q)sums d
a| 10 21 3
b| 14 26 9

q)2 msum t
a  b
-----
10 4
31 9
24 11

q)1 2 wsum d
18 31 15
```


## Aggregating nulls

`avg`, `min`, `max` and `sum` are special: they ignore nulls, in order to be similar to SQL92.
But for nested `x` these functions preserve the nulls.

```q
q)sum (1 2;0N 4)
0N 6
```

----
:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)
