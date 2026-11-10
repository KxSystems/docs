---
title: Window join | Reference | kdb+ and q documentation
description: wj and wj1 are q keywords that perform window joins.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `wj`, `wj1`

_Window join_

```syntax
wj [w; c; t; (q; (f0;c0); (f1;c1))]
wj1[w; c; t; (q; (f0;c0); (f1;c1))]
```

Where

- `t` and `q` are simple tables to be joined
- `w` is a pair of lists of times or timestamps: the beginnings and ends of the windows
- `c` is a symbol vector of the names of the common columns: the sym columns, followed by the time column
- `f0`, `f1` are aggregation functions applied to values in `q` columns `c0`, `c1` over the intervals

returns, for each record in `t`, a record with additional columns `c0` and `c1`, which are the results of the aggregation functions applied to values over the matching intervals in `w`.

`q` must be sorted on `` `sym`time `` with the `` `p# `` attribute on `sym`.
Since 4.1t 2023.08.04, if `t` is the name of a table as a symbol, it is updated in place.

For example, the following call finds the highest ask and lowest bid in each window. The column names `sym`, `time`, `ask` and `bid` are illustrative; `wj` does not require particular column names.

```q
wj[w;`sym`time;trade;(quote;(max;`ask);(min;`bid))]
```

Each quote prevails until the next quote arrives.

!!! tip "To see all the values in each window, pass the identity function `::` in place of the aggregates"

    For example, `wj[w;c;t;(q;(::;c0);(::;c1))]`

## Multi-column arguments

Since 3.6 2018.12.24, `wj` and `wj1` support aggregation functions with multiple column arguments. The name of the resulting column is the last argument, for example:

```q
wj[w; c; t; (q; (wavg;`asize;`ask); (wavg;`bsize;`bid))]
```

## Interval behavior

`wj` and `wj1` both use closed intervals (`[]`); that is, they consider quotes at or after the beginning of the interval and at or before its end.

For `wj`, the quote prevailing on entry to the window counts as valid, because quotes are a step function.

`wj1` considers quotes on or after entry to the window. If the join is to consider quotes that arrive from the beginning of the interval, use `wj1`.

??? detail "Behavior prior to V3.0"

    Prior to V3.0, `wj1` considered only quotes in the window except for the window end (that is, quotes ≥start and &lt;end of the interval).

    | version | wj1  |  wj               |
    |---------|------|-------------------|
    | 3.0+    | `[]` | prevailing + `[]` |
    | 2.7/2.8 | `[)` | prevailing + `[]` |

[Notation for intervals](https://en.wikipedia.org/wiki/Interval_(mathematics)#Notations_for_intervals "Wikipedia")

In the following example, a quote arrives every two seconds, so the second and third windows each begin between two quotes.

```q
q)t:([]sym:3#`ibm;time:10:01:01 10:01:04 10:01:08;price:100 101 105)
q)t
sym time     price
------------------
ibm 10:01:01 100
ibm 10:01:04 101
ibm 10:01:08 105

q)q:([]sym:`ibm; time:10:01:01+2*til 5; ask:101 103 104 107 108; bid:98 102 103 106 107)
q)q
sym time     ask bid
--------------------
ibm 10:01:01 101 98
ibm 10:01:03 103 102
ibm 10:01:05 104 103
ibm 10:01:07 107 106
ibm 10:01:09 108 107

q)c:`sym`time
q)w:-2 1+\:t.time
q)w
10:00:59 10:01:02 10:01:06
10:01:02 10:01:05 10:01:09

q)wj[w;c;t;(q;(max;`ask);(min;`bid))]
sym time     price ask bid
--------------------------
ibm 10:01:01 100   101 98
ibm 10:01:04 101   104 98
ibm 10:01:08 105   108 103
q)wj1[w;c;t;(q;(max;`ask);(min;`bid))]
sym time     price ask bid
--------------------------
ibm 10:01:01 100   101 98
ibm 10:01:04 101   104 102
ibm 10:01:08 105   108 106
```

The interval values show that `wj` includes the quote prevailing at the start of each window, while `wj1` does not:

```q
q)wj[w;c;t;(q;(::;`ask);(::;`bid))]
sym time     price ask         bid
------------------------------------------
ibm 10:01:01 100   ,101        ,98
ibm 10:01:04 101   101 103 104 98 102 103
ibm 10:01:08 105   104 107 108 103 106 107
q)wj1[w;c;t;(q;(::;`ask);(::;`bid))]
sym time     price ask     bid
----------------------------------
ibm 10:01:01 100   ,101    ,98
ibm 10:01:04 101   103 104 102 103
ibm 10:01:08 105   107 108 106 107
```

!!! tip "Use window joins with multiple symbols only with a `` `p#sym``-like schema."

    The `` `g#`` attribute typical of real-time databases gives undefined results.

!!! note "Window join is a generalization of as-of join"

    An as-of join takes a snapshot of the current state, while a window join aggregates all values of specified columns within intervals.

----

[`aj`](aj.md),
[`asof`](asof.md)
<br>

[Joins](../basics/joins.md)
<br>

_Q for Mortals_
[9.9.9 Window Joins](/q4m3/9_Queries_q-sql/#999-window-join)

