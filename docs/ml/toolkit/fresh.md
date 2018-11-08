---
author: Conor McCarthy
date: August 2018
keywords: machine learning, ml, feature extraction, feature selection, time series forecasting, interpolation
---

# <i class="fa fa-share-alt"></i> FRESH: a feature-extraction and feature-significance toolkit



<i class="fab fa-github"></i>
[KxSystems/ml](https://github.com/kxsystems/ml)

Feature extraction and selection are vital components of many machine-learning pipelines. Here we outline an implementation of the [FRESH](https://arxiv.org/pdf/1610.07717v3.pdf) (FeatuRe Extraction and Scalable Hypothesis testing) algorithm.

Feature extraction is the process of building derived, aggregate features from a time-series dataset. The features created are designed to characterize the underlying time-series in a way that is easier to interpret and provides a more suitable input to machine-learning algorithms.

Following feature extraction, statistical-significance tests between feature and target vectors can be applied. This allows selection of only those features with relevance (in the form of a p-value) above a given threshold.

Feature selection can improve the accuracy of a machine-learning algorithm by

-   Simplifying the models used.
-   Shortening the training time needed.
-   Avoiding the curse of dimensionality.
-   Reducing variance in the dataset to reduce overfitting.


Notebooks showing examples of the FRESH algorithm used in different applications can be found at 
<i class="fab fa-github"></i>
[KxSystems/ml/fresh/notebooks](https://github.com/kxsystems/ml/tree/master/fresh/notebooks).


## Loading

Load the FRESH library using

```q
q)\l ml/ml.q
q).ml.loadfile`:fresh/init.q
```


## Data formatting

Data passed to the feature extraction procedure should contain an identifying (id) column, which groups the time-series into subsets from which features can be extracted. The id column can be inherent to the data or derived for a specific use-case (e.g. applying a sliding window onto the dataset).

Null values in the data should be replaced with derived values most appropriate to the column.

Data-types supported by the feature-extraction procedure are boolean, int, real, long, short and float. Other datatypes should not be passed to the extraction procedure.

In particular, data should not contain text (strings or symbols), other than the id column. If a text-based feature is thought to be important, one-hot encoding can be used to convert to numerical values.

!!! note

    A range of formatting functions (e.g. null-filling and one-hot encoding) are supplied in the [Utilities section](utils.md) of the toolkit.


## Calculated features

Feature-extraction functions are defined in the script `fresh.q` and found within the `.ml.fresh` namespace.

function                         | returns 
:--------------------------------|:--------------
absenergy[x]                     | Absolute sum of the differences between successive datapoints
aggautocorr[x]                   | Aggregation (mean/var etc.) of an autocorrelation over all possible lags 1 - length data 
augfuller[x]                     | Hypothesis test to check for a unit root in time series dataset
autocorr[x;lag]                  | Autocorrelation over specified lags
binnedentropy [x;n bins]         | System entropy of data binned into equidistant bins
c3[x;lag]                        | Measure of the non-linearity of the time series
changequant[x;ql;qh;isabs]       | Aggregated value of successive changes within corridor specified by `ql `(lower quantile) and `qh` (upper quantile)
cidce[x;isabs]                   | Measure of time series complexity based on peaks and troughs in the dataset
countabovemean[x]                | Number of points in the dataset with a value greater than the time series mean
fftaggreg[x]                     | Spectral centroid (mean), variance, skew, and kurtosis of the absolute Fourier-transform spectrum
fftcoeff[x;coeff]                | Fast-Fourier transform coefficients given real inputs and extract real, imaginary, absolute and angular components
hasdup[x]                        | If the time-series contains any duplicate values
hasdupmax[x]                     | Boolean value stating if a duplicate of the maximum value exists in the dataset
indexmassquantile[x;q]           | Relative index `i` where `q`% of the time-series `x`’s mass lies left of `i`
kurtosis[x]                      | Adjusted G2 Fisher-Pearson kurtosis
lintrend[x]                      | Slope, intercept, r-value, p-value and standard error associated with the time series
longstrikelmean[x]               | Length of the longest subsequence in `x` less than the mean of `x`
meanchange[x]                    | Mean over the absolute difference between subsequent t-series values
mean2dercentral[x]               | Mean value of the central approximation of the second derivative of the time series
numcrossingm[x;m]                | Number of crossings in the dataset over a value `m`: crossing is defined as sequential values either side of `m`, where the first is less than `m` and the second is greater or vice-versa
numcwtpeaks[x;width]             | Peaks in the time-series following data smoothing via application of a Ricker wavelet
numpeaks[x;support]              | Number of peaks with a specified support in a time series `x`
partautocorrelation[x;lag]       | Partial autocorrelation of the time series at a specified lag
perrecurtoalldata[x]             | (Count of values occurring more than once)÷(count different values)
perrecurtoallval[x]              | (Count of values occurring more than once)÷(count data)
ratiobeyondrsigma[x;r]           | Ratio of values more than `r*dev[x]` from the mean of `x`
ratiovalnumtserieslength[x]      | (Number of unique values)÷(count values)
spktwelch[x;coeff]               | Cross power spectral density of the time series at different tunable frequencies
symmetriclooking[x]              | If the data ‘appears’ symmetric
treverseasymstat[x;lag]          | Measure of the asymmetry of the time series based on lags applied to the data
vargtstdev[x]                    | If the variance of the dataset is larger than the standard deviation


Feature-extraction functions are not, typically, called individually. A detailed explanation of each operation is therefore excluded.

!!! warning

    At present this feature-extraction procedure works only on functions which do not take hyper-parameters, accessed via `.ml.fresh.getsingleinputfeatures[]`.
    Functions with multiple parameters will be added in a future release.


## Feature extraction

Feature-extraction involves applying a set of aggregations to subsets of the initial input data, with the goal of obtaining information that is more informative than the raw time series. 

The `.ml.fresh.createfeatures` function applies a set of aggregation functions to derive features. There are 57 such functions available in the `.ml.fresh.feat` namespace, though users may select a subset based on requirements.

Syntax: `.ml.fresh.createfeatures[table;aggs;cnames;funcs]`

Where

-   `table` is the input data (table).
-   `aggs` is the id column name (symbol).
-   `cnames` are the column names (symbols) on which extracted features will be calculated (these columns should contain only numerical values).
-   `funcs` is the dictionary of functions to be applied to the table (a subset of `.ml.fresh.feat`).

This returns a table keyed by id column and containing the features extracted from the subset of the data identified by the id.

```q 
q)m:30;n:100
q)show tab:([]date:raze m#'"d"$til n;time:(m*n)#"t"$til m;col1:50*1+(m*n)?20;col2:(m*n)?1f)
date       time         col1 col2      
---------------------------------------
2000.01.01 00:00:00.000 1000 0.3927524 
2000.01.01 00:00:00.001 350  0.5170911 
2000.01.01 00:00:00.002 950  0.5159796 
2000.01.01 00:00:00.003 550  0.4066642 
2000.01.01 00:00:00.004 450  0.1780839 
2000.01.01 00:00:00.005 400  0.3017723 
2000.01.01 00:00:00.006 400  0.785033  
2000.01.01 00:00:00.007 500  0.5347096 
2000.01.01 00:00:00.008 600  0.7111716 
2000.01.01 00:00:00.009 250  0.411597  
2000.01.01 00:00:00.010 50   0.4931835 
2000.01.01 00:00:00.011 400  0.5785203 
2000.01.01 00:00:00.012 800  0.08388858
2000.01.01 00:00:00.013 950  0.1959907 
2000.01.01 00:00:00.014 1000 0.375638  
2000.01.01 00:00:00.015 650  0.6137452 
2000.01.01 00:00:00.016 50   0.5294808 
2000.01.01 00:00:00.017 600  0.6916099 
2000.01.01 00:00:00.018 900  0.2296615 
2000.01.01 00:00:00.019 300  0.6919531 
..
q)featdict:.ml.fresh.getsingleinputfeatures[] / feature functions without hyperparams
q)show features:.ml.fresh.createfeatures[tab;`date;2_ cols tab;featdict]
date      | absenergy_col1 absenergy_col2 abssumchange_col1 abssumchange_col2..
----------| -----------------------------------------------------------------..
2000.01.01| 1.156e+07      9.245956       8700              7.711325         ..
2000.01.02| 1.1225e+07     8.645625       11350             9.036386         ..
2000.01.03| 9910000        10.8401        9800              9.830704         ..
2000.01.04| 1.0535e+07     7.900601       7350              10.21271         ..
2000.01.05| 7830000        8.739328       6900              11.02193         ..
2000.01.06| 9150000        9.530337       8150              11.38859         ..
2000.01.07| 1.296e+07      11.36589       9500              10.8551          ..
2000.01.08| 1.11175e+07    12.97225       8800              11.70683         ..
2000.01.09| 1.183e+07      10.99597       11600             9.372777         ..
2000.01.10| 1.076e+07      8.8356         11600             9.923837         ..
2000.01.11| 7640000        11.77406       11400             9.307188         ..
2000.01.12| 1.13e+07       9.965319       9150              9.232088         ..
2000.01.13| 1.0195e+07     9.743622       6400              8.435915         ..
2000.01.14| 1.077e+07      9.934516       10400             8.685272         ..
2000.01.15| 1.033e+07      12.23959       11750             7.666534         ..
2000.01.16| 7602500        10.44816       8800              8.319819         ..
2000.01.17| 1.10275e+07    11.49045       7850              9.464308         ..
2000.01.18| 8942500        8.282222       9500              6.880915         ..
2000.01.19| 7775000        12.43864       10200             9.068333         ..
2000.01.20| 1.20175e+07    14.59714       9400              9.383993         ..
..
```


## Feature significance

Statistical-significance tests can be applied to the derived features, to determine how useful each feature is in predicting a target vector. The specific significance test applied, depends on the characteristics of the feature and target. The following table outlines the test applied in each case.

feature type       | target type       | significance test 
:------------------|:------------------|:------------------
Binary             | Real              | Kolmogorov-Smirnov
Binary             | Binary            | Fisher-Exact      
Real               | Real              | Kendall Tau-b     
Real               | Binary            | Kolmogorov-Smirnov

Each test returns a p-value, which can be passed to the Benjamini-Hochberg-Yekutieli (BHY) procedure. This determines if the feature meets a defined False Discovery Rate (FDR) level (set at 5% by default).

Both the calculation of p-values and the completion of the BHY procedure are contained within the `.ml.fresh.significantfeatures` function:

Syntax: `.ml.fresh.significantfeatures[table;targets]`

Where

-   `table` is the value section of the table produced by the feature-creation procedure
-   `targets` is a list of target values corresponding to the ids 

returns a list of the features deemed statistically significant.

Sample code:

```q
q)target:value exec avg col2+.001*col2 by date from tab / combination of col avgs
q)show sigfeats:.ml.fresh.significantfeatures[value features;target]
`absenergy_col2`countabovemean_col2`countbelowmean_col2`mean_col2`med_col2`mi..
q)count 2_cols tab      / number of raw features
2
q)count 1_cols features / number of extracted features
72
q)count sigfeats        / number of selected features
9
```

!!! note "Feature-significance tests may result in *no* significant features being found."


## Fine tuning

### Parameter dictionary

Hyperparameters for a number of the functions are contained in the dictionary `.ml.fresh.paramdict` (defined in the script `paramdict.q`). The default dictionary can be modified by users to suit their use cases better.


### User-defined functions

The aggregation functions contained in this library are a small subset of the functions that could be applied in a feature-extraction pipeline. Users can add their own functions by following the template outlined within `fresh.q`.

