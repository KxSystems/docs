---
title: var, svar – variance and sample variance | Reference | kdb+ and q documentation
description: var and svar are q keywords that return (respectively) the variance and sample variance of their argument.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `var`, `svar`

_Variance, sample variance_

## `var`

_Variance_

```syntax
var x    var[x]
```

Where `x` is a numeric list, returns its variance as a float atom. `var` ignores nulls.

```q
q)var 2 3 5 7
3.6875
q)var 2 3 5 0n 7
3.6875
q)trade:([]sym:`IBM`MSFT`IBM`MSFT`IBM;price:101 52 103 50 102f)
q)select var price by sym from trade
sym | price
----| ---------
IBM | 0.6666667
MSFT| 1
```

`var` is an aggregate function. Where `sqr:{x*x}`, it is equivalent to:

```q
{avg[sqr x]-sqr[avg x]}
```

Since 4.1t 2022.04.15, `var` can also traverse columns of tables and general, anymap, and nested lists.

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

Where `x` is a numeric list, returns its [sample variance](https://en.wikipedia.org/wiki/Variance#Sample_variance "Wikipedia") as a float atom. `svar` ignores nulls.

$$svar(x)=\frac{n}{n-1}var(x)$$

where $n$ is the number of non-null items in `x`.

```q
q)var 2 3 5 7
3.6875
q)svar 2 3 5 7
4.916667
q)svar 2 3 5 0n 7
4.916667
q)select svar price by sym from trade
sym | price
----| -----
IBM | 1
MSFT| 2
```

`svar` is an aggregate function, equivalent to `{var[x]*n%-1+n:count[x]-sum null x}`.

Since 4.1t 2022.04.15, `svar` can also traverse columns of tables and general, anymap, and nested lists.

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
domain: B G X H I J E F C S P M D Z N U V T
range:  f . f f f f f f f . f f f f f f f f
```

----

[`cov`, `scov`](cov.md)
<br>

[Mathematics](../basics/math.md)
<br>

[Covariance](https://en.wikipedia.org/wiki/Covariance "Wikipedia"),
[Variance](https://en.wikipedia.org/wiki/Variance "Wikipedia")
