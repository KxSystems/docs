---
title: u.q | Documentation for q and kdb+
description: How to construct systems from kdb+ processes
keywords: kdb+, q, tick, tickerplant, streaming
---
# u.q

`u.q` is available from :fontawesome-brands-github:[KxSystems/kdb-tick](https://github.com/KxSystems/kdb-tick)

## Overview

Contains functions to allow clients to subscribe to all or subsets of available data, publishing to interested clients and  alerting clients to events, for example, end-of-day. Tracks client subscription interest and removes client subscription details on their disconnection.

This script is loaded by other processes, for example [a tickerplant](tickq.md).

## Usage

To allow the ability to publish data to any process, do the following:

-   load `u.q`
-   declare the tables to be published in the top level namespace. Each table must contain a column called `sym`, which acts as the single key field to which subscribers subscribe
-   initialize by calling [`.u.init[]`](#uinit)
-   publish data by calling [`.u.pub[table name; table data]`](#upub)

The list of tables that can be published and the processes currently subscribed are held in [`.u.w`](#variables).

Subscriber processes must open a connection to the publisher and call [`.u.sub[tablename;list_of_symbols_to_subscribe_to]`](#usub).

If a subscriber calls `.u.sub` again, the current subscription is overwritten either for all tables (if a wildcard is used) or the specified table. 
To add to a subscription, for example, add more `syms` to a current subscription, the subscriber can call [`.u.add`](#uadd)).

Clients should define a [`upd`](rq.md#upd) function to receive updates, and [`.u.end`](rq.md#uend) function for end-of-day events.

## Variables

| Name | Description |
| ---- | ---- |
| .u.w | Dictionary of registered client interest in data being processed (for example, tables->(handle;syms) |
| .u.t | Table names |

## Functions

Functions are open source and open to customisation.

### .u.init

Initialise variables used to track registered clients.

```q
.u.init[]
```

Initialises [variables](#variables) by retreiving all tables defined in the root namespace. Used to track client interest in data being published.

### .u.del

Delete subscriber from dictionary of known subscribers ([`.u.w`](#variables)) for given table

```q
.u.del[x;y]
```
Where

* `x` is a table name
* `y` is the connection handle

### .u.sel

Select from table, given optional sym filter. Used to filter tables to clients who may not want everything from the table.

```q
.u.sel[x;y]
```
Where

* `x` is a table
* `y` is a list of syms (can be empty list)

returns the table `x`, which can be filtered by `y`.

### .u.pub

Publish updates to subscribers.

```q
.u.pub[x;y]
```
Where

* `x` is table name (sym type)
* `y` is new data for table `x` (table type)

Actions performed:

* find interested client handles for table `x` and any filter they may have (using [`.u.w`](#variables))
* for each client
    * filter `y` using [`.u.sel`](#usel) (if client specifed a filter at subscription time)
    * publish [asynchronously](../basics/ipc.md#async-message-set) to client, calling their `upd` function with parameters _table name_ and _table data_.


### .u.add

Add client subscription interest in table with optional filter.

```q
.u.add[x;y]
```
Where
* `x` is a table name (sym)
* `y` is list of syms used to filter table data, with empty sym representing for all table data

Actions performed:

* uses [`.z.w`](../ref/dotz.md#zw-handle) to get current client handle.
* find any existing subscriptions to table `x` for client (using [`.u.w`](#variables))
    * if existing, update filter with union on `y`
    * else a new entry is added to [`.u.w`](#variables) with client handle, `x` and `y`.

Returns 2 element list. The first element is the table name. The second element depends on whether `x` refers to a keyed table.

* If `x` is a keyed table, [`.u.sel`](#usel) is used to select from the keyed table the required syms
* otherwise returns an empty table `x` (schema definition of table), with the [grouped attribute](../ref/set-attribute.md#grouped-and-parted) applied to the sym column.

### .u.sub

Used by clients to register subscription interest.

```q
.u.sub[x;y]
```
Where

* `x` is a table name (sym)
* `y` is list of syms used to filter table data, with empty sym representing for all table data

If `x` is empty symbol, client is subscribed to all known tables using `y` criteria. This is achieved by calling .u.sub for each table in [`.u.t`](#variables). 
For the subscribing  client, any previous registered in the given tables are removed prior to reinstating new criteria provided i.e. calls [`.u.del`](#udel).
Calls [`.u.add`](#uadd) to record the client subscription.

Returns 
* a two item list if x is an indivial table name. First item is the table name subscribed to as a symbol. Second item is an empty table (table schema).
* a list of two item lists as described above for each individual table, if x is an empty symbol (i.e. subscribe to all tables)
* an error if the table does not exist.

### .u.end

Inform all registered clients that end-of-day has occured.

```q
.u.end[x]
```

Where `x` is a date, representing the day that is ending.

Iterates over all client handles via [`.u.w`](#variables) and asyncronously calls their `.u.end` function passing `x`.

### .z.pc

Implementation of [`.z.pc`](../ref/dotz.md#zpc-close) callback for connection close.

Called when a client disconnects. The client handle provided is used to call [`.u.del`](#udel) for all tables. This ensures all subscriptions are removed for that client.

## Example

[`tick.q`](tickq.md) is an example of a tickerplant that uses `u.q` for pub/sub. 

In addition, the example scripts below demonstrate pub/sub in a standalone publisher and subscriber.
They can be downloaded from :fontawesome-brands-github:[KxSystems/cookbook/pubsub](https://github.com/KxSystems/cookbook/tree/master/pubsub). 
Each script should be run from the OS command prompt as shown in the following example.

```bash
$ q publisher.q
$ q subscriber.q
```

The publisher generates some random data and publishes it periodically on a timer.

The subscriber receives data from the publisher and is displayed on the screen. You can modify the subscription request and the `upd` function of the subscriber as required. You can run multiple subscribers at once.
