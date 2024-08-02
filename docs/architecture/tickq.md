---
title: tick.q | Documentation for q and kdb+
description: How to construct a tickerplant process
keywords: hdb, kdb+, q, tick, tickerplant, streaming
---
# Tickerplant (TP) using tick.q

`tick.q` is available from :fontawesome-brands-github:[KxSystems/kdb-tick](https://github.com/KxSystems/kdb-tick)

## Overview

All incoming streaming data is processed by a kdb+ process acting as a tickerplant.
A tickerplant writes all data to a tickerplant log (to permit data recovery) and publishes data to subscribed clients, for example a RDB.

### Customization

`tick.q` provides a starting point to most environments. The source code is freely available and can be tailored to individual needs.

### Schema file

A tickerplant requires a schema file.
A schema file describes the data you plan to capture, by specifying the tables to be populated by the tickerplant environment. 
The [datatypes](../basics/datatypes.md) and [attributes](../ref/set-attribute.md) are denoted within the file as shown in this example:
```q
quote:([]time:`timespan$(); sym:`g#`symbol$(); bid:`float$(); ask:`float$(); bsize:`long$(); asize:`long$(); mode:`char$(); ex:`char$())
trade:([]time:`timespan$(); sym:`g#`symbol$(); price:`float$(); size:`int$(); side:`char$())
```

The default setup requires the first two columns to be `time` and `sym`.

### Real-time vs Batch Mode

_The mode is controlled via the [`-t`](#usage) command line parameter._
Batch mode can alleviate CPU use on both the tickerplant and its subscribers by grouping together multiple ticks within the timer interval prior to sending/writing. 
This comes at the expense of tickerplant memory (required memory to hold several ticks) and increased latency that may occur between adding to the batch and sending. 
There is no ideal setting for all deployments as it depends on the frequency of the ticks received. 
Real-time mode processes every tick as soon as they occur.

!!! note "A feedhandler can be written to send messages comprising of multiple ticks to a tickerplant. In this situation real-time mode will already be processing batches of messages."

### End-of-day

The tickerplant watches for a change in the current day. 
As the day ends, a new tickerplant log is created and the tickerplant informs all subscribed clients, via their `.u.end` function. 
For example, a RDB may implement [`.u.end`](rq.md#uend) to write down all in-memory tables to disk which can then be consumed by a HDB. 

### Tickerplant Logs

[Log files](../kb/logging.md) are created using the format `<tickerplant log dir>/<schema filename><date>` e.g. `tplog/sym2022.02.02`.
These record all published messages and permit recovery by downstream clients, by allowing them to replay messages they have missed.
The directory used should have enough space to record all published data.

As end-day-day causes a file roll, a process should be put in place to remove old log files that are no longer required.

!!! note "The tickerplant does not replay log files for clients, but exposes [log file details](#variables) to clients so they can access the current log file"

### Publishing to a tickerplant

Feed handlers publish ticks to the tickerplant using [IPC](../basics/ipc.md). These can be a kdb+ process or clients written in any number of different languages that use one of the available client APIs.
Each feed sends data to the tickerplant  by calling the [`.u.upd`](#uupd) function. The call can include one or many ticks. For example, publishing from kdb+:

```q
q)h:hopen 5010                                                               / connect to TP on port 5010 of same host
q)neg[h](".u.upd";`trade;(.z.n;`APPL;35.65;100;`B))                          / async publish single tick to a table called trade
q)neg[h](".u.upd";`trade;(10#.z.n;10?`MSFT`AMZN;10?10000f;10?100i;10?`B`S))  / async publish 10 ticks of some random data to a table called trade
...
```

### Subscribing to a tickerplant

Clients, such as a RDB or RTE, can subscribe by calling [`.u.sub`](uq.md#usub) over [IPC](../basics/ipc.md).

```q
q)h:hopen 5010                          / connect to TP on port 5010 of same host
q)h".u.sub[`;`]"                        / subscribe to all updates
```
```q
q)h:hopen 5010                          / connect to TP on port 5010 of same host
q)h".u.sub[`trade;`MSFT.O`IBM.N]"       / subscribe to updates to trade table that contain sym value of MSFT.O or IBM.N only
```

Clients should implement functions [`upd`](rq.md#upd) to receive updates, and [`.u.end`](rq.md#uend) to perform any end-of-day actions.

## Usage

```bash
q tick.q SRC DST [-p 5010] [-t 1000] [-o hours]
```

| Parameter Name | Description | Default |
| --- | --- | --- |
| SRC | schema filename, loaded using the format `tick/<SRC>.q` | sym |
| DST | directory to be used by tickerplant logs. _No tickerplant log is created if no directory specified_ | &lt;none&gt; |
| -p  | [listening port](../basics/cmdline.md#-p-listening-port) for client communications | 5010 |
| -t  | [timer period](../basics/cmdline.md#-t-timer-ticks) in milliseconds. Use zero value to enable real-time mode, otherwise will operate in batch mode. | real-time mode (with timer of 1000ms) |
| -o  | [utc offset](../basics/cmdline.md#-o-utc-offset) | localtime |

!!! Note "Standard kdb+ [command line options](../basics/cmdline.md) may also be passed"

## Variables

| Name | Description |
| ---- | ---- |
| .u.w | Dictionary of registered clients interest in data being processed i.e. tables->(handle;syms) |
| .u.i | Msg count in log file |
| .u.j | Total msg count (log file plus those held in buffer) - used when in batch mode |
| .u.t | Table names |
| .u.L | TP log filename |
| .u.l | Handle to tp log file |
| .u.d | Current date |

## Functions

Functions are open source & open to customisation.

### .u.endofday

Performs end-of-day actions.

```q
.u.endofday[]
```

Actions performed:

* inform all subscribed clients (for example, RDB/RTE/etc) that the day is ending by calling [.u.end](uq.md#uend)
* increment current date ([`.u.d`](#variables)) to next day
* roll log if using tickerplant log, i.e.
    * close current tickerplant log ([`.u.l`](#variables))
    * create a new tickerplant log file i.e set [`.u.l`](#variables), call [`.u.ld`](#uld) with new date

### .u.tick

Performs initialisation actions for the tickerplant.

```q
.u.tick[x;y]
```

Where

* `x` is the name of the schema file without the `.q` file extension i.e. [`SRC`](#usage) command line parameter
* `y` is the directory used to store tickerplant logs i.e. [`DST`](#usage) command line parameter

Actions performed:

* call [`.u.init[]`](uq.md#uinit) to initialise table info, [`.u.t`](#variables) and [`.u.w`](#variables)
* check first two columns in all tables of provided schema are called `time` and `sym` (throw `timesym` error if not)
* apply [`grouped`](../ref/set-attribute.md#grouped-and-parted) attribute to the sym column of all tables in provided schema
* set [`.u.d`](#variables) to current local date, using [`.z.D`](../ref/dotz.md#zt-zt-zd-zd-timedate-shortcuts)
* if a tickerplant log filename was provided:
    * set [`.u.L`](#variables) with a temporary value of `` `:<log filename>/<schema filename>.......... `` (will have date added in next step)
    * create/initialise the log file by calling [`.u.ld`](#uld), passing [`.u.d`](#variables) (current local date)
    * set [`.u.l`](#variables) to log file handle

### .u.ld

Initialise or reopen existing log file.

```q
.u.ld[x]
```

Where `x` is current date. Returns handle of log file for that date.

Actions performed:

* using [`.u.L`](#variables), change last 10 chars to provided date and create log file if it doesnt yet exist
* set [`.u.i`](#variables) and [`.u.j`](#variables) to count of valid messages currently in log file
* if log file is found to be corrupt (size bigger than size of number of valid messages) an error will be returned
* open new/existing log file

### .u.ts

Given a date, runs end-of-day procedure if a new day has started.

```q
.u.ts[x]
```
Where x is a date.

Compares date provided with [`.u.d`](#variables). If no change, no action taken. 
If one day difference (i.e. a new day), [`.u.endofday`](#uendofday) is called. 
More than one day results in an error and the kdb+ timer is cancelled.

### .u.upd

Update tickerplant with data to process/analyse. External processes call this to input data into the tickerplant.

```q
.u.upd[x;y]
```
Where

* `x` is table name (sym)
* `y` is data for table `x` (list of column data, each element can be an atom or list)

#### Batch Mode

Add each recieved message to batch and record message to tickerplant log. Batch will be published on running timer.

Actions performed:
* If the first element of  `y` is not a timespan (or list of timespan)
    * inspect [`.u.d`](#variables), if a new day has occured call [`.z.ts`](#batch-mode_1)
    * add a new timespan column populated with the current local time ([`.z.P`](../ref/dotz.md#zp-local-timestamp)). If mutiple rows of data, all rows receive the same time.
* Add data to current batch (i.e. new data `y` inserted into table `x`), which will be published on batch timer [`.z.ts`](#batch-mode_1).
* If tickerplant log file created, write upd function call & params to the log and increment [`.u.j`](#variables) so that an RDB can execute what was originally called during recovery.


#### Realtime Mode

Publish each received message to all interested clients & record message to tickerplant log.

Actions performed:

* Checks if end-of-day procedure should be run by calling [`.u.ts`](#uts) with the current date
* If the first element of `y` is not a timespan (or list of timespan), add a new timespan column populated with the current local time ([`.z.P`](../ref/dotz.md#zp-local-timestamp)). If mutiple rows of data, all rows receive the same time.
* Retrieves the column names of table `x`
* Publish data to all interested clients, by calling [`.u.pub`](uq.md#upub) with table name `x` and table generated from `y` and column names.
* If tickerplant log file created, write upd function call & params to the log and increment [`.u.i`](#variables) so that an RDB can execute what was originally called during recovery

### .z.ts

Defines the action for the kdb+ timer callback function [`.z.ts`](../ref/dotz.md#zts-timer). 

The frequency of the timer was set on the [command line](#usage) ([`-t`](../basics/cmdline.md#-t-timer-ticks) command-line option or [`\t`](../basics/syscmds.md#t-timer) system command).

#### Batch Mode

Runs on system timer at specified interval.

Actions performed:

* For every table in [`.u.t`](#variables)
    * publish data to all interested clients, by calling [`.u.pub`](uq.md#upub) with table name `x` and table generated from `y` and column names.
    * reapply the grouped attribute to the sym column
* Update count of processed messages by setting [`u.i`](#variables) to [`u.j`](#variables) (the number of batched messages).
* Checks if end-of-day procedure should be run by calling [`.u.ts`](#uts) with the current date 

#### Realtime Mode

If batch timer not specified, system timer is set to run every 1000 milliseconds to check if end-of-day has occured.
End-of-day is checked by calling [`.u.ts`](#uts), passing current local date ([`.z.D`](../ref/dotz.md#zt-zt-zd-zd-timedate-shortcuts)).

### Pub/Sub functions

`tick.q` also loads [`u.q`](uq.md) which enables all of its features within the tickerplant.

