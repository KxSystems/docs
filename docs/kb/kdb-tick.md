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

    chainedtick.q contains `\l tick/u.q` therefore has a dependency on [`u.q`](https://github.com/KxSystems/kdb-tick/blob/master/tick/u.q) existing within the directory `tick`.

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

<!--
### `daily.q`

By default, the end-of-day processing simply saves the intra-day RDB to disk after a little re-organization. 

Additional processing, such as a permanent HLOC (high/low/open/close) table and building a NBBO (national best bid and offer) table, can be found in

:fontawesome-brands-github: 
[KxSystems/kdb/taq/daily.q](https://github.com/KxSystems/kdb/blob/master/taq/daily.q). 
-->
