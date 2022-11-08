---
title: embedR, an interface for calling R from q
author: Conor McCarthy
date: September 2019
description: embedR is an interface that allows the R programming language to be invoked by q programs
keywords: interface, kdb+, q, r, 
---
# embedR, an interface for calling R from q

:fontawesome-brands-superpowers: [Fusion for kdb+](../fusion.md)
{: .fusion}

:fontawesome-brands-github:
[kxsystems/embedr](https://github.com/kxsystems/embedr)

This package is used to invoke R from q for both 32- and 64-bit builds. If the appropriate build is not available on your target system, build instructions are available in the `README.md` for this repository

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
q)Rset["mids";mids]
/- Graph it
q)Rcmd["plot(mids$time,mids$mid,type=\"l\",xlab=\"time\",ylab=\"price\")"]
```

This will produce a plot as shown in Figure 4: 

![Quote mid price plot drawn from q](../../img/r/figure4.svg)  
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

This is a trivial example to demonstrate the mechanics of the interface allowing you to leverage the 5,000 libraries available to R from within q.
