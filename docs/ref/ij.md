---
title: ij, ijf
description: ij and ijf are q keywords that perform inner joins.
author: Stephen Taylor
keywords: ij, ijf, inner join, join, kdb+, q
---
# `ij`, `ijf` 






_Inner join_

Syntax: `t1 ij t2`, `ij[t1;t2]`  
Syntax: `t1 ijf t2`, `ijf[t1;t2]`

Where 

-   `t1` and `t2` are tables
-   `t2` is keyed, and its key columns are columns of `t1`

returns two tables joined on the key columns of the second table. 
The result has one combined record for each row in `t1` that matches a row in `t2`.

```q
q)t
sym  price
---------------
IBM  0.7029677
FDP  0.08378167
FDP  0.06046216
FDP  0.658985
IBM  0.2608152
MSFT 0.5433888
q)s
sym | ex  MC
----| --------
IBM | N   1000
MSFT| CME 250
q)t ij s
sym  price     ex  MC
-----------------------
IBM  0.7029677 N   1000
IBM  0.2608152 N   1000
MSFT 0.5433888 CME 250
```


## Changes in V3.0

Since V3.0, `ij` has changed behavior (similarly to `lj`): when there are nulls in `t2`, `ij` uses the `t2` null, where the earlier version left the corresponding value in `t1` unchanged:

```q
q)show x:([]a:1 2;b:`x`y;c:10 20)
a b c
------
1 x 10
2 y 20
q)show y:([a:1 2]b:``z;c:1 0N)
a| b c
-| ---
1|   1
2| z
q)x ij y        /V3.0
a b c
-----
1   1
2 z
q)x ij y        /V2.8
a b c
------
1 x 1
2 z 20
```

Since 2016.02.17, the earlier version is available in all V3.4 and later versions as `ijf`.


<i class="far fa-hand-point-right"></i> 
Basics: [Joins](../basics/joins.md)

