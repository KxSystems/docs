---
title: Performance tips
description: Tips on improving the performance of kdb+ processes
keywords: kdb+, performance, q
---
# Performance tips





## How do I execute functions in parallel?

In the expression `f each xs`, `f` is applied to each element of `xs` in sequence. In a multi-CPU setting, applications of `f` can be done in parallel by using `peach` instead of `each`. Typically this is worth it if `f` is computationally expensive.


## Evaluating a hardware configuration

The scripts `throughput.q` and `io.q` are a useful starting point for users wanting to measure the performance of the systems where kdb+ will be deployed. The results of these (somewhat rough) tests can be used to stress-test different CPU, disk and network configurations running kdb+. 

<i class="fab fa-github"></i> [simongarland/io](https://github.com/simongarland/io)


### Throughput

This test measures the time to insert a million rows into a table, one at a time, and also as bulk inserts of 10, 100, 1000, and 10000 rows.

To run the test, simply load it into a q session:

```bash
$ q throughput.q
```

On an AMD Opteron box with 4 GB of RAM, we get

```txt
0.672 million inserts per second (single insert)
6.944 million inserts per second (bulk insert 10)
20.408 million inserts per second (bulk insert 100)
24.39 million inserts per second (bulk insert 1000)
25 million inserts per second (bulk insert 10000)
```

On an AMD Turion64 laptop with 0.5 GB of RAM,

```txt
0.928 million inserts per second (single insert)
8.065 million inserts per second (bulk insert 10)
16.129 million inserts per second (bulk insert 100)
16.129 million inserts per second (bulk insert 1000)
16.129 million inserts per second (bulk insert 10000)
```

The complete code of this benchmark is as follows:

```q
\l trade.q
STDOUT:-1
tmp:STDOUT""
show trade
tmp:STDOUT""
t1:trade 0
t10:10#trade
t100:100#trade
t1000:1000#trade
t10000:10000#trade

tmp:value"\\t do[1000000;trade,:t1]" / prepare space

trade:0#trade
ms:value"\\t do[1000000;trade,:t1]"
tmp:STDOUT(string 0.001*floor 0.5+(count trade)%ms)," million inserts per second (single insert)"

trade:0#trade
ms:value"\\t do[100000;trade,:t10]"
tmp:STDOUT(string 0.001*floor 0.5+(count trade)%ms)," million inserts per second (bulk insert 10)"

trade:0#trade
ms:value"\\t do[10000;trade,:t100]"
tmp:STDOUT(string 0.001*floor 0.5+(count trade)%ms)," million inserts per second (bulk insert 100)"

trade:0#trade
ms:value"\\t do[1000;trade,:t1000]"
tmp:STDOUT(string 0.001*floor 0.5+(count trade)%ms)," million inserts per second (bulk insert 1000)"

trade:0#trade
ms:value"\\t do[100;trade,:t10000]"
tmp:STDOUT(string 0.001*floor 0.5+(count trade)%ms)," million inserts per second (bulk insert 10000)"
```


### Disk input/output

This test measures the cost of disk access from kdb+. Things that are measured include: open and close of a file; read files (cold and in the cache); write files; appends; getting the size of a file; etc.

The benchmark first creates the test files, and then does something else for a while to get them out of the cache.

```bash
$ q io.q -prepare
```

```q
KDB+ 2.4t 2006.09.29 Copyright (C) 1993-2006 Kx Systems
l64/ 4cpu 3943MB ...

start local q server with: q -p 5555
tmpfiles created
```

Next we need to start a second kdb+ process.

```bash
$ q -p 5555
```

Now we can run the benchmark.

```bash
$ q io.q -flush 32 -run
```

On an AMD Opteron box with 4 GB of RAM, we get:

```txt
memory flushed (32GB)

* local file
hclose hopen`:read.test 0.0094 ms
read `:read.test - 270 MB/sec
read `:read.test - 392 MB/sec (cached)
write `:write.test - 157 MB/sec
* local fileops
.[`:file.test;();,;2 3] 0.017 ms
.[`:file.test;();:;2 3] 0.093 ms
append (2 3) to handle 0.00883 ms
hcount`:file.test 0.0053 ms
read1`:file.test 2.1732 ms
value`:file.test 0.0251 ms
* local comm
hclose hopen`:127.0.0.1:5555 0.135 ms
sync (key rand 100) 0.06277 ms
async (string 23);collect 0.00773 ms
sync (string 23) 0.05514 ms
```

Finally, we can clean up the temporary files.

```bash
$ q io.q -cleanup

tmpfiles deleted
```


### Command-line arguments

```txt
q io.q [-run] [-prepare] [-cleanup] [-flush memsizeingb] [-rl remotelocation] [-rh remotehost] / hardware timings

eg: q io.q -prepare -rl /mnt/foo
    q io.q -flush 32 -run -rl /mnt/foo -rh server19:5005
    q io.q -cleanup -rl /mnt/foo
```

If remote host/location aren’t supplied only local tests will be run.

The local and remote q servers must be started manually.


## Performance of different versions of insert

There are several syntactic forms to insert rows into tables, with different costs. We demonstrate the differences.

In the examples, we use a non-keyed table.

```q
q)trade
date       open  high  low   close volume   sym
------------------------------------------------
2006.10.03 24.5  24.51 23.79 24.13 19087300 AMD
2006.10.03 27.37 27.48 27.21 27.37 39386200 MSFT
q)row: first trade
```

In our first test, we use `insert`.

```q
q)load `:trade
q)row: first trade
q)\t do[1000000; insert[`trade; row]]
1968
```

Next we test the version that uses the dot notation.

```q
q)load `:trade
q)row: first trade
q)\t do[1000000; .[`trade; (); ,; row]]
1890
```

Those two can take the table as a parameter. If the table is known, we can also use the Amend operator, which is faster:

```q
q)load `:trade
q)row: first trade
q)\t do[1000000; trade,: row]
1718
```

!!! note "Differences between versions"
    
    The result of this comparison might vary between different versions of kdb+. The tests shown above are for V2.4t.

Finally, remember that bulk insert is faster than repeated inserts of single rows:

```q
q)load `:trade
q)row: first trade
q)rows: 1000000 # enlist row
q)\t insert[`trade; rows]
109

q)load `:trade
q)\t .[`trade; (); ,; rows]
78

q)load `:trade
q)\t trade,: rows
78
```


## Using the `` `g#`` attribute

This recipe demonstrates the use of the `` `g#`` attribute to improve performance of queries. The test is as follows: given 10 million trades and 10 million quotes, how long does it take to snapshot price, bid, ask, mid for the SP500 at some prior time?

The tables can be set up like this:

```q
q)n:10000000
q)s:`$read0`:tick/sp500.txt
q)S:s,-7500?`4 / 8000 symbols
q)t:{09:30:00.0+floor 23400000%x%til x} / milliseconds from 9:30 to 16:00
q)trade:([]sym:n?S;time:t n;price:n?100.0;ox:n?2) / 10 million trades
q)quote:([]sym:n?S;time:t n;bid:n?100.0;ask:n?100.0) / 10 million quotes

q)r:first s / sample ric
q)t:12:00:00.0 / sample time
```

The test queries and their running times are as follows:

```q
q)\t select last sym,last price from trade where sym=r,ox=1,time<=t
84
q)\t select from trade where sym=r,ox=1,time=time time bin t
84
```

Now, let’s apply the attribute to the `sym` column:

```q
q)update `g#sym from `trade
q)update `g#sym from `quote
```

The queries now run faster.

```q
q)\t select last sym,last price from trade where sym=r,ox=1,time<=t
0
q)\t select from trade where sym=r,ox=1,time=time time bin t
0
```

In fact, we need to run them many times to get a measurable time:

```q
q)n:1000
q)\t do[n;select last sym,last price from trade where sym=r,ox=1,time<=t]
78
q)\t select from trade where sym=r,ox=1,time=time time bin t
83
```


## STAC-M3 benchmark

[STAC-M3](http://www.stacresearch.com/m3) is an independent benchmark for testing solutions (such as kdb+) that manage large timeseries datasets (tick databases). This has been run using kdb+ on several platforms. The [results](http://www.stacresearch.com/kx) are available to registered STAC users.

These benchmarks are run on a year of daily NYSE TAQ-like data, approximately 5 TB in total. They use a series of up to 20 complex queries that were defined by financial institutions to reflect real business requirements. The benchmarks enable users and vendors to compare the performance of their database solutions against audited, third-party measurements.

