---
title: bin, binr | Reference | kdb+ and q documentation
description: bin and binr are q keywords that perform binary searches.
keywords: bin, binr, kdb+, q, search_
---
# `bin`, `binr`





_Binary search_

```syntax
x bin  y    bin[x;y]
x binr y    binr[x;y]
```

## Lists

Where

-   `x` is a sorted list
-   `y` is an atom of exactly the same type (no type promotion)

returns the index of the _last_ item in `x` which is ≤`y`. The result is `-1` for `y` less than the first item of `x`. If `x` is a simple list, `bin` is [atomic](../basics/atomic.md) in `y`. (For higher ranks of either argument, `bin` works the same way as [`?` (Find)](find.md/#type-specific).)
`binr` _binary search right_, introduced in V3.0 2012.07.26, gives the index of the _first_ item in `x` which is ≥`y`.

```q
q)0 2 4 6 8 10 bin 5
2
q)0 2 4 6 8 10 bin -10 0 4 5 6 20
-1 0 2 2 3 5

q)0 1 1 2 bin 0 1 2
0 2 3
q)0 1 1 2 binr 0 1 2
0 1 3
```

`bin` uses a binary search algorithm, which is generally more efficient on large data than the linear-search algorithm used by [`?` (Find)](find.md).

The items of `x` must be sorted ascending although `bin` does not verify this property.

!!! danger "If `x` is not sorted the result is undefined."

`bin` can be also used if `x` is a dictionary with its values sorted.

```q
q)(`a`b`c!0 2 4) bin -1 3
``b
```

Non-simple lists can also be used. In this case, items are lexicographically sorted.

```q
q)("apple";"banana";"coffee") bin ("anise";"berry";"curry")
-1 1 2
```

The result `r` can be interpreted as follows: for an atom `y`, `r` is an integer atom whose value is either a valid index of `x` or `-1`. In general:

```txt
r[i]=-1            iff y[i]<x[0]
r[i]=j             iff last j such that x[j]<=y[i]<=x[j+1]
r[i]=n-1           iff x[n-1]<=y[i]
```

and

```txt
r[j]=x bin y[j]    for all j in index of y
```

`bin` is the function used in [`aj`](aj.md) and [`lj`](lj.md).

`bin` and `binr` are [multithreaded primitives](../kb/mt-primitives.md).

## Tables

Where

-   `x` is a table of `n` columns
-   `y` is a table row with the same schema (e.g. a list with `n` elements or a dictionary with the same keys as the columns of `x`)

returns the index of the last row of `x` for which 

- the first `n-1` values each match the first `n-1` values of `y`, and
- the last value is not greater than the last value of `y`.

(For higher ranks, see the examples below as well as the documentation for [`?` (Find)](find.md/#type-specific).)

If no items match the criteria, either because there are no rows that match in the first `n-1` columns, or because the last value is smaller than the last value in the first such row, `0N` is returned.

```q
q)t:([]a:`p`p`p`q`q`q;b:0 2 4 0 2 4)
q)t bin `a`b!(`p;3)
1
q)t bin ([]a:`q;b:-1 1 3 5)
0N 3 4 5
q)t bin `a`b!(`r;2)
0N
```

To use `bin` with a table, the last column needs not be sorted overall, but it needs to be sorted within the equivalence classes defined by the first `n-1` columns (as shown in the previous example).

`bin` can also be used with keyed tables. Here, `y` needs to contain all value columns, and it is the keys that are returned (as a table).

```q
q)kt:([k:`c`d`e`f`g`h`j`l]a:`p`p`q`q`p`p`q`q;b:0 1 0 1 0 1 0 1;c:3 3 3 3 7 7 7 7)
q)kt
k| a b c
-| -----
c| p 0 3
d| p 1 3
e| q 0 3
f| q 1 3
g| p 0 7
h| p 1 7
j| q 0 7
l| q 1 7
q)kt bin ([]a:`p`q`q`r;b:1;c:4 8 2 4)
k
-
d
l


q)(kt bin ([]a:`p`q`q`r;b:1;c:4 8 2 4))`k
`d`l``
```

## Sorted third column

`bin` detects the special case of three columns with the third column having a sorted attribute. The search is initially constrained by the first column, then by the sorted third column, and then by a linear search through the remaining second column. The performance difference is visible in this example:

```q
q)n:1000000;t:([]a:`p#asc n?`2;b:`#asc n?1000;c:asc n?100000)
q)\t t bin t
194
q)update`#c from`t; / remove the sort attr from column c
q)\t t bin t
3699
```


----

:fontawesome-solid-book:
[`aj`](aj.md), [`lj`](lj.md)
<br>
:fontawesome-solid-book-open:
[Search](../basics/by-topic.md#search)

