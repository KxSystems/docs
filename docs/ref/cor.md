---
title: cor
description: cor is a q keyword that calculates the correlation coefficient of two numeric lists. 
keywords: cor, correlate, correlation, kdb+, math, mathematics, q, statistics
---

# `cor`



_Correlation_

Syntax: `x cor y`, `cor[x;y]`

Where `x` an d `y` are conforming numeric lists returns their correlation as a floating point number in the range `-1f` to `1f`. Applies to all numeric data types and signals an error with temporal types, char and sym. 

```q
q)29 10 54 cor 1 3 9
0.7727746
q)10 29 54 cor 1 3 9
0.9795734
q)1 3 9 cor neg 1 3 9
-1f

q)select price cor size by sym from trade
```

`cor` is an aggregate function.

Perfectly correlated data results in a `1` or `-1`. When one variable increases as the other increases the correlation is positive; when one decreases as the other increases it is negative. Completely uncorrelated arguments return `0f`. 


<i class="far fa-hand-point-right"></i> 
Wikipedia: [Correlation and dependence](https://en.wikipedia.org/wiki/Correlation_and_dependence)  
financereference.com: [Correlation](http://financereference.com/learn/correlation)  
Basics: [Mathematics](../basics/math.md)

