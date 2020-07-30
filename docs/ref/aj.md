---
title: aj, aj0, ajf, ajf0 – as-of join | Reference | kdb+ and q documentation
description: As-of joins join two tables taking from the second the most recent records prior to the times in the first
keywords: as-of, join, kdb+, q
---
# `aj`, `aj0`, `ajf`, `ajf0`




_As-of join_

<pre markdown="1" class="language-txt">
aj  [c<sub>1</sub>…c<sub>n</sub>; t1; t2]
aj0 [c<sub>1</sub>…c<sub>n</sub>; t1; t2]
ajf [c<sub>1</sub>…c<sub>n</sub>; t1; t2]
ajf0[c<sub>1</sub>…c<sub>n</sub>; t1; t2]
</pre>

Where 

-   `t1` is a table
-   `t2` is a simple table 
-   <code>c<sub>1</sub>…c<sub>n</sub></code> is a symbol list of column names, common to `t1` and `t2`, and of matching type
-   column <code>c<sub>n</sub></code> is of a sortable type (typically time)

returns a table with records from the left-join of `t1` and `t2`.
In the join, columns <code>c<sub>1</sub>…c<sub>n-1</sub></code> are matched for equality, and the last value of <code>c<sub>n</sub></code> (most recent time) is taken.
For each record in `t1`, the result has one record with the items in `t1`, and

-   if there are matching records in `t2`, the items of the last (in row order) matching record are appended to those of `t1`;
-   otherwise the remaining columns are null.

```q
q)t:([]time:10:01:01 10:01:03 10:01:04;sym:`msft`ibm`ge;qty:100 200 150)
q)t
time       sym  qty
-----------------
10:01:01 msft 100
10:01:03 ibm  200
10:01:04 ge   150

q)q:([]time:10:01:00 10:01:00 10:01:00 10:01:02;sym:`ibm`msft`msft`ibm;px:100 99 101 98)
q)q
time     sym  px 
-----------------
10:01:00 ibm  100
10:01:00 msft 99 
10:01:00 msft 101
10:01:02 ibm  98 

q)aj[`sym`time;t;q]
time       sym  qty px
---------------------
10:01:01 msft 100 101
10:01:03 ibm  200 98
10:01:04 ge   150
```

!!! tip "There is no requirement for any of the join columns to be keys but the join will be faster on keys."


## `aj`, `aj0`

`aj` and `aj0` return different times in their results:

```txt
aj    boundary time from t1
aj0   actual time from t2
```


## `ajf`, `ajf0`

Since V3.6 2018.05.18 `ajf` and `ajf0` behave as V2.8 `aj` and `aj0`, i.e. they fill from LHS if RHS is null. e.g.

```q
q)t0:([]time:2#00:00:01;sym:`a`b;p:1 1;n:`r`s)
q)t1:([]time:2#00:00:01;sym:`a`b;p:0 1)
q)t2:([]time:2#00:00:00;sym:`a`b;p:1 0N;n:`r`s)
q)t0~ajf[`sym`time;t1;t2]
1b
```


## Performance

!!! warning "Order of search columns"

    Ensure the first argument to `aj`, the columns to search on, is in the correct order, e.g. `` `sym`time``. Otherwise you’ll suffer a severe performance hit.

If the resulting time value is to be from the quote (actual time) instead of the (boundary time) from trade, use `aj0` instead of `aj`.

`aj` should run at a million or two trade records per second; whether the tables are mapped or not is irrelevant. However, for speed:

medium | t2\[c<sub>1</sub>\] | t2\[c<sub>2</sub>…\] | example
-------|---------------------|----------------------|-----------------------
memory | `g#`          | sorted within <code>c<sub>1</sub></code> | `quote` has `` `g#sym`` and `time` sorted within `sym`
disk   | `p#`          | sorted within <code>c<sub>1</sub></code> | `quote` has `` `p#sym`` and `time` sorted within `sym`

Departure from this incurs a severe performance penalty. 

Note that, on disk, the `g#` attribute does not help.

!!! warning "Select the virtual partition column only if you need it. It is fabricated on demand, which can be slow for large partitions."


## `select` from `t2`

In memory, there is no need to select from `t2`. Irrespective of the number of records, use, e.g.:

```q
aj[`sym`time;select … from trade where …;quote]
```

instead of

```q
aj[`sym`time;select … from trade where …;
             select … from quote where …]
```

In contrast, on disk you must map in your splay or day-at-a-time partitioned database:

Splay:

```q
aj[`sym`time;select … from trade where …;select … from quote]
```

Partitioned:

```q
aj[`sym`time;select … from trade where …;
             select … from quote where date = …]
```

!!! warning "If further `where` constraints are used, the columns will be _copied_ instead of mapped into memory, slowing down the join."

If you are using a database where an individual day’s data is spread over multiple partitions the on-disk `p#` will be lost when retrieving data with a constraint such as `…date=2011.08.05`. 
In this case you will have to reduce the number of quotes retrieved by applying further constraints – or by re-applying the attribute.


----
:fontawesome-solid-book:
[`asof`](asof.md) 
<br>
:fontawesome-solid-book-open:
[Joins](../basics/joins.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.9.8 As-of Joins](/q4m3/9_Queries_q-sql/#998-as-of-joins)
