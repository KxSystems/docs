---
title: kdb+tick alternative architecture – Knowledge Base – kdb+ and q documentation
description: A ‘vanilla’ tick setup has a tickerplant (TP) logging to disk and publishing to an in-memory realtime database (RDB) – and at day-end the RDB data is saved to disk as another day in the history database (HDB). Users typically query the RDB or HDB directly. It doesn’t have to be that way. There are a many other ways of assembling the kdb+tick “building blocks” to reduce or share the load.
keywords: chained, hdb, kdb+, q, rdb, tick, tickerplant
---
# kdb+tick alternative architecture


A [‘vanilla’](../architecture/index.md) tick setup has a tickerplant (TP) logging to disk and publishing to an in-memory realtime database (RDB) – and at day-end the RDB data is saved to disk as another day in the history database (HDB). Users typically query the RDB or HDB directly.

It doesn’t have to be that way. There are a _many_ other ways of assembling the kdb+tick “building blocks” to reduce or share the load.


## TP

### Chained tickerplants

If the primary tickerplant is running in zero-latency mode (i.e. all updates are published immediately to subscribers) 
it can be inefficient to have a client task that is only plotting graphs subscribe for instantaneous update. An update every few seconds would be quite adequate.

One way of doing this is to have a chained tickerplant, or even a chain of them. 

A chained tickerplant subscribes to the primary tickerplant and receives updates like any other subscriber, and then serves that data to its subscribers in turn.
Unlike the primary tickerplant, *it doesn’t keep its own log*.

If the primary tickerplant is a zero-latency tickerplant the chained tickerplant can be a more traditional tickerplant that chunks up updates on a timer. 
For example if clients are using data from the tickerplant to drive a GUI, it may not need updates hundreds of times per second.
A tickerplant that updates once a second would suffice

#### Example

The example script [`chainedtick.q`](https://github.com/KxSystems/kdb/blob/master/tick/chainedtick.q) can be run as follows:
```bash
q chainedtick.q [host]:port[:usr:pwd] [-p 5110] [-t N]
```

!!! note

    chainedtick.q contains `\l tick/u.q` therefore has a dependancy on [`u.q`](https://github.com/KxSystems/kdb-tick/blob/master/tick/u.q) existing within the directory `tick`.

If the primary tickerplant is running on the same host (port 5010), the following starts a chained tickerplant on port 5010 sending bulk updates, every 1000 milliseconds.
```bash
$ q chainedtick.q :5010 -p 5110 -t 1000
```

Start a chained tickerplant which echoes updates immediately.
```bash
q chainedtick.q :5010 -p 5110 -t 0
```

:fontawesome-brands-github:
[KxSystems/kdb/tick/chainedtick.q](https://github.com/KxSystems/kdb/blob/master/tick/chainedtick.q)
<br>
:fontawesome-brands-github:
[KxSystems/kdb-tick/tick/u.q](https://github.com/KxSystems/kdb-tick/blob/master/tick/u.q)

## RDB

### Chained RDBs

A chained RDB can either be connected to the primary tickerplant, or to a chained tickerplant. 
Unlike a default RDB, the chained RDB doesn't have any day-end processing beyond emptying all tables.

The benefit is similar to that of a chained tickerplant i.e. being able to keep ordinary users away from the primary RDB. 
In particular, the CPU load will reduce if connecting to a chained bulking tickerplant instead of a primary zero latency tickerplant.

A chained RDB doesn’t have to subscribe to the whole set of available data.
It might be useful to have an RDB with only the stocks building a particular index, or perhaps only trades and no quotes.

Don’t forget though that a second RDB will increase the memory usage, as it's an in-memory database and can’t be sharing any data with the primary RDB.

#### Example

The example script [`chainedr.q`](https://github.com/KxSystems/kdb/blob/master/tick/chainedr.q) can be run as follows:
```bash
q chainedr.q [host]:port[:usr:pwd] [-p 5111]
```

If a tickerplant is running on the same host (port 5010), the following starts a chained RDB on port 5111
```q
$ q chainedr.q :5010 -p 5111 
```

:fontawesome-brands-github: [KxSystems/kdb/tick/chainedr.q](https://github.com/KxSystems/kdb/blob/master/tick/chainedr.q)

### Write-only RDB

The default behavior of the RDB is to collect data to an in-memory database during the day and then to save it to disk as an historical partition at day end. 
This is acceptable if it’s actually queried during the day, but if the only reason for having an RDB is to be able to save the historical partition, 
the amount of memory required to keep the in-memory database can be excessive.

It would make sense to write the data to disk during the day so that it’s ready for day-end processing, but with only a small memory footprint to build bulk updates.

:fontawesome-brands-github:
[simongarland/tick/w.q](https://github.com/simongarland/tick/blob/master/w.q)
is a potential replacement for the default RDB ([`r.q`](../architecture/rq.md))

`w.q` connects to the tickerplant, but buffers requests. Each time the number of records in the buffer is equal to  `MAXROWS`, it will write the records to disk.
At day end, remaining data is flushed to disk, the database is sorted (on disk) and then moved to the appropriate date partition within the historical database.

!!! note 

    It is not recommended to query the task running `w.q` as it contains a small (and variable-sized) selection of records. 
    Although it wouldn’t be difficult to modify it to keep the last 5 minutes of data, for example, that sort of custom collection is probably better housed in a task running a [`c.q`](#cq)-like aggregation.

Syntax:
```bash
q w.q [tickerplanthost]:port[:usr:pwd] [hdbhost]:port[:usr:pwd] [-koe|keeponexit]
```

e.g.
```bash
$ q w.q :5010 :5012
```

The `-koe` or `-keeponexit` parameter governs the behavior when a `w.q` task is exited at user request, when `.z.exit` is called. 
By default, the data saved so far is deleted. If the task were restarted it would be difficult to ensure it restarted from exactly the right place.
It’s easier to replay the log and (re)write the data. If the flag is provided (or the `KEEPONEXIT` global set to `1b`) the data is not removed.

:fontawesome-regular-map:
[Intraday writedown solutions](../wp/intraday-writedown/index.md)

## RTE

### `c.q` collection

:fontawesome-brands-github:
[KxSystems/kdb/tick/c.q](https://github.com/KxSystems/kdb/blob/master/tick/c.q)

An often-overlooked problem is users fetching vast amounts of raw data to calculate something that could much better be built once, incrementally updated, and then made available to all interested clients. 

A simple example would be keeping a running Open/High/Low/Latest: much simpler to update incrementally with data from the TP each time something changes than to build from scratch. 

A more interesting example is keeping a table of the latest trade and the associated quote for every stock – trivial to do in real time with the incremental updates from the TP, but impossible to build from scratch in a timely fashion with the raw data. 

The default version of `c.q` connects to a TP and starts collecting data.
Dpending on your situation, you may wish to be able to replay TP data on a restart of an RTE.
An alternative version that replays data from a [TP log](../wp/data-recovery.md) on start-up is available from [`simongarland/tick/clog.q`](https://github.com/simongarland/tick/blob/master/clog.q).

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
| -p    | [listening port](../basics/cmdline.md#-p-listening-port) for client communications | &lt;none&gt; |

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

##### VWAP calculation

```bash
q c.q vwap [host]:port[:usr:pwd] [-p 5040]
```
Populates table `vwap` with information that can be used to generate a volume weighted adjusted price. The input volume and price can fluctuate during the day. This example uses [`wsum`](../ref/sum.md#wsum) to calculate the weighted sum over the mutliple ticks that may be in a single update. Result shows size representing the total volume traded, and price being the total cost of all stocks traded. Example depends upon tickerplant using a schema with a trade table that include the columns sym, price and size.
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

##### VWAP calculation (time window)

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

##### VWAP calculation (tick limit)

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

##### VWAP calculation (time limit)

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

### `daily.q`

By default, the end-of-day processing simply saves the intra-day RDB to disk after a little re-organization. 

Additional processing, such as a permanent HLOC (high/low/open/close) table and building a NBBO (national best bid and offer) table, can be found in

:fontawesome-brands-github: 
[KxSystems/kdb/taq/daily.q](https://github.com/KxSystems/kdb/blob/master/taq/daily.q). 

