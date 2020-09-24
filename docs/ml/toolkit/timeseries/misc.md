---
title: Time Series Feature Engineering | Time Series | Machine Learning Toolkit | Documentation for kdb+ and q
author: Diane O'Donoghue
date: September 2020
keywords: machine learning, ml, time series, feature engineering, lag, window, stationarity
---

# :fontawesome-solid-share-alt: Miscellaneous Time Series Functionality

<pre markdown="1" class="language-txt">
.ml.ts

**Feature Engineering**
[laggedFeatures](#mltslaggedfeatures) Create lagged features from a time series
[windowFeatures](#mltswindowfeatures) Create windowed features from a time series

**Miscellaneous Functionality**
[stationarity](#mltsstationarity)   Test that time-series data is stationary
</pre>

<i class="fab fa-github"></i>
[KxSystems/ml/timeseries](https://github.com/KxSystems/ml/tree/master/timeseries)

## `.ml.ts.laggedFeatures`

_Create lagged features from an equispaced tabular time series dataset_

Syntax: `.ml.ts.laggedFeatures[tab;colNames;lags]`

Where
 
-  `tab` is a table containing equispaced time series data
-  `colNames` is a list of columns to extract the lag values from
-  `lags` is a list of historic lags to be added as columns to the dataset

returns a table with additional columns containing the historical values for each row

!!!Warning
	The original data contained within the time series is not removed from the table. As such, null values are present in any lagged columns. A user wishing to apply a machine learning algorithm shoud handle this data as appropriate to their use case.

```q
q)show tab:([]"p"$"d"$til 100;100?10f;100?100)
x                             x1       x2
-----------------------------------------
2000.01.01D00:00:00.000000000 1.018678 15
2000.01.02D00:00:00.000000000 5.017681 31
2000.01.03D00:00:00.000000000 4.292246 5 
2000.01.04D00:00:00.000000000 9.130693 98
2000.01.05D00:00:00.000000000 9.87942  63
2000.01.06D00:00:00.000000000 3.10237  18
2000.01.07D00:00:00.000000000 3.185829 98
2000.01.08D00:00:00.000000000 5.001716 3 
2000.01.09D00:00:00.000000000 8.8483   28
2000.01.10D00:00:00.000000000 4.389455 32
2000.01.11D00:00:00.000000000 4.622394 31
..
q).ml.ts.laggedFeatures[tab;`x1`x2;1 7]
x                             x1       x2 x1_xprev_1 x2_xprev_1 x1_xprev_7 x2..
-----------------------------------------------------------------------------..
2000.01.01D00:00:00.000000000 1.018678 15                                    ..
2000.01.02D00:00:00.000000000 5.017681 31 1.018678   15                      ..
2000.01.03D00:00:00.000000000 4.292246 5  5.017681   31                      ..
2000.01.04D00:00:00.000000000 9.130693 98 4.292246   5                       ..
2000.01.05D00:00:00.000000000 9.87942  63 9.130693   98                      ..
2000.01.06D00:00:00.000000000 3.10237  18 9.87942    63                      ..
2000.01.07D00:00:00.000000000 3.185829 98 3.10237    18                      ..
2000.01.08D00:00:00.000000000 5.001716 3  3.185829   98         1.018678   15..
2000.01.09D00:00:00.000000000 8.8483   28 5.001716   3          5.017681   31..
2000.01.10D00:00:00.000000000 4.389455 32 8.8483     28         4.292246   5 ..
2000.01.11D00:00:00.000000000 4.622394 31 4.389455   32         9.130693   98..
2000.01.12D00:00:00.000000000 5.947391 64 4.622394   31         9.87942    63..
2000.01.13D00:00:00.000000000 7.07042  74 5.947391   64         3.10237    18..
2000.01.14D00:00:00.000000000 5.73765  36 7.07042    74         3.185829   98..
2000.01.15D00:00:00.000000000 7.687404 40 5.73765    36         5.001716   3 ..
2000.01.16D00:00:00.000000000 7.911298 57 7.687404   40         8.8483     28..
2000.01.17D00:00:00.000000000 4.390106 32 7.911298   57         4.389455   32..
2000.01.18D00:00:00.000000000 6.657884 97 4.390106   32         4.622394   31..
2000.01.19D00:00:00.000000000 7.177445 41 6.657884   97         5.947391   64..
2000.01.20D00:00:00.000000000 6.135786 2  7.177445   41         7.07042    74..
```

## `.ml.ts.windowFeatures`

_Create windowed features from an equispaced tabular time series_

Syntax: `.ml.ts.windowFeatures[tab;colNames;funcs;wins]`

Where
 
-  `tab` is a table containing equispaced time series data
-  `colNames` is a list of columns to apply the windowed functions to
-  `funcs` list of function names (as symbols) which are to be applied to the time series
-  `wins` list of window sizes on which to apply these functions

returns a table with additional columns containing the functions applied over appropriate window lengths

!!! Note
	The first `max[wins]` rows of the table are removed as these are produced with insufficient data to provide accurate results

```q
q)show ts_tab:([]"p"$"d"$til 100;100?10f;100?100)
x                             x1        x2
------------------------------------------
2000.01.01D00:00:00.000000000 5.230753  23
2000.01.02D00:00:00.000000000 7.651266  84
2000.01.03D00:00:00.000000000 0.7032763 5 
2000.01.04D00:00:00.000000000 8.144315  64
2000.01.05D00:00:00.000000000 4.290421  56
2000.01.06D00:00:00.000000000 3.202111  6 
2000.01.07D00:00:00.000000000 9.261242  9 
2000.01.08D00:00:00.000000000 7.979004  67
2000.01.09D00:00:00.000000000 9.891492  61
2000.01.10D00:00:00.000000000 8.093424  94
2000.01.11D00:00:00.000000000 1.013315  87
q)funcs:`avg`max`med
q)wins:7 14
q).ml.ts.windowFeatures[ts_tab;`x1`x2;funcs;wins]
x                             x1        x2 avg_7_x1  avg_7_x2 avg_14_x1 avg_1..
-----------------------------------------------------------------------------..
2000.01.01D00:00:00.000000000 5.230753  23 0.7472505 3.285714 0.3736252 1.642..
2000.01.02D00:00:00.000000000 7.651266  84 1.840289  15.28571 0.9201443 7.642..
2000.01.03D00:00:00.000000000 0.7032763 5  1.940757  16       0.9703783 8    ..
2000.01.04D00:00:00.000000000 8.144315  64 3.10423   25.14286 1.552115  12.57..
2000.01.05D00:00:00.000000000 4.290421  56 3.717147  33.14286 1.858574  16.57..
2000.01.06D00:00:00.000000000 3.202111  6  4.174592  34       2.087296  17   ..
2000.01.07D00:00:00.000000000 9.261242  9  5.497626  35.28571 2.748813  17.64..
2000.01.08D00:00:00.000000000 7.979004  67 5.890234  41.57143 3.318742  22.42..
2000.01.09D00:00:00.000000000 9.891492  61 6.210266  38.28571 4.025277  26.78..
2000.01.10D00:00:00.000000000 8.093424  94 7.266001  51       4.603379  33.5 ..
2000.01.11D00:00:00.000000000 1.013315  87 6.247287  54.28571 4.675759  39.71..
```

## `.ml.ts.stationarity`

_Summary of the stationarity of a set of time series data using an augmented dickey-filler test_

Syntax: `.ml.ts.stationarity[dset]`

Where

-  `dset` is a dictionary, table or vector of time series data. All data should be numerical.

returns a keyed table outlining the stationarity of each key, column or vector of the provided dataset

```q
q)vec:1000?1f
q).ml.ts.stationarity[vec]
    | ADFstat   pvalue stationary CriticalValue_1% CriticalValue_5% CriticalValue_10%
----| -------------------------------------------------------------------------------
data| -30.77781 0      1          -3.436913        -2.864437        -2.568313        

q)tab:([]1000?1f;til 1000;1000?5)
q).ml.ts.stationarity[tab]
  | ADFstat   pvalue stationary CriticalValue_1% CriticalValue_5% CriticalValue_10%
- | -------------------------------------------------------------------------------
x | -32.40113 0      1          -3.436913        -2.864437        -2.568313        
x1| 19.27252  1      0          -3.436999        -2.864476        -2.568333        
x2| -31.5352  0      1          -3.436913        -2.864437        -2.568313        

q)dict:`x`x1`x2!(100?1f;100?1f;asc 100?1f)
q).ml.ts.stationarity[dict]
  | ADFstat   pvalue       stationary CriticalValue_1% CriticalValue_5% CriticalValue_10%
- | -------------------------------------------------------------------------------------
x | -9.522067 3.046044e-16 1          -3.498198        -2.891208        -2.582596        
x1| -8.763674 2.632545e-14 1          -3.498198        -2.891208        -2.582596        
x2| 0.3685454 0.9802798    0          -3.498198        -2.891208        -2.582596        
```
