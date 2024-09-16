---
title: Building real-time tick engines | kdb+ and q documentation
description: How to build a custom real-time tick engine
author: Nathan Perrem
date: August 2014
keywords: kdb+, q, real-time, subscribe, tick
---
# Building real-time engines

## The kdb+tick environment

The use of real-time engines (RTEs) within a [tick environment](../../architecture/index.md) provides the ability to enrich it further with real-time custom analytics and alerts. A tick environment can have one or many optional RTEs subscribing to the real-time data being generated from the tickerplant (TP).

A RTE can subscribe to all or a subset of the data provided by a TP. The data stored with an RTE can be as little as only that required to hold the latest calculated result (or send an alert), resulting in a very low utilization of resources.

The [RDB](../../architecture/rq.md) is a form of RTE. It is a real-time process subscribes to all tables and to all symbols on the tickerplant. This process has very simple behavior upon incoming updates, it inserts these records to the end of the corresponding table in order to contain all of the currrent days data.

An alternative is to using an RTE is to query the RDB on each clients request. As this would entail performing an operation on a growing dataset, it can prove much more inefficient for the client while also consuming the resources of the RDB.

A RTE can also use the TP log file to recover from any inexpected intra-day restarts.

## Building a RTE

How to create a RTE will be shown using an example.

### Environment setup

The following environment can be used to run all examples on this page.

Download kdb+tick from :fontawesome-brands-github:[KxSystems/kdb-tick](https://github.com/KxSystems/kdb-tick)

Create a schema file with the following two tables (`quote` and `trade`) in `tick/sym.q`
```q
quote:([]time:`timespan$();sym:`symbol$();mm:`symbol$();bid:`float$();ask:`float$();bsize:`int$();asize:`int$())
trade:([]time:`timespan$();sym:`symbol$();price:`float$();size:`int$())
```

1. Start a tickerplant
```q
q tick.q sym . -p 5000
```
Refer to [tick.q usage](../../architecture/tickq.md#usage) for more details. Note that a log file will be created in the current directory based on the above command, which will log every message received.
2. Start one or more of the RTEs below, to connect to the tickerplant. Once data is being produced from the feed simulator you can inspect the tables generated, as shown in the relevent examples.
3. Start a feed simulator to publish randomly generated data on a regular interval. The following `feed.q` script has been created to generate data relevant to the schema file above:
```q
h:neg hopen `:localhost:5000 /connect to tickerplant
syms:`MSFT.O`IBM.N`GS.N`BA.N`VOD.L /stocks
prices:syms!45.15 191.10 178.50 128.04 341.30 /starting prices
n:2 /number of rows per update
flag:1 /generate 10% of updates for trade and 90% for quote
getmovement:{[s] rand[0.0001]*prices[s]} /get a random price movement
/generate trade price
getprice:{[s] prices[s]+:rand[1 -1]*getmovement[s]; prices[s]}
getbid:{[s] prices[s]-getmovement[s]} /generate bid price
getask:{[s] prices[s]+getmovement[s]} /generate ask price
/timer function
.z.ts:{
  s:n?syms;
  $[0<flag mod 10;
    h(".u.upd";`quote;(n#.z.N;s;n?`AA`BB`CC`DD;getbid'[s];getask'[s];n?1000;n?1000));
    h(".u.upd";`trade;(n#.z.N;s;getprice'[s];n?1000))];
  flag+:1; }
/trigger timer every 100ms
\t 100
```
Run as
```q
q feed.q
```
Points to note from the above:
    1.  The data sent to the tickerplant is in columnar (column-oriented) list format. In other words, the tickerplant expects data as lists, not tables. This point will be relevant later when the RDB wishes to replay the tickerplant logfile.
    1.  The function triggered on the tickerplant upon receipt of these updates is [`.u.upd`](../../architecture/tickq.md#uupd).
    1.  If you wish to increase the frequency of updates sent to the tickerplant for testing purposes, simply change the timer value at the end of this script accordingly.


### Weighted average (VWAP) example

This section describes how to build an RTE which calculates information used for VWAP (volume-weighted average price) on a per-symbol basis in real-time.
Clients can then retrieve the current VWAP value for one or many symbols.
Upon an end-of-day event it will clear current records, ready to recalculate on the next trading day.

A VWAP can be defined as:

$$ VWAP = \frac{\sum_{i} (tradevolume_i)(tradeprice_i)}{\sum_{i} (trade price_i)}$$

The code to create this example (`vwap.q`) is as follows: 
```q
/ connect to TP
h:hopen `::5000;

/ syms to subscribe to
s:`MSFT.O`IBM.N
/ table to hold info used in vwap calc
ttrades:([sym:`$()]price:`float$();size:`int$())

/ action for real-time data
upd:{[x;y]ttrades+:select size wsum price,sum size by sym from y;}

/ subscribe to trade table for syms
h(".u.sub";`trade;s);

/ clear table on end of day
.u.end:{[x]
  0N!"End of Day ",string x;
  delete from `ttrades;}

/ client function to retrieve vwap
/ e.g. getVWAP[`IBM.N`MSFT.O]
getVWAP:{select sym,vwap:price%size from ttrades where sym in x}
```

The RTE can be run as `q vwap.q -p 5041` after starting a tickerplant, but prior to starting the feedhandler.

#### Subscribing to a TP

Connect to the TP using [IPC](../../basics/ipc.md#connecting) (via the [hopen](../../ref/hopen.md) command). 
For example the following connects to another process on the current host using port 5000:
```q
h:hopen `::5000;
```

Once connected, a subcription to the required data is created by calling the [`.u.sub`](../../architecture/uq.md#usub) 
function in the TP using a [synchronous request](../../basics/ipc.md#sync-request-get).

A RTE should subscribe to the least amount of data required to perform there task. 
To aid this, the default mechanism allows filtering both by table name and by symbol names being
updated within the table.

The VWAP example subscribes to any updates occuring within the trade table for the symbols MSFT.O and IBM.N:

```q
h(".u.sub";`trade;`MSFT.O`IBM.N);
```

#### Intraday updates

In order to receive real-time updates for the subscriptions made, the RTE must implement the upd function.
This should contain the logic required for your choosen analytic or alert.
```q
upd[x;y]
```
Where

* x is a symbol atom of the name of the table being updated; e.g. `` `trade``, `` `quote``, etc.
* y is table data to add to table x, which can contain one or more rows. The schema used for the table will be the one defined in the TP schema file.

An example of data passed to `upd` in the `y` parameter for the example `trade` schema :
```q
time                 sym    mm bid      ask      bsize asize
------------------------------------------------------------
0D11:57:53.538026000 MSFT.O BB 45.16191 45.16555 349   902
0D11:57:53.538026000 IBM.N  DD 178.4829 178.5018 31    673
```

`y` can one or more rows depending on the configuration of the feed handler and TP and the filtering enabled
within the subscription. When batching enabled in either feed handler or TP, more than one row can be present.

The VWAP example has the following custom logic
```q
upd:{[x;y]ttrades+:select size wsum price,sum size by sym from y;}
```
From the example above, it uses qsql to select the required data. It uses [sum](../../ref/sum.md) and [wsum](../../ref/sum.md#wsum) to perform the calculation. 
Both the result of the calculation and `ttables` are keyed tables (dictionaries) so the `+` ([add](../../ref/add.md)) operator has upsert semantics,
adding the result of the calculation to the running total (`ttables`) indexed by sym.

The following example shows the actions of an intraday update on the `ttables` keyed table:

1. contents of `ttables` prior to update
```q
sym   | price    size
------| -------------
MSFT.O| 91572.43 2026
IBM.N | 269151.2 1408
```
2. TP calls upd with `x` set to `trade and `y` set to:
```q
time                 sym   price    size
----------------------------------------
0D13:03:22.799016000 IBM.N 191.1547 684
```
3. result of the custom calculation performed on data passed to upd 
```q
sym  | price    size
-----| -------------
IBM.N| 130749.8 684
```
4. contents of `ttables` after update 
```q
sym   | price    size
------| -------------
MSFT.O| 91572.43 2026
IBM.N | 399901   2092
```

As `upd` is defined as a binary (2-argument) function, it could alternatively be defined as a dictionary which maps table names to unary function definitions. 
This duality works because of a fundamental and elegant feature of kdb+: [executing functions and indexing into data structures are equivalent](../../ref/apply.md).
The following demonstrates how a `upd` function can be replaced by a mapping of table name to handling function, simulating what occurs on different updates:
```q
q)updquote:{[x]0N!"quote update with data ";show x;}  / function for quote table updates 
q)updtrade:{[x]0N!"trade update with data ";show x;}  / function for trade table updates
q)upd:`trade`quote!(updtrade;updquote)                / map table names to unique handler two tables called 'trade' and 'quote'
q)upd[`quote;([]a:1 2 3;b:4 5 6)];                    / update for quote table calls updquote
"quote update with data "
a b
---
1 4
2 5
3 6
q)upd[`trade;([]a:1 2 3;b:4 5 6)];                    / update for trade table calls updtrade
"trade update with data "
a b
---
1 4
2 5
3 6
q)upd[`not_handled;([]a:1 2 3;b:4 5 6)];             / update with no corresponding handler
```

The RTE could also be integrated with other processes using [IPC](../../basics/ipc.md) to call a function when specific conditions occur (i.e. an alert).

#### End of day

At end of day (EOD), the TP sends messages to all subscribed clients, telling them to execute their unary end-of-day function called .u.end.
```q
.u.end[x]
```
Where x is the date that has ended, as a date atom type.

A RTE will execute its `.u.end` function once at end-of-day, regardless of whether it has one or many subscriptions.

In the VWAP example, it logs that the end-of-day has occured and clears the table holding the current calculation.

#### Client interaction

The RTE can provide a client API consisting of one or more functions that can be used by a client to retrieve the results of our calculation. Rather than have each client request a specific calculation is performed. It also hides the data structures used to record data, leaving them self contained for future improvements.

The VWAP example defines a `getVWAP` function that can take a list of symbols. A RTE client can use [IPC](../../basics/ipc.md) to retrieve the current VWAP calculation for one or many symbols, for example
```q
q)h:hopen `::5041
q)h("getVWAP";`MSFT.O)
sym    vwap
---------------
MSFT.O 45.16362
q)h("getVWAP";`MSFT.O`IBM.N)
sym    vwap
---------------
MSFT.O 45.16362
IBM.N  191.0711
```
Without an RTE, this calculation would have to be performed over the entire days dataset contained within the RDB.

### Weighted average (VWAP) example with recovery

If a situation occurs were an RTE is restarted and it requires all of todays relevant data to regain the current value, it can replay the data from the TP log.

To demonstrate this, the previous [example](#weighted-average-vwap-example) (`vwap.q`) has been altered to include the ability to replay from a TP log on startup:

```q
/ connect to TP
h:hopen `::5000;

/ syms to subscribe to
s:`MSFT.O`IBM.N
/ table to hold info used in vwap calc
ttrades:([sym:`$()]price:`float$();size:`int$())

/ action for real-time data
upd_rt:{[x;y]ttrades+:select size wsum price,sum size by sym from y}

/ action for data received from log file
upd_replay:{[x;y]if[x~`trade;upd_rt[`trade; select from (trade upsert flip y) where sym in s]];}

/ clear table on end of day
.u.end:{[x]
  0N!"End of Day ",string x;
  delete from `ttrades;}

/ replay log file
replay:{[x]
  logf:x[1];
  if[null first logf;:()];      / return if logging not enabled on TP
  .[set;x[0]];                  / create empty table for data being sent
  upd::upd_replay;
  0N!"Replaying ",(string logf[0])," messages from log ",string logf[1];
  -11!logf;
  0N!"Replay done";}

/ subscribe and initialize
replay h"(.u.sub[`trade;",(.Q.s1 s),"];.u `i`L)";
upd:upd_rt;

/ client function to retrieve vwap
/ e.g. getVWAP[`IBM.N`MSFT.O]
getVWAP:{select sym,vwap:price%size from ttrades where sym in x}
```

The code required to perform a replay will now be discussed using this example.

#### Retrieving TP Log information

The log information in the example is retreived at the same time as the subscription is made. 
It is important to register all subscriptions at the same time as retrieving log information, and immediately process the log before processing any updates.
The ensures that no messages update prior to processing the log, nor are sent between processing the log and regaining real-time updates.

In the example provided, several steps are performed in one line of code:
```q
replay h"(.u.sub[`trade;",(.Q.s1 s),"];.u `i`L)";
```
We can break this down into the following steps

1. Retrieve [log information](../../architecture/tickq.md#variables) stored in TP to get the current number of messages and the log file location and perform the subscription. The following shows an example of requesting log information without making a subscription:
```q
q)h:hopen `::5000;
q)h".u `i`L"
942
`:./sym2024.08.30
```
2. Register subscription for real-time data. The following shows an example of a TP client making a subscription for two symbols within the trade table and also requesting the log information shown in the previous step. The return value is a two item list, with the first item being the the schema information (returned by [`.u.sub`](../../architecture/uq.md#usub)) and the second element being the log file information.
```q
q)h"(.u.sub[`trade;`MSFT.O`IBM.N];.u `i`L)"
`trade +`time`sym`price`size!(`timespan$();`g#`symbol$();`float$();`int$())
942   `:./sym2024.08.30
```
3. Call a function to perform the replay of data from the TP log file given the information returned from the previous steps. In the example we call our custom `replay` function with both the schema information and log information.
```q
replay h"(.u.sub[`trade;",(.Q.s1 s),"];.u `i`L)";
```

#### TP Log replay

Replaying a log file is detailed [here](../../kb/logging.md#replaying-log-files).

The data replayed has two potential differences from the live data that should be considered:

1. The TP log file contains all of todays data. The RTE real-time subscription may have been subscribing to a subset of the data. For example, the RTE subscription could be filtering for particular tables or symbols. Therefore the replay action must include the logic to filter for required data.
2. Each message passed to `upd` structures its data using a list of vectors for each column. Real-time data uses a table structure.

In order to handle the difference of data between replay and live data, the `upd` function is changed before/after replay. The VWAP example has
```q
upd::upd_replay; / set upd to upd_replay function which will then be called for each message in the log file
...
-11!logf;        / replay log file
...
upd:upd_rt;      / set upd to upd_rt function which will be used for all real-time messages
```

As can be seen from the VWAP example, each message stored in the log file executes `upd` (which has been set to `upd_replay`). 
The VWAP example is only interested in updates to the `trade` table for specific symbols, so  `upd_replay` filters the data for messages matching that criteria. The data is then tranformed into the format that would normally call `upd_rt` so the logic to calculate VWAP is reused by passing the data to that function.

## Further reading

The default RDB ([r.q](../../architecture/rq.md)) is a form of RTE, so it can be useful to understand how it works and read the related source code. 
A number of [examples](#further-examples) are also provided for study.

## Further examples

### `c.q` collection

:fontawesome-brands-github:
[KxSystems/kdb/tick/c.q](https://github.com/KxSystems/kdb/blob/master/tick/c.q)

An often-overlooked problem is users fetching vast amounts of raw data to calculate something that could much better be built once, incrementally updated, and then made available to all interested clients. `c.q` provides a collection of RTE examples, such as

*  keeping a running Open/High/Low/Latest: much simpler to update incrementally with data from the TP each time something changes than to build from scratch. 
*  keeping a table of the latest trade and the associated quote for every stock – trivial to do in real time with the incremental updates from the TP, but impossible to build from scratch in a timely fashion with the raw data. 

The default version of `c.q` connects to a TP and starts collecting data.
Depending on your situation, you may wish to be able to replay TP data on a restart of an RTE.
An alternative version that replays data from a [TP log](../data-recovery.md) on start-up is available from [`simongarland/tick/clog.q`](https://github.com/simongarland/tick/blob/master/clog.q).

#### General Usage

```bash
q c.q CMD [host]:port[:usr:pwd] [-p 5040]
```

| Parameter Name | Description | Default |
| ---- | ---- | --- |
| CMD | See [options](#options) for list of possible options | &lt;none&gt; |
| host | host running kdb+ instance that the instance will subscribe to e.g. tickerplant host | localhost | 
| port | port of kdb+ instance that the instance will subscribe to  e.g. tickerplant port | 5010 |
| usr   | username | &lt;none&gt; |
| pwd   | password | &lt;none&gt; |
| -p    | [listening port](../../basics/cmdline.md#-p-listening-port) for client communications | &lt;none&gt; |

The `t` variable within the source file can be edited to a table name to filter, or an empty sym list for no filter.

The `s` variable within the source file can be edited to a list of syms to filter on, or an empty sym list for no filter.

#### Features

Possible options for `CMD` on command-line are:

##### All data (with filter)

```bash
q c.q all [host]:port[:usr:pwd] [-p 5040]
```
Stores all data received via subscribed tables/syms in corresponding table(s).
```q
q)trade
time                 sym    price    size
-----------------------------------------
0D17:43:53.750787000 MSFT.O 45.18422 227
0D17:43:53.750787000 MSFT.O 45.18253 723
0D17:43:54.750922000 IBM.N  190.9688 31
```

##### Latest value

```bash
q c.q last [host]:port[:usr:pwd] [-p 5040]
```
Stores last value per sym, for data received via subscribed tables/syms. If variable `t` set to subscribe to all tables (i.e. value is empty sym) then the
script will also set `r` to the last table update received. `r` can contain more than one row if the feedhandler or TP is configured to send messages in batches.
```q
q)trade
sym   | time                 price    size
------| ----------------------------------
MSFT.O| 0D17:47:44.755199000 45.21574 566
IBM.N | 0D17:47:43.751284000 191.0358 505
q)r
sym  | time                 mm bid      ask      bsize asize
-----| -----------------------------------------------------
IBM.N| 0D17:47:46.355176000 BB 191.0336 191.0548 452   888
```

##### Five minute window

```bash
q c.q last5 [host]:port[:usr:pwd] [-p 5040]
```
Populates tables with each row representing the last update within a five minute window for each sym. Latest row updates for each tick until five minute window passes and a new row is created.
```q
q)trade
sym    minute| time                 price    size
-------------| ----------------------------------
MSFT.O 17:45 | 0D17:49:56.755206000 45.2008  289
IBM.N  17:45 | 0D17:49:59.750186000 191.1024 79
IBM.N  17:50 | 0D17:54:55.752129000 191.2633 817
MSFT.O 17:50 | 0D17:54:58.754249000 45.22999 635
IBM.N  17:55 | 0D17:55:06.753962000 191.266  154
MSFT.O 17:55 | 0D17:55:11.751203000 45.23911 826
```

##### Trade with quote

```bash
q c.q tq [host]:port[:usr:pwd] [-p 5040]
```
Records the current quote price as each trade occurs. It populates table `tq` with all trade updates, accompanied by the value contained within the last received quote update for the related sym. Example depends upon the tickerplant using a schema with only a quote and trade table.
```q
q)tq
time                 sym    price    size bid      ask      bsize asize
-----------------------------------------------------------------------
0D11:11:45.566803000 MSFT.O 45.14688 209  45.14713 45.15063 55    465
0D11:11:49.868267000 MSFT.O 45.15094 288  45.14479 45.15053 27    686
```

##### Weighted average (VWAP)

```bash
q c.q vwap [host]:port[:usr:pwd] [-p 5040]
```
Populates table `vwap` with information that can be used to generate a volume weighted adjusted price. The input volume and price can fluctuate during the day. This example uses [`wsum`](../../ref/sum.md#wsum) to calculate the weighted sum over the mutliple ticks that may be in a single update. Result shows size representing the total volume traded, and price being the total cost of all stocks traded. Example depends upon tickerplant using a schema with a trade table that include the columns sym, price and size.
```q
q)vwap
sym   | price    size
------| -------------
MSFT.O| 148714.2 6348
IBM.N | 138147.1 3060
q)select sym,vwap:price%size from vwap
sym    vwap
---------------
MSFT.O 23.42693
IBM.N  45.14611
```

##### Weighted average (VWAP with time window)

```bash
q c.q vwap1 [host]:port[:usr:pwd] [-p 5040]
```
Populates table `vwap` with information that can be used to generate a volume weighted adjusted price. Calculation as per `vwap` example above. A new row is inserted per sym, when each minute passes. This presents the vwap on per minute basis.
```q
q)vwap
sym    minute| price    size
-------------| --------------
MSFT.O 11:07 | 570708.2 12643
MSFT.O 11:08 | 1328935  29425
MSFT.O 11:09 | 56653.97 1254
q)select sym,minute,vwap:price%size from vwap
sym    minute vwap
----------------------
MSFT.O 11:07  45.14025
MSFT.O 11:08  45.16346
MSFT.O 11:09  45.18718
```

##### Weighted average (VWAP with tick limit)

```bash
q c.q vwap2 [host]:port[:usr:pwd] [-p 5040]
```
As per `vwap` example, but only including last ten trade messages for calculation.
```q
q)vwap
sym   | vwap
------| --------
MSFT.O| 45.14031
```

##### Weighted average (VWAP with time limit)

```bash
q c.q vwap3 [host]:port[:usr:pwd] [-p 5040]
```
As per `vwap` example, but only including any trade messages received in the last minute for calculation.
```q
q)vwap
sym   | vwap
------| --------
MSFT.O| 45.14376
```

##### Moving calculation (time window)

```bash
q c.q move [host]:port[:usr:pwd] [-p 5040]
```
Populates table `move` with moving price calculation performed in real-time, generating the `price` and `price * volume` change over a 1 minute window. Using the last tick that occurred over one minute ago, subtract from latest value. For example, price change would be +12 if the value one minute ago was 8 and the last received price was 20. Recalculates for every update. Example depends upon tickerplant using a schema with a trade table that include the columns sym, price and size. _Example must be run for at least one minute._
```q
q)move
sym   | size      size1
------| ---------------
MSFT.O| -35842.39 -794
```

##### Daily running stats

```bash
q c.q hlcv [host]:port[:usr:pwd] [-p 5040]
```
Populates table `hlcv` with high price, low price, last price, total volume. Example depends upon tickerplant using a schema with a trade table that include the columns sym, price and size.
```q
q)hlcv
sym   | high     low      price    size
------| -------------------------------
MSFT.O| 45.15094 45.14245 45.14724 5686
```

##### Categorizing into keyed table

```bash
q c.q lvl2 [host]:port[:usr:pwd] [-p 5040]
```
Populates a dictionary `lvl2` mapping syms to quote information. The quote information is a keyed table showing the latest quote for each market maker.
```q
q)lvl2`MSFT.O
mm| time                 bid      ask      bsize asize
--| --------------------------------------------------
AA| 0D10:59:44.510353000 45.15978 45.16659 883   321
CC| 0D10:59:43.010352000 45.15233 45.15853 956   293
BB| 0D10:59:45.910348000 45.15745 45.16148 533   721
DD| 0D10:59:46.209092000 45.15623 45.16231 404   279
q)lvl2`IBM.N
mm| time                 bid      ask      bsize asize
--| --------------------------------------------------
DD| 0D10:59:52.410404000 191.0868 191.093  768   89
AA| 0D10:59:52.410404000 191.0798 191.0976 587   140
BB| 0D10:59:54.610352000 191.1039 191.1101 187   774
CC| 0D10:59:54.310351000 191.0951 191.1116 563   711
```
Requires a quote schema containing a column named `mm` for the market maker, for example
```q
quote:([]time:`timespan$();sym:`symbol$();mm:`symbol$();bid:`float$();ask:`float$();bsize:`int$();asize:`int$())
```

##### Store to nested structures

```bash
q c.q nest [host]:port[:usr:pwd] [-p 5040]
```
Creates and populates a `trade` table. There will be one row for each symbol, were each element is a list. Each list has its corresponding value appended to on each update i.e. four trade updates will result in a four item list of prices. Example depends upon the tickerplant publishing a trade table.
```q
q)trade
sym   | time                                                                                price                             size
------| -------------------------------------------------------------------------------------------------------------------------------------
MSFT.O| 0D11:06:24.370938000 0D11:06:25.374533000 0D11:06:26.373827000 0D11:06:27.376053000 45.14767 45.14413 45.1419 45.1402 360 585 869 694
```

### Real-time trade with as-of quotes

#### Overview

One of the most popular and powerful joins in the q language is the [`aj`](../../ref/aj.md) function. This keyword was added to the language to solve a specific problem – how to join trade and quote tables together in such a way that for each trade, we grab the prevalent quote _as of_ the time of that trade. In other words, what is the last quote at or prior to the trade? 

This function is relatively easy to use for one-off joins. However, what if you want to maintain trades with as-of quotes in real time? This section describes how to build an RTE with real-time trades and as-of quotes.

One additional feature this script demonstrates is the ability of any q process to write to and maintain its own kdb+ binary logfile for replay/recovery purposes. In this case, the RTE maintains its own daily logfile for trade records. This will be used for recovery in place of the standard tickerplant logfile.

#### Example script

This is a heavily modified version of an RDB ([`r.q`](../../architecture/rq.md)), written by the author and named `RealTimeTradeWithAsofQuotes.q`.

```q
/
The purpose of this script is as follows:
1. Demonstrate how custom RTEs can be created in q
2. In this example, create an efficient engine for calculating
   the prevalent quotes as of trades in real-time.
   This removes the need for ad-hoc invocations of the aj function.
3. In this example, this subscriber also maintains its own binary
   log file for replay purposes.
   This replaces the standard tickerplant log file replay functionality.
\
show "RealTimeTradeWithAsofQuotes.q"
/sample usage
/q tick/RealTimeTradeWithAsofQuotes.q -tp localhost:5000 -syms MSFT.O IBM.N GS.N

/default command line arguments - tp is location of tickerplant.
/syms are the symbols we wish to subscribe to
default:`tp`syms!("::5000";"")

args:.Q.opt .z.x /transform incoming cmd line arguments into a dictionary
args:`$default,args /upsert args into default
args[`tp] : hsym first args[`tp]

/drop into debug mode if running in foreground AND
/errors occur (for debugging purposes)
\e 1

if[not "w"=first string .z.o;system "sleep 1"]

/initialize schemas for custom RTE
InitializeSchemas:`trade`quote!
  (
   {[x]`TradeWithQuote insert update mm:`,bid:0n,bsize:0N,ask:0n,asize:0N from x};
   {[x]`LatestQuote upsert select by sym from x}
  );

/intraday update functions
/Trade Update
/1. Update incoming data with latest quotes
/2. Insert updated data to TradeWithQuote table
/3. Append message to custom logfile
updTrade:{[d]
  d:d lj LatestQuote;
  `TradeWithQuote insert d;
  LogfileHandle enlist (`replay;`TradeWithQuote;d); }

/Quote Update
/1. Calculate latest quote per sym for incoming data
/2. Update LatestQuote table
updQuote:{[d]
  `LatestQuote upsert select by sym from d; }

/upd dictionary will be triggered upon incoming update from tickerplant
upd:`trade`quote!(updTrade;updQuote)

/end of day function - triggered by tickerplant at EOD
.u.end:{
  hclose LogfileHandle; /close the connection to the old log file
  /create the new logfile
  logfile::hsym `$"RealTimeTradeWithAsofQuotes_",string .z.D;
  .[logfile;();:;()]; /Initialize the new log file
  LogfileHandle::hopen logfile;
  {delete from x}each tables `. /clear out tables
  }

/Initialize name of custom logfile
logfile:hsym `$"RealTimeTradeWithAsofQuotes_",string .z.D;

replay:{[t;d]t insert d} /custom log file replay function

/attempt to replay custom log file
@[{-11!x;show"successfully replayed custom log file"}; logfile;
  {[e]
    m:"failed to replay custom log file";
    show m," - assume it does not exist. Creating it now";
    .[logfile;();:;()]; /Initialize the log file
  } ]

/open a connection to log file for writing
LogfileHandle:hopen logfile

/ connect to tickerplant and subscribe to trade and quote for portfolio
h:hopen args`tp; /connect to tickerplant
InitializeSchemas . h(".u.sub";`trade;args`syms);
InitializeSchemas . h(".u.sub";`quote;args`syms);
```

This process should be started off as follows:

```bash
q tick/RealTimeTradeWithAsofQuotes.q -tp localhost:5000 -syms MSFT.O IBM.N GS.N -p 5003
```

This process will subscribe to both trade and quote tables for symbols `MSFT.O`, `IBM.N` and `GS.N` and will listen on port 5003. The author has deliberately made some of the q syntax more easily understandable compared to `r.q`.

The first section of the script simply parses the command-line arguments and uses these to update some default values.

The error flag [`\e`](../../basics/syscmds.md#e-error-trap-clients) is set for purely testing purposes. 
When the developer runs this script in the foreground, 
if errors occur at runtime as a result of incoming IPC messages, the process will drop into debug mode. 
For example, if there is a problem with the definition of `upd`, then when an update is received from the tickerplant 
we will drop into debug mode and (hopefully) identify the issue.

We can see this RTE in action by examining the five most recent trades for `GS.N`:

```q
q)-5#select from TradeWithQuote where sym=`GS.N
time                 sym  price    size bid      bsize ask      asize 
---------------------------------------------------------------------
0D21:50:58.857411000 GS.N 178.83   790  178.8148 25    178.8408 98
0D21:51:00.158357000 GS.N 178.8315 312  178.8126 12    178.831  664
0D21:51:01.157842000 GS.N 178.8463 307  178.8193 767   178.8383 697 
0D21:51:03.258055000 GS.N 178.8296 221  178.83   370   178.8627 358
0D21:51:03.317152000 GS.N 178.8314 198  178.8296 915   178.8587 480
```

#### Initialize desired table schemas

`InitializeSchemas` defines the behavior of this RTE upon connecting and subscribing to the tickerplant’s trade and quote tables. 
`InitializeSchemas` (defined as a dictionary which maps table names to unary function definitions) replaces [`.u.rep`](../../architecture/rq.md#urep) in `r.q`:

The RTE’s trade table (named `TradeWithQuote`) maintains `bid`, `bsize`, `ask` and `asize` columns of appropriate type. 
For the quote table, we just maintain a keyed table called `LatestQuote`, keyed on `sym` which will maintain the most recent quote per symbol. 
This table will be used when joining prevalent quotes to incoming trades.


#### Intraday update behavior

`updTrade` defines the intraday behavior upon receiving new trades.

Besides inserting the new trades with prevalent quote information into the trade table, `updTrade`
also appends the new records to its custom logfile. This logfile will be replayed upon recovery/startup of the RTE. 
Note that the replay function is named `replay`. This differs from the conventional TP logfile where the replay function was called `upd`.

`updQuote` defines the intraday behavior upon receiving new quotes.

The `upd` dictionary acts as a case statement – when an update for the trade table is received, 
`updTrade` will be triggered with the message as argument. 
Likewise, when an update for the quote table is received, `updQuote` will be triggered.

In `r.q`, `upd` is defined as a function, not a dictionary. However we can use this dictionary definition for reasons discussed previously.


#### End of day

At end of day, the tickerplant sends a message to all RTEs telling them to invoke their EOD function (`.u.end`):

This function has been heavily modified from `r.q` to achieve the following desired behavior:

* `hclose LogfileHandle`
    * Close connection to the custom logfile.
* ``logfile::hsym `$"RealTimeTradeWithAsofQuotes_",string .z.D``
    * Create the name of the new custom logfile. This logfile is a daily logfile – meaning it only contains one day’s trade records and it has today’s date in its name, just like the tickerplant’s logfile.
* `.[logfile;();:;()]`
    * Initialize this logfile with an empty list.
* `LogfileHandle::hopen logfile`
    * Establish a connection (handle) to this logfile for streaming writes.
* ``{delete from x}each tables `.``
    * Empty out the tables.


#### Replay custom logfile

This section concerns the initialization and replay of the RTE’s custom logfile.

```q
/Initialize name of custom logfile
logfile:hsym `$"RealTimeTradeWithAsofQuotes_",string .z.D 

replay:{[t;d]t insert d} /custom log file replay function
```

At this point, the name of today’s logfile and the definition of the logfile replay function have been established. The replay function will be invoked when replaying the process’s custom daily logfile. It is defined to simply insert the on-disk records into the in memory (`TradeWithQuote`) table. This will be a fast operation ensuring recovery is achieved quickly and efficiently.

Upon startup, the process uses a try-catch to replay its custom daily logfile. If it fails for any reason (possibly because the logfile does not yet exist), it will send an appropriate message to standard out and will initialize this logfile. Replay of the logfile is achieved with the standard operator `-11!` as discussed previously.

```q
/attempt to replay custom log file
@[{-11!x;show"successfully replayed custom log file"}; logfile;
  {[e]
    m:"failed to replay custom log file";
    show m," - assume it does not exist. Creating it now";
    .[logfile;();:;()]; /Initialize the log file
  } ]
```

Once the logfile has been successfully replayed/initialized, a handle (connection) is established to it for subsequent streaming appends (upon new incoming trades from tickerplant):

```q
 /open a connection to log file for writing
LogfileHandle:hopen logfile
```

#### Subscribe to TP

The next part of the script is probably the most critical – the process connects to the tickerplant and subscribes to the trade and quote table for user-specified symbols.

```q
/ connect to tickerplant and subscribe to trade and quote for portfolio 
h:hopen args`tp; /connect to tickerplant
InitializeSchemas . h(".u.sub";`trade;args`syms);
InitializeSchemas . h(".u.sub";`quote;args`syms);
```

The output of a subscription to a given table (for example `trade`) from the tickerplant is a 2-list, as discussed previously. This pair is in turn passed to the function `InitializeSchemas`.


## Performance considerations

The developer can build the RTE to achieve whatever real-time behavior is desired. However from a performance perspective, not all RTE instances are equal. The standard RDB is highly performant – meaning it should be able process updates at a very high frequency without maxing out CPU resources. In a real world environment, it is critical that the RTE can finish processing an incoming update before the next one arrives. The high level of RDB performance comes from the fact that its definition of `upd` is extremely simple:

```q
upd:insert
```

In other words, for both TP logfile replay and intraday updates, simply insert the records into the table. It doesn’t take much time to execute `insert` in kdb+. However, the two custom RTE instances discussed in this white paper have more complicated definitions of `upd` for intraday updates and will therefore be less performant. This section examines this relative performance.

For this test, the TP log will be used. This particular TP logfile has the following characteristics:

```q
q)hcount `:C:/OnDiskDB/sym2014.08.15 /size of TP logfile on disk in bytes
41824262
q)logs:get`:C:/OnDiskDB/sym2014.08.15 /load logfile into memory 
q)count logs /number of updates in logfile
284131
```

We can examine the contents of the logfile as follows:

```q
q)2#logs /display first 2 messages in logfile
`upd `quote (0D16:05:08.818951000 0D16:05:08.818951000;`GS.N`VOD.L;78.5033 53.47096;17.80839 30.17723;522 257;908 360)
`upd `quote (0D16:05:08.918957000 0D16:05:08.918957000;`VOD.L`IBM.N;69.16099 22.96615;61.37452 52.94808;694 934;959 221)
```

In this case, the first two updates were for `quote`, not `trade`. Given the sample feedhandler used, each update for `trade` or `quote` had two records. The overall number of `trade` and `quote` updates in this logfile were:

```q
 q)count each group logs[;1]
quote| 255720
trade| 28411
```

It was previously mentioned that the TP logfile has the data in columnar list format as opposed to table format, whereas intraday TP updates are in table format. Therefore, in order to simulate intraday updates, a copy of the TP logfile is created where the data is in table format.

The code to achieve this transformation is below:

```q
/LogfileTransform.q

\l tick/sym.q /obtain table schemas
d:`trade`quote!(cols trade;cols quote) 

`:C:/OnDiskDB/NewLogFile set () /initialize new logfile
h:hopen `:C:/OnDiskDB/NewLogFile /handle to NewLogFile

upd:{[tblName;tblData]
  h enlist(`upd;tblName;flip(d tblName)!tblData); }

-11!`:C:/OnDiskDB/sym2014.08.15 /replay TP log file and create new one
```

This transformed logfile will now be used to test performance on the
RDB and two RTE instances. 

On the RDB, we obtained the following performance:

```q
q)upd /vanilla, simple update behavior
insert
q)logs:get`:C:/OnDiskDB/NewLogFile /load logfile into memory 
q)count logs /number of messages to process
284131
q)\ts value each logs /execute each update
289 31636704
```

It took 289 milliseconds to process over a quarter of a million updates, where each update had two records. Therefore, the average time taken to process a single two-row update is 1µs.

In the first example RTE (Real-time Trade With As-of Quotes), we obtained the following performance:

```q
q)upd /custom real time update behavior
trade| {[d]
  d:d lj LatestQuote;
  `TradeWithQuote insert d;
  LogfileHandle enlist (`replay;`TradeWithQuote;d); }
quote| {[d] `LatestQuote upsert select by sym from d; }
q)logs:get`:C:/OnDiskDB/NewLogFile /load logfile into memory 
q)count logs /number of messages to process
284131
q)\ts value each logs /execute each update
2185 9962336
```

It took 2185 milliseconds to process over a quarter of a million updates, where each update had two records. Therefore, the average time taken to process a single two-row update is 7.7 µs – over seven times slower than RDB.

In the second example RTE (Real-time VWAP), we obtained the following performance:

```q
/
Because there are trades and quotes in the logfile 
but this RTE is only designed to handle trades, 
a slight change to upd is necessary 
for the purpose of this performance experiment
\
/If trade – process as normal. If quote - ignore 
q)upd:{if[x=`trade;updIntraDay[`trade;y]]}
q)
q)logs:get`:C:/OnDiskDB/NewLogFile /load logfile into memory
q)count logs /number of messages to process
284131
q)\ts value each logs /execute each update
9639 5505952
```

It took 9639 milliseconds to process over a quarter of a million updates, where each update had two records. Therefore, the average time taken to process a single two row update is 34 µs – over thirty times slower than RDB.

We can conclude that there was a significant difference in performance in processing updates across the various RTEs. However even in the worst case, assuming the TP updates arrive no more frequently than once every 100 µs, the process should still function well.

It should be noted that prior to this experiment being carried out on each process, all tables were emptied.


