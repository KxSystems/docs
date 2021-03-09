---
author: Conor McCarthy
description: The toolkit contains utility functions, used in many applications and not limited to categories such as statistics or preprocessing.
date: April 2019
keywords: pandas manipulation, dataframe, train test split, .
---
# :fontawesome-solid-share-alt: Utility functions 



<div markdown="1" class="typewriter">
.ml   **Utility functions**
  [arange](#mlarange)             Evenly-spaced values within a range
  [combs](#mlcombs)              n linear combinations of k numbers
  [df2tab](#mldf2tab)             kdb+ table from a pandas dataframe
  [df2tabTimezone](#mldf2tabTimezone)     Pandas dataframe to kdb+ conversion handling
                     dates/times/timezones
  [eye](#mleye)                Identity matrix
  [iMax](#mlimax)               Index of maximum element of a list
  [iMin](#mlimin)               Index of minimum element of a list
  [linearSpace](#mllinearspace)        List of evenly-spaced values
  [range](#mlrange)              Range of values
  [shape](#mlshape)              Shape of a matrix
  [tab2df](#mltab2df)             Pandas dataframe from a q table
  [trainTestSplit](#mltraintestsplit)     Split into training and test sets
</div>

:fontawesome-brands-github:
[KxSystems/ml/util/util.q](https://github.com/kxsystems/ml/blob/master/util/util.q)

The toolkit contains utility functions, used in many applications and not limited to categories such as statistics or preprocessing.


## `.ml.arange`

_Evenly-spaced values_

```txt
.ml.arange[start;end;step]
```

Where

- `start` is the start of the interval (inclusive)
- `end` is the end of the interval (non-inclusive)
- `step` is the spacing between values

returns a vector of evenly-spaced values between start and end in steps of length `step`

```q
q).ml.arange[1;10;1]
1 2 3 4 5 6 7 8 9
q).ml.arange[6.25;10.5;0.05]
6.25 6.3 6.35 6.4 6.45 6.5 6.55 6.6 6.65 6.7 6.75 6.8 6.85 6.9 6.95 7 7.05 7...
```

## `.ml.combs`

_Unique combinations of a vector or matrix_

```txt
.ml.combs[n;degree]
```

Where

-  `n` is the integer number of values required for combinations
-  `degree` is the degree of the combinations to be produced

returns the unique combinations of values from the data.

```q
q).ml.combs[3;2]
0 1
0 2
1 2
q)show k:5?`1
`p`j`e`o`b
q)k .ml.combs[count k;4]	/ display values in combinations
p j e o
p j e b
p j o b
p e o b
j e o b
q)show m:(0 1 2;2 3 4;4 5 6;6 7 8)
0 1 2
2 3 4
4 5 6
6 7 8
q)m .ml.combs[count m;3]
0 1 2 2 3 4 4 5 6
0 1 2 2 3 4 6 7 8
0 1 2 4 5 6 6 7 8
2 3 4 4 5 6 6 7 8
```

## `.ml.df2tab`

_Convert pandas dataframe to q table_

```txt
.ml.df2tab[tab]
```

Where  

-  `tab` is an embedPy representation of a Pandas dataframe

returns `tab` as a q table.

```q
q)p)import pandas as pd
q)print t:.p.eval"pd.DataFrame({'fcol':[0.1,0.2,0.3,0.4,0.5],'jcol':[10,20,30,40,50]})"
   fcol  jcol
0   0.1    10
1   0.2    20
2   0.3    30
3   0.4    40
4   0.5    50
q).ml.df2tab t
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
q).ml.df2tab kt
jcol| fcol
----| ----
10  | 0.1
20  | 0.2
30  | 0.3
40  | 0.4
50  | 0.5
```

**Index columns** This function assumes a single unnamed Python index column is to be removed. It returns an unkeyed table. All other variants of Python index columns map to q key columns. For example any instance with two or more indexes will map to two or more Python keys, while any named single-index Python column be associated with a q key in a keyed table.

!!!note
	This function is a wrapper around `.ml.df2tabTimezone`, conversions within this function will default to convert `datetime.date` and `datetime.time` types to foreign objects, numpy timezone types are converted to their UTC representation. These conversion choices have been made due to python related computational inefficiencies in converting to native q types and local-time representations respectively.

## `.ml.df2tabTimezone`

_Convert a pandas dataframe containing datetime objects to a q table_

```txt
.ml.df2tabTimezone[tab;local;qObj]
```

Where:

- `tab` is an embedPy representation of a Pandas dataframe
- `local` is a boolean indicating if timezone(tz) objects are to be converted to local time (1b) or UTC (0b)
- `qObj` is a boolean indicating if python datetime.date/datetime.time objects are returned as q (1b) or foreign objects (0b)

Returns a q table

```q
q)p)import pandas as pd
q)p)import datetime
q)p)import numpy as np
q)p)dtdf=pd.DataFrame(
    {'time':[datetime.time(12, 10, 30,500),datetime.time(12, 13, 30,200)],
    'timed':[datetime.timedelta(hours=-5),datetime.timedelta(seconds=1000)],
    'datetime':[np.datetime64('2005-02-25T03:30'),np.datetime64('2015-12-22')]})
q)p)dtdf['dt_with_tz']=dtdf.datetime.dt.tz_localize('CET')

q)print dttab:.p.get[`dtdf]
              time             timed            datetime                dt_with_tz
0  12:10:30.000500 -1 days +19:00:00 2005-02-25 03:30:00 2005-02-25 03:30:00+01:00
1  12:13:30.000200          00:16:40 2015-12-22 00:00:00 2015-12-22 00:00:00+01:00

/ default behavior (tz -> UTC, time -> foreign)
q).ml.df2tabTimezone[dttab;0b;0b]
time    timed                 datetime                      dt_with_tz                   
-----------------------------------------------------------------------------------------
foreign -0D05:00:00.000000000 2005.02.25D03:30:00.000000000 2005.02.25D02:30:00.000000000
foreign 0D00:16:40.000000000  2015.12.22D00:00:00.000000000 2015.12.21D23:00:00.000000000

/ default time conversion, local tz conversion
q).ml.df2tabTimezone[dttab;1b;0b]
time    timed                 datetime                      dt_with_tz                   
-----------------------------------------------------------------------------------------
foreign -0D05:00:00.000000000 2005.02.25D03:30:00.000000000 2005.02.25D03:30:00.000000000
foreign 0D00:16:40.000000000  2015.12.22D00:00:00.000000000 2015.12.22D00:00:00.000000000

/ default tz conversion and conversion to q time
q).ml.df2tabTimezone[dttab;0b;1b]
time                 timed                 datetime                      dt_with_tz                   
------------------------------------------------------------------------------------------------------
0D12:10:30.000500000 -0D05:00:00.000000000 2005.02.25D03:30:00.000000000 2005.02.25D02:30:00.000000000
0D12:13:30.000200000 0D00:16:40.000000000  2015.12.22D00:00:00.000000000 2015.12.21D23:00:00.000000000
``` 
!!! warning "`.ml.df2tab_tz` deprecated"
    The above function was previously defined as `.ml.df2tab_tz`.
    It is still callable but will be deprecated after version 3.0.

## `.ml.eye`

_Create identity matrix_

```txt
.ml.eye[n]
```

Where  

- `n` is the width/height of identity matrix 

returns an identity matrix of height/width `n`.

```q
q).ml.eye 5
1 0 0 0 0
0 1 0 0 0
0 0 1 0 0
0 0 0 1 0
0 0 0 0 1
```

## `.ml.iMax`

_Index of maximum element of a list_

```txt
.ml.iMax[array]
```

Where 

- `array` is a numerical array of values

returns the index of the maximum element of the array

```q
q)show a:8?5.
3.883438 4.96977 2.447749 3.253555 4.246108 4.54695 1.381171 2.273137
q).ml.iMax a
1
q)show b:8?100
23 8 12 24 6 36 68 37
q).ml.iMax b
6
```
!!! warning "`.ml.imax` deprecated"
    The above function was previously defined as `.ml.imax`.
    It is still callable but will be deprecated after version 3.0.

## `.ml.iMin`

_Index of maximum element of a list_

```txt
.ml.iMin[array]
```

Where 

-  `array` is a numerical array of values

returns the index of the minimum element of the array


```q
q)show a:8?10.
0.6916353 8.045142 7.619755 4.599266 0.3341879 6.43216 6.177459 4.751895
q).ml.iMin a
4
q)show b:8?50
22 45 3 22 3 5 40 26
q).ml.iMin b
2
```

!!! warning "`.ml.imin` deprecated"
    The above function was previously defined as `.ml.imin`.
    It is still callable but will be deprecated after version 3.0.

## `.ml.linearSpace`

_Array of evenly-spaced values_

```txt
.ml.linearSpace[start;end;n]
```

Where

-  `start` is the start of the interval (inclusive)
-  `end` is the end of the interval (inclusive)
-  `n` indicates how many spaces are to be created 

returns a vector of `n` evenly-spaced values between `start` and `end`.

```q
q).ml.linearSpace[10;20;9]
10 11.25 12.5 13.75 15 16.25 17.5 18.75 20
q).ml.linearSpace[0.5;15.25;12]
0.5 1.840909 3.181818 4.522727 5.863636 7.204545 8.545455 9.886364 11.22727 1..
```
!!! warning "`.ml.linspace` deprecated"
    The above function was previously defined as `.ml.linspace`.
    It is still callable but will be deprecated after version 3.0.


## `.ml.range`

_Range of values_

```txt
.ml.range[array]
```

Where 

-  `array` is a numerical array

returns the range of its values.

```q
q).ml.range 1000?100000f
99742.37
q)show mat:(2 2#4?1f)
0.04492896 0.1786355
0.9694828  0.8964098
q).ml.range mat
0.9245539 0.7177742
```


## `.ml.shape`

_Shape of a matrix_

```txt
.ml.shape[matrix]
```

Where 

-  `matrix` is a matrix of values

returns its shape as a list of dimensions.

```q
q).ml.shape 10
`long$()
q).ml.shape enlist 10
,1
q).ml.shape til 10
,10
q).ml.shape enlist til 10
1 10
q).ml.shape 2 5#til 10
2 5
q).ml.shape 2 3 4#til 24
2 3 4
q).ml.shape ([]c1:til 10;c2:0)
10 2
```

!!! warning "Behavior of `.ml.shape` is undefined for ragged/jagged arrays."


## `.ml.tab2df`

_Convert q table to Pandas dataframe_

```txt
.ml.tab2df[tab]
```

Where  `tab` is a table

returns a Pandas dataframe.

```q
q)n:5
/ q table for input
q)table:([]x:n?10000f;x1:1+til n;x2:reverse til n;x3:n?100f)
x        x1 x2 x3
-----------------------
2631.44  1  4  78.71917
1118.109 2  3  80.09356
3250.627 3  2  16.71013
// Convert to pandas dataframe and show it is an embedPy object
q)show pdf:.ml.tab2df[table] 
{[f;x]embedPy[f;x]}[foreign]enlist
// Display the Python form of the dataframe
q)print pdf 
             x  x1  x2         x3
0  2631.439704   1   4  78.719172
1  1118.109056   2   3  80.093563
2  3250.627243   3   2  16.710134
```

## `.ml.trainTestSplit`

_Split into training and test sets_

```txt
.ml.trainTestSplit[data;target;size]
```

Where

-   `data` is a matrix, table or list
-   `target` is a vector of target values the same count as data
-   `size` is the percentage size of the testing set

returns a dictionary containing the data matrix and target values, split into a training and testing set according to the percentage `size` of the data to be contained in the test set.

```q
q)mat:(30 20)#1000?10f
q)target:rand each 30#0b
q).ml.trainTestSplit[mat;target;0.2] / split the data such that 20% is contained in the test set
xtrain| (2.02852 2.374546 1.083376 2.59378 6.698505 6.675959 4.120228 2.63468..
ytrain| 110010100101111001110000b
xtest | (8.379916 8.986609 7.06074 2.067817 5.468488 4.103195 0.1590803 0.259..
ytest | 000001b

q)tab:([]30?1f;30?`1;30?10)
q).ml.trainTestSplit[tab;target;0.2]
xtrain| +`x`x1`x2!(0.1659182 0.5316555 0.9658597 0.6659117 0.4921318 0.580703..
ytrain| 0.4449418 0.6637015 0.77852 0.8229043 0.5678825 0.9534722 0.2448434 0..
xtest | +`x`x1`x2!(0.6913239 0.3921862 0.2904501 0.6536423 0.6517715 0.961030..
ytest | 0.9861457 0.752895 0.2695986 0.122979 0.4412847 0.4952119

q)list:asc 30?1f
q).ml.trainTestSplit[list;target;0.2]
xtrain| 0.4251052 0.6419072 0.5701215 0.4231011 0.327041 0.1573152 0.3414573 ..
ytrain| 0.5029018 0.05230331 0.628313 0.5766565 0.6314705 0.3266584 0.9624403..
xtest | 0.3692275 0.4192985 0.1573064 0.9121564 0.28237 0.07992544
ytest | 0.3821462 0.9177309 0.3572827 0.1110881 0.9807582 0.5132051
```

!!! warning "`.ml.traintestsplit` deprecated"
    The above function was previously defined as `.ml.traintestsplit`.
    It is still callable but will be deprecated after version 3.0.
