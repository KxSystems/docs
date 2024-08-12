---
title: RBB (r.q) | Documentation for q and kdb+
description: How to construct an RDB
keywords: kdb+, q, rdb, streaming
---
# Real-time Database (RDB) using r.q

`r.q` is available from :fontawesome-brands-github:[KxSystems/kdb-tick](https://github.com/KxSystems/kdb-tick)

## Overview

A kdb+ process acting as an RDB stores a current day’s data in-memory for client queries.
It can write its contents to disk at end-of-day, clearing out it in-memory data to prepare for the next day.
After writing data to disk, it communicates with a HDB to load the written data.

### Customization

`r.q` provides a starting point to most environments. The source code is freely avaialble and can be tailered to individual needs. For example:

#### Memory use

The default RDB stores all of a days data in memory before end-of-day writing to disk. The host machines should be configured that all required resources 
can handle the demands that may be made of them (both for today and the future).
Depending on when there may be periods of low/no activity, [garbage collection](../ref/dotq.md#gc-garbage-collect) could be deployed after clearing tables at end-of-day, or a system for intra-day writedowns.

#### User queries

A gateway process should control user queries and authorization/authentication, using RDBs/RTEs/HDBs to retrieve the required information.
If known/common queries can be designed, the RDB can load additional scripts to pre-define functions a gateway can call.

### End-of-day

The end-of-day event is governed by the tickerplant process. The tickerplant calls the RDB [`.u.end`](#uend) function when this event occurs.
The main end-of-day event for an RDB is to save todays data from memory to disk, clear its tables and uses IPC to instruct the HDB to be aware of a new days dataset for it to access.

!!! Note "[.u.rep](#urep) sets the HDB directory be the same as the tickerplant log file directory. This can be edited to use a different directory if required"

### Recovery

Using IPC ([sync request](../basics/ipc.md#sync-request-get)), the RDB process can retrieve the current tickerplant log location and use via the [variables](tickq.md#variables) the tickerplant maintains.
The function [`.u.rep`](#urep) is then used to [replay the log](../kb/logging.md#replaying-log-files), repopulating the RDB.

!!! Note "The RDB should be able to access the tickerplant log from a directory on the same machine. The RDB/tickerplant can be changed to reside on different hosts but this increases the resources needed to transmit the log file contents over the network."

## Usage

```bash
q tick/r.q [host1]:port1[:usr:pwd] [host2]:port2[:usr:pwd] [-p 5020]
```

| Parameter Name | Description | Default |
| ---- | ---- | --- |
| host1 | host running kdb+ instance that the RDB will subscribe to e.g. tickerplant host | localhost |
| port1 | port of kdb+ instance that the RDB will subscribe to  e.g. tickerplant port | 5010 |
| host2 | host of kdb+ instance to inform at end-of-day, after data saved to disk  e.g. HBD host | localhost |
| port2 | port of kdb+ instance to inform at end-of-day, after data saved to disk  e.g. HBD port | 5012 |
| usr   | username | &lt;none&gt; |
| pwd   | password | &lt;none&gt; |
| -p    | [listening port](../basics/cmdline.md#-p-listening-port) for client communications | &lt;none&gt; |

!!! Note "Standard kdb+ [command line options](../basics/cmdline.md) may also be passed"

## Variables

| Name | Description |
| ---- | ---- |
| .u.x | Connection list. First element populated by [`host1`](#usage) (tickerplant), and second element populated by [`host2`](#usage) (HDB) |

## Functions

Functions are open source & open to customisation.

### upd

Called by external process to update table data. Defaults to [`insert`](../ref/insert.md) to insert/append data to a table.

```q
upd[x;y]
```
Where

* `x` is a symbol atom naming a table
* `y` is table data to add to table `x`, which can contain one or more rows.

### .u.end

Perform end-of-day actions of saving tables to disk, clearing tables and running reload on HDB instance to make it aware of new day of data.

```q
.u.end[x]
```
Where x is the date that has ended.

Actions performed:

* finds all tables with the group attribute on the sym column
* calls [`.Q.dpft`](../ref/dotq.md#hdpf-save-tables), with params: 
    * HDB connection from [`.u.x`](#variables) (second element)
    * current directory (note: directory was changed in [`.u.rep`](#urep))
    * date passed to this function (`x`) i.e. day that is ending
    * `` `sym `` column
* re-apply group attribute to sym column for those tables found in first steps (as clearing the table removed grouped attribute)

### .u.rep

Initialise RDB by creating tables, which is then populated with any existing tickerplant log. Will set the HDB directory to use at end-of-day.

```q
.u.rep[x;y]
```
Where

* `x` is a list of table details, each element a two item list
    * symbol for table name
    * schema table
* `y` is the tickerplant log details.log comprising of a two item list:
    * a long for the log count (null represents no log)
    * a file symbol for the location of the current tickerplant log (null represents no log)

Actions performed:

* tables are created using `x`
* if a tickerplant log file has been provided
    * log file is replayed using [`-11!`](../basics/internal.md#-11-streaming-execute) to populate tables
    * set the HDB directory by changing the working directory to the same directory as used by the log file (see [`tick.q`](tickq.md#usage) for details on how to alter the log file directory).

