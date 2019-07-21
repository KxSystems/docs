---
title: Kdb+tick configuration
description: A ‘vanilla’ tick setup has a tickerplant (TP) logging to disk and publishing to an in-memory realtime database (RDB) – and at day-end the RDB data is saved to disk as another day in the history database (HDB). Users typically query the RDB or HDB directly. It doesn’t have to be that way. There are a many other ways of assembling the kdb+tick “building blocks” to reduce or share the load.
keywords: chained, hdb, kdb+, q, rdb, tick, tickerplant
---
# Kdb+tick configuration





A ‘vanilla’ tick setup has a tickerplant (TP) logging to disk and publishing to an in-memory realtime database (RDB) – and at day-end the RDB data is saved to disk as another day in the history database (HDB). Users typically query the RDB or HDB directly.

It doesn’t have to be that way. There are a _many_ other ways of assembling the kdb+tick “building blocks” to reduce or share the load.


## Chained tickerplants

Starting at the beginning with the TP: if this is running in zero-latency mode (i.e. all updates are published immediately to subscribers) it is completely over-the-top to have a client task that is only plotting graphs subscribe for instantaneous update – an update every few seconds would be quite adequate.

One way of doing this is to have a chained TP, or even a chain of them. The first TP would be a zero-latency TP – and would have only clients who truly need immediate update. It in turn would have as one of its clients a TP publishing bulk updates every 100ms. That in turn would have a chained tickerplant as client that publishes updates only every second. Clients then subscribe to the TP with granularity that suits their needs. 

<i class="far fa-hand-point-right"></i> 
[Chained tickerplant and RDB for kdb+tick](chained-tickerplant.md)


## No RDB

Next in the chain comes the RDB. An RDB is an in-memory database, and by day-end can be using a lot of memory. If clients are querying that data intra-day then the memory cost is reasonable – but if the data’s only being collected for insertion into the HDB at day-end the overhead is unreasonable. In such a case it would make sense to write the data to disk during the day so that it’s ready for day-end processing, but with only a small memory footprint to build bulk updates.

<i class="far fa-hand-point-right"></i> 
[Write-only alternative to RDB](w-q.md)


## Chained RDBs

The other extreme is when one RDB isn’t enough - then the same approach can be used with multiple chained RDBs. Depending on the sort of clients it has it may be enough for one of the chained RDBs to subscribe to a bulk-update TP rather than the fastest zero-latency one.

A chained RDB doesn’t have to subscribe to the whole ‘firehose’. It might be useful to have a TP with only the stocks building a particular index, or perhaps only trades and no quotes.

<i class="far fa-hand-point-right"></i> 
[Chained tickerplant and RDB for kdb+tick](chained-tickerplant.md)


## Working with the TP logfile

The TP logs the updates published to subscribers to a file. In the event of a serious crash, this file can be rescued using the utility functions in 
<i class="fab fa-github"></i> 
[simongarland/tickrecover/rescuelog.q](https://github.com/simongarland/tickrecover/blob/master/rescuelog.q)


## `c.q`

Another often-overlooked problem is users fetching vast amounts of raw data to calculate something that could much better be built once, incrementally updated, and then made available to all interested clients. 

A simple example would be keeping a running Open/High/Low/Latest: much simpler to update incrementally with data from the TP each time something changes than to build from scratch. 

A more interesting example is keeping a table of the latest trade and the associated quote for every stock – trivial to do in real time with the incremental updates from the TP, but impossible to build from scratch in a timely fashion with the raw data. 

<i class="fab fa-github"></i> 
[KxSystems/kdb/tick/c.q](https://github.com/KxSystems/kdb/blob/master/tick/c.q)


## `clog.q`

The default version of `c.q` linked to above connects to a TP and starts collecting data. Sometimes that’s not enough and you want to replay the log through the task first. (For example, to get the Open/High/Low for the day, not just since starting the task.) For that, use `clog.q` instead. 

<i class="fab fa-github"></i> 
[simongarland/tick/clog.q](https://github.com/simongarland/tick/blob/master/clog.q)


## `daily.q`

By default, the end-of-day processing simply saves the intra-day RDB to disk after a little re-organization. 

An example of additional processing (updating a permanent HLOC table and building an NBBO table from scratch) can be found in
<i class="fab fa-github"></i> 
[KxSystems/kdb/taq/daily.q](https://github.com/simongarland/tick/blob/master/clog.q). 
