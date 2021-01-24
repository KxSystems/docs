---
title: Using R with kdb+ – Interfaces – kdb+ and q documentation
description: How to enable R to connect to kdb+ and extract data; embed R inside q and invoke R routines; enable q to connect to a remote instance of R via TCP/IP and invoke R routines remotely; and enable q to load the R maths library and invoke R math routines locally.
keywords: interface, kdb+, library, q, r
---
# :fontawesome-brands-r-project: Using R with kdb+

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
Below are some best practice guidelines, although where the line is drawn between q and R will depend on both the system architecture and the strengths of the data scientists using the system.

-   Do as much of the analysis as possible in q. Q analyzes the data directly from the disk and it is always most efficient to do as much work as possible as close to the data as possible. Whenever possible avoid extracting large raw datasets from q. When extractions are required, use q to create smaller aggregated datasets
-   Do not re-implement tried and tested R routines in q unless they either
    -   can be written more efficiently in q and are going to be called often
    -   require more data than is feasible to ship to the R installation
-   Use R for data visualization

There are four ways to interface q with R:

1.  **R can connect to kdb+ and extract data** – loads a shared library into R, connects to kdb+ via TCP/IP
2.  **Embed R inside q and invoke R routines** – loads the R library into q, instantiates R
3.  **Q can connect to a remote instance of R** via TCP/IP and invoke R routines remotely
4.  **Q can load the R maths library** and invoke the R math routines locally

The first and second methods on interfacing between q and R are covered by the Fusion interfaces [rkdb](rkdb.md) and [embedR](embedr.md). The remaining methods are not supported or owned by KX but are desbut are described [here](r-and-q.md), the packages and methods outlined here are kdb-Rmath, RServe and RODBC

A number of considerations will affect which of the above interfaces are used.

Considering the potential size of the data, it is probably more likely that the kdb+ installation containing the data will be hosted remotely from the user. Points to consider when selecting the integration method are:

-   if interactive graphing is required, either interface (1) or (2) must be used
-   interface (2) can only be used if the q and R installations are installed on the same server
-   interfaces (2) and (4) require less data transfer between (possibly remote) processes
-   interfaces (2) and (3) both require variables to be copied from kdb+ to R for processing, meaning that at some point in time two copies of the variable will exist, increasing total memory requirements
