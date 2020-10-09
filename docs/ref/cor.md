---
title: cor – corelation coefficient | Reference | kdb+ and q documentation
description: cor is a q keyword that calculates the correlation coefficient of two numeric lists.
---
# `cor`



_Correlation_

```txt
x cor y    cor[x;y]
```

Where `x` an d `y` are [conforming](../basics/conformable.md) numeric lists returns their correlation as a float in the range `-1f` to `1f`. 

Perfectly correlated data results in a `1` or `-1`. When one variable increases as the other increases the correlation is positive; when one decreases as the other increases it is negative. 

Completely uncorrelated arguments return `0f`.

```q
q)29 10 54 cor 1 3 9
0.7727746
q)10 29 54 cor 1 3 9
0.9795734
q)1 3 9 cor neg 1 3 9
-1f

q)1000101000b cor 0010011001b
-0.08908708
```

`cor` is an aggregate function, equivalent to `{cov[x;y]%dev[x]*dev y}`.


## Domain and range

Applies to all non-temporal numerics.


----
:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)
<br>
:fontawesome-brands-wikipedia-w:
[Correlation and dependence](https://en.wikipedia.org/wiki/Correlation_and_dependence "Wikipedia")
<br>
:fontawesome-solid-globe:
[Correlation](http://financereference.com/learn/correlation "financereference.com")

