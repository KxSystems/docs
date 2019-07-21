---
title: Chained tickerplant and RDB for kdb+tick
description: Two scripts provide convenient additional functionality to an existing kdb+tick setup.
author: Simon Garland
keywords: chained, kdb+, q, rdb, tickerplant
---
# Chained tickerplant and RDB for kdb+tick




Two scripts provide convenient additional functionality to an existing kdb+tick setup.


## Chained tickerplant

There are a number of occasions when an additional tickerplant would be useful – but it’s overkill to have a full parallel installation. A chained tickerplant subscribes to the master tickerplant and receives updates like any other subscriber, and then serves that data to its subscribers in turn. Unlike the master tickerplant, it doesn’t keep its own log.

If the master tickerplant is a zero-latency tickerplant the chained tickerplant can be a more traditional tickerplant that chunks up updates on a timer. For example if clients are using data from the tickerplant to drive a GUI it’s pointless having that updated every time a new tick comes in – probably a tickerplant that updates once a second would suffice.

Having a second tickerplant allows keeping ordinary users safely away from the master tickerplant – the master tickerplant can be set up to allow only specific connections – and all other subscribers would have to go to the chained tickerplant.

Start a chained tickerplant from port 5010 with bulk updates.

```bash
$ q chainedtick.q :5010 -p 5110 -t 1000
```

Start a chained tickerplant which echoes updates immediately.
```bash
$ q chainedtick.q :5010 -p 5110 -t 0
```

<i class="fab fa-github"></i> 
[KxSystems/kdb/tick/chainedtick.q](https://github.com/KxSystems/kdb/blob/master/tick/chainedtick.q)


## Chained RDB

A chained RDB can either be connected to the master tickerplant, or to a chained tickerplant. Unlike a default RDB, the chained RDB doesn't have any day-end processing beyond emptying all tables.

The benefit is similar to that of a chained tickerplant – being able to keep ordinary users away from the primary RDB. In particular, if connecting to a chained bulking tickerplant instead of a primary zero latency tickerplant the CPU load will be lower.

Don’t forget though that a second RDB will double up the memory usage – it's an in-memory database and can’t be sharing any data with the primary RDB.

```bash
$ q chainedr.q :5010 -p 5111 / start a chained RDB from :5010
```

<i class="fab fa-github"></i> [KxSystems/kdb/tick/chainedr.q](https://github.com/KxSystems/kdb/blob/master/tick/chainedr.q)

