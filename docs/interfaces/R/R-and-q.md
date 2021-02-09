---
title: Using R with kdb+ – Non-Fusion Interfaces
description: Enable q to connect to a remote instance of R via TCP/IP and invoke R routines remotely; and enable q to load the R maths library and invoke R math routines locally.
keywords: interface, kdb+, library, q, r
---
# :fontawesome-brands-r-project: Using R and kdb+

Outside the Fusion interfaces to R, a number of interfaces provide extremely useful functionality to a q instance from R and vice-versa.

## Q in R

### RODBC with kdb+

Although it is not the recommended method, if R is running on Windows, the q ODBC driver can be used to connect to kdb+ from R.

:fontawesome-regular-hand-point-right:
[Kdb+ server for ODBC](../q-server-for-odbc.md)

The RODBC package should be installed in R. An example is given below.

```r
# install RODBC
> install.packages("RODBC")
# load it
> library(RODBC)
# create a connection to a predefined DSN
> ch <- odbcConnect("localhost:5000") # run a query
# s.k should be installed on the q server to enable standard SQL
# However, all statements can be prefixed with q) to run standard q.
> res <- sqlQuery(ch, paste('q)select count i by date from trade'))
```

## R in q

### Embedded R maths library

R contains a maths library which can be compiled standalone.
The functions can then be exposed to q by wrapping them in C code which handles the mapping between R datatypes and q datatypes (K objects).
See :fontawesome-brands-github: [rwinston/kdb-rmathlib](https://github.com/rwinston/kdb-rmathlib)
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

:fontawesome-regular-hand-point-right:
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
