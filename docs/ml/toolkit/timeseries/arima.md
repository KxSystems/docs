---
title: Time Series ARIMA models | Time Series | Machine Learning Toolkit | Documentation for kdb+ and q
author: Diane O'Donoghue
date: August 2020
keywords: machine learning, ml, time series, ar, arima, sarima, aic
---

# :fontawesome-solid-share-alt: Time Series ARIMA models

<pre markdown="1" class="language-txt">
.ml.tm   **ARIMA models**

Fitting Functionality  
  [ARfit](#mltmARfit)             Fit an AutoRegressive model
  [ARMAfit](#mltmARMAfit)         Fit an AutoRegressive Moving Average model
  [ARIMAfit](#mltmARIMAfit)        Fit an AutoRegressive Integrated Moving Average model
  [SARIMAfit](#mltmSARIMAfit)       Fit a Seasonal AutoRegressive Integrated Moving Average model

Prediction Functionality 
  [ARpred](#mltmARpred)          Predict future values using a fitted AutoRegressive model
  [ARMApred](#mltmARMApred)        Predict future values using a fitted AutoRegressive Moving Average model
  [ARIMApred](#mltmARIMApred)       Predict future values using a fitted AutoRegressive Integrated Moving Average model
  [SARIMApred](#mltmSARIMApred)      Predict future values using a fitted Seasonal AutoRegressive Integrated Moving Average model
 
Scoring Funcionality
  [aicparam](#mltmaicparam)        Determine optimal input parameters for ARIMA model using the AIC score


</pre>

<i class="fab fa-github"></i>
[KxSystems/ml/timeseries](https://github.com/KxSystems/ml/tree/master/timeseries)

## Model Explanations

### AutoRegressive (AR) model

An AR model uses only past behaviour of a time series in order to forecast future values. This modelling can be used when there is a correlation between past and future values in time series data. An AR(p) model uses `p` lag values to calculate the preceeding values. 

The equation for an AR model is

$$y_t= \mu  + \sum_{i=1}^{p} \phi_{i} y_{t-i}$$

Where

$y_t$ is the time series at time t

$\mu$ is the trend value

$\phi_{i}$ is the lag parameter at time t-i 

### AutoRegressive Moving Average (ARMA) model

ARMA models utilise both past lag values (AR) and past shock effects/white noise terms (MA) observed in a time series in order to forecast future values in weakly stationary stochastic time series. `p` lag values and `q` past residual error are used in forecasting.

The equation for an ARMA model is

$$y_t= \mu  + \sum_{i=1}^{p} \phi_{i} y_{t-i} + \sum_{i=1}^{q} \theta_{i} \epsilon_{t-i}$$

Where

$\epsilon_{t-i}$ is the residual error term at time t-i
 
$\theta_{i}$ is the residual error parameter at time t-i 


### AutoRegressive Integrated Moving Average (ARIMA) model

ARIMA models are an extention to ARMA models which differences the time series a number of times (d) in order to make a time series stationary. Once the time series is made stationary, an ARMA model is applied to forecast future values. Any 'non seasonal' time series data that is not just random white noise can be modeled using this method 

The equation for an ARIMA model is 

$$\hat{y}_{t}= \mu  + \sum_{i=1}^{p} \phi_{i} y_{t-i} + \sum_{i=1}^{q} \theta_{i} \epsilon_{t-i}$$

Where

$\hat{y}_{t}$ is the differenced value of y

### Seasonal AutoRegressive Moving Average (SARIMA) model

SARIMA models are used for time series containing seasonal trends. This is a similar method to ARIMA, with seasonal `P` `D` and `Q` components also applied when forecasting future values. This can be written as `ARIMA(p,d,q)X(P,D,Q)s` where the lowercase indicate the non seasonal components and the uppercase represent the seasonal aspects

The equation for a SARIMA model can be found [here](https://www.statsmodels.org/dev/examples/notebooks/generated/statespace_sarimax_stata.html#ARIMA-Example-3:-Airline-Model)   

### Stationary Time Series
A time series is stationary if its statistical properties such as mean, variance and autocorrelation do not change over time. Time series with trends or seasonality are not stationary. Differencing can be applied to a time series in order to make it staionary. This involves computing the differences between consecutive observations in the time series.

### Akaike Information Criterion (AIC)
AIC is used to score a statistical model by taking into account the goodness of fit and the simplicity of the model. The optimal model to choose recieves the lowest AIC score.

The equation used to caluclate the AIC score is:

```AIC = -2log(L) + 2(p+q+k+1)```

Where

-  `L` is the liklihood of the data (How well the model preforms)

## Fitting Functionality

The below functions returned a dictionary to be used in forecasting future values. The keys of each dictionary have the following meanings:

key      |  Explanation
---------------|---------------------------
params      | model paramaters for future predictions
tr_param    | trend paramaters
exog_param | exog paramaters
p_param    | lag value paramaters
q_param     | error paramaters
P_param    | seasonal lag value paramaters
Q_param     | seasonal error paramaters
lags        | lagged values from the training set
resid       | q residual errors calculated from training set using the params
estresid     | Coefficients used to estimate resid errors
origd        | Original values of input values before being differenciated
origs        | Original values to be used to transform seasonal differencing to original format


### `.ml.tm.ARfit`

_Fit an AutoRegressive forecasting model using time series data_

Syntax:`.ml.tm.ARfit[endog;exog;p;tr]`

Where

-  `endog` endogenous variable as a list (time-series)
-  `exog`  table of exogenous variables, if (::)/() then exogenous variables ignored
-  `p`     number of lag values to include
-  `tr`   is a trend to be accounted for

returns a dictionary containing the model parameters and data to be used for forecasting future values

```q
q)timeSeries:100?10f
q)exogVar:([]100?10f;100?1f)
// Fit an arima model with no exog variables with trend and 3 lags
q).ml.tm.ARfit[timeSeries;();3;1b]
params    | 4.936532 0.03997196 0.03751383 0.005364343
tr_param  | ,4.936532
exog_param| `float$()
p_param   | 0.03997196 0.03751383 0.005364343
lags      | 0.8175513 2.401967 5.784208
// Fit the same model with exog variables included
q).ml.tm.ARfit[timeSeries;exogVar;3;1b]
params    | 5.994866 -0.2057255 -1.904434 0.06913882 0.04123651 -0.01732191
tr_param  | ,5.994866
exog_param| -0.2057255 -1.904434
p_param   | 0.06913882 0.04123651 -0.01732191
lags      | 0.8175513 2.401967 5.784208
```

### `.ml.tm.ARMAfit`

_Fit an AutoRegressive Moving Average forecasting model using time series data_

Syntax:`.ml.tm.ARMAfit[endog;exog;p;q;tr]`

Where

-  `endog` endogenous variable as a list (time-series)
-  `exog`  table of exogenous variables, if (::)/() then exogenous variables ignored
-  `p`     number of lag values to include
-  `q`     number of residual errors to include
-  `tr`   is a trend to be accounted for

returns a dictionary containing the model parameters and data to be used for forecasting future values

```q
q)timeSeries:100?10f
q)exogVar:([]100?10f;100?1f)
q).ml.tm.ARMAfit[timeSeries;exogVar;2;1;0b]
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

### `.ml.tm.ARIMAfit`

_Fit an AutoRegressive Integrated Moving Average forecasting model using time series data_

Syntax:`.ml.tm.ARIMAfit[endog;exog;p;d;q;tr]`

Where

-  `endog` endogenous variable as a list (time-series)
-  `exog`  table of exogenous variables, if (::)/() then exogenous variables ignored
-  `p`     number of lag values to include
-  `d`     order of differencing being used
-  `q`     number of residual errors to include
-  `tr`   is a trend to be accounted for

returns a dictionary containing the model parameters and data to be used for forecasting future values

```q
q)timeSeries:100?10f
q)exogVar:([]100?10f;100?1f)
q).ml.tm.ARIMAfit[timeSeries;exogVar;3;1;2;1b]
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

!!! Note
	In general, values of `d` less than 2 are used in ARIMA models.

### `.ml.tm.SARIMAfit`

_Fit an Seasonal AutoRegressive Integrated Moving Average forecasting model using time series data_

Syntax:`.ml.tm.SARIMAfit[endog;exog;p;d;q;tr;s]`

Where

-  `endog` endogenous variable as a list (time-series)
-  `exog`  table of exogenous variables, if (::)/() then exogenous variables ignored
-  `p`     number of lag values to include
-  `d`     order of differencing being used
-  `q`     number of residual errors to include
-  `tr`   is a trend to be accounted for
-  `s`    dictionary of seasonal `P`,`D`,`Q` and and `m`(periodicy) components 

returns a dictionary containing the model parameters and data to be used for forecasting future values

```q
q)timeSeries:100?10f
q)exogVar:([]100?10f;100?1f)
q)show s:`P`D`Q`m!2 0 1 10
P| 2
D| 0
Q| 1
m| 10
.ml.tm.SARIMAfit[timeSeries;exogVar;3;0;1;s]
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

## Prediction Functionality

### `.ml.tm.ARpred`

_Predict future values of a time series used a fitted AR model_

Syntax:`.ml.tm.ARpred[mdl;exog;len]`

Where

-  `mdl` dictionary returned from fitted AR model
-  `exog` exogenous values used for predicting future values
-  `len` number of values that are to be predicted

returns the future predicted values

!!! Note
	Future `exog` variables should be in the same format as the `exog` variables used when fitting the model, and also must be the same length as `len`
```q
q)timeSeries:100?10f
q)exogVar:([]100?10f;100?1f)
q)show ARmdl:.ml.tm.ARfit[timeSeries;exogVar;3;1b]
params    | 5.994866 -0.2057255 -1.904434 0.06913882 0.04123651 -0.01732191
tr_param  | ,5.994866
exog_param| -0.2057255 -1.904434
p_param   | 0.06913882 0.04123651 -0.01732191
lags      | 0.8175513 2.401967 5.784208
// Future exog variables
q)exogFuture:([]10?10f;10?1f)
q).ml.tm.ARpred[ARmdl;exogFuture;10]
3.822056 3.727468 4.99475 3.499939 3.844594 4.326576 5.916375 4.12185 3.85929
```

### `.ml.tm.ARMApred`

_Predict future values of a time series used a fitted ARMA model_

Syntax:`.ml.tm.ARMApred[mdl;exog;len]`

Where

-  `mdl` dictionary returned from fitted AR model
-  `exog` exogenous values used for predicting future values
-  `len` number of values that are to be predicted

returns the future predicted values

```q
q)timeSeries:100?10f
q)show ARMAmdl:.ml..tm.ARMAfit[timeSeries;();2;1;0b]
params    | 0.2363127 5.656993 -5.419003
tr_param  | 0n
exog_param| `float$()
p_param   | 0.2363127 5.656993
q_param   | ,-5.419003
lags      | 0.8175513 2.401967 5.784208
resid     | ,5.49667
estresid  | 0.03874406 0.03694788 0.008526308
pred_dict | `p`q`tr!(2;1;0b)
q).ml.tm.ARMApred[ARMAmdl;();10]
3.502366 3.120234 3.394482 3.605035 3.17703 3.109334 3.072042 3.002552 2.8720...
```
### `.ml.tm.ARIMApred`

_Predict future values of a time series used a fitted ARIMA model_

Syntax:`.ml.tm.ARMApred[mdl;exog;len]`

Where

-  `mdl` dictionary returned from fitted AR model
-  `exog` exogenous values used for predicting future values
-  `len` number of values that are to be predicted

returns the future predicted values

```q
q)timeSeries:100?10f
q)show ARIMAmdl:.ml.tm.ARIMAfit[timeSeries;exogVar;2;1;0;1b]
params    | 0.1901339 0.05783913 -1.025339 -0.3470224 -0.6955525
tr_param  | ,0.1901339
exog_param| 0.05783913 -1.025339
p_param   | -0.3470224 -0.6955525
lags      | 1.584416 3.382242
q_param   | ()
resid     | ()
origd     | ,5.784208
q).ml.tm.ARIMApred[ARIMAmdl;exogFuture;10]
2.540794 3.437806 4.324895 2.921683 3.768364 2.919457 3.347546 3.741517 3.715..
```

### `.ml.tm.SARIMApred`

_Predict future values of a time series used a fitted SARIMA model_

Syntax:`.ml.tm.SARIMApred[mdl;exog;len]`

Where

-  `mdl` dictionary returned from fitted AR model
-  `exog` exogenous values used for predicting future values
-  `len` number of values that are to be predicted

returns the future predicted values

```q
q)timeSeries:100?10f
q)exogVar:([]100?10f;100?1f)
q)s:`P`D`Q`m!3 0 1 5 
q)show SARIMAmdl:.ml.tm.SARIMAfit[timeSeries;exogVar;2;0;1;0b;s]
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
q).ml.tm.SARIMApred[SARIMAmdl;exogFuture;10]
4.120073 4.828971 5.943532 3.411156 4.342353 2.056176 4.707504 4.516458 6.316
```

## Scoring Functionality

### `.ml.tm.aicparam`

_Use AIC score to determine optimal model parameters for ARIMA model_

Syntax:`.ml.tm.aicparam[trainltest;len;dict]

Where

-  `train` training data dictionary with keys `endog`exog
-  `test` testing data dictionry with keys `engod`exog
-  `len` Number of values that are to be predicted
-  `dict` dictionary of different input parameters to score

returns a dictionary indicating the optimal input model parameters to use for an ARIMA model along with the associated AIC score

```q
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
q).tm.aicparam[trainDict;testDict;10;param]
p    | 2
d    | 0
q    | 1
tr   | 0b
score| 30.69017
```
