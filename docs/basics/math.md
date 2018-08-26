# Mathematics 


function     | syntax          | ƒ |  semantics
-------------|-----------------|---|--------------------------
`+`          | `x+y`           | a | [add](../ref/add.md)
`-`          | `x-y`           | a | [subtract](../ref/subtract.md)
`*`          | `x*y`           | a | [multiply](../ref/multiply.md)
`%`          | `x%y`           | a | [divide](../ref/divide.md)
`$`          | `x$y`           | A | [dot product, matrix multiply](../ref/mmu.md)
`&`          | `x&y`           | a | [minimum](../ref/minimum.md)
`|`          | `x|y`           | a | [maximum](../ref/maximum.md)
`abs`        | `abs x`         | a | [absolute value](../ref/abs.md)
`deltas`     | `x deltas y`    | u | [differences](../ref/deltas.md)
`div`        | `x div y`       | a | [integer division](../ref/div.md)
`ceiling`    | `ceiling x`     | a | [ceiling](../ref/ceiling.md)
`exp`        | `exp x`         | a | [_e_<sup>x</sup>](../ref/exp.md)
`floor`      | `floor x`       | a | [floor](../ref/floor.md)
`inv`        | `inv x`         | u | [matrix inverse](../ref/inv.md)
`log`        | `log x`         | a | [natural logarithm](../ref/log.md)
`lsq`        | `x lsq y`       |   | [matrix divide](../ref/lsq.md)
`mod`        | `x mod y`       | a | [modulo](../ref/mod.md)
`prd`        | `prd x`         | A | [product](../ref/prd.md)
`prds`       | `prds x`        | u | [products](../ref/prds.md)
`ratios`     | `ratios x`      | u | [ratios](../ref/ratios.md)
`reciprocal` | `reciprocal x`  | a | [reciprocal](../ref/log.md)
`signum`     | `signum x`      | a | [sign](../ref/signum.md)
`sqrt`       | `sqrt x`        | a | [square root](../ref/sqrt.md)
`sum`        | `sum x`         | A | [sum](../ref/sum.md)
`sums`       | `sums x`        | u | [sums](../ref/sums.md)
`til`        | `til x`         |   | [natural numbers till](../ref/til.md)
`xbar`       | `x xbar y`      |   | [grouping at regular intervals](../ref/xbar.md)
`xexp`       | `x xexp y`      | a | [x<sup>y</sup>](../ref/xexp.md)
`xlog`       | `x xlog y`      | a | [base-x logarithm of y](../ref/xlog.md)

ƒ – a: atomic; u: uniform; A: aggregate


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
Individual function articles tabulate domain and range datatypes.


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

<!--






-->