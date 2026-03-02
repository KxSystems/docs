---
title: asof – Reference – KDB-X and q documentation
description: Where t1 is a table  and t2 is a table or dictionary in which the last key or column of t2 corresponds to a time column in t1, asof[t1;t2] returns the values from the last rows matching the rest of the keys and time ≤ the time in t2.
keywords: asof, join, KDB-X, q
---
# `asof`

_As-of join_

```syntax
t asof d     asof[t;d]
```

Where

- `t` is a table
- `d` is a dictionary (or table) with `n` keys (or columns) that correspond to columns in `t`
- the last key (or column) of `d` corresponds to a sortable column in `t` (usually time)

returns the values of the remaining columns from the last row in `t` for which

- the first `n-1` values each match the first `n-1` values of `d`, and
- the last value is not greater than the last value of `d`.

If no items match the criteria, either because there are no rows that match in the first `n-1` columns, or because the last value is smaller than the last value in the first such row, a dictionary of nulls is returned.

```q
q)show t:([] time:6#09:00+10*til 3; sym:raze flip 3 2#`AAPL`GOOG; px:6?100f; vol:6?100)
time  sym  px       vol
-----------------------
09:00 AAPL 81.77547 36
09:10 AAPL 75.20102 12
09:20 AAPL 10.86824 97
09:00 GOOG 95.98964 92
09:10 GOOG 3.668341 99
09:20 GOOG 64.30982 45
q)t asof `sym`time!(`AAPL;09:15)
px | 75.20102
vol| 12
q)t asof ([]sym:`GOOG`MSFT; time:09:05)
px       vol
------------
95.98964 92
              / a row of nulls for no match
```

`asof` is a [multithreaded primitive](mt-primitives.md).

----

[`aj`](aj.md),
[`wj`](wj.md)  

[Joins](joins.md)
<br>

_Q for Mortals_
[§9.9.8 As-of Joins](../learn/q4m/9_Queries_q-sql.md/#998-as-of-joins)
