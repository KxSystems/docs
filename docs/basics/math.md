---
title: Mathematics and statistics | Basics | kdb+ and q documentation
description: Operators and keywords that perform mathematical or statistical operations
author: Stephen Taylor
---
# Mathematics and statistics




function                            | rank | ƒ | semantics
------------------------------------|------|---|--------------------------
[`+`](../ref/add.md)                | 2    | a | add
[`-`](../ref/subtract.md)           | 2    | a | subtract
[`*`](../ref/multiply.md)           | 2    | a | multiply
[`%`](../ref/divide.md)             | 2    | a | divide
[`$`](../ref/mmu.md)                | 2    | A | dot product, matrix multiply
[`&`](../ref/lesser.md)             | 2    | a | lesser
[`|`](../ref/greater.md)            | 2    | a | greater
[`abs`](../ref/abs.md)              | 1    | a | absolute value
[`acos`](../ref/cos.md)             | 1    | a | arccosine
[`asin`](../ref/sin.md)             | 1    | a | arcsine
[`atan`](../ref/tan.md)             | 1    | a | arctangent
[`avg`](../ref/avg.md#avg)          | 1    | A | arithmetic mean
[`avgs`](../ref/avg.md#avgs)        | 1    | u | arithmetic means
[`ceiling`](../ref/ceiling.md)      | 1    | a | round up to integer
[`cor`](../ref/cor.md)              | 2    | A | correlation
[`cos`](../ref/cos.md)              | 1    | a | cosine
[`cov`](../ref/cov.md)              | 2    | A | covariance
[`deltas`](../ref/deltas.md)        | 1    | u | differences
[`dev`](../ref/dev.md#dev)          | 1    | A | standard deviation
[`div`](../ref/div.md)              | 2    | a | integer division
[`ema`](../ref/ema.md)              | 2    | m | exponential moving average
[`exp`](../ref/exp.md#exp)          | 1    | a | _e_<sup>x</sup>
[`floor`](../ref/floor.md)          | 1    | a | round down to integer
[`inv`](../ref/inv.md)              | 1    | u | matrix inverse
[`log`](../ref/log.md#log)          | 1    | a | natural logarithm
[`lsq`](../ref/lsq.md)              | 2    |   | matrix divide
[`mavg`](../ref/avg.md#mavg)        | 2    | m | moving average
[`max`](../ref/max.md#max)          | 1    | A | greatest
[`maxs`](../ref/max.md#maxs)        | 1    | u | maximums
[`mcount`](../ref/count.md#mcount)  | 2    | m | moving count
[`mdev`](../ref/dev.md#mdev)        | 2    | m | moving deviation
[`med`](../ref/med.md)              | 1    | A | median
[`min`](../ref/min.md#min)          | 1    | A | least
[`mins`](../ref/min.md#mins)        | 1    | u | minimums
[`mmax`](../ref/max.md#mmax)        | 2    | m | moving maximum
[`mmin`](../ref/min.md#mmin)        | 2    | m | moving minimum
[`mmu`](../ref/mmu.md)              | 2    |   | matrix multiply
[`mod`](../ref/mod.md)              | 2    | a | modulo
[`msum`](../ref/sum.md#msum)        | 2    | m | moving sum
[`prd`](../ref/prd.md)              | 1    | A | product
[`prds`](../ref/prd.md#prds)        | 1    | u | products
[`ratios`](../ref/ratios.md)        | 1    | u | ratios
[`reciprocal`](../ref/reciprocal.md)| 1    | a | reciprocal
[`scov`](../ref/cov.md#scov)        | 2    | A | statistical covariance
[`sdev`](../ref/dev.md#sdev)        | 1    | A | statistical standard deviation
[`signum`](../ref/signum.md)        | 1    | a | sign
[`sin`](../ref/sin.md)              | 1    | a | sine
[`sqrt`](../ref/sqrt.md)            | 1    | a | square root
[`sum`](../ref/sum.md)              | 1    | A | sum
[`sums`](../ref/sum.md#sums)        | 1    | u | sums
[`svar`](../ref/var.md#svar)        | 1    | A | statistical variance
[`tan`](../ref/tan.md)              | 1    | a | tangent
[`til`](../ref/til.md)              | 1    |   | natural numbers till
[`var`](../ref/var.md#var)          | 1    | A | variance
[`wavg`](../ref/avg.md#wavg)        | 2    | A | weighted average
[`wsum`](../ref/sum.md#wsum)        | 2    | A | weighted sum
[`xbar`](../ref/xbar.md)            | 2    | A | round down
[`xexp`](../ref/exp.md#xexp)        | 2    | a | x<sup>y</sup>
[`xlog`](../ref/log.md#xlog)        | 2    | a | base-x logarithm of y


ƒ – a: atomic; u: uniform; A: aggregate; m: moving


## Domains and ranges

The domains and ranges of the mathematical functions have boolean, numeric, and temporal datatypes.
```q
q)2+3 4 5
5 6 7
q)2012.05 2012.06m-2
2012.03 2012.04m
q)3.3 4.4 5.5*1b
3.3 4.4 5.5
```

Individual function articles tabulate non-obvious domain and range datatypes.


## Dictionaries and tables

The domains and ranges also extend to:

-   **dictionaries** where the [`value`](../ref/value.md) of the dictionary is in the domain
    <pre><code class="language-q">
    q)3+\`a\`b\`c!(42;2012.09.15;1b)
    a| 45
    b| 2012.09.18
    c| 4
    </code></pre>
-   **simple tables** where the [`value`](../ref/value.md) of the [`flip`](../ref/flip.md) of the table is in the domain
<pre><code class="language-q">
    q)3%([]b:1 2 3;c:45 46 47)
    b   c
    --------------
    3   0.06666667
    1.5 0.06521739
    1   0.06382979
    </code></pre>
-   **keyed tables** where the [`value`](../ref/value.md) of the table is in the domain
    <pre><code class="language-q">
    q)show v:([sym:\`ibm\`goog\`msoft]qty:1000 2000 3000;p:1550 375 98)
    sym  | qty  p
    -----| ---------
    ibm  | 1000 1550
    goog | 2000 375
    msoft| 3000 98
    q)v+5
    sym  | qty  p
    -----| ---------
    ibm  | 1005 1555
    goog | 2005 380
    msoft| 3005 103
    </code></pre>

Exceptions to the above:
```txt
cor                  scov
cov                  sdev
dev                  svar
div  (tables)        til
ema                  var
inv                  wavg (tables)
lsq                  wsum (tables)
mmu                  xbar (tables)
mod  (tables)        xexp (tables)
```


## Mathematics with temporals

Temporal datatypes (timestamp, month, date, datetime, timespan, minute, second, time) are encoded as integer or float offsets from 2000.01.01 or 00:00.

Mathematical functions on temporals are applied to the underlying numerics. See domain/range tables for individual functions for the result datatypes.

!!! warning "Beyond addition and subtraction"
    Results for addition and subtraction are generally intuitive and useful; not always for other arithmetic functions.
    <pre><code class="language-q">
    q)2017.12.31+0 1 2
    2017.12.31 2018.01.01 2018.01.02
    q)2017.12m-0 1 2
    2017.12 2017.11 2017.10m
    q)2017.12m*0 1 2
    2000.01 2017.12 2035.11m
    q)2017.12m% 1 2 3
    215 107.5 71.66667
    q)00:10%2
    5f
    q)00:10:00%2
    300f
    q)00:10:00.000%2
    300000f
    q)00:10:00.000000000%2
    3e+11
    </code></pre>


## Aggregating nulls

`avg`, `min`, `max` and `sum` are special: they ignore nulls, in order to be similar to SQL92.
<!-- FIXME
    test for mins and maxs
    note on individual pages
-->
But for nested `x` these functions preserve the nulls.

```q
q)avg (1 2;0N 4)
0n 3
```
