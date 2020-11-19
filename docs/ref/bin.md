---
title: bin, binr – Reference – kdb+ and q documentation
description: bin and binr are q keywords that perform binary searches.
keywords: bin, binr, kdb+, q, search_
---
# `bin`, `binr`





_Binary search_

```txt
x bin  y    bin[x;y]
x binr y    binr[x;y]
```

Where

-   `x` is a sorted list
-   `y` is a list or atom of exactly the same type (no type promotion)

returns the index of the _last_ item in `x` which is ≤`y`. The result is `-1` for `y` less than the first item of `x`.
`binr` _binary search right_, introduced in V3.0 2012.07.26, gives the index of the _first_ item in `x` which is ≥`y`.

They use a binary-search algorithm, which is generally more efficient on large data than the linear-search algorithm used by `?` ([Find](find.md)).

The items of `x` should be sorted ascending although `bin` does not verify that; if the items are not sorted ascending, the result is undefined. `y` can be either an atom or a simple list of the same type as the left argument.

The result `r` can be interpreted as follows: for an atom `y`, `r` is an integer atom whose value is either a valid index of `x` or `-1`. In general:

```txt
r[i]=-1            iff y[i]<x[0]
r[i]=i             iff x[i]<=y[i]<x[i+1]
```

and

```txt
r[j]=x bin y[j]    for all j in index of y
```

Essentially `bin` gives a half-open interval on the left.

`bin` and `binr` are right-atomic: their results have the same count as `y`.

`bin` also operates on tuples and table columns and is the function used in [`aj`](aj.md) and [`lj`](lj.md).

!!! danger "If `x` is not sorted the result is undefined."


## Three-column argument

`bin` and `?` on three columns find all equijoins on the first two cols and then do `bin` or `?` respectively on the third column. `bin` assumes the third column is sorted within the equivalence classes of the first two column pairs (but need not be sorted overall).

```q
q)0 2 4 6 8 10 bin 5
2
q)0 2 4 6 8 10 bin -10 0 4 5 6 20
-1 0 2 2 3 5
```

If the left argument items are not distinct the result is not the same as would be obtained with `?`:

```q
q)1 2 3 3 4 bin 2 3
1 3
q)1 2 3 3 4 ? 2 3
1 2
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

