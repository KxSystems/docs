---
title: med
description: med is a q keyword that returns the median of its argument.
keywords: kdb+, median, q, statistics
---

# `med` 




_Median_

Syntax: `med x`, `med[x]`

Where `x` is a numeric list returns its [median](https://en.wikipedia.org/wiki/Median "Wikipedia").

```q
q)med 10 34 23 123 5 56
28.5
q)select med price by sym from trade where date=2001.10.10,sym in`AAPL`LEH
```

`med` is an aggregate function.


## Partitions and segments

In V3.0 upwards `med` signals a rank error when running a median over partitions, or segments. This is deliberate, as previously `med` was returning median of medians for such cases. This should now be explicitly coded as a cascading select.

```q
q)select med price by sym from select price, sym from trade where date=2001.10.10, sym in `AAPL`LEH
```



<i class="far fa-hand-point-right"></i> 
Basics: [Mathematics](../basics/math.md)
