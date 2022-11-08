---
title: Kdb+ query scaling | White papers | kdb+ and q documentation
description: How to take advantage of multiple kdb+ query structures  to achieve optimal query performance for large volumes of data
author: Ian Lester
date: January 2014
keywords: find, join, kdb+, optimize, performance, q, query, scale, select
---
White paper
{: #wp-brand}

# Kdb+ query scaling

by [Ian lester](#author)
{: .wp-author}






Trading volumes in financial market exchanges have increased significantly in recent years and as a result it has become increasingly important for financial institutions to invest in the best technologies and to ensure that they are used to their full potential.

This white paper will examine some of the key steps which can be taken to ensure the optimal efficiency of queries being run against large kdb+ databases. In particular it will focus on [q-SQL statements](../basics/qsql.md), [joins](../basics/joins.md), and other constructs which provide kdb+ with a powerful framework for extracting information from increasingly large amounts of timeseries data both-in memory and on- disk. It covers key ideas and optimization solutions while also highlighting potential pitfalls.

All tests were run using kdb+ 3.1 (2013.12.27)


## Overview of data

For the purpose of analysis we have created three pairs of trade and quote tables containing equity timeseries data where one pair is fully in memory, one has been splayed on-disk and one has been partitioned by date. Each pair of tables, `quote` and `trade`, have been loaded into a namespace (`.mem`, `.splay` or `.par`) so that it is clear which table we are looking at during our analysis. 
<!-- The code used to create this database is available in the appendix. -->

The data contains 4 primary symbols (AAPL, GOOG, IBM and MSFT) along with 96 randomly-generated others. The in-memory quote table contains 2 million records, the splayed quote table contains 5 million records and the partitioned quote table contains 2 million records per partition over 5 days giving 10 million records in total. The trade data is 10% the size of each quote table and has been simplified by basing it off the previous quote rather than maintaining an order book.

```q
q)1_count each .mem
quote| 2000000
trade| 200000

q)1_count each .splay 
quote| 5000000 
trade| 500000

q)1_count each .par
quote| 50000000
trade| 5000000

q)date
2014.02.19 2014.02.20 2014.02.21 2014.02.22 2014.02.23

q)select count i by date from .par.quote 
date      | x
----------| --------
2014.02.19| 10000000
2014.02.20| 10000000 
2014.02.21| 10000000 
2014.02.22| 10000000 
2014.02.23| 10000000
```

Each table has an attribute applied to the sym column – the in-memory tables being grouped (`g#`), and those on-disk being parted (`p#`). The table metadata below displays the structure of the in-memory quote and trade tables, the meta of the tables on-disk differ by attribute only.

```q
q)meta .mem.quote 
c  | t f a
---| ----- 
sym| s   g
dt | p
ap | f
as | j
bp | f
bs | j

q)meta .mem.trade 
c   | t f a 
----| ----- 
sym | s   g
dt  | p
tp  | f
ts  | j
side| s
```



## Select statements


In this section we will look at the most common and flexible method for querying kdb+ data, the q-SQL `select` statement. This construct allows us to query both on-disk (memory mapped) and in-memory data in a similar fashion.


### Retrieving records by symbol

In this section we will look at methods for retrieving the first and last records by symbol with and without further constraints added to the select statement. We will focus on the use of the efficient `select by sym from tab` construct as well as using the [Find `?` operator](../ref/find.md) to perform a lookup for a table.

In the following example we look at how we can retrieve the last record by symbol from a table. The default behavior of the q By clause is to retrieve the last value of each column grouped by each parameter in the By clause. If no aggregation function is specified there is no need to explicitly call the last function; comparing the two constructs we see a 2½× speed improvement and similar memory usage.

```q
q)select by sym from .mem.quote
sym | dt                            ap       as bp       bs 
----| ----------------------------------------------------- 
AAPL| 2014.02.23D15:59:56.081766206 527.1077 93 527.0023 77
ACJ | 2014.02.23D15:59:58.392773419 487.661  66 487.5635 26 
AGL | 2014.02.23D15:59:58.475614283 363.3669 43 363.2942 49 
AHF | 2014.02.23D15:59:59.843160342 145.5018 52 145.4727 84
..

q)\ts a:select by sym from .mem.quote 
20 16784064

q)\ts b:select last dt, last ap, last as, last bp, last bs by sym from .mem.quote
51 16783328

q)a~b
1b
```

We see an approximately 4× performance improvement when we apply to partitioned data.

```q
q)\ts a:select by sym from .par.quote where date = last date
78 134226368

q)\ts b:select last date, last dt, last ap, last as, last bp, last bs by sym from .par.quote where date = last date 
345 201329840

q)a~b
1b
```

We can use the Find operator `?` to obtain a list of indexes corresponding to the first occurrence of a symbol in our table. In our first example we obtain the position `i` of the first occurrence of each sym in our table, we then perform a lookup in the same table using the Find operator and index into the original table with the result, which will be a list of type long. Note that this example is actually redundant, we could use the simpler 

```q
select first sym, first dt, first ap, first as, first bp, first bs 
  by sym from .mem.quote
```

to retrieve this data even more efficiently, but we will build on this in the rest of this section. We find this to be approximately 2× faster than using
`fby` and it also uses slightly less memory:

```q
q).mem.quote(select sym, i from .mem.quote)?0!select first i by sym from .mem.quote
sym                                dt       ap asbp     bs 
-----------------------------------------------------------
AAPL 2014.02.23D09:00:00.117540266 544.0444 27 543.9356 56 
ACJ  2014.02.23D09:00:01.156257558 487.5938 36 487.4963 60 
AGL  2014.02.23D09:00:00.014462973 345.9409 80 345.8717 104 
AHF  2014.02.23D09:00:00.466329697 138.5061 44 138.4784 63 
AHK  2014.02.23D09:00:00.167160294 342.2259 97 342.1575 104 
..

q)\ts a:.mem.quote(select sym, i from .mem.quote)?0!select first i by sym from .mem.quote
24 33557504
q)\ts b:select from .mem.quote where i = (first; i) fby sym 63 42995872
q)a~b
1b

q)\ts select first sym, first dt, first ap, first as, first bp, first bs by sym from .mem.quote
12 15238560
```

In our second example we show how using the Find operator does not outperform `select by sym from t` but is still an improvement over using `last`:

```q
q)\ts a:.mem.quote(select sym,i from .mem.quote)?0!select last i by sym from .mem.quote
32 33556528
q)\ts b:0!select by sym from .mem.quote 20 16784144
q)a~b
1b
```

Finally we demonstrate a key use case for this construct: how we can select the first occurrence of an event in one column of the table. In our example below we look at the maximum bid size by sym. Examples like this, where there is no q primitive shortcut which can be applied consistently across all columns, for example the call to `first` used above, is where the performance improvements of this construct come to the fore. In the example below we will achieve 2× performance over the alternative method `fby`.

```q
q).mem.quote(`sym`bs#.mem.quote)?0!select max bs by sym from .mem.quote
sym  dt                            ap       as  bp       bs 
------------------------------------------------------------ 
AAPL 2014.02.23D09:00:19.752919580 544.043  92  543.9342 109 
ACJ  2014.02.23D09:00:12.435798905 487.5911 106 487.4936 109 
AGL  2014.02.23D09:01:29.984035491 345.9841 79  345.915  109 
AHF  2014.02.23D09:04:30.327046606 138.578  13  138.5503 109 
AHK  2014.02.23D09:03:01.717110984 342.2449 12  342.1764 109 
..

q)\ts .mem.quote(`sym`bs#.mem.quote)?0!select max bs by sym from .mem.quote
28 16779264
```


### Efficient select statements using attributes

One of the most effective ways to ensure fast lookup of data is the correct use of attributes, discussed in white paper [Columnar database and query optimization](columnar-database/index.md). In this section we will look at how we can ensure an attribute is used throughout an entire select statement.

If we wish to filter a table for entries containing a particular list of syms, the simplest way of doing this is to use a statement like `select from table where sym in symList`. However, when we apply the `in` keyword to a column which contains an attribute we will only receive that attribute’s performance benefit for the first symbol in the list we are searching. 

An alternative is to rewrite the query using a lambda and pass in each symbol in turn: 

```q
{select from table where sym = x} each symList
```

When we use the lambda function we get the performance improvement for every symbol in the list, so even with the overhead of appending the results using the `raze` function we will often see an improvement in execution time at the cost of the extra memory needed to store the intermediate results.

In the following examples, which are run on the partitioned quote table, we see a speed increase of slightly below 2× at the cost of a larger memory footprint. However, as the number of symbols under consideration and the size of the data increases we would expect to see greater benefits.

```q
q)raze {select from .par.quote where date = last date, sym = x}each `AAPL`GOOG`IBM
date       sym  dt                            ap       as bp       bs 
---------------------------------------------------------------------- 
2014.02.23 AAPL 2014.02.23D09:00:00.248076673 527.0607 29 526.9553 86 
2014.02.23 AAPL 2014.02.23D09:00:01.054893527 527.0606 18 526.9552 85 
2014.02.23 AAPL 2014.02.23D09:00:01.189490128 527.0605 15 526.9551 72 
2014.02.23 AAPL 2014.02.23D09:00:01.211703848 527.0605 41 526.9551 69 
2014.02.23 AAPL 2014.02.23D09:00:01.286917179 527.0606 49 526.9552 59 
2014.02.23 AAPL 2014.02.23D09:00:01.546945609 527.061 100 526.9556 88 
..

q)\ts a:raze {select from .par.quote where date = last date, sym = x}each `AAPL`GOOG`IBM
15 44042032

q)\ts b:select from .par.quote where date = last date, sym in `AAPL`GOOG`IBM
25 27264720

q)a~b
1b
```

The example below uses a similar construct to find the maximum ask price for each symbol from our in-memory quote table; here we achieve a 20% speed increase and a huge reduction in memory usage.

```q
q)raze{select max ap by sym from .mem.quote where sym = x} each `AAPL`GOOG`IBM
sym | ap
----| --------
AAPL| 544.0496
GOOG| 1198.86
IBM | 183.5632

q)\ts a:select max ap by sym from .par.quote where date = last date, sym in `AAPL`GOOG`IBM
20 12584960

q)\ts b:raze {select max ap by sym from .par.quote where date = last date, sym = x}each `AAPL`GOOG`IBM
16 2100176

q)a~b
1b
```


### Obtaining a subset of columns

In cases where our goal is to obtain a subset of columns from a table we can use the Take operator `#` to do this more efficiently than in a standard select statement. This potential improvement comes from recognizing that a table is a list of dictionaries with its indexes swapped. Position `[1;2]` in a table is equivalent to position `[2;1]` in a dictionary. A table is therefore subject to dictionary operations. This is a highly efficient operation as kdb+ only has to index into the keys defined in the left argument of `#`.

```q
q)`sym`ap`as#.mem.quote 
sym  ap       as 
----------------
AAPL 544.0444 27
AAPL 544.0431 57 
AAPL 544.043  77 
..

q)\ts:1000000 a:`sym`ap`as#.mem.quote
687 672

q)\ts:1000000 b:select sym, ap, as from .mem.quote
819 1200

q)a~b
```

The above gives a small performance increase and corresponding decrease in memory usage and will also work on splayed tables. It can be applied to keyed tables when used in conjunction with the Each Right iterator `/:`. This will return the columns passed as a list of symbols in the first argument along with the key column of the table. To illustrate this we create a table `.mem.ktrade`, which is the in-memory trade table defined above keyed on unique GUID values.

```q
// add a unique GUID tradeID primary key to in-memory trade table 
q).mem.ktrade:(flip enlist[`tradeID]!enlist `u#(neg count .mem.trade)?0Ng)!.mem.trade
q)`sym`side#/:.mem.ktrade
tradeID                             | sym side
------------------------------------| --------- 
deaf3e2d-f9ba-6a8b-1db4-ffe76a6a3be6| AAPL Sell 
986e1121-ba3c-d9a1-80f4-a884ad783444| AAPL Sell 
37472984-556c-4a6b-1f2c-e7eb716144ee| AAPL Buy 
6e65f67e-23e1-4ef9-cb08-9c68467f9e34| AAPL Sell 
..

q)\ts:10000 a:`sym`side#/:.mem.ktrade
19 736

q)\ts:10000 b:select tradeID, sym, side from .mem.ktrade
21 1376

q)\ts:10000 c:`tradeID xkey select tradeID, sym, side from .mem.ktrade
63 1424

q)a~/:(b;c)
11b
```

As before, we see a modest improvement in runtime if our goal is to return an unkeyed table. However, if we want to return the data keyed, as it was in the original table, the performance improvement is approximately 3×. In both cases we cut memory usage in half.


### Efficient querying of partitioned on-disk data

A basic but incredibly important consideration when operating on a large dataset is the ordering of the Where clause which will be used to extract the data required from a table. An efficiently ordered Where clause that exploits the partitioned structure of a database or its attributes can make a query orders of magnitude faster.

The following code illustrates how efficient construction of a Where clause in a partitioned database, by filtering for the partition column first, can lead to superior results.

```q
q)select from .par.trade where date = last date, ts > 50
date       sym  dt                            tp       ts side 
-------------------------------------------------------------- 
2014.02.23 AAPL 2014.02.23D09:00:15.613542722 527.0524 52 Buy 
2014.02.23 AAPL 2014.02.23D09:00:33.319332489 526.9366 53 Sell 
2014.02.23 AAPL 2014.02.23D09:00:42.741552220 527.0334 70 Buy 
2014.02.23 AAPL 2014.02.23D09:00:45.434857198 526.9292 70 Buy 
2014.02.23 AAPL 2014.02.23D09:00:50.608371516 527.0314 63 Sell

q)\ts select from .par.trade where date = last date, ts > 50 
47 20973216

q)\ts select from .par.trade where ts > 50, date = last date 
1822 169872240
```

The date parameter in the above example can also be modified within the select statement while still providing a performance improvement. For example, we could use the [`mod`](../ref/mod.md) keyword to obtain data for one particular day of the week, or a [Cast](../ref/cast.md) to get the data for an entire month. The key to applying these functions properly is ensuring that the virtual date column is the first parameter in the first element of the Where clause; this can be confirmed by looking at the parse tree created by the select statement.

```q
// select all the data for February 2014
q)select from .par.trade where date.month = 2014.02m
date       sym  dt                            tp       ts side 
--------------------------------------------------------------
2014.02.19 AAPL 2014.02.19D09:00:00.627678019 509.4149 18 Buy
2014.02.19 AAPL 2014.02.19D09:00:02.227734720 509.4179 42 Sell
2014.02.19 AAPL 2014.02.19D09:00:03.376288471 509.4192 19 Sell
2014.02.19 AAPL 2014.02.19D09:00:03.714012114 509.42   12 Sell
2014.02.19 AAPL 2014.02.19D09:00:13.403248267 509.4331 57 Sell
..

q)\ts select from .par.trade where date.month = 2014.02m 
93 322964016

q)parse "select from .par.trade where date.month=2014.02m" 
?
`.par.trade
,,(=;`date.month;2014.02m)
0b 
()
```

The parse tree above shows how a query is broken down to be executed by the q interpreter. 

item                           | role
-------------------------------|-------------------------------
`?`                            | `select` or `exec` statement
`` `.par.trade``               | table we are selecting from
``,,(=;`date.month;2014.02m)`` | Where clause
`0b`                           | By clause: `0b` is none
`()`                           | columns to select: `()` means all


This pattern is the same as that used in the functional forms of `select` or `exec`.

:fontawesome-regular-hand-point-right:
Basics: [Functional q-SQL](../basics/funsql.md)  
_Q for Mortals_: [§9.12 Functional Forms](/q4m3/9_Queries_q-sql/#912-functional-forms)

The key to this query working efficiently is ensuring that `date.month` is the first element in the Where clause of the parsed query.


## Joins


One of the most powerful aspects of kdb+ is that it comes equipped with a large variety of join operators for enriching datasets. These operators may be divided into two distinct types, timeseries joins and non-timeseries joins. In this section we will focus on optimal use of three of the most commonly-used timeseries join operators, `aj` and `wj`, and the non-timeseries join `lj`.

:fontawesome-regular-hand-point-right:
Basics: [Joins](../basics/joins.md)

The majority of joins in a kdb+ database should be performed implicitly by foreign keys and linked columns, permanent relationships defined between tables in a database. These provide a performance advantage over the standard joins and should be used where appropriate.

:fontawesome-regular-hand-point-right:
White paper: [The application of foreign keys and linked columns in kdb+](foreign-keys.md)


### Left joins

The left join `lj` is one of the most common, important and widely used joins in kdb+. It is used to join two tables based on the key columns of the table in the second argument. If the key columns in the second table are unique it will perform an operation similar to a left outer join in standard SQL. However, if the keys in the second table are not unique, it will look up the first value only. If there is a row in the first table which has no corresponding row in the second table, a null record will be added in the resulting table.

The example below illustrates a simple left join which is used to add reference data to our quote table. First we define a table `.mem.ref`, keyed on symbol, with some market information as the value. The `lj` joins this market information to the `.mem.trade` table, returning the result. 

```q
q).mem.ref:([sym:exec distinct sym from .mem.trade]; mkt:100?`n`a`l) 
q).mem.quote lj .mem.ref
sym  dt                            ap       as bp       bs mkt 
--------------------------------------------------------------
AAPL 2014.02.23D09:00:00.117540266 544.0444 27 543.9356 56 n 
AAPL 2014.02.23D09:00:00.770298577 544.0431 57 543.9343 68 n 
AAPL 2014.02.23D09:00:01.014678832 544.043  77 543.9342 96 n 
AAPL 2014.02.23D09:00:03.650976810 544.0455 12 543.9367 48 n 
..
```

In our second example we see that when there are duplicate keys in the second table only the first value corresponding to that key is used in the join.

```q
q).mem.ref2:update sym:`AAPL from .mem.ref1 where 0 = i mod 2 
q).mem.ref2
sym | mkt
----| ---
AAPL| n
ACJ | n
AAPL| l
AHF | a
AAPL| l
..
q)select firstMkt:first mkt, lastMkt:last mkt by sym from .mem.ref2 where sym = `AAPL
sym | firstMkt lastMkt
----| ----------------
AAPL| n        l

q).mem.quote lj .mem.ref2
sym  dt                            ap       as bp       bs mkt 
--------------------------------------------------------------
AAPL 2014.02.23D09:00:00.117540266 544.0444 27 543.9356 56 n 
AAPL 2014.02.23D09:00:00.770298577 544.0431 57 543.9343 68 n 
AAPL 2014.02.23D09:00:01.014678832 544.043  77 543.9342 96 n 
AAPL 2014.02.23D09:00:03.650976810 544.0455 12 543.9367 48 n 
AAPL 2014.02.23D09:00:06.727747153 544.0471 81 543.9383 50 n
```

The left join is built into `dict,keyedTab` and `tab,\:keyedTab` (since V2.7). `lj` has been updated (since V3.0) to use this form inside a `.Q.ft` wrapper to allow the table being joined to be keyed. `.Q.ft` will unkey the table, run the left join, and then rekey the result.

<!-- 
Between V2.7 and V3.0 there is an approximately 2× performance improvement when joining a keyed table to a table, and approximately 5× improvement when joining a keyed table to a dictionary using the `,\:` construct over the earlier implementation of `lj`.
 -->


### Window joins

`wj` and `wj1` are the most general forms of timeseries joins. They aggregate over all the values in specified columns for a given time interval. `wj1` differs from `wj` in that it only considers values from within the given time period, whereas `wj` will also consider the currently prevailing values.

In the example below `wj` calculates the minimum ask price and maximum bid price in the second table, `.mem.quote`, based on the time windows `w`; in this case the values just before and after a trade is executed in `.mem.trade`.

```q
// Define the time windows to aggregate over
q)w:-2 1+\:exec dt from .mem.trade where sym = `AAPL

q)w
2014.02.23D09:00:00.118540264 2014.02.23D09:00:22.930035590 
2014.02.23D09:00:00.118540267 2014.02.23D09:00:22.930035593

// calculate the min ask price and max bp for each time window and join to the trade table
q)wj[w; `sym`dt; select from .mem.trade where sym = `AAPL; (.mem.quote; (min; `ap); (max; `bp))]
sym  dt                            tp       ts side ap       bp 
--------------------------------------------------------------------- 
AAPL 2014.02.23D09:00:00.118540266 544.0444 27 Sell 544.0444 543.9356 
AAPL 2014.02.23D09:00:22.930035592 544.0437 55 Sell 544.0437 543.9349 
AAPL 2014.02.23D09:00:25.852858872 544.0401 88 Buy  544.0401 543.9313 
AAPL 2014.02.23D09:00:35.654202142 543.9216 12 Sell 544.0304 543.9216 
AAPL 2014.02.23D09:00:42.274095995 543.9134 40 Buy  544.0222 543.9134 
..

q)\ts wj[w; `sym`dt; select from .mem.trade where sym = `AAPL; (.mem.quote; (min; `ap); (max; `bp))]
9 207696

q)w:-2 1+\:.mem.trade.dt

q)\ts wj[w; `sym`dt; .mem.trade; (.mem.quote; (min; `ap); (max; `bp))] 
485 14898368
```

`wj` can also be used to run aggregations efficiently on splayed or partitioned data.

```q
// define an aggregation window from this trade back to the previous one
q)w:value flip select dt^prev dt,dt from .par.trade where date=max date, sym=`AAPL

// calculate max and min values between two trades
q)t:select from .par.trade where date = max date, sym = `AAPL
q)q:select from .par.quote where date = max date
q)wj[w; `sym`dt; t; (q; (min; `ap); (max; `bp))]
date       sym  dt                            tp       ts side ap       bp
--------------------------------------------------------------------------
2014.02.23 AAPL 2014.02.23D09:00:01.606196483 527.0609 43 Sell 527.0609 526.9555
2014.02.23 AAPL 2014.02.23D09:00:02.905704958 527.0586 12 Buy 527.0609  526.9555
2014.02.23 AAPL 2014.02.23D09:00:14.610539881 526.9486 33 Buy 527.0597  526.9543
..
```

`wj` can be useful for finding max and min values in a given timeframe as shown above, however in most situations it is preferable to use an as-of join or a combination of as-of joins.


### As-of joins

[`aj`and `aj0`](../ref/aj.md) are simpler versions of `wj`. They return the last value from the given time interval rather than the results from an arbitrary aggregation function. `aj` displays the time column from the first table in its result, whereas `aj0` uses the column from the second table.

If a table has either a grouped or parted attribute on its sym column, as is the case for all of the tables in our sample database, it will likely be a good candidate for an as-of join, which we would expect to give constant time performance. However it is important to realize that only the attributes on the first column in an as-of join will be used, therefore it is rarely a good idea to use an `aj` on more than two columns. If there is no attribute on the data being joined, or there is a need to apply extra constraints we will expect a linear runtime and a select statement will in most cases be more appropriate.

As we can see in the results below, our second as-of join without the
attribute is four orders of magnitude slower than the first join and
used an order of magnitude more memory.

```q
q)meta .mem.quote
c  | t f a
---| ----- 
sym| s g
dt | p
ap | f
as | j
bp | f
bs | j

q)\ts aj[`sym`dt; select from .mem.trade where sym = `AAPL; .mem.quote] 
2 150848

q)update sym:reverse reverse sym from `.mem.quote 
`.mem.quote

q)meta .mem.quote c |tfa
---| -----
sym| s
dt | p
ap | f
as | j
bp | f
bs | j

q)\ts aj[`sym`dt; select from .mem.trade where sym = `AAPL; .mem.quote] 
11393 2442416
```

An as-of join can also be performed directly on memory-mapped data without having to read the entire files. It is important to take advantage of this by only reading the data needed into memory, rather than performing further restrictions in the Where clause, as this will result in a subset of the data being copied into memory and greatly increase the runtime despite working with a smaller dataset.

```q
q)t:select from .par.trade where date = max date, sym = `AAPL
q)q:select from .par.quote where date = .z.d
q)select sym, dt, ap, bp, tp from aj[`sym`dt; t; q]
sym  dt                            ap       bp       tp 
-------------------------------------------------------------
AAPL 2014.02.23D09:00:01.606196483 527.0609 526.9555 527.0609 
AAPL 2014.02.23D09:00:02.905704958 527.0586 526.9532 527.0586 
AAPL 2014.02.23D09:00:14.610539881 527.054  526.9486 526.9486 
AAPL 2014.02.23D09:00:15.613542722 527.0524 526.947  527.0524 
AAPL 2014.02.23D09:00:25.251668544 527.0447 526.9393 526.9393 
AAPL 2014.02.23D09:00:28.020791189 527.0443 526.9389 526.9389 
AAPL 2014.02.23D09:00:32.284428963 527.0435 526.9381 527.0435 
AAPL 2014.02.23D09:00:33.319332489 527.042  526.9366 526.9366 
AAPL 2014.02.23D09:00:33.863122707 527.0424 526.937  527.0424 
AAPL 2014.02.23D09:00:34.584276510 527.0417 526.9363 527.0417 
..

q)\ts aj[`sym`dt; select from .par.trade where date = .z.D, sym = `AAPL; select from .par.quote where date = max date]
24 68438016

q)\ts aj[`sym`dt; select from .par.trade where date = .z.D, sym = `AAPL; select from .par.quote where date = max date, sym = `AAPL]
4696 8193984
```



## Conclusion

This paper looked at how to take advantage of multiple kdb+ query structures  to achieve optimal query performance for large volumes of data. It focused on making efficient changes to standard select statements for both on-disk and in-memory databases, illustrating how they can provide both flexibility and performance within a database. 

It also considered joins, in particular the left join, window join and as-of join, which allow us to perform large-scale analysis on in-memory and on-disk tables. The performance and flexibility of user queries and timeseries joins are some of the main reasons why kdb+ is such an effective tool for the analysis of large-scale timeseries data. The efficient application of these tools is vital for any kdb+ enterprise system.

All tests were run using kdb+ 3.1 (2013.12.27)


## Author

**Ian Lester** is a financial engineer who has worked as a consultant for some of the world’s largest financial institutions. Based in New York, Ian is currently working on a trading application at a US investment bank.


[:fontawesome-solid-print: PDF](/download/wp/kdb_query_scaling.pdf)