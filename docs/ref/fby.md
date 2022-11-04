---
title: fby – Reference – kdb+ and q documentation
description: fby is a q keyword that applies an aggregate function to groups.
author: Stephen Taylor
keywords: fby, group, kdb+, q, query, qsql, sql
---
# `fby`





_Apply an aggregate to groups_

```syntax
(aggr;d) fby g
```

Where 

-   `aggr` is an aggregate function
-   `d` and `g` are conforming vectors

collects the items of `d` into sublists according to the corresponding items of `g`, applies `aggr` to each sublist, and returns the results as a vector with the same count as `d`.

!!! tip "When to use `fby`"

    `fby` is designed to collapse cascaded 

        select … from select … by … from t

    expressions into a single 

        select … by … from … where … fby …

    Think of `fby` when you find yourself trying to apply a filter to the aggregated column of a table produced by `select … by …`.

```q
q)show dat:10?10
4 9 2 7 0 1 9 2 1 8
q)grp:`a`b`a`b`c`d`c`d`d`a
q)(sum;dat) fby grp
14 16 14 16 9 4 9 4 4 14
```

Collect the items of `dat` into sublists according to the items of `grp`.

```txt
q)group grp
a| 0 2 9
b| 1 3
c| 4 6
d| 5 7 8

q)dat group grp
a| 4 2 8
b| 9 7
c| 0 9
d| 1 2 1
```

Apply `aggr` to each sublist.

```txt
q)sum each dat group grp
a| 14
b| 16
c| 9
d| 4
```

The result is created by replacing each item of `grp` with the result of applying `aggr` to its corresponding sublist. 

```q
q)(sum;dat) fby grp
14 16 14 16 9 4 9 4 4 14
q)(sum each dat group grp)grp / w/o fby
14 16 14 16 9 4 9 4 4 14
```


## Vectors

```q
q)dat:2 5 4 1 7             / data
q)grp:"abbac"               / group by
q)(sum;dat) fby grp         / apply sum to the groups
3 9 9 3 7
q)(first;dat) fby grp       / apply first to the groups
2 5 5 2 7
```


## Tables

When used in a `select`, usually a comparison function is applied to the results of `fby`, e.g.

```q
select from t where 10 < (sum;d) fby a
```

```q
q)\l sp.q
q)show sp                                       / for reference
s  p  qty
---------
s1 p1 300
s1 p2 200
s1 p3 400
s1 p4 200
s4 p5 100
s1 p6 100
s2 p1 300
s2 p2 400
s3 p2 200
s4 p2 200
s4 p4 300
s1 p5 400
```

Sales where quantity &gt; average quantity by part:

```q
q)select from sp where qty > (avg;qty) fby p
s  p  qty
---------
s2 p2 400
s4 p4 300
s1 p5 400
```

Sales where quantity = maximum quantity by part:

```q
q)select from sp where qty = (max;qty) fby p
s  p  qty
---------
s1 p1 300
s1 p3 400
s1 p6 100
s2 p1 300
s2 p2 400
s4 p4 300
s1 p5 400
```

To group on multiple columns, tabulate them in `g`.

```q
q)update x:12?3 from `sp
`sp
q)sp
s  p  qty x
-----------
s1 p1 300 0
s1 p2 200 2
s1 p3 400 0
s1 p4 200 1
s4 p5 100 0
s1 p6 100 0
s2 p1 300 0
s2 p2 400 2
s3 p2 200 2
s4 p2 200 2
s4 p4 300 1
s1 p5 400 1

q)select from sp where qty = (max;qty) fby ([]s;x)
s  p  qty x
-----------
s1 p2 200 2
s1 p3 400 0
s4 p5 100 0
s2 p1 300 0
s2 p2 400 2
s3 p2 200 2
s4 p2 200 2
s4 p4 300 1
s1 p5 400 1
```

??? info "`fby` before V2.7"

    In V2.6 and below, `fby`’s behavior is undefined if the aggregation function returns a list; it usually signals an error from the k definition of `fby`. However, if the concatenation of all list results from the aggregation function results `raze` has the same length as the original vectors, a list of some form is returned, but the order of its items is not clearly defined.

---
:fontawesome-solid-book-open:
[q-SQL](../basics/qsql.md)
