---
title: median of a numeric list | Reference | kdb+ and q documentation
description: med is a q keyword that returns the median of its argument.
keywords: kdb+, median, q, statistics
---
# `med` 




_Median_

```txt
med x    med[x]
```

Where `x` is a numeric list returns its [median](https://en.wikipedia.org/wiki/Median "Wikipedia").

```q
q)med 10 34 23 123 5 56
28.5
q)select med price by sym from trade where date=2001.10.10,sym in`AAPL`LEH
```

`med` is an aggregate function, equivalent to 

```q
{avg x (iasc x)@floor .5*-1 0+count x,:()}
```


## Implicit iteration

`med` applies to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).

```q
q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 -21 3;4 5 -6)

q)med d
7 -8 -1.5

q)med t
a| 3
b| -6

q)med k
a| 3
b| -6
```


## Partitions and segments

`med` signals a part error when running a median over partitions, or segments. 
(Since V3.5 2017.01.18; from V3.0 it signalled a rank error.)
This is deliberate, as previously `med` was returning median of medians for such cases. This should now be explicitly coded as a cascading select.

```q
select med price by sym from 
  select price, sym from trade where 
      date within 2001.10.10 2001.10.11, 
      sym in `AAPL`LEH;
```


----
:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)
