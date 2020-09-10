---
title: Time Series | Machine Learning Toolkit | Documentation for kdb+ and q
author: Diane O'Donoghue
date: August 2020
keywords: machine learning, ml, time series forecasting, ar, arima, sarima 
---
# :fontawesome-solid-share-alt: Time Series Forecasting

In time series analysis, time series forecasting is the use of a model to predict the future values of a dataset based on historical observations. Forecasting can be achieved using a wide range of techniques from simple linear regression to complex neural network constructs. Use cases for time series forecasting vary from its use in the prediction of weather patterns, the forecasting of future product sales and the applications in the stock market.

The Machine Learning Toolkit contains a number of implementations of commonly used statistical [forecasting algorithms](arima.md). These include the following models

1. AutoRegressive (AR)
2. AutoRegressive Conditional Heteroskedasticity (ARCH)
3. AutoRegressive Moving Average (ARMA)
4. AutoRegressive Integrated Moving Average (ARIMA)
5. Seasonal AutoRegressive Moving Average (SARIMA)

In addition to this, a number of feature extraction techniques to generate lagged values and apply moving calculations are also included. These techniques are provided as they can be used to convert a time series dataset into a format which may be more suited to the application of traditional machine learning algorithms.

Notebooks showing examples of time series forecasting can be found at 

:fontawesome-brands-github:
[KxSystems/mlnotebooks](https://github.com/kxsystems/mlnotebooks)

All code relating to the time series section of the Machine Learning Toolkit is available at

:fontawesome-brands-github:
[KxSystems/ml/timeseries/](https://github.com/kxsystems/ml/timeseries)


## Loading

The time series extension can be loaded independently of the ML Toolkit:

```q
q)\l ml/ml.q
q).ml.loadfile`:timeseries/init.q
```
