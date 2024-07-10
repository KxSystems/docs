---
title: kdb+tick alternative architecture – Knowledge Base – kdb+ and q documentation
description: A ‘vanilla’ tick setup has a tickerplant (TP) logging to disk and publishing to an in-memory realtime database (RDB) – and at day-end the RDB data is saved to disk as another day in the history database (HDB). Users typically query the RDB or HDB directly. It doesn’t have to be that way. There are a many other ways of assembling the kdb+tick “building blocks” to reduce or share the load.
keywords: chained, hdb, kdb+, q, rdb, tick, tickerplant
---
# kdb+tick alternative architecture


A [‘vanilla’](../architecture/index.md) tick setup has a tickerplant (TP) logging to disk and publishing to an in-memory realtime database (RDB) – and at day-end the RDB data is saved to disk as another day in the history database (HDB). Users typically query the RDB or HDB directly.

It doesn’t have to be that way. There are a _many_ other ways of assembling the kdb+tick “building blocks” to reduce or share the load.


## Chained tickerplants

If the primary tickerplant is running in zero-latency mode (i.e. all updates are published immediately to subscribers) 
it can be inefficient to have a client task that is only plotting graphs subscribe for instantaneous update. An update every few seconds would be quite adequate.

One way of doing this is to have a chained tickerplant, or even a chain of them. 

A chained tickerplant subscribes to the primary tickerplant and receives updates like any other subscriber, and then serves that data to its subscribers in turn.
Unlike the primary tickerplant, *it doesn’t keep its own log*.

If the primary tickerplant is a zero-latency tickerplant the chained tickerplant can be a more traditional tickerplant that chunks up updates on a timer. 
For example if clients are using data from the tickerplant to drive a GUI, it may not need updates hundreds of times per second.
A tickerplant that updates once a second would suffice

### Example

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

## Chained RDBs

A chained RDB can either be connected to the primary tickerplant, or to a chained tickerplant. 
Unlike a default RDB, the chained RDB doesn't have any day-end processing beyond emptying all tables.

The benefit is similar to that of a chained tickerplant i.e. being able to keep ordinary users away from the primary RDB. 
In particular, the CPU load will reduce if connecting to a chained bulking tickerplant instead of a primary zero latency tickerplant.

A chained RDB doesn’t have to subscribe to the whole set of available data.
It might be useful to have an RDB with only the stocks building a particular index, or perhaps only trades and no quotes.

Don’t forget though that a second RDB will increase the memory usage, as it's an in-memory database and can’t be sharing any data with the primary RDB.

### Example

The example script [`chainedr.q`](https://github.com/KxSystems/kdb/blob/master/tick/chainedr.q) can be run as follows:
```bash
q chainedr.q [host]:port[:usr:pwd] [-p 5111]
```

If a tickerplant is running on the same host (port 5010), the following starts a chained RDB on port 5111
```q
$ q chainedr.q :5010 -p 5111 
```

:fontawesome-brands-github: [KxSystems/kdb/tick/chainedr.q](https://github.com/KxSystems/kdb/blob/master/tick/chainedr.q)

## No RDB

An RDB is an in-memory database, and by day-end can be using a lot of memory. If clients are querying that data intra-day then the memory cost is reasonable – but if the data’s only being collected for insertion into the HDB at day-end the overhead is unreasonable. In such a case it would make sense to write the data to disk during the day so that it’s ready for day-end processing, but with only a small memory footprint to build bulk updates.

:fontawesome-regular-hand-point-right: 
[Write-only alternative to RDB](w-q.md)


## Working with the TP logfile

The TP logs the updates published to subscribers to a file. In the event of a serious crash, this file can be rescued using the utility functions in 
:fontawesome-brands-github: 
[simongarland/tickrecover/rescuelog.q](https://github.com/simongarland/tickrecover/blob/master/rescuelog.q)


## `c.q`

Another often-overlooked problem is users fetching vast amounts of raw data to calculate something that could much better be built once, incrementally updated, and then made available to all interested clients. 

A simple example would be keeping a running Open/High/Low/Latest: much simpler to update incrementally with data from the TP each time something changes than to build from scratch. 

A more interesting example is keeping a table of the latest trade and the associated quote for every stock – trivial to do in real time with the incremental updates from the TP, but impossible to build from scratch in a timely fashion with the raw data. 

:fontawesome-brands-github: 
[KxSystems/kdb/tick/c.q](https://github.com/KxSystems/kdb/blob/master/tick/c.q)


## `clog.q`

The default version of `c.q` linked to above connects to a TP and starts collecting data. Sometimes that’s not enough and you want to replay the log through the task first. (For example, to get the Open/High/Low for the day, not just since starting the task.) For that, use `clog.q` instead. 

:fontawesome-brands-github: 
[simongarland/tick/clog.q](https://github.com/simongarland/tick/blob/master/clog.q)


## `daily.q`

By default, the end-of-day processing simply saves the intra-day RDB to disk after a little re-organization. 

An example of additional processing (updating a permanent HLOC table and building an NBBO table from scratch) can be found in
:fontawesome-brands-github: 
[KxSystems/kdb/taq/daily.q](https://github.com/simongarland/tick/blob/master/clog.q). 
