These functions return results for a [sliding window](/kb/programming-idioms/#how-do-i-apply-a-function-to-a-sequence-sliding-window "Knowledge Base: Programming idioms") on a list.


`ema`
-----

**Exponential moving average**

Syntax: `x ema y` (binary, uniform)

Where

- `y` is a numeric list
- `x` is a numeric atom or list of length `count y`

returns the [exponentially-weighted moving averages](https://en.wikipedia.org/wiki/Moving_average#Exponential_moving_average "Wikipedia") (EWMA, also known as _exponential moving average_ , EMA) of `y`, with `x` as the smoothing parameter.

Example: An impulse response with decay of &frac13;.
```q
q)ema[1%3;1,10#0]
1 0.6666667 0.4444444 0.2962963 0.1975309 0.1316872 0.0877915 0.05852766 0.03901844 0.02601229 0.01734153
```
Example: 10-day EMA on price, as at [stockcharts.com](http://stockcharts.com/school/doku.php?id=chart_school:technical_indicators:moving_averages). Smoothing parameter for EMA over $N$ points is defined as $\frac{2}{1+N}$.

```q
q)p:22.27 22.19 22.08 22.17 22.18 22.13 22.23 22.43 22.24 22.29 22.15 22.39 22.38 22.61 23.36 24.05 23.75 23.83 23.95 23.63 23.82 23.87 23.65 23.19 23.1 23.33 22.68 23.1 22.4 22.17
q)(2%1+10)ema p
22.27 22.25545 22.22355 22.21382 22.20767 22.19355 22.20017 22.24196 22.2416 22.2504 22.23215 22.26085 22.28251 22.34206 22.52714 22.80402 22.97602 23.13129 23.28014 23.34375 23.43034 23.51028 23.53568 23.47283 23.40505 23.3914 23.26206 23.23259 23.08121 22.91554
```

!!! tip "V3.1 to V3.3"
    `ema` has been defined since V3.4. To use it in V3.1 to V3.3, define it in `.q`:
    <pre><code class="language-q">
    .q.ema:{first\[y\]("f"\$1-x)\x*y}
    </code></pre>


## `mavg`

**Moving average**

Syntax: `x mavg y` (binary, uniform)

Where `x` is an int atom (not infinite), returns the `x`-item [simple moving averages](https://en.wikipedia.org/wiki/Moving_average#Simple_moving_average) of numeric list `y`, with any nulls after the first item replaced by zero. The first `x` items of the result are the averages of the terms so far, and thereafter the result is the moving average. The result is floating point.
```q
q)2 mavg 1 2 3 5 7 10
1 1.5 2.5 4 6 8.5
q)5 mavg 1 2 3 5 7 10
1 1.5 2 2.75 3.6 5.4
q)5 mavg 0N 2 0N 5 7 0N    / nulls after the first are replaced by 0
0n 2 2 3.5 4.666667 4.666667
```


## `mcount`

**Moving counts**

Syntax: `x mcount y` (binary, uniform)

Returns the `x`-item moving counts of the non-null items of numeric list `y`. The first `x` items of the result are the counts so far, and thereafter the result is the moving count.
```q
q)3 mcount 0 1 2 3 4 5
1 2 3 3 3 3
q)3 mcount 0N 1 2 3 0N 5
0 1 2 3 2 2
```


## `mdev`

**Moving deviations**

Syntax: `x mdev y` (binary, uniform)

Returns the floating-point `x`-item moving deviations of numeric list `y`, with any nulls after the first item replaced by zero. The first `x` items of the result are the deviations of the terms so far, and thereafter the result is the moving deviation. 
```q
q)2 mdev 1 2 3 5 7 10
0 0.5 0.5 1 1 1.5
q)5 mdev 1 2 3 5 7 10
0 0.5 0.8164966 1.47902 2.154066 2.87054
q)5 mdev 0N 2 0N 5 7 0N    / nulls after the first are replaced by 0
0n 0 0 1.5 2.054805 2.054805
```


## `mmax`

**Moving maximums** 

Syntax: `x mmax y` (binary, uniform)

Returns the `x`-item moving maximums of numeric `y`, with nulls after the first replaced by the preceding maximum. The first `x` items of the result are the maximums of the items so far, and thereafter the result is the moving maximum.
```q
q)3 mmax 2 7 1 3 5 2 8
2 7 7 7 5 5 8
q)3 mmax 0N -3 -2 0N 1 0  / initial null returns negative infinity
-0W -3 -2 -2 1 1          / remaining nulls replaced by preceding max
```


## `mmin`

**Moving minimums**

Syntax: `x mdev y` (binary, uniform)

Returns the `x`-item moving minimums of numeric list `y`, with nulls treated as the minimum value. The first `x` items of the result are the minimums of the terms so far, and thereafter the result is the moving minimum.
```q
q)3 mmin 0N -3 -2 1 -0W 0
0N 0N 0N -3 -0W -0W
q)3 mmin 0N -3 -2 1 0N -0W    / null is the minimum value
0N 0N 0N -3 0N 0N
```


## `msum`

**Moving sums**

Syntax: `x msum y` (binary, uniform) 

Returns the `x`-item moving sums of numeric list `y`, with nulls replaced by zero. The first `x` items of the result are the sums of the terms so far, and thereafter the result is the moving sum.
```q
q)3 msum 1 2 3 5 7 11
1 3 6 10 15 23
q)3 msum 0N 2 3 5 0N 11     / nulls treated as zero
0 2 5 10 8 16
```



