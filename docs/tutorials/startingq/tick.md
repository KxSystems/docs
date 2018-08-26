# 6. Kdb+tick


## 6.1 Overview

Kdb+tick is used to capture, store and analyze massive volumes of data in real time.  
<i class="fab fa-github"></i> [KxSystems/kdb-tick](https://github.com/KxSystems/kdb-tick) 

A standard kdb+tick setup consists of

- a tickerplant to capture and log all the incoming data
- a real-time database (RDB) to store the current day’s data in memory and write it to the historical database (hdb) at the end of day
- a historical database (HDB) to access all the data prior to the current day

As a minimum, it is recommended to have RAM of at least 4× expected data size, so for 5Gb data per day, the RDB machine should have at least 20Gb RAM. In practice, much larger RAM might be used.


## 6.2 Data feeds

Data feeds can be any market or other time series data. A feedhandler converts the data stream into a format suitable for writing to kdb+. These are usually written in a compiled language, such as C, C++, Java or C\#. 

A Reuters RFA feedhandler is available.  
<i class="fab fa-github"></i> [KxSystems/kdb/c/feed/rfa.zip](https://github.com/KxSystems/kdb/blob/master/c/feed/rfa.zip)

In the example described here, the data feed is generated at random by a q process.


## 6.3 Tickerplant

The data feed could be written directly to the RDB. More often, it is written to a q process called a tickerplant, which will:

- write all incoming records to a log file
- push all data to the RDB
- push all or subsets of the data to other processes

Other processes would subscribe to a tickerplant to receive new data, and each would specify what data should be sent: all or a selection.


## 6.4 Example

The demo scripts run a simple tickerplant/RDB configuration.  
<i class="fab fa-github"></i> [KxSystems/cookbook/start/tick](https://github.com/KxSystems/cookbook/tree/master/start/tick) 

The layout is:
```
            feed
              |
         tickerplant
  /     /     |     \     \    \
rdb   vwap  hlcv   tq    last  show
 /\   /\     /\    /\     /\
   ... client applications ...
```
Where

`feed`
: is a demo feedhandler that generates random trades and quotes and sends them to the tickerplant. In practice, this would be replaced by real feedhandlers.

`tickerplant`
: gets data from feed and pushes it to clients that have subscribed. Once the data is written, it is discarded.

`rdb` `vwap` `hlcv` `tq` `last`
: are databases that have subscribed to the tickerplant. Note that these databases can be queried by a client application.

| database | role  |
|----------|-------|
| `rdb`    | has all of today’s data |
| `vwap`   | has volume-weighted averages for selected stocks |
| `hlcv`   | has high, low, close, volume for selected stocks |
| `tq`     | has a trade and quote table for selected stocks. Each row is a trade joined with the most recent quote. |
| `last`   | has the last entries for each stock in the trade and quote tables|
| `show`   | counts the updates, and displays the counts periodically |

Note that all the client processes load the same script file cx.q, with a parameter that selects the corresponding code for the process in that file. Alternatively, each process could load its own script file, but since the definitions tend to be very short, it is convenient to use a single script for all. More examples:  
<i class="fab fa-github"></i> [KxSystems/kdb/tick/c.q](https://github.com/KxSystems/kdb/blob/master/tick/c.q)  
<i class="fab fa-github"></i> [KxSystems/kdb/e/c.q](https://github.com/KxSystems/kdb/blob/master/e/c.q) 


## 6.5 Running the demo

Install kdb+tick.  
<i class="fab fa-github"></i> [KxSystems/kdb-tick](https://github.com/KxSystems/kdb-tick) 

Install the demo scripts.  
<i class="fab fa-github"></i> [KxSystems/cookbook/start/tick](https://github.com/KxSystems/cookbook/tree/master/start/tick)  

The demo displays each q process in its own window. 

- <i class="fab fa-windows"></i> `start/tick/run.bat` 
- <i class="fab fa-linux"></i> `start/tick/run.sh`
- <i class="fab fa-apple"></i> Run the start/tick/run.app application from Finder. (Consult the readme as changes must be made to the default Terminal settings.)

The calls starting each process are essentially:

1. tickerplant – the tick.q script defines the tickerplant, and runs on port 5010
    ```bash
    ..$ q tick.q -p 5010
    ```
2. feed – connects to the tickerplant and sends a new batch every 507 milliseconds
    ```bash
    ..$ q feed.q localhost:5010 -t 507
    ```
3. rdb – the r.q script defines the real time database
    ```bash
    ..$ q tick/r.q -p 5011
    ```
4. show – the `show` process, which does not need a port
    ```bash
    ..$ q cx.q show
    ```


## 6.6 Running processes manually

If the run scripts are unsuitable for your system, then you can call each process manually. In each case, open up a new terminal window, change to the q directory and enter the appropriate command. The tickerplant should be started first.

Kdb+tick uses paths relative to the local directory. To run correctly, you should change directory such that tick.q is in the local directory. For example on a Mac, for each of the following commands, open a new terminal, change to ~/q/start/tick, then:
```bash
~/q/start/tick$ ~/q/m32/q tick.q -p 5010
~/q/start/tick$ ~/q/m32/q feed.q localhost:5010 -t 107
~/q/start/tick$ ~/q/m32/q tick/r.q -p 5011
```
Refer to run1.sh for the remaining processes.


## 6.7 Process examples

Set focus on the `last` window, and view the trade table. Note that each time the table is viewed, it will be updated with the latest data:
```q
q)trade
sym | time         price size stop cond ex
----| ------------------------------------
AAPL| 14:36:02.656 97.37 11   0    A    N
AIG | 14:36:02.870 19.92 86   0    P    O
AMD | 14:36:03.405 23.21 94   1    W    N
...
```
Set focus on the `vwap` window, and view the vwap table. Note that _price_ is actually `price*size`. This can be updated much more efficiently than storing actual prices and sizes.
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


## 6.8 Kdb+tick modifications

The standard components of kdb+tick support various options. In the basic set-up outlined here, the tickerplant publishes all data immediately, and does not create a log file. Optional parameters of
```bash
..$ ~/q/m32/q tick.q [schema] [destination directory] [-t N] -p 5010
```
can be supplied. If the destination directory is set, then the schema must also be defined. To modify the supplied example to create a tickerplant log file and to publish data in 1 second batches rather than immediately, start the process with:
```
..$ ~/q/m32/q tick.q sym ./hdb -t 1000 -p 5010
```
Similarly the real-time database can be started with optional host:port:user:pass of the tickerplant and historic database to reload at end-of-day:
```bash
..$ ~/q/m32/q tick/r.q [tickerplant host:port] [hdb host:port] -p 5011
```
e.g.
```bash
..$ ~/q/m32/q tick/r.q :5010 :5012 -p 5011
```


## 6.9 Process communication

The q processes communicate by sending a function with arguments using [Interprocess communication](ipc).

For example, the tickerplant sends new data to the subscribers by calling the `upd` function with the table name and new data. In the last process, this is:
```q
upd:{[t;x].[t;();,;select by sym from x]}]
```


## 6.10 More information

<i class="fab fa-github"></i> [KxSystems/kdb/d/tick.htm](https://github.com/KxSystems/kdb/blob/master/d/tick.htm)  
<i class="fab fa-github"></i> [Kxsystems/kdb/d/FD_kdb+tick_manual_1.0.doc](https://github.com/KxSystems/kdb/blob/master/d/FD_kdb%2Btick_manual_1.0.doc)

