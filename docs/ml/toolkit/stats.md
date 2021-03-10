---
title: Statistical Methods | Machine Learning | Machine Learning | kdb+ and q documentation
author: Diane O'Donoghue
description: Descriptive statistical methods to gain more insight into data, and linear regression estimation methods to investigate unknown parameters in a model
date: February 2021
---
# :fontawesome-solid-share-alt: Statistical analysis

<div markdown="1" class="typewriter">
.ml.stats   **Statistical functions**

**Descriptive statistics**
  [describe](#mlstatsdescribe)         Descriptive information about a table
  [percentile](#mlstatspercentile)       Percentile calculation for an array

**Statistical estimation methods**
  [describeFuncs](#mlstatsdescribefuncs)    Modify statistical functions applied to data
  [OLS.fit](#mlstatsolsfit)           Train an ordinary least squares model on data
  [WLS.fit](#mlstatswlsfit)           Train a weighted least squares model on data
</div>

:fontawesome-brands-github:
[KxSystems/ml/stats](https://github.com/KxSystems/ml/tree/master/stats)

This statistical library contains functionality ranging from descriptive statistical methods to gain more insight into your data, to linear-regression estimation methods to investigate unknown parameters in a model.


### Modifying description functionality

The statistical functions applied to the data can be altered by either

-   modifying `stats/describe.json`
-   calling `.ml.stats.describeFuncs`

The JSON file follows the format

```json
 "count":{
    "func":"count",
    "type":["num","temporal","other"]
  },
  "type":{
    "func":"{.ml.stats.i.metaTypes .Q.ty x}",
    "type":["num","temporal","other"]
  },
  "mean":{
    "func":"avg",
    "type":["num"]
  },
  "std":{
    "func":"sdev",
    "type":["num"]
  },
  "min":{
    "func":"min",
    "type":["num","temporal"]
  }
```

---


## `.ml.stats.describe`

_Generates descriptive statistics of columns in a table_

```txt
.ml.stats.describe tab
```

Where `tab` is a simple table,
returns a tabular description of aggregate information (count, standard deviation, quartiles etc) for each column.


```q
q)n:1000
q)tab:([]sym:n?`4;x:n?10000f;x1:1+til n;x2:reverse til n;x3:n?100f)
q).ml.stats.describe tab
             | sym     x           x1       x2       x3
-----        | -------------------------------------------------
count        | 1000    1000        1000     1000     1000
type         | `symbol `float      `long    `long    `float
mean         | ::      5101.113    500.5    499.5    51.59885
std          | ::      2833.686    288.8194 288.8194 29.33562
min          | ::      9.771725    1        0        0.02741043
max          | ::      9973.398    1000     999      99.96445
q1           | ::      2708.268    250.75   249.75   27.0071
q2           | ::      5148.468    500.5    499.5    51.23665
q3           | ::      7375.113    750.25   749.25   78.01016
nulls        | 0i      0i          0i       0i       0i
inf          | ::      0i          0i       0i       0i
range        | ::      9963.627    999      999      99.93704
skew         | ::      -0.03914009 0f       0f       -0.07741558
countDistinct| 994     1000        1000     1000     1000
mode         | `lnmj   5300.464    1        999      90.61246
freq         | 1       1           1        1        1
sampleDev    | ::      2833.686    288.8194 288.8194 29.33562
standardError| ::      89.56419    9.128705 9.128705 0.9272099

// Generate a table containing only temporal data
q)timeTab:([]"z"$n?100;"d"$n?til 5)
q).ml.stats.describe timeTab
             | x                       x1
-----        | ----------------------------------
count        | 1000                    1000
type         | `datetime               `date
min          | 2000.01.01T00:00:00.000 2000.01.01
max          | 2000.04.09T00:00:00.000 2000.01.05
nulls        | 0i                      0i
range        | 99f                     4i
countDistinct| 100                     5
mode         | 2000.03.09T00:00:00.000 2000.01.05
freq         | 3                       187
```

!!! warning "Deprecated"

    The above function was previously defined as `.ml.describe`.
    That is still callable but will be removed after version 3.0.


## `.ml.stats.describeFuncs`

<!-- FIXME Can this syntax be correct? -->

`.ml.stats.describeFuncs` loads the dictionary defined in `stats/describe.json` and returns it as a table

```txt
q)5#.ml.stats.describeFuncs
     | func                              type
-----| ------------------------------------------------------------
count| "count"                           ("num";"temporal";"other")
type | "{.ml.stats.i.metaTypes .Q.ty x}" ("num";"temporal";"other")
mean | "avg"                             ,"num"
std  | "sdev"                            ,"num"
min  | "min"                             ("num";"temporal")
```

in which

-   the key of the dictionary defines the name of the function that will appear in the table returned from `.ml.stats.describe`.
-   `func` is the function to be applied to the data
-   `type` defines the type of data that the function will be applied to. The valid types allowed are ``` `num`temporal`other ```

```txt
num      "hijef"
temporal "pmdznuvt"
other    All other remaining types
```


## `.ml.stats.percentile`

_Percentile calculation for an array_

```syntax
.ml.stats.percentile[array;perc]
```

Where

-  `array` is a numerical array
-  `perc` is the percentile of interest between 0-1

returns the value below which `perc` percent of the observations within the array are found.

```q
q).ml.stats.percentile[10000?1f;0.2]
0.2030272
q).ml.stats.percentile[10000?1f;0.6]
0.5916521
```


## `.ml.stats.OLS.fit`

_Train an ordinary least squares model on data_

```syntax
.ml.stats.OLS.fit[endog;exog;trend]
```

Where

-  `endog` is the numerical endogenous variable
-  `exog` are the numerical exogenous variables in `n` dimensions
-  `trend` indicates whether a trend is included or not when calculating the parameters

returns the coefficients and statistical values calculated during the fitting process (`modelInfo`) and a projection of the fit function allowing for prediction on new data (`predict`).

More info on endogenous and exogenous variables can be found within the [timeseries](#../timeseries/models/) section of the toolkit

??? "Result dictionary"

	The information contained within `modelInfo` has three parts

	-  `coef` The coefficients calculated during the fitting process
	-  `variables` Statistical values calculated for each coefficient
	-  `statsDict` Descriptive statistics for the regression model. These include:

	key        | description
	-----------|------------
	dfTotal    | Total degrees of freedom
	dfModel    | The degrees of freedom of the model
	dfResidual | The degrees of freedom of the residuals
	sumSquares | Sum of squares between the true and predicted values
	meanSquares| Mean squares between the true and predicted values using degrees of freedom
	fStat      | F statistic
	r2         | r2 score
	r2Adj      | r2 Adjusted score
	mse        | Mean squared error
	rse        | Residual squared error
	pValue     | p Value
	logLike    | log liklihood


```q
q)exog:til 10
q)endog:3+2*til 10
q)trend:1b
q)show mdl:.ml.stats.OLS.fit[endog;exog;trend]
modelInfo| `coef`variables`statsDict!(3 2f;(+(,`name)!,`yInterce..
predict  | {[config;exog]
  modelInfo:config`modelInfo;
  trend:`yIntercept i..

// Coefficients and statistical values calculated during the
// fitting process
q)mdl.modelInfo
coef     | 3 2f
variables| (+(,`name)!,`yIntercept`x0)!+`coef`stdErr`tStat`pVal..
statsDict| `dfTotal`dfModel`dfResidual`SSTotal`SSModel`SSResidu..
q)mdl.modelInfo.variables
name      | coef stdErr       tStat        pValue C195
----------| --------------------------------------------------
yIntercept| 3    3.011588e-15 9.961524e+14 0      6.944733e-15
x0        | 2    5.64122e-16  3.545332e+15 0      1.300868e-15
q)mdl.modelInfo.statsDict
dfTotal   | 9
dfModel   | 1
dfResidual| 8
SSResidual| 2.100342e-28
MSTotal   | 36.66667
...

// Use the fitted model to predict on new data
q)newData:4 2 3 1 2 6
q)mdl.predict newData
11 7 9 5 7 15f
```


## `.ml.stats.WLS.fit`

_Train a weighted least squares model on data_

```syntax
.ml.stats.WLS.fit[endog;exog;weights;trend]
```

Where

-  `endog` is the numerical endogenous variable
-  `exog` are the exogenous variables in `n` dimensions
-  `weights` are the weights to be applied to the endog variable (must be the same length as the endog variable). If `()/(::)` is passed, the model deduces the weights by using the inverse of the residuals calculated from fitting the data on an ordinary OLS model
-  `trend` indicates whether a trend is included or not when calculating the parameters

returns the coefficients and statistical values calculated during the fitting process (`modelInfo`) and a projection of the fit function allowing for prediction on new data (`predict`)

??? "Result dictionary"

	The information in `modelInfo` has four parts

	-  `coef` The coefficients calculated during the fitting process
	-  `variables` Statistical values calculated for each coefficient
	-  `statsDict` Descriptive statistics for the regression model. These include:
	-  `weights` The weights used for fitting the model

	key        | description
	-----------|------------
	dfTotal    | Total degrees of freedom
	dfModel    | The degrees of freedom of the model
	dfResidual | The degrees of freedom of the residuals
	sumSquares | Sum of squares between the true and predicted values
	meanSquares| Mean squares between the true and predicted values using degrees of freedom
	fStat      | F statistic
	r2         | r2 score
	r2Adj      | r2 Adjusted score
	mse        | Mean squared error
	rse        | Residual squared error
	pValue     | p Value
	logLike    | log liklihood

```q
q)exog:til 10
q)endog:3+2*til 10
q)weights:10?5
q)trend:0b
q)show mdl:.ml.stats.WLS.fit[endog;exog;weights;trend]
modelInfo| `coef`variables`statsDict`weights!(,2.50289;(+(,`name)!..
predict  | {[config;exog]
  modelInfo:config`modelInfo;
  trend:`yIntercept i..
// Coefficients and statistical values calculated during the
// fitting process
q)mdl.modelInfo
coef     | ,2.50289
variables| (+(,`name)!,,`x0)!+`coef`stdErr`tStat`pValue`C195!(,2...
statsDict| `dfTotal`dfModel`dfResidual`SSTotal`SSModel`SSResidual..
weights  | 4 4 0 4 0 2 0 0 4 0
// Statistic information calculated during the fitting
q)mdl.modelInfo.variables
name| coef    stdErr    tStat    pValue      C195
----| -----------------------------------------------
x0  | 2.50289 0.1012509 24.71968 2.68138e-10 0.233485
q)mdl.modelInfo.statsDict
dfTotal   | 9
dfModel   | 1
dfResidual| 8
SSTotal   | 330f
SSModel   | ,516.8179
SSResidual| ,26.29573
MSTotal   | 36.66667
MSModel   | ,516.8179
MSResidual| ,3.286967
...

// Use the fitted model to predict on new data
q)newData:4 2 3 1 2 6
q)mdl.predict newData
10.01156 5.00578 7.508671 2.50289 5.00578 15.01734
```
