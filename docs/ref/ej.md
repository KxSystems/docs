---
title: ej
description: ej is a q keyword that performs an equi join on two tables.
keywords: ej, equi join, join, kdb+, q
---
# `ej` 






_Equi join_

Syntax: `ej[c;t1;t2]`

Where `c` is a list of column names (or a single column name) and `t1` and `t2` are tables, returns `t1` and `t2` joined on column/s `c`.

The result has one combined record for each row in `t1` that matches `t2` on columns `c`. (Since V2.6.)

```q
q)t:([]sym:`IBM`FDP`FDP`FDP`IBM`MSFT;price:0.7029677 0.08378167 0.06046216 0.658985 0.2608152 0.5433888)
q)s:([]sym:`IBM`MSFT;ex:`N`CME;MC:1000 250)
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
sym  ex  MC
-------------
IBM  N   1000
MSFT CME 250
q)ej[`sym;s;t]
sym  price     ex  MC
-----------------------
IBM  0.7029677 N   1000
IBM  0.2608152 N   1000
MSFT 0.5433888 CME 250
```



<i class="far fa-hand-point-right"></i> 
Basics: [Joins](../basics/joins.md)

