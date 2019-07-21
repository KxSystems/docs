---
title: Programming idioms
description: Q expressions that solve some common programming problems.
keywords: idiom, kdb+, programming, q
---
# Programming idioms




Q expressions that solve some common programming problems.


## How do I select all the columns of a table except one?

If the table has many columns, it is tedious and error-prone to write

```q
q)select c1,c2,... from t
```

In q we can write

```q
q)delete somecolumn from t
```

Here, delete does not modify the table `t` in place.

!!! warning "Watch out"

    `delete` does not work on historical databases.


## How do I select a range of rows in a table by position?

You can use the row index `i`.

```q
q)select from tab where i within 42 57
```


## How do I extract the milliseconds from a time?

Given

```q
q)time: 09:10:52.139
```

we can extract hour, minute and second like this

```q
q)(time.hh; time.mm; time.ss)
9 10 52
```

To query the milliseconds

```q
q)time mod 1000
139
```


## How do I populate a table with random data?

This is useful for testing. The `?` operator can be used to generate random values of a given type.

```q
q)n:1000
q)stocks:`goog`amzn`msft`intel`amd`ibm
q)trade:([]stock:n?stocks; price:n?100.0;amount:100*10+n?20;time:n?24:00:00.000)
q)trade
stock price     amount time
-----------------------------------
ibm   94.1497   2800   10:45:14.943
amzn  96.1774   2800   03:17:33.371
ibm   3.95321   2200   04:53:09.818
goog  11.10307  1000   19:27:15.894
msft  64.73216  1900   17:32:42.558
intel 19.51964  2600   05:05:58.680
ibm   10.18318  1000   05:47:46.437
...
```


## How do I get the hourly lowest and highest price?

This query

```q
q)select price by stock,time.hh from trade
```

groups the prices hourly by stock

```q
stock hh| price                                                              ..
--------| -------------------------------------------------------------------..
amd   0 | 76.03805 3.632539 16.6526 77.27191 79.27451 7.501845               ..
amd   1 | 16.35361 85.9618 27.60804 61.91134 6.921016 84.99082 50.05533 81.10..
amd   2 | 47.61621 15.33209 23.64018 88.34472                                ..
...
```

The `price` column is a list. To get the low and high prices, we need to apply list functions that produce that result:

```q
q)select low: min price,high: max price by stock,time.hh from trade
stock hh| low       high
--------| ------------------
amd   0 | 3.632539  79.27451
amd   1 | 6.921016  85.9618
amd   2 | 15.33209  88.34472
...
```


## How can I extract the time of the lowest and highest prices?

This query makes use of `where` to extract the time matching the high/low prices:

```q
q)t: `time xasc ([] time:09:30:00.0+100000?23000000; sym:100000?`AAPL`GOOG`IBM; price:50+(floor (100000?0.99)*100)%100)
q)select high:max price,low:min price,time_high:first time where price=max price,time_low:first time where price=min price by sym,time.hh from t
sym  hh| high  low time_high    time_low    
-------| -----------------------------------
AAPL 9 | 50.98 50  09:31:01.254 09:32:19.141
AAPL 10| 50.98 50  10:01:24.975 10:04:21.228
AAPL 11| 50.98 50  11:00:04.438 11:00:19.517
AAPL 12| 50.98 50  12:01:24.891 12:01:09.768
AAPL 13| 50.98 50  13:00:35.044 13:01:15.162
AAPL 14| 50.98 50  14:02:37.634 14:01:06.998
AAPL 15| 50.98 50  15:00:42.958 15:01:24.288
GOOG 9 | 50.98 50  09:30:21.404 09:30:12.264
..
```


## How do I extract regular time series from observed quotes?

Given this table containing observed quotes:

```q
q)t: `time xasc ([] time:09:30:00.0+100000?23000000; sym:100000?`AAPL`GOOG`IBM; bid:50+(floor (100000?0.99)*100)%100; ask:51+(floor (100000?0.99)*100)%100);
q)t
time         sym  bid   ask  
-----------------------------
09:30:00.143 IBM  50.75 51.09
09:30:00.192 IBM  50.03 51.56
09:30:00.507 GOOG 50.23 51.47
09:30:00.540 IBM  50.49 51.22
..
```

We can extract the last observation of each ‘second’ time period:

```q
q)`second xasc select last bid,last last ask by sym,1 xbar time.second from select from t
sym  second  | bid   ask  
-------------| -----------
AAPL 09:30:00| 50.45 51.4 
GOOG 09:30:00| 50.43 51.04
IBM  09:30:00| 50.49 51.22
AAPL 09:30:01| 50.68 51.11
..
```

However this solution will skip periods where there were no observations. 
For example, in the table generated for this document there were no observations for AAPL and IBM at 09:30:03:

```q
..
IBM  09:30:02| 50.39 51.15
GOOG 09:30:03| 50.26 51.94
AAPL 09:30:04| 50.13 51.66
GOOG 09:30:04| 50.07 51.62
IBM  09:30:04| 50.61 51.14
..
```

A better solution would be to use `aj`:

```q
q)res: aj[`sym`time;([]sym:`AAPL`IBM`GOOG) cross ([]time:09:30:00+til `int$(16:00:00 - 09:30:00)); select `second$time,sym,bid,ask from t]
q)`time xasc res
sym  time     bid   ask  
-------------------------
AAPL 09:30:00 50.45 51.4 
IBM  09:30:00 50.49 51.22
GOOG 09:30:00 50.43 51.04
AAPL 09:30:01 50.68 51.11
IBM  09:30:01 50.2  51.48
GOOG 09:30:01 50.59 51.72
AAPL 09:30:02 50.3  51.54
IBM  09:30:02 50.39 51.15
GOOG 09:30:02 50.74 51.09
AAPL 09:30:03 50.3  51.54
IBM  09:30:03 50.39 51.15
GOOG 09:30:03 50.26 51.94
AAPL 09:30:04 50.13 51.66
IBM  09:30:04 50.61 51.14
GOOG 09:30:04 50.07 51.62
..
```

When a millisecond resolution is required, this solution might offer better performances:

```q
q)aapl:select from t where sym=`AAPL
q)res:([]time),'(`bid`ask#aapl) -1+where deltas @[;count[d]-1;:;count time]d:(time:09:30:00.0+til`int$10:00:00.0-09:30:00.0) bin aapl`time
q)select from res where time>09:31:00
time         bid   ask  
------------------------
09:31:00.001 50.41 51.13
09:31:00.002 50.41 51.13
09:31:00.003 50.41 51.13
09:31:00.004 50.41 51.13
09:31:00.005 50.41 51.13
..
```


## How do I select the last n observations for each sym?

A couple of solutions using the same table than in the previous examples:

```q
q)ungroup select sym,-3#'time,-3#'bid,-3#'ask from select time,bid,ask by sym from t where time<15:00:00
sym  time         bid   ask  
-----------------------------
AAPL 14:59:58.564 50.94 51.28
AAPL 14:59:59.450 50.54 51.17
AAPL 14:59:59.650 50.42 51.87
GOOG 14:59:59.159 50.42 51.41
GOOG 14:59:59.302 50.52 51.66
GOOG 14:59:59.742 50.52 51.25
IBM  14:59:56.439 50.01 51.81
IBM  14:59:56.556 50.38 51.33
IBM  14:59:57.116 50.96 51.45
q)select sym,time,bid,ask from t where time<15:00:00,3>(idesc;i) fby sym
sym  time         bid   ask  
-----------------------------
IBM  14:59:56.439 50.01 51.81
IBM  14:59:56.556 50.38 51.33
IBM  14:59:57.116 50.96 51.45
AAPL 14:59:58.564 50.94 51.28
GOOG 14:59:59.159 50.42 51.41
GOOG 14:59:59.302 50.52 51.66
AAPL 14:59:59.450 50.54 51.17
AAPL 14:59:59.650 50.42 51.87
GOOG 14:59:59.742 50.52 51.25
```


## How do I calculate vwap series?

Use `xbar` and `wavg`:

```q
q)t: `time xasc ([] time:09:30:00.0+100000?23000000; sym:100000?`AAPL`GOOG`IBM; price:50+(floor (100000?0.99)*100)%100; size:10*100000?100);
q)aapl: select from t where sym=`AAPL,size>0
q)select vwap:size wavg price by 5 xbar time.minute from aapl 
minute| vwap     
------| ---------
09:30 | 50.474908
09:35 | 50.461356
09:40 | 50.46645 
09:45 | 50.493585
09:50 | 50.48062 
..
```

<i class="far fa-hand-point-right"></i> _Q for Mortals_ [§9.13.4 Meaty Queries](/q4m3/9_Queries_q-sql/#9134-meaty-queries)


## How do I extract regular-size vwap series?

One quick solution is to use xbar with the running size sum to average the wanted periods:

```q
q)t:`time xasc ([]time:N?.z.t;price:0.01*floor 100*10 + N?1.0;size:N?500)
q)select time:last time ,vwap: size wavg price by g:1000 xbar sums size from t
g    | time         vwap     
-----| ----------------------
0    | 00:41:19.862 10.771082
1000 | 01:25:20.920 10.656847
2000 | 02:15:20.433 10.522944
3000 | 02:35:18.721 10.295203
4000 | 02:58:30.142 10.320519
5000 | 05:54:20.645 10.564838
..
```

However this solution approximates regular trade series: the last trade of each period can overflow the requested size (1000 in the examples) and the overflowing amount will not be used in the following period. 
This query highlights the problem:

```q
q)update total:sum each size from select time:last time,vwap: size wavg price,size by g:1000 xbar sums size from t
g    | time         vwap      size                  total
-----| --------------------------------------------------
0    | 00:41:19.862 10.771082 409 297 80 59 116     961  
1000 | 01:25:20.920 10.656847 126 451 244 149 29    999  
2000 | 02:15:20.433 10.522944 85 417 107 50         659  
3000 | 02:35:18.721 10.295203 422 477 477           1376 
4000 | 02:58:30.142 10.320519 408 19 305            732  
5000 | 05:54:20.645 10.564838 406 277 58 106 323    1170 
..
```

A more precise (and elaborate) solution consist of splitting the edge trades into two parts so that each size bar sum up to the requested even amount:

```q
rvwap : { [t;size_par]
 // add the bucket and the total size
 t:update bar:size_par xbar tot from update tot:sums size from t;
 // get the indices where the bar changes
 ind:where differ t`bar;
 // re-index t, and sort (duplicate the rows where the bucket changes)
 t:t asc (til count t),ind;
 // shift all the indices due to the table now being larger
 ind:ind+til count ind;
 // update the size in the first trade of the new window and modify the bar
 t:update size:size-tot-bar,bar:size_par xbar tot-size from t where i in ind;
 // update the size in the second trade of the new window
 t:update size:tot-bar from t where i in 1+ind;
 // calculate stats
 select last time,price:size wavg price,sum size by bar from t
 }

q)rvwap[t;1000]
bar  | time         price    size
-----| --------------------------
0    | 00:44:53.037 10.76246 1000
1000 | 01:29:02.279 10.64794 1000
2000 | 02:25:13.605 10.49144 1000
3000 | 02:52:50.130 10.24878 1000
4000 | 03:11:20.253 10.37125 1000
5000 | 06:01:35.780 10.57725 1000
..
```


## How do I apply a function to a sequence sliding window?

Use the [Scan iterator](../ref/accumulators.md#binary-values) to build a moving list adding one item at the time from the original table, and the [`_` Drop operator](../ref/drop.md) to discard older values.

This example calculates the moving average for a sliding window of 3 items. 
Note how the second parameter sets the size of the sliding window.

```q
q)swin:{[f;w;s] f each { 1_x,y }\[w#0;s]}
q)swin[avg; 3; til 10]
0 0.33333333 1 2 3 4 5 6 7 8
q)// trace the sliding window
q)swin[0N!; 3; til 10]
0 0 0
0 0 1
0 1 2
1 2 3
2 3 4
3 4 5
..
```

A different approach based on [`prev`](../ref/next.md#prev), inserting `0N` at the beginning of the window rather than 0:

```q
q)swin2:fwv:{x/'[flip reverse prev\[y-1;z]]}
q)swin2[avg;3;til 10]
0 0.5 1 2 3 4 5 6 7 8
q)swin2[::;3;til 10]
    0
  0 1
0 1 2
1 2 3
2 3 4
3 4 5
..
```

`swin2:fwv` finds all the windows using `prev` and [Converge](../ref/accumulators.md#converge). To find windows of size 3:

```q
q)prev\[2;x:3 5 7 2 4 3 7]
3 5 7 2 4 3 7
  3 5 7 2 4 3
    3 5 7 2 4
q)flip reverse prev\[2;x]
    3 
  3 5
3 5 7
5 7 2
7 2 4
2 4 3
4 3 7
q)max each flip prev\[2;x]
3 5 7 7 7 4 7
q)(3 mmax x)~max each flip prev\[2;x]
1b
```

A third, more memory efficient function, `m` is:

```q
q)m:{last{(a;x 1;x[2],z y x[1]+a:1+x 0)}[;z;x]/[n:count z;(0-y;til y;())]}
```

For larger windows, time and space may be important...

```q
q)\ts swin[max;1000;10000?10]
71 82473552
q)\ts 1000 mmax 10000?10
76 524592
q)\ts m[max;1000;10000?10]
205 401984
q)\ts fwv[max;1000;10000?10]
491 213061888
```

…c.f. smaller window

```q
q)\ts w mmax v
1 393440
q)\ts fwv[f:max;w:10;v:10000?10]
6 2656576
q)\ts swin[f;w;v]
12 1702416
q)\ts m[f;w;v]
50 262784
```

To index:

```q
q)w:{(til[count z]-m)+x each flip reverse prev\[m:y-1;z]}
q)x w[{x?max x};3;x]
3 5 7 7 7 4 7
```

which is useful for addressing other lists:

```q
q)update top:date w[{x?max x};3;volume] from ([]date:2000.01.01+til 7;volume:x)
date       volume top
----------------------------
2000.01.01 3      2000.01.01
2000.01.02 5      2000.01.02
2000.01.03 7      2000.01.03
2000.01.04 2      2000.01.03
2000.01.05 4      2000.01.03
2000.01.06 3      2000.01.05
2000.01.07 7      2000.01.07
```


## Grouping over non-primary keys

Consider a table with multiple entries for the same value of the stock column.

```q
q)table:([]stock:(); price:())
q)insert[`table; (`ibm`ibm`ibm`ibm`intel`intel`intel`intel; 1 2 3 4 1 2 3 4)]
0 1 2 3 4 5 6 7
q)table
stock price
-----------
ibm   1
ibm   2
ibm   3
ibm   4
intel 1
intel 2
intel 3
intel 4
```

If we `select` and group by stock ...

```q
q)select by stock from table
stock| price
-----| -----
ibm  | 4
intel| 4
```

… only the last price is in the result.

What if we want the first price? We reverse the table.

```q
q)select by stock from reverse table
stock| price
-----| -----
ibm  | 1
intel| 1
```

What if we want all the prices as a list? We use `xgroup`.

```q
q)`stock xgroup table
stock| price
-----| -------
ibm  | 1 2 3 4
intel| 1 2 3 4
```


## Getting the contents of the columns of a table

Imagine that we want to save a CSV file without the first row that contains the names of the table columns. 
This can be done by extracting the columns from a table, without the row name, and then saving in CSV format.

Here, we assume that tables are not keyed. We’ll use this table as our example:

```q
q)trade
date       open  high  low   close volume   sym
------------------------------------------------
2006.10.03 24.5  24.51 23.79 24.13 19087300 AMD
2006.10.03 27.37 27.48 27.21 27.37 39386200 MSFT
2006.10.04 24.1  25.1  23.95 25.03 17869600 AMD
2006.10.04 27.39 27.96 27.37 27.94 82191200 MSFT
2006.10.05 24.8  25.24 24.6  25.11 17304500 AMD
2006.10.05 27.92 28.11 27.78 27.92 81967200 MSFT
2006.10.06 24.66 24.8  23.96 24.01 17299800 AMD
2006.10.06 27.76 28    27.65 27.87 36452200 MSFT
```

There are two ways of extracting columns from a table. The first one uses indexing by the column names:

```q
q)cols trade
`date`open`high`low`close`volume`sym
q)trade (cols trade)
2006.10.03 2006.10.03 2006.10.04 2006.10.04 2006.10.05 2006.10.05 2006.10.06 ..
24.5       27.37      24.1       27.39      24.8       27.92      24.66      ..
24.51      27.48      25.1       27.96      25.24      28.11      24.8       ..
23.79      27.21      23.95      27.37      24.6       27.78      23.96      ..
24.13      27.37      25.03      27.94      25.11      27.92      24.01      ..
19087300   39386200   17869600   82191200   17304500   81967200   17299800   ..
AMD        MSFT       AMD        MSFT       AMD        MSFT       AMD        ..
```

The second one turns the table into a dictionary and then gets the values

```q
q)value flip trade
2006.10.03 2006.10.03 2006.10.04 2006.10.04 2006.10.05 2006.10.05 2006.10.06 ..
24.5       27.37      24.1       27.39      24.8       27.92      24.66      ..
24.51      27.48      25.1       27.96      25.24      28.11      24.8       ..
23.79      27.21      23.95      27.37      24.6       27.78      23.96      ..
24.13      27.37      25.03      27.94      25.11      27.92      24.01      ..
19087300   39386200   17869600   82191200   17304500   81967200   17299800   ..
AMD        MSFT       AMD        MSFT       AMD        MSFT       AMD        ..
```

Now we can save in CSV format without the column names:

```q
q)t: trade (cols trade)
q)save `:t.csv
`:t.csv
q)\cat t.csv
"2006-10-03,24.5,24.51,23.79,24.13,19087300,AMD"
"2006-10-03,27.37,27.48,27.21,27.37,39386200,MSFT"
"2006-10-04,24.1,25.1,23.95,25.03,17869600,AMD"
...
```

Using `flip` is more efficient (constant time):

```q
q)\t do[1000000; value flip trade]
453
q)\t do[1000000; trade (cols trade)]
2984
```

However, for splayed tables, only indexing works:

```dos
C:\>.\q.exe dir
KDB+ 2.4t 2006.07.27 Copyright (C) 1993-2006 Kx Systems
w32/ 1cpu 384MB ...
```
```q
q)\v
`s#`sym`trade
q)trade (cols trade)
2006.10.03 2006.10.03 2006.10.04 2006.10.04 2006.10.05 2006.10.05 2006.10.06 ..
24.5       27.37      24.1       27.39      24.8       27.92      24.66      ..
24.51      27.48      25.1       27.96      25.24      28.11      24.8       ..
23.79      27.21      23.95      27.37      24.6       27.78      23.96      ..
24.13      27.37      25.03      27.94      25.11      27.92      24.01      ..
19087300   39386200   17869600   82191200   17304500   81967200   17299800   ..
AMD        MSFT       AMD        MSFT       AMD        MSFT       AMD        ..
q)value flip trade
`:trade/
```


## Column names as parameters to functions

Column names cannot be arguments to parameterized queries. 
A type error is signalled when a query like that is applied:

```q
q)f:{[tbl; col; amt] select from tbl where col > amt}
q)f[trade][`volume][10000]
{[tbl; col; amt] select from tbl where col > amt}
'type
```

However, a query can also be built from a string. 
This allows column names to be used as query parameters. 
The above parameterized query can be written using strings:

```q
q)f:{[tbl; col; amt] value "select from ", (string tbl), " where ", (string col), " > ", string amt}
q)f[`trade][`volume][10000]
date       open  high  low   close volume   sym
------------------------------------------------
2006.10.03 24.5  24.51 23.79 24.13 19087300 AMD
2006.10.03 27.37 27.48 27.21 27.37 39386200 MSFT
...
```

Executing queries built from strings has a performance penalty.

```q
q)\t do[100000; select from table where volume > 10000]
234
q)\t do[100000; value "select from ", (string `trade), " where ", (string `volume), " > ", string 10000]
1250
```

An alternative to building queries by concatenating strings is to use [parse trees](../basics/parsetrees.md). 

```q
q)f:{[tbl;col;amt] ?[tbl; enlist (>;col;amt); 0b; ()]}
q)f[trade; `volume; 10000]
date       open  high  low   close volume   sym
------------------------------------------------
2006.10.03 24.5  24.51 23.79 24.13 19087300 AMD
2006.10.03 27.37 27.48 27.21 27.37 39386200 MSFT
```

This is more efficient than using strings:

```q
q)\t do[100000; ?[trade; enlist (>;`volume;10000); 0b; ()]]
312
```

!!! note 

    When `f` builds the query from 

    -   strings, `tbl` is passed by reference, e.g. `` `trade``
    -   parse trees, `tbl` is passed by value, e.g. `trade`

    <i class="far fa-hand-point-right"></i> [Glossary](../basics/glossary.md#reference-pass-by) for passing by reference and value
