---
title: Realtime database – Starting kdb+ – Learn – kdb+ and q documentation
description: How to set up and use a real-time database in kdb+
keywords: kdb+, q, rdb, realtime database start, tutorial
---
# Realtime database



kdb+tick is used to capture, store and analyze massive volumes of data in real time. 

:fontawesome-brands-github: 
[KxSystems/kdb-tick](https://github.com/KxSystems/kdb-tick) 

A standard setup might consist of

-   a tickerplant to capture and log incoming data
-   a historical database (HDB) to access all the data prior to the current day
-   a real-time database (RDB) to store the current day’s data in memory and write it to the HDB at the end of day

As a minimum, it is recommended to have RAM of at least 4× expected data size, so for 5 GB data per day, the RDB machine should have at least 20 GB RAM. 
In practice, much larger RAM might be used.


## Data feeds

Data feeds can be any market or other time-series data. A feedhandler converts the data stream into a format suitable for writing to kdb+. These are usually written in a compiled language, such as C, C++, Java or C\#. 

In the example described here, the data feed is generated at random by a kdb+ process.


## Tickerplant

The data feed could be written directly to the RDB. More often, it is written to a kdb+ process called a tickerplant, which will:

-   write all incoming records to a log file
-   push all data to the RDB
-   push all or subsets of the data to other processes

Other processes would subscribe to a tickerplant to receive new data, and each would specify what data should be sent: all or a selection.


## Example

The demo scripts run a simple tickerplant/RDB configuration. 

The layout is:

```txt
            feed
              |
         tickerplant
  /     /     |     \     \    \
rdb   vwap  hlcv   tq    last  show
 /\   /\     /\    /\     /\
   ... client applications ...
```

Where

feed

: is a demo feedhandler that generates random trades and quotes and sends them to the tickerplant. In practice, this would be replaced by real feedhandlers.

tickerplant

: gets data from feed and pushes it to clients that have subscribed. Once the data is written, it is discarded.

rdb

: is an RDB (realtime database) than stores all intra-day data received in memory

vwap, hlcv, tq, last, show

: are RTE (realtime engines) that have subscribed to the tickerplant. Note that these databases can be queried by a client application.

database | role  
---------|-------
vwap     | has volume-weighted averages for selected stocks 
hlcv     | has high, low, close, volume for selected stocks 
tq       | has a trade and quote table for selected stocks; each row is a trade joined with the most recent quote
last     | has the last entries for each stock in the trade and quote tables
show     | counts the updates, and displays the counts periodically 

Note that all the client processes load the same script file `cx.q`, with a parameter that selects the corresponding code for the process in that file. Alternatively, each process could load its own script file, but since the definitions tend to be very short, it is convenient to use a single script for all. More RTE examples: 

:fontawesome-brands-github: 
[KxSystems/kdb/tick/c.q](https://github.com/KxSystems/kdb/blob/master/tick/c.q)  
:fontawesome-brands-github: [KxSystems/kdb/e/c.q](https://github.com/KxSystems/kdb/blob/master/e/c.q) 


### Running the demo

Download kdb+tick. 

:fontawesome-brands-github: 
[KxSystems/kdb-tick](https://github.com/KxSystems/kdb-tick) 

Download the demo scripts. 

:fontawesome-brands-github: 
[KxSystems/cookbook/start/tick](https://github.com/KxSystems/cookbook/tree/master/start/tick)  

Copy `sym.q` (table schema) to `<kdb-tick directory>/tick/sym.q`

From the downloaded `kdb-tick` directory create a tickerplant:
```q
q tick.q -p 5010
```
from a separate terminal window, start an RDB:
```q
q tick/r.q -p 5011
```

From the demo scripts directory run each of the following realtime engines in separate terminal windows:

```q
q cx.q hlcv -p 5014 -t 1000
q cx.q last -p 5015 -t 1000
q cx.q tq -p 5016 -t 1000
q cx.q vwap -p 5017 -t 1000
q cx.q show
```

Create a feedhandler simulator to start data flowing into the system:
```q
q feed.q localhost:5010 -t 500
```

### Process examples

Set focus on the RDB, and view the trade table. 
Note that each time the table is viewed, it is updated with the latest data:

```q
q)trade
sym | time         price size stop cond ex
----| ------------------------------------
AAPL| 14:36:02.656 97.37 11   0    A    N
AIG | 14:36:02.870 19.92 86   0    P    O
AMD | 14:36:03.405 23.21 94   1    W    N
...
```

Set focus on the VWAP window, and view the `vwap` table. Note that `price` is actually `price*size`. This can be updated much more efficiently than storing actual prices and sizes.

```q
q)vwap
sym | price        size
----| -------------------
AAPL| 6.70234e+07  705352
AMD | 1.998351e+07 699901
DOW | 1.709416e+07 705367
...
```

To get the correct weighted-average price:

```q
q)select sym,price%size,size from vwap
sym  price    size
--------------------
AAPL 95.02686 706049
AMD  28.54816 700441
DOW  24.23159 705727
...
```


## kdb+tick modifications

The standard components of kdb+tick support various options. In the basic set-up outlined here, the tickerplant publishes all data immediately, and does not create a log file. Optional parameters of

```bash
q tick.q [schema] [destination directory] [-t N] -p 5010
```

can be supplied. If the destination directory is set, then the schema must also be defined. To modify the supplied example to create a tickerplant log file and to publish data in 1-second batches rather than immediately, start the process with:

```bash
q tick.q sym ./hdb -t 1000 -p 5010
```

Similarly the real-time database can be started with optional host:port:user:pass of the tickerplant and historic database to reload at end-of-day:

```bash
q tick/r.q [tickerplant host:port] [hdb host:port] -p 5011
```

e.g.

```bash
q tick/r.q :5010 :5012 -p 5011
```


## Process communication

The qkdb+ processes communicate by sending a function with arguments using [Interprocess communication](ipc.md).

For example, the tickerplant sends new data to the subscribers by calling the `upd` function with the table name and new data. In the last process, this is:

```q
upd:{[t;x].[t;();,;select by sym from x]}]
```


## More information

:fontawesome-regular-map:
[Streaming Architecture](../../architecture/index.md)

