These functions return aggregates from their arguments. In most cases, they return an atom from a simple list, but [`avgs`](#avgs-averages), [`maxs`](#maxs-maximums) and [`mins`](#mins-minimums) return _running aggregations_.


## `avg` (average)

Syntax: `avg x` (unary, aggregate)

Returns the **arithmetic mean** of numeric list `x`. the mean of an atom is itself. Null is returned if `x` is empty, or contains both positive and negative infinity. Any null items in `x` are ignored.
```q
q)avg 1 2 3
2f
q)avg 1 0n 2 3       / null values are ignored
2f
q)avg 1.0 0w
0w
q)avg -0w 0w
0n
q)\l trade.q
q)show select ap:avg price by sym from trade
sym| ap
---| -----
a  | 10.75
```


## `avgs` (averages)

Syntax: `avgs x` (unary, uniform)

Returns the **running averages** of numeric list `x`, i.e. applies function `avg` to successive prefixes of `x`.
```q
q)avgs 1 2 3 0n 4 -0w 0w
1 1.5 2 2 2.5 -0w 0n
```


## `cor` (correlation)

Syntax: `x cor y` (binary, aggregate)

Returns the **correlation** (<i class="far fa-hand-point-right"></i> [Wikipedia](https://en.wikipedia.org/wiki/Correlation_and_dependence), [accessible version](http://financereference.com/learn/correlation "financereference.com")) of `x` and `y` as a floating point number in the range `-1f` to `1f`. Applies to all numeric data types and signals an error with temporal types, char and sym. 
```q
q)29 10 54 cor 1 3 9
0.7727746
q)10 29 54 cor 1 3 9
0.9795734
q)1 3 9 cor neg 1 3 9
-1f

q)select price cor size by sym from trade
```

!!! note "Correlation"
    Perfectly correlated data results in a `1` or `-1`. When one variable increases as the other increases the correlation is positive; when one decreases as the other increases it is negative. Completely uncorrelated arguments return `0f`. Arguments must be of the same length.


## `cov` (covariance)

Syntax: `x cov y` (binary, aggregate)

Returns the [**covariance**](https://en.wikipedia.org/wiki/Covariance "Wikipedia") of `x` and `y` as a floating point number. Applies to all numeric data types and signals an error with temporal types, char and sym.
```q
q)2 3 5 7 cov 3 3 5 9
4.5
q)2 3 5 7 cov 4 3 0 2
-1.8125
q)select price cov size by sym from trade
```


## `dev` (standard deviation)

Syntax: `dev x` (unary, aggregate)

Returns the **standard deviation** (<i class="far fa-hand-point-right"></i> [Wikipedia](https://en.wikipedia.org/wiki/Standard_deviation), [accessible version](http://financereference.com/learn/standard-deviation "financereference.com")) of list `x` (as the square root of the variance). Applies to all numeric data types and signals an error with temporal types, char and sym.
```q
q)dev 10 343 232 55
134.3484
q)select dev price by sym from trade
```


## `max` (maximum)

Syntax: `max x` (unary, aggregate)

Returns the **maximum** of the items of list `x`. The maximum of an atom is itself. Applies to any datatype except symbol. Nulls are ignored, except that if the items of `x` are all nulls, the result is negative infinity.
```q
q)max 2 5 7 1 3
7
q)max "genie"
"n"
q)max 0N 5 0N 1 3                  / nulls are ignored
5
q)max 0N 0N                        / negative infinity if all null
-0W
q)select max price by sym from t   / use in a select statement
```


## `maxs` (maximums)

Syntax: `maxs x` (unary, uniform)

Returns the **running maximums** of the prefixes of list `x`. The maximum of an atom is itself. Applies to any datatype except symbol. Nulls are ignored, except that initial nulls are returned as negative infinity.
```q
q)maxs 2 5 7 1 3
2 5 7 7 7
q)maxs "genie"
"ggnnn"
q)maxs 0N 5 0N 1 3         / initial nulls return negative infinity
-0W 5 5 5 5
```


## `med` (median)

Syntax: `med x` (unary, aggregate)

Returns the [**median**](https://en.wikipedia.org/wiki/Median "Wikipedia") of numeric list `x`.
```q
q)med 10 34 23 123 5 56
28.5
q)select med price by sym from trade where date=2001.10.10,sym in`AAPL`LEH
```

!!! warning "Partitions and segments"
    In V3.0 upwards `med` signals a rank error when running a median over partitions, or segments. This is deliberate, as previously `med` was returning median of medians for such cases. This should now be explicitly coded as a cascading select.
    <pre><code class="language-q">
    q)select med price by sym from select price,sym from trade where date=2001.10.10,sym in\`AAPL\`LEH
    </code></pre>


## `min` (minimum)

Syntax: `min x` (unary, aggregate)

Returns the **minimum** of list `x`. The minimum of an atom is itself. Applies to any datatype except symbol. Nulls are ignored, except that if the argument has only nulls, the result is infinity.
```q
q)min 2 5 7 1 3
1
q)min "genie"
"e"
q)min 0N 5 0N 1 3                  / nulls are ignored
1
q)min 0N 0N                        / infinity if all null
0W
q)select min price by sym from t   / use in a select statement
```

!!! note "Aggregating nulls"
    `avg`, `min`, `max` and `sum` are special: they ignore nulls, in order to be similar to SQL92.
    But for nested `x` these functions preserve the nulls.
    <pre><code class="language-q">
    q)avg (1 2;0N 4)
    0n 3
    </code></pre>


## `mins` (minimums)

Syntax: `mins x` (unary, uniform) 

Returns the **running minimums** of the prefixes of list `x`. The minimum of an atom is itself. Applies to any datatype except symbol. Nulls are ignored, except that initial nulls are returned as infinity.
```q
q)mins 2 5 7 1 3
2 2 2 1 1
q)mins "genie"
"geeee"
q)mins 0N 5 0N 1 3         / initial nulls return infinity
0W 5 5 1 1
```


## `scov` (statistical covariance)

Syntax: `x scov y` (binary, aggregate)

Returns the **statistical covariance** of `x` and `y` as a float atom.

$$scov(x,y)=\frac{n}{n-1}cov(x,y)$$

Applies to all numeric data types and signals an error with temporal types, char and sym.
```q
q)2 3 5 7 scov 3 3 5 9
8
q)2 3 5 7 scov 4 3 0 2
-2.416667
q)select price scov size by sym from trade
```


## `sdev` (statistical standard deviation)

Syntax: `sdev x` (unary, aggregate)

Returns the **statistical standard deviation** of list `x` (as the square root of the statistical variance).

$$sdev(x)=\sqrt{\frac{n}{n-1}var(x)}$$

Applies to all numeric data types and signals an error with temporal types, char and sym.
```q
q)sdev 10 343 232 55
155.1322
q)select sdev price by sym from trade
```


## `svar` (statistical variance)

Syntax: `svar x` (unary, aggregate)

Returns the **statistical variance** of numeric list `x` as a float atom.

$$svar(x)=\frac{n}{n-1}var(x)$$

```q
q)var 2 3 5 7
3.6875
q)svar 2 3 5 7
4.916667
q)select svar price by sym from trade where date=2010.10.10,sym in`IBM`MSFT
```


## `var` (variance)

Syntax: `var x` (unary, aggregate)

Returns the **variance** (<i class="far fa-hand-point-right"></i> [Wikipedia](https://en.wikipedia.org/wiki/Variance), [accessible version](http://financereference.com/learn/variance "financereference.com")) of numeric list `x` as a float atom. Nulls are ignored.
```q
q)var 2 3 5 7
3.6875
q)var 2 3 5 0n 7
3.6875
q)select var price by sym from trade where date=2010.10.10,sym in`IBM`MSFT
```


## `wavg` (weighted average)

Syntax: `x wavg y` (binary, aggregate)

Returns the [**weighted average**](https://en.wikipedia.org/wiki/Weighted_arithmetic_mean "Wikipedia") of numeric list `y` weighted by numeric list `x`. The result is a float atom. The calculation is `(sum x*y) % sum x`.
```q
q)2 3 4 wavg 1 2 4
2.666667
q)2 0N 4 5 wavg 1 2 0N 8  / nulls in either argument ignored
6f
```

!!! tip "Volume-weighted average price"
    The financial analytic known as [VWAP](https://en.wikipedia.org/wiki/Volume-weighted_average_price "Wikipedia") is a weighted average.
    <pre><code class="language-q">
    q)select size wavg price by sym from trade
    sym| price
    ---| -----
    a  | 10.75
    </code></pre>


## `wsum` (weighted sum)

Syntax: `x wsum y` (binary, aggregate)

Returns the [**weighted sum**](https://en.wikipedia.org/wiki/Weight_function "Wikipedia") of the products of `x` and `y`. When both `x` and `y` are integer lists, they are first converted to floats. The calculation is `sum x *y`.
```q
q)2 3 4 wsum 1 2 4   / equivalent to sum 2 3 4 * 1 2 4f
24f
q)2 wsum 1 2 4       / equivalent to sum 2 * 1 2 4
14
```


