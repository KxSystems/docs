---
title: As-of join
keywords: as-of, join, kdb+, q
---

# `aj`, `aj0` 





_As-of join_

Syntax: <code>aj[c<sub>1</sub>…c<sub>n</sub>;t1;t2]</code>

Where 

-   `t1` is a table
-   `t2` is a simple table 
-   <code>c<sub>1</sub>…c<sub>n</sub></code> is a symbol list of column names, common to `t1` and `t2`, and of matching type
-   column <code>c<sub>n</sub></code> is of a sortable type (typically time)

returns a table with records from the left-join of `t1` and `t2`.
In the join, the last value (most recent time) is taken.
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

`aj` and `aj0` return different times in their results:

join  | time in result
------|------------------------
`aj`  | boundary time from `t1`
`aj0` | actual time from `t2`


## Performance

`aj` should run at a million or two trade records per second; whether the tables are mapped or not is irrelevant. However, for speed:

medium | c<sub>1</sub> | c<sub>2</sub>…
-------|---------------|-----------------------------------------
memory | `g#`          | sorted within <code>c<sub>1</sub></code>
disk   | `p#`          | sorted within <code>c<sub>1</sub></code>

Departure from this incurs a severe performance penalty. 

Note that, on disk, the `g#` attribute does not help.

!!! warning "Virtual partition column"

    Select the virtual partition column only if you need it. It is fabricated on demand, which can be slow for large partitions.

### `select` from `t2`

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

!!! warning "Further `where` constraints"

    If further `where` constraints are used, the columns will be _copied_ instead of mapped into memory, slowing down the join.

If you are using a database where an individual day’s data is spread over multiple partitions the on-disk `p#` will be lost when retrieving data with a constraint such as `…date=2011.08.05`. 
In this case you will have to reduce the number of quotes retrieved by applying further constraints – or by re-applying the attribute.



<i class="far fa-hand-point-right"></i> 
Basics: [Joins](../basics/joins.md)

