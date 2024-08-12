---
title: Architecture | Documentation for q and kdb+
description: How to construct systems from kdb+ processes
keywords: hdb, kdb+, q, rdb, tick, tickerplant, streaming
---
# Architecture of kdb+ systems

A kdb+ tick based archecture can be used to capture, process and analyse vasts amount of real-time and historical data.

The following diagram illustrates the components that are often found in a vanilla kdb+ tick setup:

![architecture](../img/architecture.png)

## Components

### Data feed

This is a source of real-time data; for example, financial quotes and trades from Bloomberg or Refinitiv, or readings from a network of sensors.


### Feedhandler

Parses data from the data feed to a format that can be ingested by kdb+.

Multiple feed handlers can be used to gather data from a number of different sources and feed it to the kdb+ system for storage and analysis.

KX’s [Fusion interfaces](../interfaces/index.md#fusion-interfaces) connect kdb+ to a range of other technologies, such as [R](../interfaces/r.md), Apache Kafka, Java, Python and [C](../interfaces/c-client-for-q.md).


### Tickerplant (TP)

A kdb+ processing acting as a TP (tickerplant) captures the initial data feed, writes it to the log file and publishes these messages to any registered subscribers.
Aims for zero-latency.
Includes ingesting data in batch mode.

Manages subscriptions: adds and removes subscribers, and sends subscriber table definitions.

Handles end-of-day (EOD) processing.

[`tick.q`](tickq.md) represents a tickerplant and is provided as a starting point for most environments.

!!! tip "Best practices for tickerplants"

    Tickerplants should be lightweight, not capturing data and using very little memory. 

    For best resilience, and to avoid core resource competition, run them on their own cores.


#### TP Log

This is the file to which the Tickerplant logs the q messages it receives from the feedhandler. It is used for recovery: if the RDB has to restart, the log file is replayed to return to the current state.

!!! tip "Best practices for log files"

    Store the file on a fast local disk to minimize publication delay and I/O waits.

    :fontawesome-regular-map:
    [Data recovery for kdb+tick](../wp/data-recovery.md)
    <br>
    :fontawesome-solid-desktop:
    [Linux production notes](../kb/linux-production.md)


### Real-time database (RDB)

A kdb+ processing acting as a RDB (real-time database) subscribes to messages from the Tickerplant, stores them in memory, and allows this data to be queried intraday.

At startup, the RDB sends a message to the tickerplant and receives a reply containing the data schema, the location of the log file, and the number of lines to read from the log file. It then receives subsequent updates from the TP as they are published.

At end of day usually writes intraday data to the Historical Database, and sends it a new EOD message.

[`r.q`](rq.md) represents a tickerplant and is provided as a starting point for most environments.

!!! tip "Best practices for real-time databases"

    RDBs queried intraday should exploit attributes in their tables. For example, a trade table might be marked as sorted by time (`` `s#time``) and grouped by sym (`` `g#sym``).

    RDBs require RAM as they are storing the intraday messages.
    Calculate how much RAM your RDB needs for a given table:

    (Expected max # of messages) \* schema cost \* flexibility ratio

    Schema cost: for a given row, a sum of the datatype size.
    <br>
    Flexibility ratio: 1.5 is a common value

    :fontawesome-regular-map:
    [Intraday writedown solutions](../wp/intraday-writedown/index.md)


### Real-time engine/subscriber (RTE/RTS)

A kdb+ processing acting as a RTE (real-time engine) subscribes to the intraday messages and typically performs some additional function on receipt of new data – e.g. calculating an order book or maintaining a subtable with the latest price for each instrument.
A RTE is sometimes referred to as a RTS (real-time subscriber).

!!! tip "Best practices for real-time subscribers"

    Write streaming analytics to compute the required results, rather than timed computations.

    Ensure analytics can deal with multiple messages, so there are no dependencies here if the tickerplant runs in batch mode.

    Check analytic run time versus expected TP publish intervals to ensure you don’t bottleneck. In general, look to the most busy and stressful market day for this, and add additional scaling factors.
    E.g. If my TP publishes a message ~every 30ms, my analytic should take less than 30ms to run. To allow for message throughput to double in the TP, the analytic should run in <15ms.

    :fontawesome-regular-map:
    [Order Book: a kdb+ intraday storage and access methodology](../wp/order-book.md)



### Historical database (HDB)

A kdb+ processing acting as a HDB (historical database) provides a queryable data store of historical data;
for example, for creating customer reports on order execution times, or sensor failure analyses.

Large tables are usually stored on disk partitioned by date, with each column stored as its own file.

The dates are referred to as _partitions_ and this on-disk structure contributes to the high performance of kdb+.

!!! tip "Best practices for historical databases"

    Attributes are key. Partition tables on disk on the most-queried column.

    If the first two columns are `time` and `sym`, sorting on `time` within `sym` partitions is assumed and provides a performance boost.

    Can add grouping attribute for other highly-queried columns.

    When creating the database schema consider the symbol versus string type  choice very carefully:

    -   Symbol type: Use symbols for columns with highly repeating data that are queried most frequently e.g. sym, exchange, side etc.
    -   String type: Any highly variable data e.g. order ID

    Database sizing follows the same formula as the RDB sizing.

    Consider using [compression](../kb/file-compression.md) for older data, or less-queried columns, to reduce on-disk size. Typically compression sees ⅕ the space usage.
    When compressing databases, choose compression algorithm and blocksizes through performance comparisons on typical queries.

    :fontawesome-regular-map:
    [Compression in kdb+](../wp/compress/index.md)

#### Example HDB script

A q script named `hdb.q` that can be used by kdb+ to create a HDB process:
```q
/q tick/hdb.q sym -p 5012
if[1>count .z.x;show"Supply directory of historical database";exit 0];
hdb:.z.x 0
/Mount the Historical Date Partitioned Database
@[{system"l ",x};hdb;{show "Error message - ",x;exit 0}]
```
Usage
```bash
q hdb.q SRC [-p 5012]
```

| Parameter Name | Description | Default |
| ---- | ---- | --- |
| SRC | The [directory used by the RDB](rq.md#end-of-day) to which it saves previous values at end-of-day | &lt;none&gt; |
| -p    | [listening port](../basics/cmdline.md#-p-listening-port) for client communication, for example, a RDB instructing the HDB to reload its DB or client queries against the HDB data | &lt;none&gt; |

!!! Note "Standard kdb+ [command line options](../basics/cmdline.md) may also be passed"

A HDB will be empty until the RDB saves its first set of tables at end-of-day.

### Gateway

The entry point into the kdb+ system. Responsible for routing incoming queries to the appropriate processes, and returning their results.

Can connect both the real-time and historical data to allow users to query across both. In some cases, a gateway will combine the result of a series of queries to different processes.

!!! tip "Best practices for gateways"

    Run only lightweight code. 

    Track disconnections and queries submitted.

    Return sensible errors when queries fail.

    Use the [deferred-response]((../basics/internal.md#-30x-deferred-response) feature (V3.6) to avoid additional coding on the side of connecting non-kdb+ processes.

    [Load-management](../kb/load-balancing.md): round-robin might not be the best option for your system. 
    Consider other options specific to your APIs and load.

    :fontawesome-regular-map:
    [Query Routing: A kdb+ framework for a scalable, load balanced system](../wp/query-routing/index.md)


