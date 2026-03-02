---
title: avg, avgs, mavg, wavg – average, running average, moving averages, weighted average | Reference | kdb+ and q documentation
description: avg and wavg are q keywords invoking aggregate functions for the arithmetic and weighted means of a vector. avgs and mavgs are q keywords that invoke uniform functions that return the cumulative and moving means of a vector
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `avg`, `avgs`, `mavg`, `wavg`

_Averages_

## `avg`

_Arithmetic mean_

```syntax
avg x     avg[x]
```

Where `x` is a numeric or temporal list,
returns the arithmetic mean as a float.

The mean of an atom is its value as a float.
Null is returned if `x` is empty, or contains both positive and negative infinity.

- If `x` is a vector, null items are ignored.
- If `x` is a mixed list, null items are treated as zero.
- If `x` is a nested list, null items make the average null.

```q
q)avg 1 2 3
2f
q)avg 1 0w
0w
q)avg -0w 0w
0n
q)avg 1 0n 2 3        / note: this is a float vector!
2f
q)avg (1;0n;2;3)
1.5
q)avg (1 2;0N 4)
0n 3
q)avg 101b
0.6666667
q)avg 1b
1f
q)avg ([]a:3 5; b:6 8f)
a| 4
b| 7
```

`avg` is an aggregate function, equivalent to `{sum[x]%count x}`.

```txt
domain: B G X H I J E F C S P M D Z N U V T
range:  f . f f f f f f f . f f f f f f f f
```

`avg` is a [multithreaded primitive](mt-primitives.md).

## `avgs`

_Running averages_

```syntax
avgs x     avgs[x]
```

Where `x` is a numeric or temporal list,
returns the running averages, i.e. applies function `avg` to successive prefixes of `x`.

```q
q)avgs 1 2 3 0n 4 -0w 0w
1 1.5 2 2 2.5 -0w 0n
```

`avgs` is a uniform function, equivalent to `(avg\)`.

```txt
domain: B G X H I J E F C S P M D Z N U V T
range:  F . F F F F F F . . F F F F F F F F
```

## `mavg`

_Moving averages_

```syntax
x mavg y     mavg[x;y]
```

Where

- `x` is a positive int atom (not infinite)
- `y` is a numeric list

returns the `x`-item [simple moving averages](https://en.wikipedia.org/wiki/Moving_average#Simple_moving_average) of `y`, with any nulls replaced by zero. The first `x` items of the result are the averages of the terms so far, and thereafter the result is the moving average. The result is of type float. If the first item of `y` is null, the first item of the result will also be null (instead of zero).

```q
q)2 mavg 1 2 3 5 7 10
1 1.5 2.5 4 6 8.5
q)5 mavg 1 2 3 5 7 10
1 1.5 2 2.75 3.6 5.4
q)5 mavg 0N 2 0N 5 7 0N       / first item of the result is null
0n 2 2 3.5 4.666667 4.666667
q)0 mavg 2 3
0n 0n
```

`mavg` is a uniform function.

Domain and range:

```txt
    B G X H I J E F C S P M D Z N U V T
----------------------------------------
b | F . F F F F F F . . F F F F F F F F
g | . . . . . . . . . . . . . . . . . .
x | F . F F F F F F . . F F F F F F F F
h | F . F F F F F F . . F F F F F F F F
i | F . F F F F F F . . F F F F F F F F
j | F . F F F F F F . . F F F F F F F F
e | . . . . . . . . . . . . . . . . . .
f | . . . . . . . . . . . . . . . . . .
c | . . . . . . . . . . . . . . . . . .
s | . . . . . . . . . . . . . . . . . .
p | . . . . . . . . . . . . . . . . . .
m | . . . . . . . . . . . . . . . . . .
d | . . . . . . . . . . . . . . . . . .
z | . . . . . . . . . . . . . . . . . .
n | . . . . . . . . . . . . . . . . . .
u | . . . . . . . . . . . . . . . . . .
v | . . . . . . . . . . . . . . . . . .
t | . . . . . . . . . . . . . . . . . .
```

Range: `F`

## `wavg`

_Weighted average_

```syntax
x wavg y     wavg[x;y]
```

Where

- `x` is a numeric list
- `y` is a numeric list

returns the average of numeric list `y` weighted by numeric list `x`. The result is a float atom.

```q
q)2 3 4 wavg 1 2 4
2.666667
q)2 0N 4 5 wavg 1 2 0N 8  / nulls in either argument are ignored
6f
q)0 wavg 2 3
0n                        / since 4.1t 2021.09.03,4.0 2021.10.01, previously returned 2.5
q)0 wavg (1 2;3 4)
0n 0n                     / since 4.0/4.1 2024.07.08, previously returned 0n
```

IF `x` and `y` are conforming nested lists, the result has an atom for each sublist.

```q
q)(1 2;3 4) wavg (500 400; 300 200)
350 266.6667        / note: this is (1 3 wavg 500 300; 2 4 wavg 400 200)
```

The financial analytic known as VWAP (volume-weighted average price) is a weighted average.

```q
q)select size wavg price by sym from trade
sym| price
---| -----
a  | 10.75
```

`wavg` is an aggregate function, equivalent to `{(sum x*y)%sum x}`.
Domain and range:

```txt
    B G X H I J E F C S P M D Z N U V T
----------------------------------------
B | f . f f f f f f f . f f f f f f f f
G | . . . . . . . . . . . . . . . . . .
X | f . f f f f f f f . f f f f f f f f
H | f . f f f f f f f . f f f f f f f f
I | f . f f f f f f f . f f f f f f f f
J | f . f f f f f f f . f f f f f f f f
E | f . f f f f f f f . f f f f f f f f
F | f . f f f f f f f . f f f f f f f f
C | f . f f f f f f f . f f f f f f f f
S | . . . . . . . . . . . . . . . . . .
P | f . f f f f f f f . f f f f f f f f
M | f . f f f f f f f . f f f f f f f f
D | f . f f f f f f f . f f f f f f f f
Z | f . f f f f f f f . f f f f f f f f
N | f . f f f f f f f . f f f f f f f f
U | f . f f f f f f f . f f f f f f f f
V | f . f f f f f f f . f f f f f f f f
T | f . f f f f f f f . f f f f f f f f

```

Range: `f`

`wavg` is a [multithreaded primitive](mt-primitives.md).

## Implicit iteration

`avg`, `avgs`, and `mavg` apply to [dictionaries and tables](math.md#dictionaries-and-tables).
`wavg` applies to dictionaries.

```q
q)kt:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 21 3;4 5 6)

q)avg d
7 13 4.5
q)avg t
a| 11.33333
b| 5
q)avg kt
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

[Mathematics](math.md)
<br>

[Weighted average mean](https://en.wikipedia.org/wiki/Weighted_arithmetic_mean "Wikipedia")

[Volume-weighted average price (VWAP)](https://en.wikipedia.org/wiki/Volume-weighted_average_price "Wikipedia")
