The linked scripts allow you to build an on-disk database and run some queries against it. The database is randomly-generated utility (smart-meter) data for different customers in different regions and industry sectors, along with some associated payment information. The idea is to allow you to see some of the q language and performance. There is some more information in the README file.  
<i class="fab fa-github"></i> [KxSystems/cookbook/tutorial](https://github.com/KxSystems/cookbook/tree/master/tutorial)


## Building the database

The database is built by running the buildsmartmeterdb.q script. You can vary the number of days of data to build, and the number of customer records per day. When you run the script, some information will be printed. Type
```q
go[]
```
to proceed.
```bash
$ q buildsmartmeterdb.q 
KDB+ 3.1 2014.05.03 Copyright (C) 1993-2014 Kx Systems
```
```q
This process is set up to save a daily profile across 61 days for 100000 random customers with a sample every 15 minute(s).
This will generate 9.60 million rows per day and 585.60 million rows in total
Uncompressed disk usage will be approximately 224 MB per day and 13664 MB in total
Compression is switched OFF
Data will be written to :./smartmeterDB

To modify the volume of data change either the number of customers, the number of days, or the sample period of the data.  Minimum sample period is 1 minute
These values, along with compression settings and output directory, can be modified at the top of this file (buildsmartmeterdb.q)
```
To proceed, type `go[]`
```q
q)go[]                                                                                                    
2014.05.15T09:17:42.271 Saving static data table to :./smartmeterDB/static
2014.05.15T09:17:42.291 Saving pricing tables to :./smartmeterDB/basicpricing and :./smartmeterDB/timepricing
2014.05.15T09:17:42.293 Generating random data for date 2013.08.01
2014.05.15T09:17:47.011 Saving to hdb :./smartmeterDB
2014.05.15T09:17:47.775 Save complete
2014.05.15T09:17:47.776 Generating random data for date 2013.08.02
2014.05.15T09:17:52.459 Saving to hdb :./smartmeterDB
2014.05.15T09:17:53.196 Save complete
2014.05.15T09:17:53.196 Generating random data for date 2013.08.03
2014.05.15T09:17:58.006 Saving to hdb :./smartmeterDB
2014.05.15T09:17:58.734 Save complete
2014.05.15T09:17:58.734 Generating random data for date 2013.08.04
2014.05.15T09:18:03.438 Saving to hdb :./smartmeterDB
2014.05.15T09:18:04.194 Save complete

... snip ...

2014.05.15T09:23:09.689 Generating random data for date 2013.09.30
2014.05.15T09:23:14.503 Saving to hdb :./smartmeterDB
2014.05.15T09:23:15.266 Save complete
2014.05.15T09:23:15.271 Saving payment table to :./smartmeterDB/payment/


2014.05.15T09:23:15.281 HDB successfully built in directory :./smartmeterDB
2014.05.15T09:23:15.281 Time taken to generate and store 585.60 million rows was 00:05:33
2014.05.15T09:23:15.281 or 1.76 million rows per second
```


## Running the queries

Once the database has been built, you can start the tutorial by running smartmeterdemo.q. This will print an overview of the database, and a lot of information as to how to step through the queries. Each query will show you the code, a sample of the results, and timing and memory usage information for the query. You can also see the code in smartmeterfunctions.q. (You will also see comments in the code in this script which should help explain how it works.) 
```bash
$ q smartmeterdemo.q 
KDB+ 3.1 2014.05.03 Copyright (C) 1993-2014 Kx Systems
```
```q
DATABASE INFO
-------------
This database consists of 5 tables.
It is using 0 slaves.
There are 61 date partitions.

... snip ... 
```
To start running queries, execute `.tut.n[]`.
```q
... snip ...

Run .tut.help[] to redisplay the below instructions
Start by running .tut.n[].

.tut.n[]     : run the Next example
.tut.p[]     : run the Previous example
.tut.c[]     : run the Current example
.tut.f[]     : go back to the First example
.tut.j[n]    : Jump to the specific example
.tut.db[]    : print out database statistics
.tut.res     : result of last run query
.tut.gcON[]  : turn garbage collection on after each query
.tut.gcOFF[] : turn garbage collection off after each query
.tut.help[]  : display help information
\\           : quit

q).tut.n[]                                                                                                                                                        

**********  Example 0  **********

Total meter usage for every customer over a 10 day period

Function meterusage has definition:

{[startdate; enddate]
 
 start:select first usage by meterid from meter where date=startdate;
 end:select last usage by meterid from meter where date=enddate;
 
 end-start}

2014.05.15T09:27:55.260 Running: meterusage[2013.08.01;2013.08.10]
2014.05.15T09:27:56.817 Function executed in 1557ms using 387.0 MB of memory

Result set contains 100000 rows.
First 10 element(s) of result set:

meterid | usage   
--------| --------
10000000| 3469.449
10000001| 2277.875
10000002| 4656.111
10000003| 2216.527
10000004| 2746.24 
10000005| 2349.073
10000006| 3599.034
10000007| 2450.384
10000008| 1939.314
10000009| 3934.089

Garbage collecting...

*********************************

q)
```


## Experimentation

Please experiment! There are lots of things to try:

- Run each query several times – does the performance change? (Q doesn’t use explicit caching, it relies on the OS file system caches.)
- Run the queries with different parameters.
- If you have multiple cores available, restart the database with [slaves](/basics/cmdline/#-s-slaves). See if some of the query performance changes.
- Rebuild the database and change the number of days of data in the database, and the number of records per day. How is the query performance affected?
- Rebuild the database with [compression](/kb/file-compression) turned on. How does the size vary? And the performance?


## User interface

The Smart-Meter demo includes a basic UI intended for Business Intelligence-type usage. It is intended as a simple example of an HTML5 front end talking directly to the q database. It is not intended as a demonstration of capability in building advanced BI tools or complex GUIs. It is to show the performance of q slicing and dicing the data in different ways directly from the raw dataset, and the q language: the whole report is done in one function, `usagereport`. There isn’t any caching of data; there aren't any tricks.

The report allows for 3 things:

- filtering of the data by date, customer type and region
- grouping (aggregating) by different combinations of dimensions. The aggregated stats are max/min/avg/total/count. If no grouping is selected, the raw usage for every meter is displayed
- pivoting of the data by a chosen field. If the data is pivoted then the `totalusage` value is displayed.

To access the UI, start the smart-meter demo database on port 5600 and point your browser (Chrome or Firefox only please!) at <http://localhost:5600/smartmeter.html>. If the date range becomes large, the query will take more time and memory. Similarly, grouping by hour can increase the time taken. 

!!! warning "32-bit free version"
    It is not hard to exceed the 32-bit memory limits of the free version of q when working on large datasets.

![Smart Meter demo UI](/img/smartmeterui.png)


## What’s next?

Maybe you want to start building your own database? A good place to start is to [load some data from CSV](/kb/loading-from-large-files/).

Or perhaps you want to try one of the [tutorials](/learn/#database-tutorials)?
