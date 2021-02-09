---
title: avg, avgs, mavg, wavg – average, running average, moving averages, weighted average | Reference | kdb+ and q documentation
description: avg and wavg are q keywords invoking aggregate functions for the arithmetic and weighted means of a vector. avgs and mavgs are q keywords that invoke uniform functions that return the cumulative and moving means of a vector
author: Stephen Taylor
---
# `avg`, `avgs`, `mavg`, `wavg`


_Averages_



## `avg` 

_Arithmetic mean_

```txt
avg x     avg[x]
```

Where `x` is a numeric or temporal list,
returns the arithmetic mean as a float.

The mean of an atom is its value as a float.
Null is returned if `x` is empty, or contains both positive and negative infinity. Where `x` is a vector null items are ignored.

```q
q)avg 1 2 3
2f
q)avg 1 0n 2 3       / vector: null items are ignored
2f
q)avg (1 2;0N 4)     / nested: null items are preserved
0n 3
q)avg 1.0 0w
0w
q)avg -0w 0w
0n
q)avg 101b
0.6666667
q)avg 1b
1f
q)\l trade.q
q)show select ap:avg price by sym from trade
sym| ap
---| -----
a  | 10.75
```

`avg` is an aggregate function, equivalent to `{sum[x]%count x}`.



## `avgs`

_Running averages_

```txt
avgs x     avgs[x]
```

Where `x` is a numeric or temporal list,
returns the running averages, i.e. applies function `avg` to successive prefixes of `x`.

```q
q)avgs 1 2 3 0n 4 -0w 0w
1 1.5 2 2 2.5 -0w 0n
```

`avgs` is a uniform function, equivalent to `(avg\)`.


## `mavg`

_Moving averages_

```txt
x mavg y     mavg[x;y]
```

Where

-   `x` is a positive int atom (not infinite)
-   `y` is a numeric list

returns the `x`-item [simple moving averages](https://en.wikipedia.org/wiki/Moving_average#Simple_moving_average) of `y`, with any nulls after the first item replaced by zero. The first `x` items of the result are the averages of the terms so far, and thereafter the result is the moving average. The result is floating point.

```q
q)2 mavg 1 2 3 5 7 10
1 1.5 2.5 4 6 8.5
q)5 mavg 1 2 3 5 7 10
1 1.5 2 2.75 3.6 5.4
q)5 mavg 0N 2 0N 5 7 0N    / nulls after the first are replaced by 0
0n 2 2 3.5 4.666667 4.666667
```

`mavg` is a uniform function.


## `wavg`

_Weighted average_

```txt
x wavg y     wavg[x;y]
```

Where

-   `x` is a numeric list
-   `y` is a numeric list

returns the average of numeric list `y` weighted by numeric list `x`. The result is a float atom. 

```q
q)2 3 4 wavg 1 2 4
2.666667
q)2 0N 4 5 wavg 1 2 0N 8  / nulls in either argument ignored
6f
```

Where `x` and `y` conform, the result has an atom for each sublist.

```q
q)(1 2;3 4) wavg (500 400; 300 200)
350 266.6667
```

The financial analytic known as VWAP (volume-weighted average price) is a weighted average.

```q
q)select size wavg price by sym from trade
sym| price
---| -----
a  | 10.75
```

`wavg` is an aggregate function, equivalent to `{(sum x*y)%sum x}`.


## :fontawesome-solid-sitemap: Implicit iteration

`avg`, `avgs`, and `mavg` apply to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).
`wavg` applies to dictionaries. 

```q
q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 21 3;4 5 6)

q)avg d
7 13 4.5
q)avg t
a| 11.33333
b| 5
q)avg k
a| 11.33333
b| 5

q)avgs t
a        b
------------
10       4
15.5     4.5
11.33333 5

q)2 mavg k
k  | a    b
---| --------
abc| 10   4
def| 15.5 4.5
ghi| 12   5.5

q)1 2 wavg d
6 10.33333 5
```


----
:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)
<br>
:fontawesome-brands-wikipedia-w:
[Weighted average mean](https://en.wikipedia.org/wiki/Weighted_arithmetic_mean "Wikipedia")
<br>
:fontawesome-brands-wikipedia-w:
[Volume-weighted average price (VWAP)](https://en.wikipedia.org/wiki/Volume-weighted_average_price "Wikipedia")


