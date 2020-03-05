---
title: Semantic extensions to SQL | Kdb+ database and language primer | Documentation for kdb+ and q
author: Dennis Shasha (shasha@cs.nyu.edu)
description: Semantic extensions to SQL made by q and kdb+
hero: <i class="fas fa-graduation-cap"></i> Kdb+ database and language primer
---
# Semantic extensions to SQL





Q views tables as a set of named, ordered columns. The order allows a class of very useful aggregates that are unavailable to the relational database programmer without SQL’s cumbersome and poorly-performing temporal extensions.

In these examples, we make use of [_uniform functions_](../../basics/glossary.md#uniform-function), both built-in (`deltas` and `mins`) and user-created (`myavgs`). A uniform function applies to one or more lists of the same length L. The output list has length L.

The arithmetic Add operator is uniform. _Atomic_ operators like Add
are special because the element at each position $p$ of the output depends
on the elements of the inputs at position $p$ and on them alone. Uniform
functions don’t make that restriction. For example, consider the running-minimum function. The value of the running-minimum function (`mins`) at
position $p$ depends on all elements of the input up to position $p$. Here
are some primitive uniform and non-atomic operators in q.

<pre markdown="1" class="language-txt">
Func    Example            Result
\--------------------------------------------------------
sums    sums 1 2 3 -4 5    1 3 6 2 7
deltas  deltas 1 2 3 -4 5  1 1 1 -7 9
prds    prds 1 2 3 -4 5    1 2 6 -24 -120
ratios  ratios 1 2 3 -4 5  1.00 2.00 1.50 -1.33 -1.25
mins    mins 1 2 3 -4 5    1 1 1 -4 -4
maxs    maxs 1 2 3 -4 5    1 2 3 3 5
</pre>

<i class="fas fa-book-open"></i>
[Mathematics and statistics](../../basics/math.md)


Copy the following to a file (e.g. `frenchtrade.q`) keeping indentations
as they are. 

```q
/ Create a list of French stocks where name is the key.
stock:([name:`Alcatel`Alstom`AirFrance`FranceTelecom`Snecma`Supra]
  industry:`telecom`engineering`aviation`telecom`aviation`consulting)

/ which distinct stocks are there?
stocks: distinct exec name from stock
ns: count stocks
n:10000

/ stock is a foreign key
/ We are taking n stocks at random.
/ Then n prices up to 100.0 at random, then n random amounts
/ then n random dates.
trade:([]stock:`stock$n?stocks;
  price:n?100.0;amount:100*10+n?20;exchange:5+n?2.0;date:2004.01.01+n?449)

/ Sort these in ascending order by date.
/ We will need this to make the following queries meaningful.
`date xasc `trade
```

Then [run q on that file](../../basics/cmdline.md#file) (e.g. `q frenchtrade.q`).

```bash
❯ q frenchtrade.q
KDB+ 3.7t 2020.02.27 Copyright (C) 1993-2020 Kx Systems
m64/ 4()core 8192MB sjt mint.local ..

`trade
```
```q
q)trade
stock         price     amount exchange date
--------------------------------------------------
Supra         24.73555  2500   5.733611 2004.01.01
FranceTelecom 0.6320508 2500   5.350808 2004.01.01
Supra         90.36648  2800   5.052385 2004.01.01
Alcatel       50.36701  2300   6.718685 2004.01.01
Alcatel       42.14249  1600   5.042672 2004.01.01
..
```

Now find the dates when the price of Snecma went up, regardless of time of day.
The [`deltas`](../../ref/deltas.md) function subtracts the previous value in a column from the current one.

```q
q)select date from trade where stock=`Snecma, 0 < deltas price
date
----------
2004.01.01
2004.01.02
2004.01.03
2004.01.03
..
```

Find the average price by day.

```q
q)aa: select aprice: avg price by date from trade where stock=`Snecma
```

Find the weighted average price by day where prices associated with bigger trades have more weight.
`wavg` is a binary keyword that takes two columns as arguments.

```q
q)select wavg[amount;price] by date from trade where stock=`Snecma
date      | price
----------| --------
2004.01.01| 28.94861
2004.01.02| 52.47699
2004.01.03| 56.04943
2004.01.04| 70.03078
2004.01.05| 49.17335
2004.01.06| 3.698125
..
```

Here is an infix form giving the same result.

```q
select amount wavg price by date from trade where stock=`Snecma
```

Find the dates when the average price went up from the previous day.

```q
q)select date, aprice from aa where 0 < deltas aprice
date       aprice
-------------------
2004.01.01 28.94861
2004.01.02 52.27256
2004.01.03 57.53982
2004.01.04 69.38597
2004.01.07 19.02218
..
```

Suppose we wanted to do the above but for every stock.
Basically we replace the `where stock=` part by putting `stock` into the By clause.
First we get the average price for each stock and date.

```q
q)aaall: select aprice: avg price by stock, date from trade
```

Now find dates having rising prices for each stock.
Note that `stock` is the key of each row and there is a vector of dates and `aprice` associated with each stock.

```q
q)xx: select date, aprice by stock from aaall where 0 < deltas aprice
```

See which are those dates for Snecma (same as before).

```q
q)select date from xx where stock = `Snecma
date                                                                         ..
-----------------------------------------------------------------------------..
2004.01.02 2004.01.03 2004.01.04 2004.01.07 2004.01.08 2004.01.09 2004.01.10 ..
```

See which are those dates for Alcatel

```q
q)select date from xx where stock = `Alcatel
date                                                                         ..
-----------------------------------------------------------------------------..
2004.01.01 2004.01.02 2004.01.04 2004.01.06 2004.01.09 2004.01.10 2004.01.12 ..
```

Suppose that we do this on a monthly basis.
Note that the date arithmetic is very flexible and that a field is created called `month` by default from the By clause.

```q
q)aaallmon: select aprice: avg price by stock, date.month from trade
q)xxmon: select month, aprice by stock from aaallmon where 0 < deltas aprice
q)select month from xxmon where stock = `Snecma
month
-------------------------------------------------------
2004.02 2004.05 2004.07 2004.08 2004.09 2004.11 2005.02
```

Here we do a compound statement.
The idea is to find the profit of the ideal transactions for each stock.

An ideal transaction is a buy on a day $x$ followed by a sell on day $y$ ($x < y$) such that the sell-buy price is maximal.
To do this, we want to find the time when the difference between the actual price and the minimum of all previous prices is greatest.

Read this as follows: compute the running minimum of prices.
This gives a vector `v1` of non-increasing numbers.
Then consider the vector of prices `v2`.
Find the value where `v2-v1` is maximum.

```q
q)show bestprofit: select best: max price - mins price by stock from trade
stock        | best
-------------| --------
AirFrance    | 99.61199
Alcatel      | 99.62988
Alstom       | 99.56627
FranceTelecom| 99.89562
Snecma       | 99.80664
Supra        | 99.82088
```

One of the very powerful features of q is that a programmer can add procedures to the SQL and things just work.
Let’s start with something simple.

```q
q)mydouble:{[x] 2*x}
q)select mydouble price from trade where stock = `Alcatel
price
---------
100.734
84.28498
83.21555
77.22301
108.7382
79.80904
..
```

Some functions can take several arguments. Suppose we were interested in the n-point moving average of a multiple of the prices.

```q
q)myavgs:{[n;m;p] n mavg p*m}
```

```q
q)select myavgs[3;2;price] from trade where stock=`Alcatel
price
--------
100.734
92.5095
89.41152
81.57451
..
```

Or we could do this for every stock.

```q
q)select myavgs[3;2;price] by stock from trade
```

!!! note 

    The example makes a point about using your own functions.
    In this particular case you could actually as well write:

    <pre><code language="q">select 3 mavg 2*price from trade</code></pre>

Even better, these procedures can go into any clause.

```q
q)select date by stock from trade where 70 < myavgs[3; 2; price]
...
q)select date by stock, myavgs[3; 2; price] from trade
```

Functions can contain qSQL. The only limitation is that you may not include field names in an argument.

```q
q)f:{[mytable] count select from mytable}
q)f[stock]
6
q)f[trade]
10000
```

The last feature we want to introduce is the fact that q can store a vector in a field of a row.
This non-first-normal-form capability can contribute to performance.

```q
q)t: select date, price, amount by stock from trade
q)select date, price, amount by stock from trade
stock        | date                                                          ..
-------------| --------------------------------------------------------------..
AirFrance    | 2004.01.02 2004.01.02 2004.01.03 2004.01.03 2004.01.05 2004.01..
Alcatel      | 2004.01.01 2004.01.01 2004.01.01 2004.01.01 2004.01.01 2004.01..
Alstom       | 2004.01.01 2004.01.02 2004.01.02 2004.01.02 2004.01.02 2004.01..
FranceTelecom| 2004.01.01 2004.01.01 2004.01.01 2004.01.01 2004.01.01 2004.01..
Snecma       | 2004.01.01 2004.01.02 2004.01.02 2004.01.03 2004.01.03 2004.01..
Supra        | 2004.01.01 2004.01.01 2004.01.01 2004.01.02 2004.01.02 2004.01..
```

This means that we get a vector of dates for Alcatel as well as a vector of prices and amounts.

Recall that unary functions work with `each` meaning: apply to each row.

```q
q)select stock, each[first] price from t
q)select stock, first each price from t / these two are equivalent
stock         price
-----------------------
AirFrance     30.80944
Alcatel       50.36701
Alstom        40.3328
FranceTelecom 0.6320508
Snecma        28.94861
Supra         24.73555
```

Now suppose that for each stock, we want the volume-weighted price.
That is a binary keyword so the `each` becomes a `'`

```q
q)select stock, amount wavg' price from t
q)select stock, wavg'[amount;price] from t / these two are equivalent
stock         price
----------------------
AirFrance     49.21206
Alcatel       50.03
Alstom        49.28983
FranceTelecom 49.98752
Snecma        50.50649
Supra         51.60445
```

We can use Each (`'`) with functions with more arguments.

```q
q)f:{[x;y;z] (avg x)*y-z}
q)select stock, f'[price; amount; price] from t
stock         price                                                          ..
-----------------------------------------------------------------------------..
AirFrance     130546.1 92965.4 113403.1 47630.21 106256.5 56099.98 126845.2 1..
Alcatel       112766.4 78090.03 83129.49 83279.68 97527.77 98252.83 103113.5 ..
Alstom        136610.3 124622.9 87363.25 79628.05 141600.6 112519.8 140533.8 ..
FranceTelecom 125636.4 50450.73 84065.38 56028.82 64232.85 125371.8 74556.96 ..
Snecma        98740.1 82379.29 72687.96 100691.5 46724.32 56744.21 94676.19 1..
Supra         126799.5 138805.4 75702.78 84324.48 120051.4 124613.7 54062.44 ..
```

<i class="fas fa-book-open"></i>
[Iteration](../../basics/iteration.md),
[qSQL](../../basics/qsql.md)


---
<i class="far fa-hand-point-right"></i>
[Modifying tables](modify-tables.md)
