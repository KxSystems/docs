---
title: Window join | Reference | kdb+ and q documentation
description: wj and wj1 are q keywords that perform window joins.
author: Stephen Taylor
keywords: join, kdb+, q, window join, wj, wj1
---
# `wj`, `wj1`





_Window join_

```txt
wj [w; c; t; (q; (f0;c0); (f1;c1))]
wj1[w; c; t; (q; (f0;c0); (f1;c1))]
```

Where

-   `t` and `q` are simple tables to be joined (`q` should be sorted `` `sym`time `` with `` `p# `` on sym)
-   `w` is a pair of lists of times/timestamps, begin and end
-   `c` are the names of the common columns, syms and times, which must have integral types
-   `f0`, `f1` are aggregation functions applied to values in q columns `c0`,`c1` over the intervals

returns for each record in `t`, a record with additional columns `c0` and `c1`, which are the results of the aggregation functions applied to values over the matching intervals in `w`.

Typically this might be:

```q
wj[w;`sym`time;trade;(quote;(max;`ask);(min;`bid))]
```

A quote is understood to be in existence until the next quote.

!!! tip "To see all the values in each window, pass the identity function `::` in place of the aggregates"

    E.g. `wj[w;c;t;(q;(::;c0);(::;c1))]`


## Multi-column arguments

Since 3.6 2018.12.24, `wj` and `wj1` support multi-col args, forming the resulting column name from the last argument e.g.

```q
wj[w; f; t; (q; (wavg;`asize;`ask); (wavg;`bsize;`bid))]
```


## Interval behaviour

`wj` and `wj1` are both \[\] interval, i.e. they consider quotes ≥beginning and ≤end of the interval.

For `wj`, the prevailing quote on entry to the window is considered valid as quotes are a step function.

`wj1` considers quotes on or after entry to the window. If the join is to consider quotes that arrive from the beginning of the interval, use `wj1`.

??? detail "Behavior prior to V3.0"

    Prior to V3.0, `wj1` considered only quotes in the window except for the window end (i.e. quotes ≥start and &lt;end of the interval).

    | version | wj1  |  wj               |
    |---------|------|-------------------|
    | 3.0+    | `[]` | prevailing + `[]` |
    | 2.7/2.8 | `[)` | prevailing + `[]` |

:fontawesome-brands-wikipedia-w:
[Notation for intervals](https://en.wikipedia.org/wiki/Interval_(mathematics)#Notations_for_intervals "Wikipedia")


```q
q)t:([]sym:3#`ibm;time:10:01:01 10:01:04 10:01:08;price:100 101 105)
q)t
sym time     price
------------------
ibm 10:01:01 100
ibm 10:01:04 101
ibm 10:01:08 105

q)a:101 103 103 104 104 107 108 107 108
q)b:98 99 102 103 103 104 106 106 107
q)q:([]sym:`ibm; time:10:01:01+til 9; ask:a; bid:b)
q)q
sym time     ask bid
--------------------
ibm 10:01:01 101 98
ibm 10:01:02 103 99
ibm 10:01:03 103 102
ibm 10:01:04 104 103
ibm 10:01:05 104 103
ibm 10:01:06 107 104
ibm 10:01:07 108 106
ibm 10:01:08 107 106
ibm 10:01:09 108 107

q)f:`sym`time
q)w:-2 1+\:t.time

q)wj[w;f;t;(q;(max;`ask);(min;`bid))]
sym time     price ask bid
--------------------------
ibm 10:01:01 100   103 98
ibm 10:01:04 101   104 99
ibm 10:01:08 105   108 104
```

The interval values may be seen as:

```q
q)wj[w;f;t;(q;(::;`ask);(::;`bid))]
sym time     price ask             bid
--------------------------------------------------
ibm 10:01:01 100   101 103         98 99
ibm 10:01:04 101   103 103 104 104 99 102 103 103
ibm 10:01:08 105   107 108 107 108 104 106 106 107
```


!!! tip "Window joins with multiple symbols should be used only with a `` `p#sym`` like schema." 

    Typical RTD-like `` `g#`` gives undefined results.

!!! note "Window join is a generalization of as-of join"

    An as-of join takes a snapshot of the current state, while a window join aggregates all values of specified columns within intervals. 
    <!-- (Since V3.0, `wj` and `wj1` are both implemented with `ww`.) -->


----
:fontawesome-solid-book:
[`aj`](aj.md),
[`asof`](asof.md)
<br>
:fontawesome-solid-book-open:
[Joins](../basics/joins.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.9.9 Window Joins](/q4m3/9_Queries_Q-sql/#999-window-join)

