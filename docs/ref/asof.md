---
title: asof – Reference – kdb+ and q documentation
description: Where t1 is a table  and t2 is a table or dictionary in which the last key or column of t2 corresponds to a time column in t1, asof[t1;t2] returns the values from the last rows matching the rest of the keys and time ≤ the time in t2.
keywords: asof, join, kdb+, q
---
# `asof`




_As-of join_

```txt
t1 asof t2     asof[t1;t2]
```

Where

-   `t1` is a table
-   `t2` is a table or dictionary
-   the last key or column of `t2` corresponds to a time column in `t1`

returns the values from the last rows matching the rest of the keys and time ≤ the time in `t2`.

```q
q)show trade asof`sym`time!(`IBM;09:30:00.0)
price| 96.3e
size | 200
stop | 0b
corr | 0
cond | "T"
ex   | "D"

q)show trade asof([]sym:`AAPL`IBM;ex:"TD";time:09:30:00.0)
price size stop corr cond
-------------------------
78.14 100  0    0    T
96.3  200  0    0    T
```

The following examples use the `mas` table from TAQ.

```q
q)`date xasc`mas       / sort by date
`mas

q)show a!mas asof a:([]sym:`A`B`C`GOOG;date:1995.01.01)
sym  date      | cusip     name                           wi ex uot
---------------| --------------------------------------------------
A    1995.01.01| 049870207 ATTWOODS PLC ADS REP5 ORD/5PNC 0  N  100
B    1995.01.01| 067806109 BARNES GROUP INCORPORATED      0  N  100
C    1995.01.01| 171196108 CHRYSLER CORP                  0  N  100
GOOG 1995.01.01|                                          0

q)show a!mas asof a:([]sym:`A`B`C`GOOG;date:2006.01.01)
sym  date      | cusip     name                      wi ex uot
---------------| ---------------------------------------------
A    2006.01.01| 00846U101 AGILENT TECHNOLOGIES, INC 0  N  100
B    2006.01.01| 067806109 BARNES GROUP INCORPORATED 0  N  100
C    2006.01.01| 172967101 CITIGROUP                 0  N  100
GOOG 2006.01.01| 38259P508 GOOGLE INC CLASS A        0  T  100

q)show a!mas asof a:([]sym:`A;date:1993.01.05 1996.05.23 2000.08.04)
sym date      | cusip     name                           wi ex uot
--------------| --------------------------------------------------
A   1993.01.05| 049870207 ATTWOODS PLC ADS REP5 ORD/5PNC 0  N  100
A   1996.05.23| 046298105 ASTRA AB CL-A ADS 1CL-ASEK2.50 0  N  100
A   2000.08.04| 00846U101 AGILENT TECHNOLOGIES  INC      0  N  100
```


----
:fontawesome-solid-book:
[`aj`](aj.md), 
[`wj`](wj.md)
<br>
:fontawesome-solid-book-open:
[Joins](../basics/joins.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.9.8 As-of Joins](/q4m3/9_Queries_q-sql/#998-as-of-joins)

