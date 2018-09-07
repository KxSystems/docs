---
title: var, svar
keywords: kdb+, math, mathematics, q, statistics, statistical variance, variance
---

# `var`, `svar`

_Variance, Statistical variance_




## `var` 

_Variance_

Syntax: `var x`, `var[x]`

Where `x` is a numeric list, returns its variance as a float atom. Nulls are ignored.

```q
q)var 2 3 5 7
3.6875
q)var 2 3 5 0n 7
3.6875
q)select var price by sym from trade where date=2010.10.10,sym in`IBM`MSFT
```

`var` is an aggregate function.


## `svar` 

_Statistical variance_

Syntax: `svar x`, `svar[x]`

Where `x` is a numeric list, returns its statistical variance as a float atom.

$$svar(x)=\frac{n}{n-1}var(x)$$

```q
q)var 2 3 5 7
3.6875
q)svar 2 3 5 7
4.916667
q)select svar price by sym from trade where date=2010.10.10,sym in`IBM`MSFT
```

`svar` is an aggregate function.


<i class="far fa-hand-point-right"></i> 
Variance: [Wikipedia](https://en.wikipedia.org/wiki/Variance), 
[financereference.com](http://financereference.com/learn/variance)  
Basics: [Mathematics](../basics/math.md)

