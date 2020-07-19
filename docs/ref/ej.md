---
title: ej – equi join | Reference | kdb+ and q documentation
description: ej is a q keyword that performs an equi join on two tables.
keywords: ej, equi join, join, kdb+, q
---
# `ej` 



_Equi join_

```txt
ej[c;t1;t2]
```

Where 

-   `c` is a list of column names (or a single column name) 
-   `t1` and `t2` are tables

returns `t1` and `t2` joined on column/s `c`.

The result has one combined record for each row in `t2` that matches `t1` on columns `c`.

```q
q)t:([]sym:`IBM`FDP`FDP`FDP`IBM`MSFT;price:0.7029677 0.08378167 0.06046216 
    0.658985 0.2608152 0.5433888)
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

Duplicate column values are filled from `t2`.

```q
q)t1:([] k:1 2 3 4; c:10 20 30 40)
q)t2:([] k:2 2 3 4 5; c:200 222 300 400 500; v:2.2 22.22 3.3 4.4 5.5)

q)ej[`k;t1;t2]
k c   v
-----------
2 200 2.2
2 222 22.22
3 300 3.3
4 400 4.4
```

---
:fontawesome-solid-book-open:
[Joins](../basics/joins.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.9.5 Equi Join](/q4m3/9_Queries_q-sql/#995-equi-join-ej)

