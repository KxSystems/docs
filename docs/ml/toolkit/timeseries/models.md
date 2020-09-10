---
title: Time Series ARIMA models | Time Series | Machine Learning Toolkit | Documentation for kdb+ and q
author: Diane O'Donoghue
date: August 2020
keywords: machine learning, ml, time series, ar, arima, sarima, aic
---

# :fontawesome-solid-share-alt: Time Series Models

<pre markdown="1" class="language-txt">
.ml.ts   **Time series models**

AR Model
  [AR.fit](#mltsarfit)         Fit an AutoRegressive model
  [AR.predict](#mltsarpredict)     Predict future values using a fitted AutoRegressive model

ARCH Model
  [ARCH.fit](#mltsarchfit)       Fit an AutoRegressive Conditional Heteroskedasticity model
  [ARCH.predict](#mltsarchpredict)   Predict future volatility values using a fitted AutoRegressive Conditional Heteroskedasticity model

ARMA Model
  [ARMA.fit](#mltsarmafit)       Fit an AutoRegressive Moving Average model
  [ARMA.predict](#mltsarmapredict)   Predict future values using a fitted AutoRegressive Moving Average model  

ARIMA Model
  [ARIMA.aicParam](#mltsarimaaicparam) Determine optimal input parameters for ARIMA model based on Akaike Information Criterion score
  [ARIMA.fit](#mltsarimafit)      Fit an AutoRegressive Integrated Moving Average model
  [ARIMA.predict](#mltsarimapredict)  Predict future values using a fitted AutoRegressive Integrated Moving Average model

SARIMA Model
  [SARIMA.fit](#mltssarimafit)     Fit a Seasonal AutoRegressive Integrated Moving Average model
  [SARIMA.predict](#mltssarimapredict) Predict future values using a fitted Seasonal AutoRegressive Integrated Moving Average model
</pre>

<i class="fab fa-github"></i>
[KxSystems/ml/timeseries](https://github.com/KxSystems/ml/tree/master/timeseries)


## AutoRegressive (AR) model

An AR model is a form of time series modelling where the output values of the model depend linearly on previous values in the series and a stochastic term. This model is suitable for use cases where there is a correlation between values in the past and future behaviour of the system. An AR model uses `p` historical lag values to calculate future values.

The equation for an AR model is given by:

$$y_t= \mu  + \sum_{i=1}^{p} \phi_{i} y_{t-i}$$

Where:

  - $y_t$ is the value of the time series at time t
  - $y_{t-i}$ is the value of the time series at time t-i
  - $\mu$ is the trend value
  - $\phi_{i}$ is the lag parameter at time t-i


### `.ml.ts.AR.fit`

_Fit an AR forecasting model based on a provided time series dataset_

Syntax:`.ml.ts.AR.fit[endog;exog;p;tr]`

Where:

-  `endog` endogenous variable as a list (time-series)
-  `exog`  table of exogenous variables, if (::)/() then exogenous variables ignored
-  `p`     number of lag values to include
-  `tr`   is a trend to be accounted for?

returns a dictionary containing the model parameters and data required for the forecasting of future values. This dictionary contains the following information

key        |  Explanation
-----------|---------------------------
params     | model paramaters for future predictions
tr_param   | trend paramaters
exog_param | exog paramaters
p_param    | lag value paramaters
lags       | lagged values from the training set

```q
// Example time series
q)timeSeries:100?10f

// Fit an AR model with no exogenous variables
q).ml.ts.AR.fit[timeSeries;();3;1b]
params    | 4.936532 0.03997196 0.03751383 0.005364343
tr_param  | ,4.936532
exog_param| `float$()
p_param   | 0.03997196 0.03751383 0.005364343
lags      | 0.8175513 2.401967 5.784208

// Fit the same model with exogenous variables included
q)exogVar:([]100?10f;100?1f)
q).ml.ts.AR.fit[timeSeries;exogVar;3;1b]
params    | 5.994866 -0.2057255 -1.904434 0.06913882 0.04123651 -0.01732191
tr_param  | ,5.994866
exog_param| -0.2057255 -1.904434
p_param   | 0.06913882 0.04123651 -0.01732191
lags      | 0.8175513 2.401967 5.784208
```


### `.ml.ts.AR.predict`

_Predict future values of a time series using a fitted AR model_

Syntax:`.ml.ts.AR.predict[mdl;exog;len]`

Where

-  `mdl` dictionary returned from a fitted AR model
-  `exog`  table of exogenous variables, if (::)/() then exogenous variables ignored
-  `len` number of values that are to be predicted

returns the future predicted values

!!! Note
        Future `exog` variables should be in the same format as the `exog` variables used when fitting the model, and also must have the same length as the number of values to be predicted (`len`)

```q
// Generate an AR model
q)timeSeries:100?10f
q)exogVar:([]100?10f;100?1f)
q)show ARmdl:.ml.ts.AR.fit[timeSeries;exogVar;3;1b]
params    | 5.994866 -0.2057255 -1.904434 0.06913882 0.04123651 -0.01732191
tr_param  | ,5.994866
exog_param| -0.2057255 -1.904434
p_param   | 0.06913882 0.04123651 -0.01732191
lags      | 0.8175513 2.401967 5.784208

// Use the fit model and set of exogenous variables to make predictions
q)exogFuture:([]10?10f;10?1f)
q).ml.ts.AR.predict[ARmdl;exogFuture;10]
3.822056 3.727468 4.99475 3.499939 3.844594 4.326576 5.916375 4.12185 3.85929
```

## AutoRegressive Conditional Heteroskedasticity (ARCH) model

An ARCH model is a statistical model used to describe the volatility of a time series. This models the variance of a point in the data series as a function of the sum the past residual errors squared. This model is appropriate to use when the error variance in the time series follows an AR model as described [above](#autoregressive-ar-model). ARCH models are used in time series data that experience time-varying volatility and as such are commonly employed in the modeling of financial time series exhibiting varying volatility.

The formula for an ARCH model is given by:

$$\hat{\epsilon}_{t}^{2}=\hat{\alpha}_{0}+\sum_{i=1}^{q} \hat{\alpha}_{i} \hat{\epsilon}_{t-i}^2$$

Where:

-  $\hat{\epsilon}_{t}$ is the residual error term
-  $\hat{\alpha}_{0}$ is the mean term
-  $\hat{\alpha}_{i}$ is past error squared coefficient

### `.ml.ts.ARCH.fit`

_Fit an ARCH model based on a provided set of residual errors retrieved from a fitted AR model_

Syntax: `.ml.ts.ARCH.fit[resid;lags]`

Where

-  `resid` is the residual errors obtained from the results of a fitted AR model
-  `lags` the number of previous error terms to include

returns a dictionary containing the model parameters and data to be used for the forecasting of future volatility

key        |  Explanation
-----------|---------------------------
params     | model paramaters for future predictions
tr_param   | trend paramaters
exog_param | exog paramaters
p_param    | lag value paramaters
resid      | lagged residual errors from the input training set

```q
q)residuals:100?10f
q).ml.ts.ARCH.fit[residuals;2]
params  | 30.55546 0.05927539 0.0799694
tr_param| 30.55546
p_param | 0.05927539 0.0799694
resid   | 9.187684 39.17214
```

### `.ml.ts.ARCH.predict`

_Predict the future volatility of a time series using a fitted ARCH model_

Syntax:`.ml.ts.ARCH.pred[mdl;len]`

Where

-  `mdl` is a dictionary returned from a fitting an ARCH model
-  `len` number of future volatility values to be predicted

```q
// Generate an ARCH model for use in prediction
q)residuals:100?10f
q)show ARCHmdl:.ml.ts.ARCH.fit[residuals;1]
params  | 37.38337 -0.07879272
tr_param| 37.38337
p_param | ,-0.07879272
resid   | ,26.18578

// Predict volatility based on a fitted model
q).ml.ts.ARCH.predict[ARCHmdl;10]
35.32012 34.6004 34.65711 34.65264 34.65299 34.65296 34.65296 34.65296 34.652.
```

## AutoRegressive Moving Average (ARMA) model

An ARMA model is a time series model which is an extension of the AR model described [above](#autoregressive-ar-model). An ARMA model can be used to describe any weakly stationary stochastic time series in terms of two polynomials, the first of these is for autoregression based on `p` lag values, the second for the moving average based on `q` past residual errors.

The equation for the ARMA model is given by:

$$y_t= \mu  + \sum_{i=1}^{p} \phi_{i} y_{t-i} + \sum_{i=1}^{q} \theta_{i} \epsilon_{t-i}$$

Where:

  - $y_t$ is the value of the time series at time t
  - $\mu$ is the trend value
  - $p$ is the order of lagged values to be accounted for in model generation
  - $q$ is the order of residual errors to be accounted for in model generation
  - $y_{t-i}$ is the value of the time series at time t-i
  - $\phi_{i}$ is the lag parameter at time t-i
  - $\epsilon_{t-i}$ is the residual error term at time t-i
  - $\theta_{i}$ is the residual error parameter at time t-i 


### `.ml.ts.ARMA.fit`

_Fit an ARMA forecasting model based on a provided time series dataset_

Syntax:`.ml.ts.ARMA.fit[endog;exog;p;q;tr]`

Where

-  `endog` endogenous variable as a list (time-series)
-  `exog`  table of exogenous variables, if (::)/() then exogenous variables ignored
-  `p`     number of lag values to include
-  `q`     number of residual errors to include
-  `tr`   is a trend to be accounted for?

returns a dictionary containing the model parameters and data to be used for the forecasting of future values. This dictionary contains the following information

key        |  Explanation
-----------|---------------------------
params     | model paramaters for future predictions
tr_param   | trend paramaters
exog_param | exog paramaters
p_param    | lag value paramaters
q_param    | error paramaters
lags       | lagged values from the training set
resid      | q residual errors calculated from training set using the params
estresid   | coefficients used to estimate resid errors
pred_dict  | a dictionary containing information about the model used for fitting

```q
q)timeSeries:100?10f
q)exogVar:([]100?10f;100?1f)
q).ml.ts.ARMA.fit[timeSeries;exogVar;2;1;0b]
params    | 0.3357414 0.3990257 0.09559668 0.8129534 -0.5975123
tr_param  | 0n
exog_param| 0.3357414 0.3990257
p_param   | 0.09559668 0.8129534
q_param   | ,-0.5975123
lags      | 0.8175513 2.401967 5.784208
resid     | ,2.761882
estresid  | 0.2177284 0.9401804 0.2752396 0.2903253 0.2554238
pred_dict | `p`q`tr!(2;1;0b)
```


### `.ml.ts.ARMA.predict`

_Predict future values of a time series using a fitted ARMA model_

Syntax:`.ml.ts.ARMA.predict[mdl;exog;len]`

Where

-  `mdl` dictionary returned from a fitted ARMA model
-  `exog`  table of exogenous variables, if (::)/() then exogenous variables ignored
-  `len` number of values that are to be predicted

returns the future predicted values

```q
// Generate an ARMA model 
q)timeSeries:100?10f
q)show ARMAmdl:.ml.ts.ARMA.fit[timeSeries;();2;1;0b]
params    | 0.2363127 5.656993 -5.419003
tr_param  | 0n
exog_param| `float$()
p_param   | 0.2363127 5.656993
q_param   | ,-5.419003
lags      | 0.8175513 2.401967 5.784208
resid     | ,5.49667
estresid  | 0.03874406 0.03694788 0.008526308
pred_dict | `p`q`tr!(2;1;0b)

// Use the fit model to make future predictions
q).ml.ts.ARMA.predict[ARMAmdl;();10]
3.502366 3.120234 3.394482 3.605035 3.17703 3.109334 3.072042 3.002552 2.8720...
```


## AutoRegressive Integrated Moving Average (ARIMA) model

**ARIMA model**

An ARIMA model is an extension of the ARMA model described [above](#autoregressive-moving-average-arma-model). As with the ARMA model, this takes into account lagged values and past residual errors when generating the model and predictions. The integrated aspect of the model is the result of differencing the time series `d` times in order to generate a 'stationary' time series. Once differenced and stationary, an ARMA model can be generated and applied to forecast future values. Any time series which has non seasonal components (daily/annual cycles) can be modelled using this method.

The equation for an ARIMA model is given by

$$\hat{y}_{t}= \mu  + \sum_{i=1}^{p} \phi_{i} y_{t-i} + \sum_{i=1}^{q} \theta_{i} \epsilon_{t-i}$$

Where:

  - $\hat{y}_{t}$ is the differenced time series at time t
  - $\mu$ is the trend value
  - $p$ is the order of lagged values to be accounted for in model generation
  - $q$ is the order of residual errors to be accounted for in model generation
  - $y_{t-i}$ is the value of the time series at time t-i
  - $\phi_{i}$ is the lag parameter at time t-i
  - $\epsilon_{t-i}$ is the residual error term at time t-i
  - $\theta_{i}$ is the residual error parameter at time t-i


**Stationary Time Series**

A time series is described as stationary if its statistical properties such as mean, variance and autocorrelation do not change over time. A time series with trends or seasonality are not stationary. Differencing can be applied to a non stationary time series in order to make it stationary. This involves computing the difference between consecutive observations in the time series a number of times. A function to test if a time series or set of time series are stationary is provided [here](misc.md)

**Akaike Information Criterion**

The Akaike Information Criterion (AIC) is an estimator of in-sample prediction error. It is often used as a means of model selection. Given a collection of models for a dataset, AIC estimates the quality of each model relative to each of the other models and chooses that which minimizes the AIC score. In cases where the out-of-sample prediction error is expected to differ from in-sample prediction error it is better to use [cross-validation](../xval.md).

The equation for calculation of the AIC score for a large sample size is given by:

$$AIC = 2(k - \hat{L})$$

Where:

  - `k` is the number of estimated parameters for the model.
  - $\hat{L}$ is the maximum value of the likelihood function for the model being fitted.

### `.ml.ts.ARIMA.aicParam`

_Use AIC score to determine the optimal model parameters for an ARIMA model_

Syntax:`.ml.ts.ARIMA.aicParam[train;test;len;dict]`

Where

-  `train` training data dictionary with keys ``` `endog`exog ```
-  `test` testing data dictionary with keys ``` `endog`exog ```
-  `len` the number of values that are to be predicted
-  `dict` dictionary of different input parameters to score

returns a dictionary indicating the optimal input model parameters to use for an ARIMA model along with the associated AIC score

```q

// Generate data for AIC parameter example
q)timeSeriesTrain:100?10f
q)timeSeriesTest:10?10f
q)exogTrain:([]100?10f;100?1f)
q)exogTest:([]10?10f;10?1f)
q)trainDict:`endog`exog!(timeSeriesTrain;exogTrain)
q)testDict:`endog`exog!(timeSeriesTest;exogTest)
q)show param:`p`d`q`tr!(5 2 3 4;1 0 1 0;0 1 2 1;1011b)
p | 5 2 3 4
d | 1 0 1 0
q | 0 1 2 1
tr| 1 0 1 1

// Optimize an ARIMA model based on AIC score
q).ml.ts.ARIMA.aicParam[trainDict;testDict;10;param]
p    | 2
d    | 0
q    | 1
tr   | 0b
score| 30.69017
```

### `.ml.ts.ARIMA.fit`

_Fit an ARIMA forecasting model based on a provided time series dataset_

Syntax:`.ml.ts.ARIMA.fit[endog;exog;p;d;q;tr]`

Where

-  `endog` endogenous variable as a list (time-series)
-  `exog`  table of exogenous variables, if (::)/() then exogenous variables ignored
-  `p`     number of lag values to include
-  `d`     order of differencing being used
-  `q`     number of residual errors to include
-  `tr`   is a trend to be accounted for?

returns a dictionary containing the model parameters and data required for the forecasting of future values. This dictionary contains the following information

key         |  Explanation
------------|---------------------------
params      | model paramaters for future predictions
tr_param    | trend paramaters
exog_param  | exog paramaters
p_param     | lag value paramaters
q_param     | error paramaters
lags        | lagged values from the training set
resid       | q residual errors calculated from training set using the params
estresid    | coefficients used to estimate resid errors
origs       | original values to be used to transform seasonal differencing to original format
pred_dict   | a dictionary containing information about the model used for fitting

!!! Note
	In general, differencing (`d`) of order 2 or less is generally sufficient to make a time series stationary for an ARIMA model.

```q
q)timeSeries:100?10f
q)exogVar:([]100?10f;100?1f)
q).ml.ts.ARIMA.fit[timeSeries;exogVar;3;1;2;1b]
params    | 1.384112 -0.4446267 -1.691142 0.3371663 0.4316854 0.001379319 -0...
tr_param  | 1.384112
exog_param| -0.4446267 -1.691142
p_param   | 0.3371663 0.4316854 0.001379319
q_param   | -0.433886 -0.893045
lags      | -1.977541 -5.295681 1.584416 3.382242
resid     | -3.129498 2.357047
estresid  | 0.02338816 -0.3251655 -0.2532815 -0.3050295 -0.5411733 -0.7709497
pred_dict | `p`q`tr!(3;2;1b)
origd     | ,5.784208
```

### `.ml.ts.ARIMA.predict`

_Predict future values of a time series using a fitted ARIMA model_

Syntax:`.ml.ts.ARIMA.predict[mdl;exog;len]`

Where

-  `mdl` dictionary returned from fitting an ARIMA model
-  `exog`  table of exogenous variables, if (::)/() then exogenous variables ignored
-  `len` number of values that are to be predicted

returns the future predicted values

```q
// Generate an ARIMA model
q)timeSeries:100?10f
q)exogVar:([]100?1f;100?1f)
q)show ARIMAmdl:.ml.ts.ARIMA.fit[timeSeries;exogVar;2;1;0;1b]
params    | 0.1901339 0.05783913 -1.025339 -0.3470224 -0.6955525
tr_param  | ,0.1901339
exog_param| 0.05783913 -1.025339
p_param   | -0.3470224 -0.6955525
lags      | 1.584416 3.382242
q_param   | ()
resid     | ()
origd     | ,5.784208

// Use the fit model and set of exogenous variables to make predictions
q)exogFuture:([]10?1f;10?1f)
q).ml.ts.ARIMA.predict[ARIMAmdl;exogFuture;10]
2.540794 3.437806 4.324895 2.921683 3.768364 2.919457 3.347546 3.741517 3.715..
```

## Seasonal AutoRegressive Integrated Moving Average (SARIMA)

A SARIMA model is an extension of the ARIMA model described [above](#autoregressive-integrated-moving-average-arima-model). As noted previously, ARIMA models cannot be used in cases where there is cyclical variability in the behaviour of the time series. Examples of cyclic variability in a time series are as follows:

1. Sales in many retail stores have yearly cycles with increases in demand around the holidays and during annual sales.
2. The use of electricity in a household has both a yearly and daily cycle with more use during the evening than at night and similarly more use in winter than summer.
3. Weather patterns also contain daily and yearly cycles with temperature changing from day to night and winter to summer

Similar to the ARIMA model which accounts for historical lag components `p`, residual errors `q` and a set of time series differencing `d`, the seasonal component of a SARIMA model has equivalent components.

* `P` is the autoregressive lag term of the seasonal component of the model
* `Q` is the residual moving average term of the seasonal component model
* `D` is the seasonal differencing term of the model

SARIMA models are usually denoted by the following definition

$$ARIMA(p,d,q)(P,D,Q)_{m}$$

where the upper case components are defined above and $m$ refers to the number of periods in each season.

A further outline of SARIMA model generation and use can be found [here](https://www.statsmodels.org/dev/examples/notebooks/generated/statespace_sarimax_stata.html#ARIMA-Example-3:-Airline-Model).

### `.ml.ts.SARIMA.fit`

_Fit an SARIMA forecasting model based on a provided time series dataset_

Syntax:`.ml.ts.SARIMA.fit[endog;exog;p;d;q;tr;s]`

Where

-  `endog` endogenous variable as a list (time-series)
-  `exog`  table of exogenous variables, if (::)/() then exogenous variables ignored
-  `p`     number of lag values to include
-  `d`     order of differencing being used
-  `q`     number of residual errors to include
-  `tr`   is a trend to be accounted for?
-  `s`    dictionary of seasonal `P`,`D`,`Q` and `m`(periodicity) components

returns a dictionary containing the model parameters and data required for the forecasting of future values. This dictionary contains the following information

key         |  Explanation
------------|---------------------------
params      | model paramaters for future predictions
tr_param    | trend paramaters
exog_param  | exog paramaters
p_param     | lag value paramaters
q_param     | error paramaters
P_param     | seasonal lag value paramaters
Q_param     | seasonal error paramaters
lags        | lagged values from the training set
resid       | q residual errors calculated from training set using the params
estresid    | coefficients used to estimate resid errors
origd       | original values of input values before being differenciated
origs       | original values to be used to transform seasonal differencing to original format
pred_dict   | a dictionary containing information about the model used for fitting

```q
q)timeSeries:100?10f
q)exogVar:([]100?10f;100?1f)
q)show s:`P`D`Q`m!2 0 1 10
P| 2
D| 0
Q| 1
m| 10
q).ml.ts.SARIMA.fit[timeSeries;exogVar;3;0;1;1b;s]
params    | 7.884855 0.06814395 -1.941512 0.07451696 0.06945657 -0.02878508 0..
tr_param  | 7.884855
exog_param| 0.06814395 -1.941512
p_param   | 0.07451696 0.06945657 -0.02878508
q_param   | ,0.0426231
P_param   | -0.3060438 -0.02981245
Q_param   | ,0.3060438
lags      | 8.785244 7.917149 9.368097 9.354093 1.198466 9.861346 2.987363 9...
resid     | -2.51953 -0.5106217 -2.752604 2.912639 3.998895 -0.8393589 2.6420..
estresid  | 0.2759621 0.5415452 0.09872066 0.2684686 0.2644688 0.224076
pred_dict | `p`q`P`Q`m`tr`seas_add_P`seas_add_Q`n!(3;1;0 10;,0;10;1b;1 2 3 11..
origd     | `float$()
origs     | `float$()
```

### `.ml.ts.SARIMA.predict`

_Predict future values of a time series using a fitted SARIMA model_

Syntax:`.ml.ts.SARIMA.predict[mdl;exog;len]`

Where

-  `mdl` dictionary returned from fiting a SARIMA model
-  `exog`  table of exogenous variables, if (::)/() then exogenous variables ignored
-  `len` number of values that are to be predicted

returns the future predicted values

```q
// Generate a SARIMA model
q)timeSeries:100?10f
q)exogVar:([]100?10f;100?1f)
q)s:`P`D`Q`m!3 0 1 5 
q)show SARIMAmdl:.ml.ts.SARIMA.fit[timeSeries;exogVar;2;0;1;0b;s]
params    | 0.3320696 -1.755837 0.3552354 -0.07180415 -0.05615472 -0.07299491..
tr_param  | 0n
exog_param| 0.3320696 -1.755837
p_param   | 0.3552354 -0.07180415
q_param   | ,-0.05615472
P_param   | -0.07299491 -0.003728334 0.301681
Q_param   | ,0.07299491
lags      | 2.987363 9.845271 6.048108 3.090942 7.947873 5.64229 2.543918 4.6..
resid     | -1.545894 3.910773 -0.1293132 -2.996627 -3.1072 2.496399
estresid  | 0.2396791 1.196061 0.2354901 0.1959916 0.178039
pred_dict | `p`q`P`Q`m`tr`seas_add_P`seas_add_Q`n!(2;1;0 5 10;,0;5;0b;1 2 6 7..
origd     | `float$()
origs     | `float$()

// Use the fit model and set of exogenous variables to make predictions
q)exogFuture:([]10?1f;10?1f)
q).ml.ts.SARIMA.predict[SARIMAmdl;exogFuture;10]
4.120073 4.828971 5.943532 3.411156 4.342353 2.056176 4.707504 4.516458 6.316
```
