---
title: cov
description: cov and scov are q keyword, that return respectively the covariance and dsample covariance of two conforming numeric lists.
keywords: cov, covariance, kdb+, q, statistical covariance, statistics
---
# `cov`, `scov`

_Covariance_




## `cov` 

Syntax: `x cov y`, `cov[x;y]`

Where `x` and `y` are conforming numeric lists returns their [covariance](https://en.wikipedia.org/wiki/Covariance "Wikipedia") as a floating-point number. Applies to all numeric data types and signals an error with temporal types, char and sym.

```q
q)2 3 5 7 cov 3 3 5 9
4.5
q)2 3 5 7 cov 4 3 0 2
-1.8125
q)select price cov size by sym from trade
```


`cov` is an aggregate function.



## `scov` 

_Sample covariance_

Syntax: `x scov y`, `scov[x;y]`

Where `x` and `y` are conforming numeric lists returns their [sample covariance](https://en.wikipedia.org/wiki/Covariance#Calculating_the_sample_covariance "Wikipedia") as a float atom.

$$scov(x,y)=\frac{n}{n-1}cov(x,y)$$

Applies to all numeric data types and signals an error with temporal types, char and sym.

```q
q)2 3 5 7 scov 3 3 5 9
8
q)2 3 5 7 scov 4 3 0 2
-2.416667
q)select price scov size by sym from trade
```

`scov` is an aggregate function.


<i class="far fa-hand-point-right"></i>
[`var, svar`](var.md)  
Wikipedia: [Covariance](https://en.wikipedia.org/wiki/Covariance)  
Basics: [Mathematics](../basics/math.md)
