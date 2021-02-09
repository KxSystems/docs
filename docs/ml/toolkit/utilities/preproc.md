---
author: Conor McCarthy
description: The Machine Learning Toolkit contains functions used regularly within pipelines for the manipulation of data. Such functions are often applied prior to the application of algorithms. They ensure data is in the correct format and does not contain uninformative information or datatypes the algorithms cannot handle.
date: April 2019
keywords: preprocessing, linear combinations, polynomial creation, infinite replace, scaler, data filling, encoding, one-hot, frequency, lexigraphical, time splitting 
---
# :fontawesome-solid-share-alt: Data preprocessing 


<div markdown="1" class="typewriter">
.ml   **Data preprocessing**
  [applylabelencode](#mlapplylabelencode)  Transform integer data to label encode representation
  [dropconstant](#mldropconstant)      Columns with zero variance removed
  [filltab](#mlfilltab)           Tailored filling of null values for a simple matrix
  [freqencode](#mlfreqencode)        Numerically encode frequency of category occurance
  [infreplace](#mlinfreplace)        Replace +/- infinities with max/min of column
  [labelencode](#mllabelencode)       Encode list of symbols to integer values and produce mapping
  [lexiencode](#mllexiencode)        Label categories based on lexigraphical order
  [minmaxscaler](#mlminmaxscaler)      Data scaled between 0-1
  [onehot](#mlonehot)            One-hot encoding of table or array
  [polytab](#mlpolytab)           Polynomial features of degree n from a table
  [stdscaler](#mlstdscaler)         Standard scaler transform-based representation of a table
  [timesplit](#mltimesplit)         Decompose time columns into constituent parts
</div>

:fontawesome-brands-github:
[KxSystems/ml/util/preproc.q](https://github.com/kxsystems/ml/blob/master/util/preproc.q)

The Machine Learning Toolkit contains functions used regularly within pipelines for the manipulation of data. Such functions are often applied prior to the application of algorithms. They ensure data is in the correct format and does not contain uninformative information or datatypes the algorithms cannot handle.

## `.ml.applylabelencode`

_Transform a list of integers based on a previously generated label encoding_

Syntax: `.ml.applylabelencode[x;y]`

Where

- `x` is a list of integers
- `y` is a dictionary mapping true representation to associated integer or the return from `.ml.labelencode`

returns a list with the integer values of `x` replaced by their appropriate 'true' representation. Values that do not appear in the mapping supplied by `y` are returned as null values

!!!Note
	This function is primarily used when attempting to convert classification predictions from a fitted model to their underlying representation. It is often the case that a user will convert a symbol list to an integer list in order to allow their machine learning model to fit the data appropriately.

```q
// List of symbols to be encoded
q)symList:`a`a`a`b`a`b`b`c`c`c`c

// Produced and display a symbol encoding schema
q)show schema:.ml.labelencode[symList]
mapping | `s#`a`b`c!0 1 2
encoding| 0 0 0 1 0 1 1 2 2 2 2

// Generate a list of integers to apply the schema to
q)newList:0 0 1 2 2 2 0 1 4

// Apply the schema completely and the mapping itself to the new list
q).ml.applylabelencode[newList;schema]
`a`a`b`c`c`c`a`b`
q).ml.applylabelencode[newList;schema`mapping]
`a`a`b`c`c`c`a`b`
```

## `.ml.dropconstant`

_Remove columns with zero variance_

Syntax: `.ml.dropconstant[x]`

Where 

-  `x` is a numerical table

returns `x` without columns of zero variance.

```q
q)5#tab:([]1000?100f;1000#10;1000#0N)
x        x1 x2
--------------
95.25017 10
42.09728 10
98.80532 10
54.5461  10
51.7746  10
q)5#.ml.dropconstant tab	/ tabular input
x
--------
95.25017
42.09728
98.80532
54.5461
51.7746
q).ml.dropconstant flip tab	/ dictionary input
x| 33.35067 23.52469 95.13262 64.67595 57.13359 4.249854 34.68608 63.04755 76..
```


## `.ml.filltab`

_Tunable filling of null data for a simple table_

Syntax: `.ml.filltab[t;gcol;tcol;dict]`

Where

-   `t` is a table
-   `gcol` is a grouping column for the fill
-   `tcol` is a time column in the data
-   `dict` is a dictionary defining fill behavior, setting this to `::` will result in forward followed by reverse filling

returns a table with columns filled according to assignment of keys in the dictionary `dict`, the null values are also encoded within a new column to maintain knowledge of the null positions. 

```q
q)show tab:([]sym:10?`A`B;time:asc 10?0t;@[10?1f;0 1 8 9;:;0n];@[10?1f;4 5;:;0n];@[10?1f;2*til 5;:;0n])
sym time         x          x1        x2         
-------------------------------------------------
B   03:27:54.715            0.9976543            
B   05:38:20.749            0.2531291 0.004250957
A   07:54:57.322 0.7625179  0.4537337            
B   08:12:25.502 0.7505538  0.7209056 0.04499967 
A   10:13:43.703 0.487814                        
A   14:10:25.386 0.2057634            0.92978    
B   17:38:28.322 0.6288875  0.8751704            
A   17:44:20.022 0.02301354 0.4503539 0.8472568  
B   18:16:47.740            0.4052153            
B   23:10:44.297            0.5513535 0.2213819  
q)gc:`sym
q)tc:`time
q)dict:`x`x1`x2!`linear`median`mean
q).ml.filltab[tab;gc;tc;dict] / tailored fills
sym time         x          x1        x2          x_null x1_null x2_null
------------------------------------------------------------------------
B   03:27:54.715 0.8117071  0.9976543 0.09021085  1      0       1      
B   05:38:20.749 0.7836716  0.2531291 0.004250957 1      0       0      
A   07:54:57.322 0.7625179  0.4537337 0.8885184   0      0       1      
B   08:12:25.502 0.7505538  0.7209056 0.04499967  0      0       0      
A   10:13:43.703 0.487814   0.4503539 0.8885184   0      1       1      
A   14:10:25.386 0.2057634  0.4503539 0.92978     0      1       0      
B   17:38:28.322 0.6288875  0.8751704 0.09021085  0      0       1      
A   17:44:20.022 0.02301354 0.4503539 0.8472568   0      0       0      
B   18:16:47.740 0.6206502  0.4052153 0.09021085  1      0       1      
B   23:10:44.297 0.5574701  0.5513535 0.2213819   1      0       0      
q).ml.filltab[tab;gc;tc;::]  / default forward-backward filling
sym time         x          x1        x2          x_null x1_null x2_null
------------------------------------------------------------------------
B   03:27:54.715 0.7505538  0.9976543 0.004250957 1      0       1      
B   05:38:20.749 0.7505538  0.2531291 0.004250957 1      0       0      
A   07:54:57.322 0.7625179  0.4537337 0.92978     0      0       1      
B   08:12:25.502 0.7505538  0.7209056 0.04499967  0      0       0      
A   10:13:43.703 0.487814   0.4537337 0.92978     0      1       1      
A   14:10:25.386 0.2057634  0.4537337 0.92978     0      1       0      
B   17:38:28.322 0.6288875  0.8751704 0.04499967  0      0       1      
A   17:44:20.022 0.02301354 0.4503539 0.8472568   0      0       0      
B   18:16:47.740 0.6288875  0.4052153 0.04499967  1      0       1      
B   23:10:44.297 0.6288875  0.5513535 0.2213819   1      0       0      
```

!!! note "Form of the `dict` argument"

  	The form of the `dict` argument changed in version 0.2. 
    Previously, it had the form `` `linear`median!(`x`x1;`x2`x3) ``. 
    
    In version `0.2.0` this is has become `` `x`x1`x2`x3!(2#`linear),2#`median ``. 


## `.ml.freqencode`

_Encoded frequency of individual category occurences_

Syntax:.`.ml.frequencode[t;c]`

Where

-  `t` is a simple table
-  `c` is a list of columns to apply encoding to, setting as `::` encodes all sym columns.

returns table with frequency of occurrance of individual symbols within a column.

```q
q)show tab:([]10?`a`b`c;10?10f;10?3)
x x1        x2
--------------
c 4.429712  1 
a 0.4843617 0 
a 7.101809  1 
a 4.706552  1 
a 5.680263  1 
a 5.329865  2 
a 8.452182  1 
a 0.4821576 0 
b 4.755664  0 
c 8.35521   0 
q).ml.freqencode[tab;::]    / default behavior
x1        x2 x_freq
-------------------
4.429712  1  0.2   
0.4843617 0  0.7   
7.101809  1  0.7   
4.706552  1  0.7   
5.680263  1  0.7   
5.329865  2  0.7   
8.452182  1  0.7   
0.4821576 0  0.7   
4.755664  0  0.1   
8.35521   0  0.2   
q).ml.freqencode[tab;`x`x2] / customised encoding
x1        x_freq x2_freq
------------------------
4.429712  0.2    0.5    
0.4843617 0.7    0.4    
7.101809  0.7    0.5    
4.706552  0.7    0.5    
5.680263  0.7    0.5    
5.329865  0.7    0.1    
8.452182  0.7    0.5    
0.4821576 0.7    0.4    
4.755664  0.1    0.4    
8.35521   0.2    0.4    
```


## `.ml.infreplace`

_Replace +/- infinities with data min/max_

Syntax: `.ml.infreplace[x]`

Where 

-  `x` is a dictionary/table/list of numeric values

returns the data with positive/negative infinities replaced by max/min values for the given key.

```q
q)show d:`A`B`C!(5 6 9 0w;10 -0w 0 50;0w 1 2 3)
A| 5  6   9 0w
B| 10 -0w 0 50
C| 0w 1   2 3

q).ml.infreplace d`A
5 6 9 9f

q).ml.infreplace d
A| 5  6 9 9
B| 10 0 0 50
C| 3  1 2 3

q).ml.infreplace flip d
A B  C
------
5 10 3
6 0  1
9 0  2
9 50 3
```

##`.ml.labelencode`

_Encode a list to an integer value representation, with associated mapping schema_

Syntax:`.ml.labelencode[x]`

Where

-  `x` is a list of any type

returns a dictionary providing the schema mapping values in the list to associated integers and the original list encoded based on this schema

```q
q)sym:`cab`acb`abc`bac`bca
q)show symencode:.ml.labelencode[sym]
mapping | `s#`abc`acb`bac`bca`cab!0 1 2 3 4
encoding| 4 1 0 2 3
q)symencode.mapping
abc| 0
acb| 1
bac| 2
bca| 3
cab| 4
q)symencode.encoding
4 1 0 2 3

q)guids:5?0Ng
q)show guidencode:.ml.labelencode[guids]
mapping | `s#580d8c87-e557-0db1-3a19-cb3a44d623b1 5a580fb6-656b-5e69-d445-417..
encoding| 3 2 1 4 0
q)guidencode.mapping
580d8c87-e557-0db1-3a19-cb3a44d623b1| 0
5a580fb6-656b-5e69-d445-417ebfe71994| 1
5ae7962d-49f2-404d-5aec-f7c8abbae288| 2
8c6b8b64-6815-6084-0a3e-178401251b68| 3
ddb87915-b672-2c32-a6cf-296061671e9d| 4
q)guidencode.encoding
3 2 1 4 0

q)floats:5?1f
q)show floatencode:.ml.labelencode[floats]
mapping | `s#0.2306385 0.4707883 0.6346716 0.949975 0.9672398!0 1 2 3 4
encoding| 1 2 4 0 3
q)floatencode.mapping
0.2306385| 0
0.4707883| 1
0.6346716| 2
0.949975 | 3
0.9672398| 4
q)floatencode.encoding
1 2 4 0 3
```

## `.ml.lexiencode`

_Label symbol columns based on lexigraphical order_

Syntax:`.ml.lexiencode[t;c]`

Where

-  `t` is a simple table
-  `c` is a list of columns to apply encoding to, setting as `::` encodes all sym columns

returns table with lexigraphical order of letters column.

```q
q)show tab:([]5?10f;5?`a`b`c;5?`e`f`g)
x        x1 x2
--------------
3.122149 b  f
1.165431 b  g
2.244198 b  e
3.163946 a  g
7.851531 b  g

q).ml.lexiencode[tab;::]  / default behavior
x        x1_lexi x2_lexi
------------------------
3.122149 1       1
1.165431 1       2
2.244198 1       0
3.163946 0       2
7.851531 1       2

q).ml.lexiencode[tab;`x1] / custom behavior
x        x2 x1_lexi
-------------------
3.122149 f  1
1.165431 g  1
2.244198 e  1
3.163946 g  0
7.851531 g  1
```


## `.ml.minmaxscaler`

_Scale data between 0-1_

Syntax: `.ml.minmaxscaler[x]`

Where

-  `x` is a numerical table, matrix or list

returns a min-max scaled representation with values scaled between 0 and 1f.

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

q).ml.minmaxscaler[tab]
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

q).ml.minmaxscaler[mat]
0         0.06408864 1         0.2109084 0.3436384
0.9658247 0.6002972  1         0.6121842 0
0         0.9313147  0.8113701 1         0.85952
0         1          0.5405182 0.8212801 0.7844459

q)list:100?100
q).ml.minmaxscaler[list]
0.7835052 0.2886598 0.5463918 0.443299 1 0.09278351 0.1030928 0 0.9175258 0.9..
```


## `.ml.onehot`

_One-hot encoding_

Syntax: `.ml.onehot[t;c]`

Where

-  `t` simple table
-  `c` is a list of columns as symbols to apply encoding to. Setting as `::` will encode all symbol columns

returns one-hot encoded representation as a table.

```q
q)5#tab:([]5?`a`b`c;5?2;5?10f)
x x1 x2      
-------------
a 0  3.21158 
a 0  2.084756
b 0  9.450667
c 1  7.8567  
c 1  5.898786
q).ml.onehot[tab;::]      / default behavior
x1 x2       x_a x_b x_c
-----------------------
0  3.21158  1   0   0  
0  2.084756 1   0   0  
0  9.450667 0   1   0  
1  7.8567   0   0   1  
1  5.898786 0   0   1  
q).ml.onehot[tab;`x`x1]   / custom behavior
x2       x_a x_b x_c x1_0 x1_1
------------------------------
3.21158  1   0   0   1    0   
2.084756 1   0   0   1    0   
9.450667 0   1   0   1    0   
7.8567   0   0   1   0    1   
5.898786 0   0   1   0    1   
```


## `.ml.polytab`

_Tunable polynomial features from an input table_

Syntax: `.ml.polytab[t;n]`

Where

-   `t` is a table of numerical values
-   `n` is the order of the polynomial feature being created

returns the polynomial derived features of degree `n` in the form of a table.

```q
q)n:100
q)5#tab:([]val:sin 0.001*til n;til n;n?100f;n?1000f;n?10)
val          n  x        x1       x2
------------------------------------
0            0  68.5896  20.67882 2
0.0009999998 1  41.60588 752.6717 1
0.001999999  2  19.6753  479.5434 3
0.002999996  3  76.81172 463.5728 3
0.003999989  4  45.02587 694.5211 8

q)5#.ml.polytab[tab;2]
val_n        val_x      val_x1    val_x2       n_x      n_x1     n_x2 x_x1   ..
-----------------------------------------------------------------------------..
0            0          0         0            0        0        0    1418.35..
0.0009999998 0.04160587 0.7526715 0.0009999998 41.60588 752.6717 1    31315.5..
0.003999997  0.03935058 0.9590862 0.005999996  39.35061 959.0868 6    9435.16..
0.008999987  0.2304348  1.390716  0.008999987  230.4352 1390.719 9    35607.8..
0.01599996   0.180103   2.778077  0.03199991   180.1035 2778.084 32   31271.4..

q)5#.ml.polytab[tab;3]
val_n_x    val_n_x1  val_n_x2     val_x_x1 val_x_x2   val_x1_x2 n_x_x1   n_x_..
-----------------------------------------------------------------------------..
0          0         0            0        0          0         0        0   ..
0.04160587 0.7526715 0.0009999998 31.31556 0.04160587 0.7526715 31315.57 41.6..
0.07870116 1.918172  0.01199999   18.87031 0.1180517  2.877259  18870.32 118...
0.6913044  4.172149  0.02699996   106.8233 0.6913044  4.172149  106823.5 691...
0.7204121  11.11231  0.1279997    125.0853 1.440824   22.22462  125085.7 1440..

/this can be integrated with the original data via the syntax
q)5#newtab:tab^.ml.polytab[tab;2]^.ml.polytab[tab;3]
val          n  x        x1       x2 val_n        val_x      val_x1    val_x2..
-----------------------------------------------------------------------------..
0            0  68.5896  20.67882 2  0            0          0         0     ..
0.0009999998 1  41.60588 752.6717 1  0.0009999998 0.04160587 0.7526715 0.0009..
0.001999999  2  19.6753  479.5434 3  0.003999997  0.03935058 0.9590862 0.0059..
0.002999996  3  76.81172 463.5728 3  0.008999987  0.2304348  1.390716  0.0089..
0.003999989  4  45.02587 694.5211 8  0.01599996   0.180103   2.778077  0.0319..
```


## `.ml.stdscaler`

_Standard scaler transform-based representation_

Syntax: `.ml.stdscaler[x]`

Where

-  `x` is a simple numerical table, matrix or list

returns a table where each column has undergone a standard scaling given by the formula `(x-avg x)%dev x`.

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

q).ml.stdscaler[tab]
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

q).ml.stdscaler[mat]
-0.9029555 -0.7241963  1.886294   -0.3146793  0.0555375
0.9173914  -0.09826245 1.012351   -0.06523305 -1.766247
-1.969172  0.5763785   0.2485354  0.764115    0.380143
-1.813095  1.068269    -0.2556652 0.5533119   0.4471792

q)list:100?100
q).ml.stdscaler[list]
0.8394957 -0.7121328 0.09600701 -0.2272489 1.518333 -1.326319 -1.293993 -1.61..
```


## `.ml.timesplit`

_Break specified time columns into constituent components_

Syntax: `.ml.timesplit[t;c]`

Where

-  `t` is a simple table
-  `c` is a list of columns as symbols to apply encoding to, if set to `::` all columns with date/time types will be encoded

returns a table with the columns with all time or date types broken into labeled versions of their constituent components.

```q
q)show timetab:([]`timestamp$(2000.01.01+til 5);5?0u;5?10;5?10)
x                             x1    x2 x3
-----------------------------------------
2000.01.01D00:00:00.000000000 21:51 7  6 
2000.01.02D00:00:00.000000000 02:55 5  7 
2000.01.03D00:00:00.000000000 09:48 7  6 
2000.01.04D00:00:00.000000000 16:50 7  5 
2000.01.05D00:00:00.000000000 13:50 4  5 
q).ml.timesplit[timetab;::]  / default behavior
x2 x3 x_dow x_year x_mm x_dd x_qtr x_wd x_hh x_uu x_ss x1_hh x1_uu
------------------------------------------------------------------
7  6  0     2000   1    1    1     0    0    0    0    21    51   
5  7  1     2000   1    2    1     0    0    0    0    2     55   
7  6  2     2000   1    3    1     1    0    0    0    9     48   
7  5  3     2000   1    4    1     1    0    0    0    16    50   
4  5  4     2000   1    5    1     1    0    0    0    13    50   
q).ml.timesplit[timetab;`x]  / tailored application of encoding
x1    x2 x3 x_dow x_year x_mm x_dd x_qtr x_wd x_hh x_uu x_ss
------------------------------------------------------------
21:51 7  6  0     2000   1    1    1     0    0    0    0   
02:55 5  7  1     2000   1    2    1     0    0    0    0   
09:48 7  6  2     2000   1    3    1     1    0    0    0   
16:50 7  5  3     2000   1    4    1     1    0    0    0   
13:50 4  5  4     2000   1    5    1     1    0    0    0   
```
