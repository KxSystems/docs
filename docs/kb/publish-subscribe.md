---
title: Publish and subscribe – Knowledge Base – kdb+ and q documentation
description: KxSystems/kdb-tick contains functionality to allow processes to publish data and subscribe to it. It is worth highlighting how the publish-and-subscribe code can be used by any process on a standalone basis. The pubsub functionality is supplied in the u.q script of kdb+tick.
keywords: kdb+, publish, q, subscribe
---
# Publish and subscribe

## Setup

[`.u.q`](../architecture/uq.md) contains functionality to allow processes to publish data and subscribe to it. 
Although commonly used by tickerplants, It is worth highlighting how the publish-and-subscribe code can be used by any process on a standalone basis.

To give the ability to publish data to any process, a few things need to be done:

-   load `u.q`
-   declare the tables to be published in the top level namespace. Each table must contain a column called `sym`, which acts as the single key field to which subscribers subscribe
-   initialize by calling [`.u.init[]`](../architecture/uq.md#uinit)
-   publish data by calling [`.u.pub[table name; table data]`](../architecture/uq.md#upub)

The list of tables that can be published and the processes currently subscribed are held in [`.u.w`](../architecture/uq.md#variables).

Subscriber processes must open a connection to the publisher and call [`.u.sub[tablename;list_of_symbols_to_subscribe_to]`](../architecture/uq.md#usub). 

If a subscriber calls `.u.sub` again, the current subscription will be overwritten either for all tables (if a wildcard is used) or the specified table. To add to a subscription (e.g. add more syms to a current subscription) the subscriber can call [`.u.add`](../architecture/uq.md#uadd)).

## Example

The example scripts below can be downloaded from :fontawesome-brands-github:[KxSystems/cookbook/pubsub](https://github.com/KxSystems/cookbook/tree/master/pubsub). Each script should be run from the OS command prompt e.g.

```bash
$ q publisher.q
$ q subscriber.q
```

The publisher will generate some random data and publish it periodically on a timer.

The subscriber will receive data from the publisher and output it to the screen. You can modify the subscription request and the `upd` function of the subscriber as required. You can run multiple subscribers at once.
