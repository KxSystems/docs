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

Where

-   `x` is a sorted list
-   `y` is an atom or list of exactly the same type (no type promotion)

returns the index of the _last_ item in `x` which is ≤`y`. The result is `-1` for `y` less than the first item of `x`. If `y` is a list, the previous is repeated for each item of `y`.
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

`bin` uses a binary-search algorithm, which is generally more efficient on large data than the linear-search algorithm used by `?` ([Find](find.md)).

The items of `x` must be sorted ascending although `bin` does not verify this property.

!!! danger "If `x` is not sorted the result is undefined."

`bin` can be also used if `x` is a dictionary with its values sorted. In this case, instead of indexes, the respective keys are returned. If a value is not found, the null value of the key type is returned.

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

