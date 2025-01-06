---
title: var, svar – variance and sample variance | Reference | kdb+ and q documentation
description: var and svar are q keywords that return (respectively) the variance and sample variance of their argument.
author: Stephen Taylor
---
# `var`, `svar`

_Variance, sample variance_


## `var`

_Variance_

```syntax
var x    var[x]
```

Where `x` is a numeric list, returns its variance as a float atom. Nulls are ignored.

```q
q)var 2 3 5 7
3.6875
q)var 2 3 5 0n 7
3.6875
q)select var price by sym from trade where date=2010.10.10,sym in`IBM`MSFT
```

`var` is an aggregate function, equivalent, where `sqr:{x*x}` to 
```q
{avg[sqr x]-sqr[avg x]}
```

Since 4.1t 2022.04.15, can also traverse columns of tables and general/anymap/nested lists.

```q
q)M:get`:m77 set m:(2 3;4 0N;1 7)
q)var m
1.555556 4
q)var M
1.555556 4
q)T:get`:tab/ set t:flip`a`b!flip m
q)var t
a| 1.555556
b| 4
q)var T
a| 1.555556
b| 4
```

`var` is a [multithreaded primitive](../kb/mt-primitives.md).


## `svar`

_Sample variance_

```syntax
svar x    svar[x]
```

Where `x` is a numeric list, returns its [sample variance](https://en.wikipedia.org/wiki/Variance#Sample_variance "Wikipedia") as a float atom.

$$svar(x)=\frac{n}{n-1}var(x)$$

```q
q)var 2 3 5 7
3.6875
q)svar 2 3 5 7
4.916667
q)select svar price by sym from trade where date=2010.10.10,sym in`IBM`MSFT
```

`svar` is an aggregate function, equivalent to `{var[x]*count[x]%-1+count x}`.

Since 4.1t 2022.04.15, can also traverse columns of tables and general/anymap/nested lists.

```q
q)M:get`:m77 set m:(2 3;4 0N;1 7)
q)svar m
2.333333 8
q)svar M
2.333333 8
q)T:get`:tab/ set t:flip`a`b!flip m
q)svar t
a| 2.333333
b| 8
q)svar T
a| 2.333333
b| 8
```

`svar` is a [multithreaded primitive](../kb/mt-primitives.md).


## Domain and range

```txt
domain: b g x h i j e f c s p m d z n u v t
range:  f . f f f f f f f . f f f f f f f f
```



----
:fontawesome-solid-book:
[`cov, scov`](cov.md)
<br>
:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)
<br>
:fontawesome-brands-wikipedia-w:
[Covariance](https://en.wikipedia.org/wiki/Covariance "Wikipedia"),
[Variance](https://en.wikipedia.org/wiki/Variance "Wikipedia")
<br>
:fontawesome-solid-globe:
[Variance](http://financereference.com/learn/variance "financereference.com")

