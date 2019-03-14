---
author: Conor McCarthy
date: March 2019
keywords: classification, combinations, python, pandas, machine learning, infinity, filling, one-hot, standard scaler, train test split, kdb+, q
---

# <i class="fa fa-share-alt"></i> .ml.util namespace 


The `.ml.util` namespace contains functions used in the manipulation and transformation of data. These functions are less fundamental those contained in the `.ml` root namespace and as such are maintained here in a separate namespace.

<i class="fab fa-github"></i>
[KxSystems/ml/util/](https://github.com/kxsystems/ml/tree/master/util)

The following functions are those contained at present within the `.ml.util` namespace

```txt
.ml.util – Manipulation and transformation of data
  .classreport          Statistical information about classification results
  .combs                Unique combinations of a vector or matrix
  .df2tab               Table from a pandas dataframe
  .dropconstant         Columns with zero variance removed
  .filltab              Tailored filling of null values for a simple matrix
  .freqencode           Numerically encode frequency of category occurance
  .infreplace           Replace +/- infinities with max/min of column
  .lexiencode           Label categories based on lexigraphical order
  .minmaxscaler         Data scaled between 0-1
  .nullencode           Fill null with defined value and flag positions of null values
  .onehot               One-hot encoding of table or array
  .polytab              Polynomial features of degree n from a table
  .stdscaler            Standard scaler transform-based representation of a table
  .tab2df               Pandas dataframe from a q table
  .traintestsplit       Split into training and test sets
  .traintestsplitseed   Split into training and test sets with a seed
```


## `.ml.util.classreport`

_Statistical information about classification results_

Syntax: `.ml.util.classreport[x;y]`

Where

* `x` is a vector of predicted values.
* `y` is a vector of true values.

returns the accuracy, precision and f1 scores and the support (number of occurrences) of each class.

```q
q)n:1000
q)xr:n?5
q)yr:n?5
q).ml.util.classreport[xr;yr]
class     precision recall f1_score support
-------------------------------------------
0         0.2       0.23   0.22     179
1         0.22      0.22   0.22     193
2         0.21      0.21   0.21     192
3         0.19      0.19   0.19     218
4         0.21      0.17   0.19     218
avg/total 0.206     0.204  0.206    1000

q)xb:n?0b
q)yb:n?0b
q).ml.util.classreport[xb;yb]
class     precision recall f1_score support
-------------------------------------------
0         0.51      0.51   0.51     496
1         0.52      0.52   0.52     504
avg/total 0.515     0.515  0.515    1000

q)xc:n?`A`B`C
q)yc:n?`A`B`C
q).ml.util.classreport[xc;yc]
class     precision recall f1_score support
-------------------------------------------
A         0.34      0.33   0.33     336
B         0.33      0.36   0.35     331
C         0.32      0.3    0.31     333
avg/total 0.33      0.33   0.33     1000
```


## `.ml.util.combs`

_Unique combinations of vector or matrix_

Syntax: `.ml.util.combs[x;y]`

Where

-  `x` is the number of values in unique combinations
-  `y` is a vector or matrix

Returns the unique combination of values from the data

```q
q)show l:til 3
0 1 2
q).ml.util.combs[2;l]
1 0
2 0
2 1
q)show k:5?`1
`o`k`c`d`m
q)3#.ml.util.combs[2;k]
c k o
d k o
d c o
q)show m:(0 1 2;2 3 4;4 5 6;6 7 8)
0 1 2
2 3 4
4 5 6
6 7 8
q).ml.util.combs[3;m]
4 5 6 2 3 4 0 1 2
7 8 9 2 3 4 0 1 2
7 8 9 4 5 6 0 1 2
7 8 9 4 5 6 2 3 4
```


## `.ml.util.df2tab`

_Convert from a Pandas DataFrame to q table_

Syntax: `.ml.util.df2tab[x]`

Where `x` is an embedPy representation of a Pandas DataFrame, returns it as a q table.

```q
q)p)import pandas as pd
q)print t:.p.eval"pd.DataFrame({'fcol':[0.1,0.2,0.3,0.4,0.5],'jcol':[10,20,30,40,50]})"
   fcol  jcol
0   0.1    10
1   0.2    20
2   0.3    30
3   0.4    40
4   0.5    50
q).ml.util.df2tab t
fcol jcol
---------
0.1  10
0.2  20
0.3  30
0.4  40
0.5  50
q)print kt:t[`:set_index]`jcol
      fcol
jcol
10     0.1
20     0.2
30     0.3
40     0.4
50     0.5
q).ml.util.df2tab kt
jcol| fcol
----| ----
10  | 0.1
20  | 0.2
30  | 0.3
40  | 0.4
50  | 0.5
```

!!! note "DataFrame indices are mapped to q key columns."


## `.ml.util.dropconstant`

_Remove columns with zero variance_

Syntax: `.ml.util.dropconstant[x]`

Where `x` is a numerical table, returns `x` without columns of zero variance.

```q
q)5#tab:([]1000?100f;1000#10;1000#0N)
x        x1 x2
--------------
95.25017 10
42.09728 10
98.80532 10
54.5461  10
51.7746  10
q)5#.ml.util.dropconstant tab
x
--------
95.25017
42.09728
98.80532
54.5461
51.7746
```


## `.ml.util.filltab`

_Tunable filling of null data for a simple table_

Syntax: `.ml.util.filltab[t;gcol;tcol;dict]`

Where

-   `t` is a table
-   `gcol` is a grouping column for the fill
-   `tcol` is a time column in the data
-   `dict` is a dictionary defining fill behaviour

returns a table with columns filled according to assignment of keys in the dictionary `dict`. The function defaults to forward-filling, followed by back-filling nulls. However changes to the default dictionary allow for zero, median, mean or linear interpolation to be applied on individual columns.

```q
q)show tab:([]sym:10?`A`B;time:asc 10?0t;@[10?1f;0 1 8 9;:;0n];@[10?1f;4 5;:;0n];@[10?1f;2*til 5;:;0n])
sym time         x          x1         x2
-------------------------------------------------
B   00:34:58.497            0.3252897
A   03:19:24.024            0.5564216  0.2726145
A   06:27:11.361 0.3867108  0.1692341
B   10:47:00.412 0.5624072  0.2069839  0.8841147
A   12:59:24.858 0.3319393
B   17:34:47.917 0.2318218             0.2439706
A   18:56:14.238 0.02746107 0.8516542
B   19:28:11.045 0.9505891  0.07314201 0.1275351
B   22:28:15.345            0.2221491
A   22:58:06.856            0.2407035  0.04661209
q).ml.util.filltab[tab;`sym;`time;()!()] / default fill
sym time         x          x1         x2
-------------------------------------------------
B   00:34:58.497 0.5624072  0.3252897  0.8841147
A   03:19:24.024 0.3867108  0.5564216  0.2726145
A   06:27:11.361 0.3867108  0.1692341  0.2726145
B   10:47:00.412 0.5624072  0.2069839  0.8841147
A   12:59:24.858 0.3319393  0.1692341  0.2726145
B   17:34:47.917 0.2318218  0.2069839  0.2439706
A   18:56:14.238 0.02746107 0.8516542  0.2726145
B   19:28:11.045 0.9505891  0.07314201 0.1275351
B   22:28:15.345 0.9505891  0.2221491  0.1275351
A   22:58:06.856 0.02746107 0.2407035  0.04661209
q).ml.util.filltab[tab;`sym;`time;`linear`median`mean!(`x;`x1;`x2)] / interpolations fills
sym time         x          x1         x2
-------------------------------------------------
B   00:34:58.497 0.8518633  0.3252897  0.4185401
A   03:19:24.024 0.434668   0.5564216  0.2726145
A   06:27:11.361 0.3867108  0.1692341  0.1596133
B   10:47:00.412 0.5624072  0.2069839  0.8841147
A   12:59:24.858 0.3319393  0.2407035  0.1596133
B   17:34:47.917 0.2318218  0.2069839  0.2439706
A   18:56:14.238 0.02746107 0.8516542  0.1596133
B   19:28:11.045 0.9505891  0.07314201 0.1275351
B   22:28:15.345 1.316885   0.2221491  0.4185401
A   22:58:06.856 -0.1277062 0.2407035  0.04661209

```

## `.ml.util.freqencode`

_Encoded frequency of individual category occurences_

Syntax:.`.ml.util.frequencode[x]`

Where

-   `x` is a table containing at least one column with categorical features (symbols)

returns table with frequency of occurrance of individual categories.

```q
q)tab:([]10?`a`b`c;10?10f)
x x1
----------
b 7.667049
b 2.975384
b 8.607676
a 7.35515
c 3.384913
c 8.934151
c 3.731562
b 6.22616
c 2.714665
a 7.288787
q).ml.util.freqencode[tab]
x1         freq_x
-----------------
9.602129   0.6
2.256037   0.4
7.922876   0.6
0.04380018 0.6
3.442662   0.6
7.116088   0.4
0.9901482  0.4
8.60422    0.6
6.491715   0.4
6.482049   0.6
```


## `.ml.util.infreplace`

_Replace +/- infinities with data min/max_

Syntax: `.ml.util.infreplace[x]`

Where `x` is a dictionary/table/list of numeric values. Returns the data with positive/negative infinities replaced by max/min values for the given key.

```q
q)show d:`A`B`C!(5 6 9 0w;10 -0w 0 50;0w 1 2 3)
A| 5  6   9 0w
B| 10 -0w 0 50
C| 0w 1   2 3
q).ml.util.infreplace d`A
5 6 9 9f
q).ml.util.infreplace d
A| 5  6 9 9
B| 10 0 0 50
C| 3  1 2 3
q).ml.util.infreplace flip d
A B  C
------
5 10 3
6 0  1
9 0  2
9 50 3
```


## `.ml.util.lexiencode`

_Categorical labels of features based on their lexigraphical order_

Syntax:`.ml.util.lexiencode[t]`

Where

-  `t` is a table containing at least one column with letters

returns table with lexigraphical order of letters column.

```q
q)show tab:([]10?10f;10?`a`b`c;10?10f)
x         x1 x2
---------------------
2.652528  b  2.194196
3.49562   a  3.997433
6.02218   c  9.08391
0.5352858 a  3.560436
2.101436  a  7.084245
2.812222  b  7.724299
5.215879  c  8.157121
2.991163  c  2.096742
8.250197  a  7.881085
0.4501006 b  4.31398
q).ml.util.lexiencode[tab]
x         x2       lexi_label_x1
--------------------------------
2.652528  2.194196 1
3.49562   3.997433 0
6.02218   9.08391  2
0.5352858 3.560436 0
2.101436  7.084245 0
2.812222  7.724299 1
5.215879  8.157121 2
2.991163  2.096742 2
8.250197  7.881085 0
0.4501006 4.31398  1
```


## `.ml.util.minmaxscaler`

_Scale data between 0-1_

Syntax: `.ml.util.minmaxscaler[x]`

Where

-  `x` is a numerical table, matrix or list

returns a min-max scaled representation with values scaled between 0 and 1.

```q
q)n:5
q)show tab:([]n?100f;n?1000;n?100f;n?50f)
x        x1  x2       x3
------------------------------
12.48134 837 42.83142 7.597138
18.019   591 77.97026 46.69185
98.8875  860 73.44471 28.72854
30.70513 599 80.56178 39.70485
42.17381 187 75.26142 38.26483
q).ml.util.minmaxscaler[tab]
x         x1        x2        x3
---------------------------------------
0          0.9658247 0         0
0.06408864 0.6002972 0.9313147 1
1          1         0.8113701 0.5405182
0.2109084  0.6121842 1         0.8212801
0.3436384  0         0.85952   0.7844459
q)show mat:value flip tab
12.48134 18.019   98.8875  30.70513 42.17381
837      591      860      599      187
42.83142 77.97026 73.44471 80.56178 75.26142
7.597138 46.69185 28.72854 39.70485 38.26483
q).ml.util.minmaxscaler[mat]
0         0.06408864 1         0.2109084 0.3436384
0.9658247 0.6002972  1         0.6121842 0
0         0.9313147  0.8113701 1         0.85952
0         1          0.5405182 0.8212801 0.7844459
q)list:100?100
q).ml.util.minmaxscaler[list]
0.7835052 0.2886598 0.5463918 0.443299 1 0.09278351 0.1030928 0 0.9175258 0.9..
```


## `.ml.util.nullencode`

_Filling of null values and encoding of original positions_

Syntax: `.ml.util.nullencode[t;y]`

Where

-   `t` is a table containing nulls and y is the function to be applied to nulls

returns table with nulls filled and additional columns that encode positions of nulls in the original columns.

```q
q)show tab:([]@[10?1f;0 1 8 9;:;0n];@[10?1f;4 5;:;0n];@[10?1f;2*til 5;:;0n])
x         x1        x2
------------------------------
          0.3238152
          0.8616775 0.8640424
0.2062779 0.032353
0.7802666 0.3826807 0.8002228
0.4809723
0.940638            0.5370027
0.3497468 0.2885991
0.3165283 0.2879356 0.5639193
          0.7708107
          0.783687  0.08766932
q).ml.util.nullencode[tab;avg]
x         x1        x2         null_x null_x1 null_x2
-----------------------------------------------------
0.512405  0.3238152 0.5705713  1      0       1
0.512405  0.8616775 0.8640424  1      0       0
0.2062779 0.032353  0.5705713  0      0       1
0.7802666 0.3826807 0.8002228  0      0       0
0.4809723 0.4664448 0.5705713  0      1       1
0.940638  0.4664448 0.5370027  0      1       0
0.3497468 0.2885991 0.5705713  0      0       1
0.3165283 0.2879356 0.5639193  0      0       0
0.512405  0.7708107 0.5705713  1      0       1
0.512405  0.783687  0.08766932 1      0       0
```


## `.ml.util.onehot`

_One-hot encoding_

Syntax: `.ml.util.onehot[x]`

Where `x` is a list of symbols or table with symbol column, returns one-hot encoded representation as matrix or table.

```q
q)x:`a`a`b`b`c`a
q).ml.util.onehot[x]
1 0 0
1 0 0
0 1 0
0 1 0
0 0 1
1 0 0
q)5#tab:([]10?`a`b`c;10?10f;10?10f)
x x1        x2
----------------------
a 7.310299  5.697305
b 0.8842384 1.714374
b 8.203719  0.09300471
a 8.749888  6.349401
b 7.73655   8.607533
q).ml.util.onehot[tab]
x1        x2         x_a x_b x_c
--------------------------------
7.310299  5.697305   1   0   0
0.8842384 1.714374   0   1   0
8.203719  0.09300471 0   1   0
8.749888  6.349401   1   0   0
7.73655   8.607533   0   1   0
```


## `.ml.util.polytab`

_Tunable polynomial features from an input table_

Syntax: `.ml.util.polytab[t;n]`

Where

-   `t` is a table of numerical values
-   `n` is the order of the polynomial feature being created

returns the polynomial derived features of degree `n` in the form of a table.

```q
q)n:100
q)5#tab:([]val:sin 0.001*til n;til n;n?100f;n?1000f;n?10)
val          x  x1       x2       x3
--------------------------------------
0            0  52.26479 990.7741 1
0.0009999998 1  2.740491 52.11973 1
0.001999999  2  42.23458 967.8194 8
0.002999996  3  23.54108 337.9137 0

q)5#.ml.util.polytab[tab;2]
val_x        val_x1      val_x2     val_x3       x_x1     x_x2     x_x3 x1_x2..
-----------------------------------------------------------------------------..
0            0           0          0            0        0        0    51782..
0.0009999998 0.002740491 0.05211972 0.0009999998 2.740491 52.11973 1    142.8..
0.003999997  0.08446911  1.935637   0.01599999   84.46917 1935.639 16   40875..
0.008999987  0.07062314  1.01374    0            70.62325 1013.741 0    7954...
0.01599996   0.2569871   2.354285   0.01999995   256.9878 2354.291 20   37814..

q)5#.ml.util.polytab[tab;3]
val_x_x1    val_x_x2   val_x_x3     val_x1_x2 val_x1_x3   val_x2_x3  x_x1_x2 ..
-----------------------------------------------------------------------------..
0           0          0            0         0           0          0       ..
0.002740491 0.05211972 0.0009999998 0.1428336 0.002740491 0.05211972 142.8337..
0.1689382   3.871275   0.03199998   81.75084  0.6757529   15.4851    81750.9 ..
0.2118694   3.041219   0            23.86453  0           0          23864.57..
1.027948    9.41714    0.07999979   151.2556  1.284935    11.77143   151256  ..

/this can be integrated with the original data via the syntax
q)5#newtab:tab^.ml.util.polytab[tab;2]^.ml.util.polytab[tab;3]

val          x  x1       x2       x3 val_x        val_x1    ..
------------------------------------------------------------..
0            0  52.26479 990.7741 1  0            0         ..
0.0009999998 1  2.740491 52.11973 1  0.0009999998 0.00274049..
0.001999999  2  42.23458 967.8194 8  0.003999997  0.08446911..
0.002999996  3  23.54108 337.9137 0  0.008999987  0.07062314..
0.003999989  4  64.24694 588.5728 5  0.01599996   0.2569871 ..
```


## `.ml.util.stdscaler`

_Standard scaler transform-based representation_

Syntax: `.ml.util.stdscaler[x]`

Where `x` is a numerical table, matrix or list, returns a table where each column has undergone a standard scaling given as `(x-avg x)%dev x`.

```q
q)n:5
q)show tab:([]n?100f;n?1000;n?100f;n?50f)
x        x1  x2       x3
------------------------------
12.48134 837 42.83142 7.597138
18.019   591 77.97026 46.69185
98.8875  860 73.44471 28.72854
30.70513 599 80.56178 39.70485
42.17381 187 75.26142 38.26483

q).ml.util.stdscaler[tab]
x          x1         x2         x3
---------------------------------------
-0.9029555 0.9173914   -1.969172 -1.813095
-0.7241963 -0.09826245 0.5763785 1.068269
1.886294   1.012351    0.2485354 -0.2556652
-0.3146793 -0.06523305 0.764115  0.5533119
0.0555375  -1.766247   0.380143  0.4471792

q)show mat:value flip tab
12.48134 18.019   98.8875  30.70513 42.17381
837      591      860      599      187
42.83142 77.97026 73.44471 80.56178 75.26142
7.597138 46.69185 28.72854 39.70485 38.26483

q).ml.util.stdscaler[mat]
-0.9029555 -0.7241963  1.886294   -0.3146793  0.0555375
0.9173914  -0.09826245 1.012351   -0.06523305 -1.766247
-1.969172  0.5763785   0.2485354  0.764115    0.380143
-1.813095  1.068269    -0.2556652 0.5533119   0.4471792

q)list:100?100
q).ml.util.stdscaler[list]
0.8394957 -0.7121328 0.09600701 -0.2272489 1.518333 -1.326319 -1.293993 -1.61..
```


## `.ml.util.tab2df`

_Convert a q table to Pandas dataframe_

Syntax: `.ml.util.tab2df[x]`

Where `x` is a table, returns it as a Pandas dataframe.

```q
q)n:5
q)table:([]x:n?10000f;x1:1+til n;x2:reverse til n;x3:n?100f) / q table for input
x        x1 x2 x3
-----------------------
2631.44  1  4  78.71917
1118.109 2  3  80.09356
3250.627 3  2  16.71013
q)show pdf:.ml.util.tab2df[table] / convert to pandas dataframe and show it is an embedPy object
{[f;x]embedPy[f;x]}[foreign]enlist
q)print pdf / display the python form of the dataframe
             x  x1  x2         x3
0  2631.439704   1   4  78.719172
1  1118.109056   2   3  80.093563
2  3250.627243   3   2  16.710134
```


## `.ml.util.traintestsplit`

_Split into training and test sets_

Syntax: `.ml.util.traintestsplit[x;y;sz]`

Where

-   `x` is a matrix
-   `y` is a boolean vector of the same count as `x`
-   `sz` is a numeric atom in the range 0-100

returns a dictionary containing the data matrix `x` and target `y`, split into a training and testing set according to the percentage `sz` of the data to be contained in the test set.

```q
q)x:(30 20)#1000?10f
q)y:rand each 30#0b
q).ml.util.traintestsplit[x;y;0.2] / split the data such that 20% is contained in the test set
xtrain| (2.02852 2.374546 1.083376 2.59378 6.698505 6.675959 4.120228 2.63468..
ytrain| 110010100101111001110000b
xtest | (8.379916 8.986609 7.06074 2.067817 5.468488 4.103195 0.1590803 0.259..
ytest | 000001b
```


## `.ml.util.traintestsplitseed`

_Split into training and test sets with a seed_

Syntax: `.ml.util.traintestsplitseed[x;y;sz;seed]`

Where

-   `x` is a matrix
-   `y` is a boolean vector of the same count as `x`
-   `sz` is a numeric atom in the range 0-1
-   `seed` is a numeric atom

as with `.ml.util.traintestsplit`, returns a dictionary containing the data matrix `x` and target `y` split into a training and testing set based on the percentage `sz` of the data to be contained in the test set. This version can be given a random seed (`seed`), thus allowing for the same splitting of the data to be repeatedly achieved.

```q
q)x:(30 20)#1000?10f
q)y:rand each 30#0b
q).ml.util.traintestsplitseed[x;y;0.2;42]
xtrain| (8.752061 6.82448 3.992896 2.465234 8.599461 2.452222 6.070236 6.8686..
ytrain| 000011101000001110111101b
xtest | (4.204472 7.137387 1.163132 9.893949 4.504886 5.465625 8.298632 0.049..
ytest | 000001b
q).ml.util.traintestsplitseed[x;y;0.2;42] /show that the splitting on repetition is the same
xtrain| (8.752061 6.82448 3.992896 2.465234 8.599461 2.452222 6.070236 6.8686..
ytrain| 000011101000001110111101b
xtest | (4.204472 7.137387 1.163132 9.893949 4.504886 5.465625 8.298632 0.049..
ytest | 000001b
```
