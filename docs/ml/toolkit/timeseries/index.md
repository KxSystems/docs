---
title: Time Series | Machine Learning Toolkit | Documentation for kdb+ and q
author: Diane O'Donoghue
date: August 2020
keywords: machine learning, ml, time series forecasting, ar, arima, sarima 
---
# :fontawesome-solid-share-alt: Time Series Forecasting

Time series forecasting is a supervised machine learning method in which meaningful statistical values are extracted from a time series data set in order to predict how the time series will preform in future events. It is implemented in a variety of use cases such as weather predictions, future sales forecasting in business planning and stock price forecasting amoung many others.

The Machine Learning Toolkit contains a number of time series forecasting statistical methods such as AR, ARIMA, SARIMA along with time series feature extraction methods.

Notebooks showing examples of time series forecasting can be fount at 

:fontawesome-brands-github:
[KxSystems/mlnotebooks](https://github.com/kxsystems/mlnotebooks)

All code relating to the time series section of the Machine Learning Toolkit is available at

:fontawesome-brands-github:
[KxSystems/ml/timeseries/](https://github.com/kxsystems/ml/timeseries)


## Loading

The clustering library can be loaded independently of the ML Toolkit:

```q
q)\l ml/ml.q
q).ml.loadfile`:timeseries/init.q
```
