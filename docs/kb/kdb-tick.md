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

### `c.q`

An often-overlooked problem is users fetching vast amounts of raw data to calculate something that could much better be built once, incrementally updated, and then made available to all interested clients. 

A simple example would be keeping a running Open/High/Low/Latest: much simpler to update incrementally with data from the TP each time something changes than to build from scratch. 

A more interesting example is keeping a table of the latest trade and the associated quote for every stock – trivial to do in real time with the incremental updates from the TP, but impossible to build from scratch in a timely fashion with the raw data. 

:fontawesome-brands-github: 
[KxSystems/kdb/tick/c.q](https://github.com/KxSystems/kdb/blob/master/tick/c.q)

#### Usage

```bash
q c.q CMD [host]:port[:usr:pwd]
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

##### Options

Possible options for `CMD` on command-line are:

* `all` uses all data received to populate table(s)
* `last` populates table(s) with last value
* `last5` populates tables with each row representing the last update within a five minute window for each sym. Latest row updates for each tick until five minute window passes and a new row is created.
```q
sym    minute| time                 price    size
-------------| ----------------------------------
MSFT.O 10:50 | 0D10:54:59.561385000 45.1433  627
MSFT.O 10:55 | 0D10:59:59.561575000 45.18819 764
MSFT.O 11:00 | 0D11:03:05.560379000 45.18205 123
```
* `tq` populates table `tq` with all trades with then current quote. Example depends upon the tickerplant using a schema with only a quote and trade table.
```q
time                 sym    price    size bid      ask      bsize asize
-----------------------------------------------------------------------
0D11:11:45.566803000 MSFT.O 45.14688 209  45.14713 45.15063 55    465
0D11:11:49.868267000 MSFT.O 45.15094 288  45.14479 45.15053 27    686
```
<!--
* `vwap` TODO
* `vwap1` TODO
* `move` TODO
-->
* `hlcv` populates table `hlcv` with high price, low price, last price, total volume. Example depends upon tickerplant using a schema with a trade table that include the columns sym, price and size.
```q
sym   | high     low      price    size
------| -------------------------------
MSFT.O| 45.15094 45.14245 45.14724 5686
```
<!--
* `lvl2` TODO
-->
* `nest` creates and populates a `trade` table. There will be one row for each symbol, were each element is a list. Each list has its corresponding value appended to on each update i.e. four trade updates will result in a four item list of prices. Example depends upon the tickerplant publishing a trade table.
```q
sym   | time                                                                                price                             size           
------| -------------------------------------------------------------------------------------------------------------------------------------
MSFT.O| 0D11:06:24.370938000 0D11:06:25.374533000 0D11:06:26.373827000 0D11:06:27.376053000 45.14767 45.14413 45.1419 45.1402 360 585 869 694
```
<!--
* `vwap2` TODO
* `vwap3` TODO
-->


### `clog.q`

The default version of `c.q` linked to above connects to a TP and starts collecting data. Sometimes that’s not enough and you want to replay the log through the task first. (For example, to get the Open/High/Low for the day, not just since starting the task.) For that, use `clog.q` instead. 

:fontawesome-brands-github: 
[simongarland/tick/clog.q](https://github.com/simongarland/tick/blob/master/clog.q)

#### Usage

```bash
q clog.q {all|..} [host]:port[:usr:pwd]
```


### `daily.q`

By default, the end-of-day processing simply saves the intra-day RDB to disk after a little re-organization. 

An example of additional processing (updating a permanent HLOC table and building an NBBO table from scratch) can be found in
:fontawesome-brands-github: 
[KxSystems/kdb/taq/daily.q](https://github.com/KxSystems/kdb/blob/master/taq/daily.q). 

