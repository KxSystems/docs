---
title: fby – Reference – kdb+ and q documentation
description: fby is a q keyword that applies an aggregate function to groups.
author: Stephen Taylor
keywords: fby, group, kdb+, q, query, qsql, sql
---
# `fby`





_Apply an aggregate to groups_

Syntax: `(aggr;data) fby group`

Where 

-   `aggr` is an aggregate function
-   `data` and `group` are conforming vectors

collects the items of `data` into sublists according to the corresponding items of `group`, applies `aggr` to each sublist, and returns the results as a vector with the same count as `data`.

!!! tip "When to use `fby`"

    `fby` is designed to collapse cascaded `select … from select … by … from t` expressions into a single `select … by … from … where … fby …`. Think of `fby` when you find yourself trying to apply a filter to the aggregated column of a table produced by `select … by …`.

```q
q)dat: 0 1 2 3 4 5 6 7 8 9
q)grp:`a`b`a`b`c`d`c`d`d`a
q)(sum;dat) fby grp
11 4 11 4 10 20 10 20 20 11
```

Collect the items of `data` into sublists according to the items of `group`.

```txt
0 2 9  (`a)
1 3    (`b)
4 6    (`c)
5 7 8  (`d)
```

Apply `aggr` to each sublist.

```txt
sum 0 2 9 -> 11
sum 1 3   -> 4
sum 4 6   -> 10
sum 5 7 8 -> 20
```

The result is created by replacing each item of `group` with the result of applying `aggr` to its corresponding sublist. 

```q
q)(sum;dat) fby grp
11 4 11 4 10 20 10 20 20 11
q)(sum each dat group grp)grp / w/o fby
11 4 11 4 10 20 10 20 20 11
```

When used in a `select`, usually a comparison function is applied to the results of `fby`.

```q
q)select from t where 10 < (sum;d) fby a

q)dat:2 5 4 1 7             / data
q)grp:"abbac"               / group by
q)(sum;dat) fby grp         / apply sum to the groups
3 9 9 3 7
q)(first;dat) fby grp       / apply first to the groups
2 5 5 2 7

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

To group on multiple columns, tabulate them in `group`.

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

!!! info "`fby` before V2.7"

    In V2.6 and below, `fby`’s behavior is undefined if the aggregation function returns a list; it usually signals an error from the k definition of `fby`. However, if the concatenation of all list results from the aggregation function results `raze` has the same length as the original vectors, a list of some form is returned, but the order of its items is not clearly defined.


:fontawesome-regular-hand-point-right:
Basics: [q-SQL](../basics/qsql.md)