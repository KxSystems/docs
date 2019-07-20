---
title: Using R with kdb+
description: How to enable R to connect to kdb+ and extract data; embed R inside q and invoke R routines; enable q to connect to a remote instance of R via TCP/IP and invoke R routines remotely; and enable q to load the R maths library and invoke R math routines locally.
keywords: interface, kdb+, library, q, r
hero: <i class="fab fa-superpowers"></i> Fusion for Kdb+
---
# <i class="fab fa-r-project"></i> Using R with kdb+



## Introduction

Kdb+ and R are complementary technologies. Kdb+ is the world’s leading timeseries database and incorporates a programming language called q. [R](https://www.r-project.org/) is a programming language and environment for statistical computing and graphics. Both are tools used by data scientists to interrogate and analyze data. Their features sets overlap in that they both:

-   are interactive development environments
-   incorporate vector languages
-   have a built-in set of statistical operations
-   can be extended by the user
-   are well suited for both structured and ad-hoc analysis

They do however have several differences:

-   q can store and analyze petabytes of data directly from disk whereas R is limited to reading data into memory for analysis
-   q has a larger set of datatypes including extensive temporal times (timestamp, timespan, time, second, minute, date, month) which make temporal arithmetic straightforward
-   R contains advanced graphing capabilities whereas q does not
-   built-in routines in q are generally faster than R
-   R has a more comprehensive set of pre-built statistical routines

When used together, q and R provide an excellent platform for easily performing advanced statistical analysis and visualization on large volumes of data.

R can be called as a server from q, and vice-versa.


### Q and R working together

Given the complementary characteristics of the two languages, it is important to utilize their respective strengths. 
All the analysis could be done in q; the q language is sufficiently flexible and powerful to replicate any of the pre-built R functions. 
Below are some best practice guidelines, although where the line is drawn between q and R will depend on both the system architecture 
and the strengths of the data scientists using the system.

-   Do as much of the analysis as possible in q. Q analyzes the data directly from the disk and it is always most efficient to do as much work as possible as close to the data as possible. Whenever possible avoid extracting large raw datasets from q. When extractions are required, use q to create smaller aggregated datasets
-   Do not re-implement tried and tested R routines in q unless they either
    -   can be written more efficiently in q and are going to be called often
    -   require more data than is feasible to ship to the R installation
-   Do use R for data visualization


### Interfaces

There are four ways to interface q with R:

1.  **R can connect to kdb+ and extract data** – loads a shared library into R, connects to kdb+ via TCP/IP
2.  **Embed R inside q and invoke R routines** – loads the R library into q, instantiates R
3.  **Q can connect to a remote instance of R** via TCP/IP and invoke R routines remotely
4.  **Q can load the R maths library** and invoke the R math routines locally

From the point of view of the user, q and R may be:

-   both on the local machine
-   one local and one remote
-   both remote but local to each other
-   both remote and remote from each other

Considering the potential size of the data, it is probably more likely that the kdb+ installation containing the data will be hosted remotely from the user. Points to consider when selecting the integration method are:

-   if interactive graphing is required, either interface (1) or (2) must be used
-   interface (2) can only be used if the q and R installations are installed on the same server
-   interfaces (2) and (4) require less data transfer between (possibly remote) processes
-   interfaces (2) and (3) both require variables to be copied from kdb+ to R for processing, meaning that at some point in time two copies of the variable will exist, increasing total memory requirements


## Calling q from R


### rkdb: R client for kdb+

<div class="fusion" markdown="1">
<i class="fab fa-superpowers"></i> [Fusion for kdb+](fusion.md)
</div>

Connects R to a kdb+ database to extract partially analyzed data into R 
for further local manipulation, analysis and display. 

Operating systems: tested and available for 

-   <i class="fab fa-linux"></i> Linux (64-bit)
-   <i class="fab fa-apple"></i> macOS 
-   <i class="fab fa-windows"></i> Windows (32-bit and 64-bit)

Download from <i class="fab fa-github"></i> [KxSystems/rkdb](https://github.com/KxSystems/rkdb) and follow the [installation instructions](https://github.com/KxSystems/rkdb#installation). 

The interface allows R to connect to a kdb+ database and send it a request, which can optionally return a result. 
Three methods are available:

`open_connection(hostname, port, username:password)`
: Open a connection to a q database. Multiple connections can be open at once

`close_connection(connectionhandle)`
: Close a connection

`execute(connectionhandle, request)`
: Execute a request on the specified connection handle. Where `connectionhandle` is:

    -   &gt;0, executes the request synchronously, blocking the call
    -   &lt;0, executes the request asynchronously; the result may arrive later

To open and initialize a connection from R to a kdb+ process on `localhost` listening on port 5000, with a trade table loaded:

```r
library(rkdb)
test.rkdb()  # run kdb+ on localhost:5000 for this
h<-open_connection("127.0.0.1",5000,"testusername:testpassword") 
```

To request data and plot it:

```r
> execute(h,"select count i by date from trade")
date x
1 2014-01-09 5125833
2 2014-01-10 5902700
3 2014-01-13 4419596
4 2014-01-14 4106744
5 2014-01-15 6156630
> # Setting TZ and retrieving time as timestamp simplifies time conversion
> Sys.setenv(TZ = "GMT")
> res<-execute(h,"select tradecount:count i, sum size, last price, vwap: size wavg price by time:0D00:05 xbar date+time from trade where date=2014.01.14,sym=`GOOG,time within 09:30 16:00")
head(res)
                 time tradecount   size    price     vwap
1 2014-01-14 09:30:00       1471 142868 1132.000 1136.227
2 2014-01-14 09:35:00       1053  65599 1130.250 1132.674
3 2014-01-14 09:40:00       1019  77808 1132.422 1130.405
4 2014-01-14 09:45:00        563  39372 1130.846 1130.835
5 2014-01-14 09:50:00        586  38944 1129.312 1129.999
6 2014-01-14 09:55:00        573  44591 1131.100 1129.720
> plot(res$time ,res$price ,type="l",xlab="time",ylab="price")
```

which produces the plot in Figure 1: 

![Last-traded price plot drawn from R](../img/r/figure1.svg)  
_Figure 1: Last-traded price plot drawn from R_

More comprehensive graphing is available in additional R packages, which can be freely downloaded. 
For example, using the [xts](http://r-forge.r-project.org/projects/xts) package:

```r
> library(xts)
# extract the HLOC buckets in 5-minute intervals
> res<-execute(h,"select high:max price,low:min price,open:first price, close:last price by time:0D00:05 xbar date+time from trade where date=2014.01.14,sym=`GOOG,time within 09:30 16:00")
# create an xts object from the returned data frame
# order on the time column
> resxts <-xts(res[,-1], order.by=res[,'time'])
# create a vector of colours for the graph
# based on the relative open and close prices
> candlecolors <- ifelse(resxts[,'close'] > resxts[,'open'], 'GREEN', 'RED')
# display the candle graph with approrpiate labels
> plot.xts(resxts, type='candles', width=100, candle.col=candlecolors, bar.col='BLACK', xlab="time", ylab="price", main="GOOG HLOC")
```

produces the plot in Figure 2: 

![Candlestick plot using xts package](../img/r/figure2.png)  
_Figure 2: Candlestick plot using xts package_

Another popular package is the [quantmod](http://www.quantmod.com) package which contains the `chartSeries` function.

```r
> library(quantmod)
# extract the last closing price in 30 second buckets
> res<-execute(h,"select close:last price by time:0D00:00:30 xbar date+time from trade where date=2014.01.14,sym=`GOOG,time within 09:30 16:00")
# create the closing price xts object
> closes <-xts(res[,-1], order.by=res[,'time'])
# chart it. Add Bollinger Bands to the main graph
# add additional Relative Strength Indicator and Rate Of Change graphs
> chartSeries(closes,theme=chartTheme("white"),TA=c(addBBands(),addTA(RSI( closes)),addTA(ROC(closes))))
```

This produces the plot shown in Figure 3: 

![Chart example from quantmod package](../img/r/figure3.svg)  
_Figure 3: Chart example from quantmod package_

Close the connection when done: ￼

```r
￼> close_connection(h)
[1] 0
```

Help with more details and some examples is available via `R` help facilities.

```r
?close_connection
close_connection            package:rkdb            R Documentation

Close connection to kdb+ instance.

Description:

     Close connection to kdb+ instance.

Usage:

     close_connection(con)

Arguments:

     con: Connection handle.

Value:

     0 on closed connection.

Examples:

     ## Not run:

     close_connection(h)
     ## End(Not run)

?execute
?open_connection
```


### RODBC with kdb+

Although it is not the recommended method, if R is running on Windows, the q ODBC driver can be used to connect to kdb+ from R. 

<i class="far fa-hand-point-right"></i> 
[Kdb+ server for ODBC](q-server-for-odbc.md)

The RODBC package should be installed in R. An example is given below.

```r
# install RODBC￼￼￼
> install.packages("RODBC")
# load it
> library(RODBC)
# create a connection to a predefined DSN
> ch <- odbcConnect("localhost:5000") # run a query
# s.k should be installed on the q server to enable standard SQL
# However, all statements can be prefixed with q) to run standard q.
> res <- sqlQuery(ch, paste('q)select count i by date from trade'))
```


## Calling R from q

There are three interfaces which allow you to invoke R from q, for both 32- and 64-bit builds. 
If the appropriate build is not available for your target system, 
it can be built from source by following the instructions outlined in the associated README. 

<i class="fab fa-github"></i> 
[KxSystems/cookbook/r](https://github.com/KxSystems/cookbook/tree/master/r)


### embedR: Embedding R inside q

<div class="fusion" markdown="1">
<i class="fab fa-superpowers"></i> [Fusion for kdb+](../fusion)
</div>

<i class="fab fa-github"></i> 
[kxsystems/embedr](https://github.com/kxsystems/embedr)

A shared library can be loaded which brings R into the q memory space, 
meaning all the R statistical routines and graphing capabilities can be invoked directly from q. 
Using this method means data is not passed between remote processes. The library has five methods:

-   `Ropen`: open R
-   `Rclose`: close R
-   `Rcmd`: run an R command, do not return a result
-   `Rget`: run an R command, return the result to q
-   `Rset`: set a variable in the R memory space

The `R_HOME` environment variable must be set prior to starting q. 
To find out what that should be, run R from the Bash shell and see the result of `R.home()`

```r
> R.home()
[1] "/Library/Frameworks/R.framework/Resources"
```

and then set it accordingly in your environment; e.g. for macOS with a Bash shell

```bash
$export R_HOME=/Library/Frameworks/R.framework/Resources
```

Optional additional environment variables are `R_SHARE_DIR`, `R_INCLUDE_DIR`, `LD_LIBRARY_PATH` (for libR.so).

An example is outlined below, using q to subselect some data and then passing it to R for graphical display.

```q
q)select count i by date from trade
date      | x       
----------| --------
2014.01.07| 29205636
2014.01.08| 30953246
2014.01.09| 30395962
2014.01.10| 29253110
2014.01.13| 32763630
2014.01.14| 29721162
2014.01.15| 30035729
..

/- extract mid prices in 5 minute bars
q)mids:select mid:last .5*bid+ask by time:0D00:05 xbar date+time from quotes where date=2014.01.17,sym=`IBM,time within 09:30 16:00
q)mids
time                         | mid     
-----------------------------| --------
2014.01.15D09:30:00.000000000| 185.92  
2014.01.15D09:35:00.000000000| 185.74  
2014.01.15D09:40:00.000000000| 186.11  
2014.01.15D09:45:00.000000000| 186.36  
2014.01.15D09:50:00.000000000| 186.5   
2014.01.15D09:55:00.000000000| 186.98  
2014.01.15D10:00:00.000000000| 187.45  
2014.01.15D10:05:00.000000000| 187.48  
2014.01.15D10:10:00.000000000| 187.66  
..

/- Load in R
q)\l rinit.q
/- Pass the table into the R memory space
q)Rset["mids";mids]￼￼￼￼￼
/- Graph it
q)Rcmd["plot(mids$time,mids$mid,type=\"l\",xlab=\"time\",ylab=\"price\")"]
```

This will produce a plot as shown in Figure 4: 

![Quote mid price plot drawn from q](../img/r/figure4.svg)  
_Figure 4: Quote mid price plot drawn from q_

To close the graphics window, use `dev.off()` rather than the close button on the window.

```q
q)Roff[]
```

Alternatively, the table can be written to a file with

```q
q)Rcmd["pdf('test.pdf')"]
q)Rcmd["plot(mids$time,mids$mid,type='l',xlab='time',ylab='price')"]
q)Roff[]
```

If the q and R installations are running remotely from the user on a Linux machine, the graphics can be seen locally using X11 forwarding over SSH.

Aside from using R’s powerful graphics, this mechanism also allows you to call R analytics from within q. 
Using a rather simple example of an average

```q
q)\l rinit.q
q)prices:10?100
q)Rset["prices";prices]
q)Rcmd["meanPrices<-mean(prices)"]
q)Rget"meanPrices"
,55.6
q)avg prices / agrees with q?
55.6
```

That’s a trivial example to demonstrate the mechanism in which you can leverage the 5,000 libraries available to R from within q.


### Embedded R maths library

R contains a maths library which can be compiled standalone. 
The functions can then be exposed to q by wrapping them in C code which handles the mapping between R datatypes and q datatypes (K objects). 
See <i class="fab fa-github"></i> [github.com/rwinston/kdb-rmathlib](https://github.com/rwinston/kdb-rmathlib)
for an example of integrating q with the R API (i.e. making use of some statistical functions from q).

```q
q)\l rmath.q
q)x:rnorm 1000     / create 1000 normal variates
q)summary x        / simple statistical summary of x
q)hist[x;10]       / show histogram (bin count) with 10 bins
q)y:scale x        / x = (x - mean(x))/sd(x)
q)quantile[x;.5]   / calculate the 50% quantile
q)pnorm[0;1.5;1.5] / cdf value for 0 for a N(1.5,1.5) distribution
q)dnorm[0;1.5;1.5] / normal density at 0 for N(1.5;1.5) distribution
```

<i class="far fa-hand-point-right"></i> 
Andrey’s [althenia.net/qml](http://althenia.net/qml)
for an embedded math lib


### Remote R: Rserve

Rserve allows applications to connect remotely to an R instance over TCP/IP. 
The methods are the same as those outlined above, 
the difference being that all data is passed over TCP/IP rather than existing in the same memory space. 

Every connection to Rserve has a separate workspace and working directory, 
which means user-defined variables and functions with name clashes will not overwrite each other. 
This differs from the previous method where, if two users are using the same q process, 
they can overwrite each other’s variables in both the q and R workspaces.


## Example: correlating stock price returns

R has a built-in operation to produce a correlation matrix of aligned datasets. 
Q does not, but one can easily be built. 
In this example we will investigate different approaches for calculating the correlation of time-bucketed returns 
for a set of financial instruments. Possible approaches are:

1.  Extract raw data from q into R for each instrument and calculate the correlation
2.  Extract bucketed data from q into R, align data from different instruments, and correlate
3.  Extract bucketed data with prices for different instruments aligned from q into R, and correlate
4.  Calculate the correlations in q

We will use a randomly-created set of equities data, with prices ticking between 8am and 5pm.

```q
q)select count i by date from trade where date.month=2014.01m
date      | x       
----------| --------
2014.01.07| 29205636
2014.01.08| 30953246
2014.01.09| 30395962
2014.01.10| 29253110
2014.01.13| 32763630
2014.01.14| 29721162
2014.01.15| 30035729
q)select count i by date from trade where date.month=2014.01m,sym=`GOOG
date      | x    
----------| -----
2014.01.07| 37484
2014.01.08| 31348
2014.01.09| 28573
2014.01.10| 32228
2014.01.13| 38461
2014.01.14| 39853
2014.01.15| 30136
```

We will use the R interface defined above.
The R and q installations are on the same host, so data-extract timings do not include network transfer time 
but do include the standard serialization and de-serialization of data. 
We will load the interface and connect to q with:

```r
> library(rkdb)
> h <- open_connection("127.0.0.1",9998,NULL)
```


### Extract raw data into R

Retrieving raw data into R and doing all the processing on the R side is the least efficient way to approach this task 
as regards processing time, network utilization, and memory usage. 
To illustrate, we can time how long it takes to extract one day’s worth of data for one symbol from q to R.

```r
> system.time(res <- execute(h, "select time,sym,price from trade where date=2014.01.09,sym=`GOOG"))
   user  system elapsed 
  0.011   0.001   0.049
```

Given we wish to process over multiple dates and instruments, we will discount this method.


### Extract aggregated data into R

The second approach is to extract aggregated statistics from q to R. 
The required statistics in this case are the price returns between consecutive time buckets for each instrument. 
The following q function extracts time bucketed data:

```q
timebucketedstocks:{[startdate; enddate; symbols; timebucket]
 data:select last price by date,sym,time:timebucket xbar date+time from trade where date within (startdate;enddate),sym in symbols;  / extract the time bucketed data
 () xkey update return:1^price%prev price by sym from data /  calculate returns between prices in consecutive buckets and return the results unkeyed
 }
```

An example is:

```q
q)timebucketedstocks[2014.01.09;2014.01.13;`GOOG`IBM;0D00:05]
date       sym  time                         price    return   
----------------------------------------------------------------
2014.01.09 GOOG 2014.01.09D04:00:00.000000000 1142     1        
2014.01.09 GOOG 2014.01.09D04:05:00.000000000 1142.5   1.000438 
2014.01.09 GOOG 2014.01.09D04:10:00.000000000 1142     0.9995624
2014.01.09 GOOG 2014.01.09D04:30:00.000000000 1143.99  1.001743 
2014.01.09 GOOG 2014.01.09D04:35:00.000000000 1144     1.000009 
2014.01.09 GOOG 2014.01.09D04:55:00.000000000 1144     1       
..
```

Once the data is in R it needs to be aligned and correlated. 
To align the data we will use a pivot function defined in the reshape package.

```r
# Reduce the dataset as much as possible
# only extract the columns we will use
> res <- execute(h,"select time,sym,return from timebucketedstocks[2014.01.09; 2014.01.15; `GOOG`IBM`MSFT; 0D00:05]")
> head(res)
                 time  sym    return
1 2014-01-09 09:30:00 GOOG 1.0000000
2 2014-01-09 09:35:00 GOOG 0.9975051
3 2014-01-09 09:40:00 GOOG 0.9966584
4 2014-01-09 09:45:00 GOOG 1.0005061
5 2014-01-09 09:50:00 GOOG 1.0004707
6 2014-01-09 09:55:00 GOOG 0.9988128
> install.packages('reshape')
> library(reshape)
# Pivot the data using the re-shape package
> p <- cast(res, time~sym)
Using return as value column. Use the value argument to cast to override ￼￼￼￼￼￼￼￼￼￼￼￼this choice
> head(p)
                 time      GOOG       IBM      MSFT
1 2014-01-09 09:30:00 1.0000000 1.0000000 1.0000000
2 2014-01-09 09:35:00 0.9975051 1.0006143 1.0002096
3 2014-01-09 09:40:00 0.9966584 1.0001588 1.0001397
4 2014-01-09 09:45:00 1.0005061 0.9998941 0.9986034
5 2014-01-09 09:50:00 1.0004707 0.9965335 1.0019580
6 2014-01-09 09:55:00 0.9988128 0.9978491 1.0022334

# And generate the correlation matrix
> cor(p)
          GOOG       IBM      MSFT
GOOG 1.0000000 0.2625370 0.1577429
IBM  0.2625370 1.0000000 0.2568469
MSFT 0.1577429 0.2568469 1.0000000
```

An interesting consideration is the timing for each of the steps and how that changes when the dataset gets larger.

```r
> system.time(res <- execute(h,"select time,sym,return from timebucketedstocks[2014.01.09; 2014.01.15; `GOOG`IBM`MSFT; 0D00:05]"))
   user  system elapsed 
  0.001   0.001   0.145 
> system.time(replicate(10,p<-cast(res,time~sym)))
   user  system elapsed 
  0.351   0.012   0.357 
> system.time(replicate(100,cor(p)))
   user  system elapsed 
   0.04    0.00    0.04 
```

We can see that

-   the data extract to R takes 145 ms. Much of this time is taken up by q producing the dataset. There is minimal transport cost (as the processes are on the same host);

    <pre><code class="language-q">
    q)\t select time,sym,return from timebucketedstocks[2014.01.09; 2014.01.15; \`GOOG\`IBM\`MSFT; 0D00:05]
    134
    </code></pre>

-   the pivot takes approximately 36 ms
-   the correlation time is negligible

We can also analyze how these figures change as the dataset grows. 
If we choose a more granular time period for bucketing the data set will be larger. 
In our case we will use 10-second buckets rather than 5-minute buckets, meaning the result data set will be 30× larger.

```r
> system.time(res <- execute(h,"select time,sym,return from timebucketedstocks[2014.01.09; 2014.01.15; `GOOG`IBM`MSFT; 0D00:00:10]"))
  user    system  elapsed
  0.015   0.008   0.234
```

Using return as value column. Use the value argument to cast to override this choice

```r
> system.time(p<-cast(res,time~sym))
  user    system elapsed
  0.950   0.048   0.998 
```

We can see that the time to extract the data increases by ~90 ms. 
The q query time increases by 4 ms, so the majority of the increase is due to shipping the larger dataset from q to R.

```q
q)\t select time,sym,return from timebucketedstocks[2014.01.09; 2014.01.15; `GOOG`IBM`MSFT; 0D00:00:10]
138
```

The pivot time on the larger data set grows from 40 ms to ~1000 ms giving a total time to do the analysis of approximately 2300 ms. 
As the dataset grows, the time to pivot the data in R starts to dominate the overall time.


### Align data in q

Given the pivot performance in R, an alternative is to pivot the data on the q side. 
This has the added benefit of reducing the volume of data transported 
due to the fact that we can drop the time and sym identification columns as the data is already aligned. 
The q function below pivots the data. 

```q
timebucketedpivot:{[startdate; enddate; symbols; timebucket]
 / Extract the time bucketed data
 data:timebucketedstocks[startdate;enddate;symbols;timebucket];
 / Get the distinct list of column names (the instruments)
 colheaders:value asc exec distinct sym from data;
 / Pivot the table, filling with 1 because if no value, the price has stayed the same and return the results unkeyed
 () xkey 1^exec colheaders#(sym!return) by time:time from data
 }
```

<i class="far fa-hand-point-right"></i> 
[Pivoting tables](../kb/pivoting-tables.md)

An example is:

```q
q)timebucketedpivot[2014.01.09;2014.01.13;`GOOG`IBM;0D00:05]
time                          GOOG      IBM      
-------------------------------------------------
2014.01.09D09:30:00.000000000 1         1        
2014.01.09D09:35:00.000000000 0.9975051 1.000614 
2014.01.09D09:40:00.000000000 0.9966584 1.000159 
2014.01.09D09:45:00.000000000 1.000506  0.9998941
2014.01.09D09:50:00.000000000 1.000471  0.9965335
2014.01.09D09:55:00.000000000 0.9988128 0.9978491
2014.01.09D10:00:00.000000000 1.000775  0.9992017
..
```

Using the larger dataset example, we can then do

```r
> system.time(res <- execute(h,"delete time from timebucketedpivot [2014.01.09; 2014.01.15; `GOOG`IBM`MSFT; 0D00:00:10]"))
   user  system elapsed
  0.003   0.004   0.225 
> cor(res)
          GOOG        IBM       MSFT
GOOG 1.0000000 0.15336531 0.03471400
IBM  0.1533653 1.00000000 0.02585773
MSFT 0.0347140 0.02585773 1.00000000
```

thus reducing the total query time from 2300 ms to 860 ms and also reducing the network usage.


### Correlations in q

A final approach is to calculate the correlations in q, meaning that R is not used for any statistical analysis. 
The below function invokes the previously defined functions and creates the correlation matrix. 
Utilizing the function `timebucketedpivot` defined above, and

```q
correlationmatrix:{[startdate; enddate; symbols; timebucket]
 / Extract the pivoted data
 data:timebucketedpivot[startdate;enddate;symbols;timebucket];
 / Make sure the symbol list is distinct
 / and only contains values present in the data
 symbols:asc distinct symbols inter exec distinct sym from data;
 / Calculate the list of pairs to correlate
 pairs:raze {first[x],/:1 _ x}each {1 _ x}\[symbols];
 / Return the pair correlation
 / Calculate two rows for each pair, with the same value in each correlate
 pair:{[data;pair]([]s1:pair;s2:reverse pair; correlation:cor[data pair 0; data pair 1])};
 paircor:raze correlatepair[flip delete time from data] each pairs;
 / Pivot the data to give a matrix 
 pivot:exec symbols#s1!correlation by sym:s2 from paircor;
 / fill with 1 for the diagonal 
 unkey () xkey 1f^pivot
 }
```

which can be run like this:

```q
q)correlationmatrix[2014.01.09; 2014.01.15; `GOOG`IBM`MSFT; 0D00:00:10]
sym  GOOG      IBM        MSFT
      ------------------------------------
GOOG 1         0.1533653  0.034714  
IBM  0.1533653 1          0.02585773
MSFT 0.034714  0.02585773 1     
q)\t correlationmatrix[2014.01.09; 2014.01.15; `GOOG`IBM`MSFT; 0D00:00:10]
181
```

This solution executes quickest and with the least network usage, as the resultant correlation matrix returned to the user is small.


## Summary

It can be seen from the above examples that it is most efficient to calculate the correlation matrix directly in q 
with the performance gains increasing as the size of the dataset increases. 
The q-only approach also simplifies the architecture as it uses a single technology. 
It is up to the user to decide which approach is the best fit for their use case and expertise, 
although some amount of initial work should always be done on the q side to avoid raw data extracts.


## Example: working with smart-meter data

To demonstrate the power of q, an example using randomly-generated smart meter data has been developed. 
This can be downloaded from 
<i class="fab fa-github"></i> 
[KxSystems/cookbook/tutorial](https://github.com/KxSystems/cookbook/tree/master/tutorial).
By following the instructions in the README, an example database can be built. 
The default database contains information on 100,000 smart meter customers from different sectors and regions over 61 days. 
The default database contains 9.6M records per day, 586M rows in total. 
A set of example queries are provided, and a tutorial to step through the queries and test the performance of q. 
Users are encouraged to experiment with:

-   using slaves to boost performance
-   running queries with different parameters
-   modifying or writing their own queries
-   compression to reduce the size of on-disk data
-   changing the amount of data generated – more days, more customers, different customer distributions etc.

The data can be extracted from R for further analysis or visualisation. 
As an example, the code below will generate an average daily usage profile 
for each customer type (`res` = residential, `com` = commercial, `ind` = industrial) over a 10-day period.

```r
# load the xtsExtra package
# this will overwrite some of the implementations
# loaded from the xts package (if already loaded)
> install.packages("xtsExtra", repos="http://r-forge.r-project.org") # for R 3.1 you may need an additional parameter type="source"
> library(xtsExtra)
# load the connection library
> library(rkdb)
> h <- open_connection("127.0.0.1",9998,NULL)
# pull back the profile data
# customertypeprofiles takes 3 parameters
# [start date; end date; time bucket size]
> d<-execute(h,"customertypeprofiles[2013.08.01;2013.08.10;15]")
> dxts<-xts(d[,-1],order.by=d[,'time'])
# plot it
> plot.xts(dxts, screens=1, ylim=c(0,500000), auto.legend=TRUE, main=" Usage Profile by Customer Type")
```

which produces the plot in Figure 5: 

![Customer usage profiles generated in q and drawn in R](../img/r/figure5.png)  
_Figure 5: Customer usage profiles generated in q and drawn in R_


### Timezones

Note that R’s timezone setting affects date transfers between R and q. In R:

```r
> Sys.timezone()               # reads current timezone
> Sys.setenv(TZ = "GMT")       # sets GMT ("UTC" is the same)
```

For example, in the R server:

```q
q)Rcmd "Sys.setenv(TZ='GMT')"
q)Rget "date()"
"Fri Feb  3 06:33:43 2012"
q)Rcmd "Sys.setenv(TZ='EST')"
q)Rget "date()"
"Fri Feb  3 01:33:57 2012"
```

<i class="far fa-hand-point-right"></i> 
Knowledge Base: [Timezones and Daylight Saving Time](../kb/timezones.md)


