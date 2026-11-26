---
title: sum, sums, msum, wsum – sum, cumulative sums, moving sums, and weighted sum of a list | Reference | kdb+ and q documentation
description: sum, sums, msum, and wsum are q keywords that return (respectively) the sum, cumulative sums, moving sums, and weighted sum of their argument.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `sum`, `sums`, `msum`, `wsum`

_Totals: simple, running, moving, and weighted_

## `sum`

_Total_

```syntax
sum x    sum[x]
```

Where `x` is

- a simple numeric list, returns the sum of its items
- an atom, returns `x`
- a list of numeric lists, returns their sum (item-wise)
- a dictionary with numeric values, returns the sum of its values

`sum` treats nulls in a vector as zeros. For a list of lists, nulls are preserved; see [Aggregating nulls](#aggregating-nulls).

```q
q)sum 7                         / sum atom (returned unchanged)
7
q)sum 2 3 5 7                   / sum list
17
q)sum 2 3 0N 7                  / 0N is treated as 0
12
q)sum (1 2 3 4;2 3 5 7)         / sum list of lists: same as 1 2 3 4 + 2 3 5 7
3 5 8 11
q)sum `a`b`c!1 2 3
6
q)sp:([]s:`s1`s1`s2`s3`s1`s2;qty:300 200 400 200 100 300)
q)select sum qty by s from sp   / use in select statement
s | qty
--| ---
s1| 600
s2| 700
s3| 200
q)sum "abc"                     / chars are summed as their codes
294i
q)sum (0n 8;8 0n)               / sum of a list of vectors does not ignore nulls
0n 0n
q)sum 0n 8                      / sum of a vector ignores nulls, as in SQL-92
8f
q)sum each flip(0n 8;8 0n)      / to ignore nulls, sum each vector
8 8f
```

`sum` is an aggregate function, equivalent to `+/`.

!!! warning "Floating-point addition is not associative"

    Changing the order of the summation can change the result.

        ❯ q -s 4
        ...

        q)\s 0
        q)a:100000000?1.
        q)\P 0
        q)sum a
        49999897.181930684
        q)sum reverse a
        49999897.181931004

    The order of summation changes when the primitive can use threads.

        q)\s 4
        q)sum a
        49999897.181933172

`sum` is a [multithreaded primitive](../kb/mt-primitives.md).

## `sums`

_Running totals_

```syntax
sums x    sums[x]
```

Where `x` is a numeric or temporal list, returns the cumulative sums of the items of `x`.

The sum of an atom is itself. `sums` treats nulls as zeros.

```q
q)sums 7                        / cumulative sum atom (returned unchanged)
7
q)sums 2 3 5 7                  / cumulative sum list
2 5 10 17
q)sums 2 3 0N 7                 / 0N is treated as 0
2 5 5 12
q)sums (1 2 3;2 3 5)            / same as (1 2 3;1 2 3 + 2 3 5)
1 2 3
3 5 8
q)sp:([]s:`s1`s1`s2`s3`s1`s2;qty:300 200 400 200 100 300)
q)select sums qty by s from sp  / use in select statement
s | qty
--| -----------
s1| 300 500 600
s2| 400 700
s3| ,200
q)sums "abc"                    / type error if list is not numeric
'type
  [0]  sums "abc"                    / type error if list is not numeric
       ^
```

`sums` is a uniform function, equivalent to `+\`.

## `msum`

_Moving sums_

```syntax
x msum y    msum[x;y]
```

Where

- `x` is a positive integer atom
- `y` is a numeric list

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

```syntax
x wsum y    wsum[x;y]
```

Where `x` and `y` are numeric lists, returns the sum of the products of `x` and `y`. When both `x` and `y` are vectors, the result is a float, except that a long vector with a boolean vector returns a long. Where `x` is an atom, the result has the type of `x*y`.

```q
q)2 3 4 wsum 1 2 4   / equivalent to sum 2 3 4 * 1 2 4f
24f

q)2 wsum 1 2 4       / equivalent to sum 2 * 1 2 4
14

q)(1 2;3 4) wsum (500 400;300 200)
1400 1600
```

`wsum` is an aggregate function, equivalent to `{sum x*y}`.

[Sliding windows](../kb/programming-idioms.md#how-do-i-apply-a-function-to-a-sequence-sliding-window)
<br>

[Weighted sum](https://en.wikipedia.org/wiki/Weight_function "Wikipedia")

## Implicit iteration

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

`avg`, `min`, `max`, and `sum` ignore nulls, as SQL-92 does.
For nested `x`, however, these functions preserve nulls.

```q
q)sum (1 2;0N 4)
0N 6
```

## Domains and ranges

`sum`

```txt
domain: B G X H I J E F C S P M D Z N U V T
range:  i . i i i j e f i . p m d z n u v t
```

`sums`

```txt
domain: B G X H I J E F C S P M D Z N U V T
range:  I . I I I J E F . . P M D Z N U V T
```

`msum`

```txt
    B G X H I J E F C S P M D Z N U V T
----------------------------------------
b | I . I I I J E F . . N I I F N U V T
g | . . . . . . . . . . . . . . . . . .
x | I . I I I J E F . . N I I F N U V T
h | I . I I I J E F . . N I I F N U V T
i | I . I I I J E F . . N I I F N U V T
j | I . I I I J E F . . N I I F N U V T
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

Range: `EFIJNTUV`

`wsum` where `x` and `y` are vectors

```txt
    B G X H I J E F C S P M D Z N U V T
----------------------------------------
B | f . f f f j f f f . f f f f f f f f
G | . . . . . . . . . . . . . . . . . .
X | f . f f f f f f f . f f f f f f f f
H | f . f f f f f f f . f f f f f f f f
I | f . f f f f f f f . f f f f f f f f
J | j . f f f f f f f . f f f f f f f f
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

Range: `fj`

`wsum` where `x` is an atom

```txt
    B G X H I J E F C S P M D Z N U V T
----------------------------------------
b | i . i i i j e f i . p m d z n u v t
g | . . . . . . . . . . . . . . . . . .
x | i . i i i j e f i . p m d z n u v t
h | i . i i i j e f i . p m d z n u v t
i | i . i i i j e f i . p m d z n u v t
j | j . j j j j e f j . p m d z n u v t
e | e . e e e e e f e . p m d z n u v t
f | f . f f f f f f f . f f z z f f f f
c | . . . . . . . f . . p m d z n u v t
s | . . . . . . . . . . . . . . . . . .
p | p . p p p p p f p . . . . . . . . .
m | m . m m m m m f m . . . . . . . . .
d | d . d d d d d z d . . . . . . . . .
z | z . z z z z z z z . . . . . . . . .
n | n . n n n n n f n . . . . . . . . .
u | u . u u u u u f u . . . . . . . . .
v | v . v v v v v f v . . . . . . . . .
t | t . t t t t t f t . . . . . . . . .
```

Range: `defijmnptuvz`

----

[Mathematics](../basics/math.md)
