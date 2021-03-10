---
title: Models | Timeseries | Toolkit | Machine Learning | Documentation for kdb+ and q
description: The kdb+ Machine Learning Toolkit implements commonly-used statistical forecasting algorithms
author: Diane O'Donoghue
date: August 2020
---
# :fontawesome-solid-share-alt: Timeseries models


<div markdown="1" class="typewriter">
.ml.ts   **Timeseries models**

**AR**: AutoRegressive
  [AR.fit](#mltsarfit)          Fit an AR model

**ARCH**: AutoRegressive Conditional Heteroskedasticity
  [ARCH.fit](#mltsarchfit)        Fit an ARCH model

**ARMA**: AutoRegressive Moving Average
  [ARMA.fit](#mltsarmafit)        Fit an ARMA model

**ARIMA**: AutoRegressive Integrated Moving Average
  [ARIMA.aicParam](#mltsarimaaicparam) Optimal input parameters for an ARIMA model
                 based on Akaike Information Criterion score
  [ARIMA.fit](#mltsarimafit)       Fit an ARIMA model

**SARIMA**: Seasonal AutoRegressive Integrated Moving Average
  [SARIMA.fit](#mltssarimafit)      Fit a SARIMA model
</div>

:fontawesome-brands-github:
[KxSystems/ml/timeseries](https://github.com/KxSystems/ml/tree/master/timeseries)

Distinguish _endogenous_ and _exogenous_ variables.

Endogenous

: The values of the variable are determined by the model, i.e. form the basis for predicting a ‘target’ variable

Exogenous

: Any variable whose value is determined outside of the model and which may impose an effect on the endogenous variable, i.e. if there is a national holiday this may affect the endogenous variable, but is completely independent of its behavior.


## AutoRegressive (AR)

An AR model is a form of timeseries modelling where the output values of the model depend linearly on previous values in the series and a stochastic term. This model is suitable for use cases where there is a correlation between values in the past and future behavior of the system. An AR model uses $p$ historical lag values to calculate future values.

The equation for an AR model is

$$y_t= \mu  + \sum_{i=1}^{p} \phi_{i} y_{t-i}$$

where

-   $y_t$ is the value of the timeseries at time $t$
-   $y_{t-i}$ is the value of the timeseries at time $t-i$
-   $\mu$ is the trend value
-   $\phi_{i}$ is the lag parameter at time $t-i$

:fontawesome-solid-hand-point-right:
[`.ml.ts.AR.fit`](#mltsarfit)


## AutoRegressive Conditional Heteroskedasticity (ARCH)

An ARCH model is a statistical model used to describe the volatility of a timeseries. This models the variance of a point in the data series as a function of the sum the past residual errors squared. This model is appropriate to use when the error variance in the timeseries follows an AR model as described [above](#autoregressive-ar-model). ARCH models are used in timeseries data that experience time-varying volatility and as such are commonly employed in the modeling of financial timeseries exhibiting varying volatility.

The formula for an ARCH model is

$$\hat{\epsilon}_{t}^{2}=\hat{\alpha}_{0}+\sum_{i=1}^{q} \hat{\alpha}_{i} \hat{\epsilon}_{t-i}^2$$

where

-  $\hat{\epsilon}_{t}$ is the residual error term
-  $\hat{\alpha}_{0}$ is the mean term
-  $\hat{\alpha}_{i}$ is past error squared coefficient

:fontawesome-solid-hand-point-right:
[`.ml.ts.ARCH.fit`](#mltsarchfit)


## AutoRegressive Moving Average (ARMA)

An ARMA model is a timeseries model that is an extension of the [AR model](#autoregressive-ar-model). An ARMA model can be used to describe any weakly stationary stochastic timeseries in terms of two polynomials, the first of these is for autoregression based on `p` lag values, the second for the moving average based on `q` past residual errors.

The equation for the ARMA model is

$$y_t= \mu  + \sum_{i=1}^{p} \phi_{i} y_{t-i} + \sum_{i=1}^{q} \theta_{i} \epsilon_{t-i}$$

Where:

-   $y_t$ is the value of the timeseries at time $t$
-   $\mu$ is the trend value
-   $p$ is the order of lagged values to be accounted for in model generation
-   $q$ is the order of residual errors to be accounted for in model generation
-   $y_{t-i}$ is the value of the timeseries at time $t-i$
-   $\phi_{i}$ is the lag parameter at time $t-i$
-   $\epsilon_{t-i}$ is the residual error term at time $t-i$
-   $\theta_{i}$ is the residual error parameter at time $t-i$

:fontawesome-solid-hand-point-right:
[`.ml.ts.ARMA.fit`](#mltsarmafit)


## AutoRegressive Integrated Moving Average (ARIMA) 

An ARIMA model is an extension of the [ARMA model](#autoregressive-moving-average-arma-model). As with the ARMA model, this takes into account lagged values and past residual errors when generating the model and predictions. The integrated aspect of the model is the result of differencing the timeseries `d` times in order to generate a ‘stationary’ timeseries.

Once differenced and stationary, an ARMA model can be generated and applied to forecast future values.

Any timeseries which has non-seasonal components (daily/annual cycles) can be modelled using this method.

The equation for an ARIMA model is

$$\hat{y}_{t}= \mu  + \sum_{i=1}^{p} \phi_{i} y_{t-i} + \sum_{i=1}^{q} \theta_{i} \epsilon_{t-i}$$

Where:

-   $\hat{y}_{t}$ is the differenced timeseries at time $t$
-   $\mu$ is the trend value
-   $p$ is the order of lagged values to be accounted for in model generation
-   $q$ is the order of residual errors to be accounted for in model generation
-   $y_{t-i}$ is the value of the timeseries at time $t-i$
-   $\phi_{i}$ is the lag parameter at time $t-i$
-   $\epsilon_{t-i}$ is the residual error term at time $t-i$
-   $\theta_{i}$ is the residual error parameter at time $t-i$


Stationary timeseries

: A timeseries is _stationary_ if its statistical properties such as mean, variance and autocorrelation do not change over time. A timeseries with trends or seasonality are not stationary.

: Differencing can be applied to a non-stationary timeseries in order to make it stationary. This involves computing the difference between consecutive observations in the timeseries a number of times.

: [`stationarity`](misc.md#mltsstationarity) is a function to test if a timeseries or set of timeseries are stationary.


Akaike Information Criterion

: The Akaike Information Criterion (AIC) is an estimator of in-sample prediction error. It is often used as a means of model selection. Given a collection of models for a dataset, AIC estimates the quality of each model relative to each of the other models and chooses that which minimizes the AIC score.

: In cases where the out-of-sample prediction error is expected to differ from in-sample prediction error it is better to use [cross-validation](../xval.md).

: The equation for calculation of the AIC score for a large sample size is given by:

    $$AIC = 2(k - \hat{L})$$

: where

    -   `k` is the number of estimated parameters for the model.
    -   $\hat{L}$ is the maximum value of the likelihood function for the model being fitted.

:fontawesome-solid-hand-point-right:
[`.ml.ts.ARIMA.AicParam`](#mltsarimaaicparam)
<br>
:fontawesome-solid-hand-point-right:
[`.ml.ts.ARIMA.fit`](#mltsarimafit)



## Seasonal AutoRegressive Integrated Moving Average (SARIMA)

A SARIMA model is an extension of the [ARIMA model](#autoregressive-integrated-moving-average-arima-model). As noted previously, ARIMA models cannot be used in cases where there is cyclical variability in the behavior of the timeseries.

Examples of cyclic variability in a timeseries:

-   Sales in many retail stores have yearly cycles with increases in demand around the holidays and during annual sales.
-   The use of electricity in a household has both a yearly and daily cycle with more use during the evening than at night and similarly more use in winter than summer.
-   Weather patterns also contain daily and yearly cycles with temperature changing from day to night and winter to summer

Similar to the ARIMA model which accounts for historical lag components $p$, residual errors $q$ and a set of timeseries differencing $d$, the seasonal component of a SARIMA model has equivalent components.

-   $P$ is the autoregressive lag term of the seasonal component of the model
-   $Q$ is the residual moving average term of the seasonal component model
-   $D$ is the seasonal differencing term of the model

SARIMA models are usually denoted by the following definition

$$ARIMA(p,d,q)(P,D,Q)_{m}$$

where the upper-case components are as defined above, and $m$ refers to the number of periods in each season.

:fontawesome-solid-globe:
[Outline of SARIMA model generation and use](https://www.statsmodels.org/dev/examples/notebooks/generated/statespace_sarimax_stata.html#ARIMA-Example-3:-Airline-Model "www.statsmodels.org")
<br>
:fontawesome-solid-hand-point-right:
[`.ml.ts.SARIMA.fit`](#mltssarimafit)



---


## `.ml.ts.AR.fit`

_Fit an AR forecasting model based on a timeseries dataset_

```syntax
.ml.ts.AR.fit[endog;exog;p;trend]
```

Where

-   `endog` is an endogenous variable as a list (timeseries)
-   `exog`  is a table of exogenous variables; if `(::)/()`, then exogenous variables ignored
-   `p` is the number of lag values to include (integer)
-   `trend` whether a trend is to be accounted for (boolean)

returns a dictionary containing all information collected during the fitting of a model (`modelInfo`), along with a prediction function which forecasts future values of the timeseries (`predict`)

??? "Result dictionary"

	The information collected during the fitting of the model is contained within `modelInfo` and includes:

	-   `coefficients` – model coefficients for future predictions
	-   `trendCoeff`   – trend coefficient
	-   `exogCoeff`    – exog coefficients
	-   `pCoeff`       – p value coefficients
	-   `lagVals`      – lagged values from the training set

	The predict functionality is contained within the `predict` key. The function takes arguments

	-   `exog` is a table of exogenous variables; if `(::)/()` then exogenous variables ignored
	-   `len` is the number of values that are to be predicted (integer)

	and returns the predicted values.

```q
// Example timeseries
q)timeSeries:100?10f

// Fit an AR model with no exogenous variables
q)show AR:.ml.ts.AR.fit[timeSeries;();3;1b]
modelInfo| `coefficients`trendCoeff`exogCoeff`pCoeff`lagVals!(4.616603 0.0877..
predict  | {[config;exog;len]
  model:config`modelInfo;
  exog:ts.i.predDataC..

// Information generated during the fitting of the model
q)AR.modelInfo
coefficients| 4.616603 0.08776223 0.1120281 -0.07892314
trendCoeff  | ,4.616603
exogCoeff   | `float$()
pCoeff      | 0.08776223 0.1120281 -0.07892314
lagVals     | 0.4152188 3.116593 2.462135

// Predict future values
q)AR.predict[();10]
4.80787 4.786498 4.993537 5.180669 5.187219 5.225836 5.239945 5.243733 5.2484..

// Fit the same model with exogenous variables included
q)exogVar:([]100?10f;100?1f)
q)AR2:.ml.ts.AR.fit[timeSeries;exogVar;3;1b]
q)AR2.modelInfo
coefficients| 4.127569 0.04545573 0.410656 0.09425878 0.1140073 -0.07340124
trendCoeff  | ,4.127569
exogCoeff   | 0.04545573 0.410656
pCoeff      | 0.09425878 0.1140073 -0.07340124
lagVals     | 0.4152188 3.116593 2.462135
// Predict future values
q)exogFuture:([]10?10f;10?1f)
q)AR2.predict[exogFuture;10]
4.72082 4.762922 4.98347 5.351918 5.158981 5.411464 5.365992 5.300226 5.58571..
```


## `.ml.ts.ARCH.fit`

_Fit an ARCH model based on a set of residual errors from a fitted AR model_

```syntax
.ml.ts.ARCH.fit[residuals;p]
```

Where

-   `residuals` is the residual errors obtained from the results of a fitted AR model
-   `p` the number of previous error terms to include

returns a dictionary containing all information collected during the fitting of a model (`modelInfo`), along with a prediction function which forecasts future values of the timeseries (`predict`)

??? "Result dictionary"

	The information collected during the fitting of the model is contained within `modelInfo` and includes:

	-   `params`       – Model coefficients for future predictions
	-   `trendCoeff`   – Trend coefficient
	-   `exogCoeff`    – Exog coefficients
	-   `pCoeff`       – Lag value coefficients
	-   `residualVals` – Lagged residual errors from the input training set

	The predict functionality is contained within the `predict` key. The function takes as argument the number of values that are to be predicted (integer) and	returns the predicted values.

```q
q)residuals:100?10f

// Fit an ARCH model
q)show ARCH:.ml.ts.ARCH.fit[residuals;2]
modelInfo| `coefficients`trendCoeff`pCoeff`residualVals!(31.3159 0.2171911 -0..
predict  | {[config;len]
  model:config`modelInfo;
  last{x>count y 1}[len;]t.

// Information generated during the fitting of the model
q)ARCH.modelInfo
coefficients| 31.3159 0.2171911 -0.04818814
trendCoeff  | 31.3159
pCoeff      | 0.2171911 -0.04818814
residualVals| 1.07191 84.82992

// Predict the next 10 values
q)ARCH.predict[10]
27.46092 48.41692 34.94705 40.14759 36.97145 38.25402 37.50239 37.81717 37.63.
```


## `.ml.ts.ARIMA.aicParam`

_Use AIC score to determine the optimal model parameters for an ARIMA model_

```syntax
.ml.ts.ARIMA.aicParam[train;test;len;dict]
```

Where

-   `train` is a training-data dictionary with keys ``` `endog`exog ```
-   `test` is a testing data dictionary with keys ``` `endog`exog ```
-   `len` is the number of values that are to be predicted (integer)
-   `dict` is a dictionary of different input parameters to score

returns a dictionary indicating the optimal input model parameters to use for an ARIMA model along with the associated AIC score.

```q
// Generate data for AIC parameter example
q)timeSeriesTrain:100?10f
q)timeSeriesTest:10?10f
q)exogTrain:([]100?10f;100?1f)
q)exogTest:([]10?10f;10?1f)
q)trainDict:`endog`exog!(timeSeriesTrain;exogTrain)
q)testDict:`endog`exog!(timeSeriesTest;exogTest)
q)show param:`p`d`q`trend!(5 2 3 4;1 0 1 0;0 1 2 1;1011b)
p    | 5 2 3 4
d    | 1 0 1 0
q    | 0 1 2 1
trend| 1 0 1 1

// Optimize an ARIMA model based on AIC score
q).ml.ts.ARIMA.aicParam[trainDict;testDict;10;param]
p    | 2
d    | 0
q    | 1
trend| 0b
score| 30.69017
```


## `.ml.ts.ARIMA.fit`

_Fit an ARIMA forecasting model based on a timeseries dataset_

```syntax
.ml.ts.ARIMA.fit[endog;exog;p;d;q;trend]
```

Where

-   `endog` is an endogenous variable as a list (time-series)
-   `exog`  is a table of exogenous variables; if `(::)/()` then exogenous variables ignored
-   `p` is the number of lag values to include (integer)
-   `d` is the order of differencing being used (integer)
-   `q` is the number of residual errors to include (integer)
-   `trend` is whether a trend is to be accounted for (boolean)

returns a dictionary containing all information collected during the fitting of a model (`modelInfo`), along with a prediction function which forecasts future values of the timeseries (`predict`)

??? "Result dictionary"

	The information collected during the fitting of the model are contained within `modelInfo` and include:

	-   `coefficients`   – model coefficients for future predictions
	-   `trendCoeff`     – trend coefficient
	-   `exogCoeff`      – exog coefficients
	-   `pCoeff`         – lag value coefficients
	-   `qCoeff`         – error coefficients
	-   `lagVals`        – lagged values from the training set
	-   `residualVals`   – q residual errors calculated from training set using the params
	-   `residualCoeffs` – coefficients used to estimate resid errors
	-   `paramDict`      – a dictionary containing information about the model used for fitting
	-   `originalData`   – original values to use to transform seasonal differencing to original format

	The predict functionality is contained within the `predict` key. The function takes the following inputs:

	-   `exog` is a table of exogenous variables; if `(::)/()` then exogenous variables ignored
	-   `len` is the number of values that are to be predicted (integer)

	returns the predicted values

!!! tip "In general, differencing (`d`) of order 2 or less suffices to make a timeseries stationary for an ARIMA model."

```q
q)timeSeries:100?10f
q)exogVar:([]100?10f;100?1f)
// Fit an ARIMA model with exogenous variables
q)show ARIMA:.ml.ts.ARIMA.fit[timeSeries;exogVar;3;1;2;1b]
modelInfo| `coefficients`trendCoeff`exogCoeff`pCoeff`qCoeff`lagVals`residualV..
predict  | {[config;exog;len]
  model:config`modelInfo;
  exog:ts.i.predDataC..

// Information generated during the fitting of the model
q)ARIMA.modelInfo
coefficients  | 0.1485258 0.075183 -1.206104 -0.189641 -0.3472614 -1.104851 -..
trendCoeff    | 0.1485258
exogCoeff     | 0.075183 -1.206104
pCoeff        | -0.189641 -0.3472614 -1.104851
qCoeff        | -0.8177743 0.162941
lagVals       | -1.531503 -7.035447 8.547459 -6.495689
residualVals  | 3.255786 -4.816692
residualCoeffs| 0.06627617 -0.5449133 -0.3366783 -0.562082 -0.8961783 -0.916927
paramDict     | `p`q`trend!(3;2;1b)
originalData  | ,2.131446

// Predict future values
q)exogFuture:([]10?10f;10?1f)
q)ARIMA.predict[exogFuture;10]
3.494618 6.035612 5.217942 5.31959 3.234357 5.971898 4.3844 3.928326 4.986652..
```


## `.ml.ts.ARMA.fit`

_Fit an ARMA forecasting model based on a timeseries dataset_

```syntax
.ml.ts.ARMA.fit[endog;exog;p;q;trend]
```

Where

-   `endog` is an endogenous variable as a list (time-series)
-   `exog` is a table of exogenous variables; if `(::)/()` then exogenous variables ignored
-   `p` is the number of lag values to include (integer)
-   `q` is the number of residual errors to include (integer)
-   `trend` is whether a trend is to be accounted for (boolean)

returns a dictionary containing all information collected during the fitting of a model, along with a prediction function which forecasts future values of the timeseries

??? "Result dictionary"

	The information collected during the fitting of the model are contained within `modelInfo` and include:

	-   `coefficients`   – model coefficients for future predictions
	-   `trendCoeff`     – trend coefficient
	-   `exogCoeff`      – exog coefficients
	-   `pCoeff`         – p value coefficients
	-   `qCoeff`         – q coefficients
	-   `lagVals`        – lagged values from the training set
	-   `residualVals`   – q residual errors calculated from training set using the params
	-   `residualCoeffs` – coefficients used to estimate resid errors
	-   `paramDict`      – a dictionary containing information about the model used for fitting

	The predict functionality is contained within the `predict` key. The function takes arguments

	-   `exog` is a table of exogenous variables; if `(::)/()` then exogenous variables ignored
	-   `len` is the number of values that are to be predicted (integer)

	and returns the predicted values.

```q
q)timeSeries:100?10f
q)exogVar:([]100?10f;100?1f)

// Fit an ARMA model with exogenous variables
q)show ARMA:.ml.ts.ARMA.fit[timeSeries;exogVar;2;1;0b]
modelInfo| `coefficients`trendCoeff`exogCoeff`pCoeff`qCoeff`lagVals`residualV..
predict  | {[config;exog;len]
  model:config`modelInfo;
  exog:ts.i.predDataC..

// Information generated during the fitting of the model
q)ARMA.modelInfo
coefficients  | 0.286072 1.322973 -0.1041432 0.705307 -0.6556155
trendCoeff    | 0n
exogCoeff     | 0.286072 1.322973
pCoeff        | -0.1041432 0.705307
qCoeff        | ,-0.6556155
lagVals       | 0.07967671 8.627135 2.131446
residualVals  | ,-3.674183
residualCoeffs| 0.2709317 1.72078 0.3283672 0.02866974 0.1678889
paramDict     | `p`q`trend!(2;1;0b)

// predict future values
q)exogFuture:([]10?10f;10?1f)
q)ARMA.predict[exogFuture;10]
3.729849 2.502793 3.398665 2.361183 4.059667 5.87973 6.046338 5.750572 4.3776..
```


## `.ml.ts.SARIMA.fit`

_Fit an SARIMA forecasting model based on a timeseries dataset_

```syntax
.ml.ts.SARIMA.fit[endog;exog;p;d;q;trend;season]
```

Where

-  `endog` is an endogenous variable as a list (time-series)
-  `exog` is a table of exogenous variables; if `(::)/()` then exogenous variables ignored
-  `p` is the number of lag values to include (integer)
-  `d` is the order of differencing being used (integer)
-  `q` is the number of residual errors to include (integer)
-  `trend` is whether a trend is to be accounted for (boolean)
-  `season` is a dictionary of seasonal `P`,`D`,`Q` and `m` (periodicity) components

returns a dictionary containing all information collected during the fitting of a model (`modelInfo`), along with a prediction function which forecasts future values of the timeseries (`predict`)

??? "Result dictionary"

	The information collected during the fitting of the model are contained within `modelInfo` and include:

	-   `coefficients`   –  model coefficients for future predictions
	-   `trendCoeff`     –  trend coefficient
	-   `exogCoeff`      –  exog coefficients
	-   `pCoeff`         –  lag value coefficients
	-   `qCoeff`         –  error coefficients
	-   `PCoeff`         –  seasonal lag value coefficients
	-   `QCoeff`         –  leasonal error coefficients
	-   `lagVals`        –  lagged values from the training set
	-   `residualVals`   –  q residual errors calculated from training set using the params
	-   `residualCoeffs` –  coefficients used to estimate resid errors
	-   `paramDict`      –  a dictionary containing information about the model used for fitting
	-   `originalData`   –  original values of input values before being differenciated
	-   `seasonData`     –  original values to transform seasonal differencing to original format

	The predict functionality is contained within the `predict` key. The function takes arguments

	-   `exog` is a table of exogenous variables; if `(::)/()` then exogenous variables ignored
	-   `len` is the number of values that are to be predicted (integer)

	and returns the predicted values.

!!! warning "Consistency across platforms"

    When applying optimization algorithms in kdb+, subtracting small values from large to generate deltas to find the optimization direction may result in inconsistent results across operating systems.

    This is due to potential floating-point precision differences at the machine level and issues with subtractions of floating point numbers more generally. These issues may be seen in the application of `.ml.ts.SARIMA` and `.ml.optimize.BFGS`.

    :fontawesome-solid-book-open:
    [Precision](../../../basics/precision.md)

```q
q)timeSeries:100?10f
q)exogVar:([]100?10f;100?1f)
// Create seasonality dictionary
q)show s:`P`D`Q`m!2 0 1 10
P| 2
D| 0
Q| 1
m| 10

// Fit an AR model with no exogenous variables
q)show SARIMA:.ml.ts.SARIMA.fit[timeSeries;();3;0;1;1b;s]
modelInfo| `coefficients`trendCoeff`exogCoeff`pCoeff`qCoeff`PCoeff`QCoeff`lag..
predict  | {[config;exog;len]
  model:config`modelInfo;
  exog:ts.i.predDataC..

// Information generated during the fitting of the model
q)SARIMA.modelInfo
coefficients  | 4.212234 0.2628173 0.1408391 1.310094 -1.351546 0.03222874 -0..
trendCoeff    | 4.212234
exogCoeff     | `float$()
pCoeff        | 0.2628173 0.1408391 1.310094
qCoeff        | ,-1.351546
PCoeff        | 0.03222874 -0.006481851
QCoeff        | ,-0.03222874
lagVals       | 0.8245929 9.587189 5.86037 4.488619 9.601101 1.260167 8.97347..
residualVals  | 4.08279 7.257717 8.672206 4.347054 3.928405 5.131788 9.05584 ..
residualCoeffs| 0.03547007 0.08178069 -0.1331158 -0.09555646
paramDict     | `p`q`P`Q`m`trend`additionalP`additionalQ`n!(3;1;0 10;,0;10;1b..
originalData  | `float$()
seasonData    | `float$()

// Predict future values
q)SARIMA.predict[();10]
4.733785 4.983382 6.129106 5.221778 5.005791 4.453757 5.75788 6.872739 3.5223..
```
