---
author: Conor McCarthy
date: August 2018
keywords: machine learning, ml, feature extraction, feature selection, time series forecasting, interpolation
---

# <i class="fa fa-share-alt"></i> FRESH: a feature-extraction and feature-significance toolkit



<i class="fab fa-github"></i>
[KxSystems/ml](https://github.com/kxsystems/ml)

Feature extraction and selection are vital components of many machine-learning pipelines. Here we outline an implementation of the [FRESH](https://arxiv.org/pdf/1610.07717v3.pdf) (FeatuRe Extraction and Scalable Hypothesis testing) algorithm.

Feature extraction is the process of building derived, aggregate features from a time-series dataset. The features created are designed to characterize the underlying time-series in a way that is easier to interpret and often provide a more suitable input to machine-learning algorithms.

Following feature extraction, statistical-significance tests between feature and target vectors can be applied. This allows selection of only those features with relevance (in the form of a p-value) above a given threshold.

Feature selection can improve the accuracy of a machine-learning algorithm by

-  Simplifying the models used.
-  Shortening the training time needed.
-  Avoiding the curse of dimensionality.
-  Reducing variance in the dataset to reduce overfitting.


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

In particular, data should not contain text (strings or symbols), other than the id column. If a text-based feature is thought to be important, one-hot, frequency or lexigraphical encoding can be used to convert the symbolic data to numerical values.

!!! note

    A range of formatting functions (e.g. null-filling and one-hot encoding) are supplied in the [Utilities section](utils.md) of the toolkit.


## Calculated features

Feature-extraction functions are defined in the script `fresh.q` and found within the `.ml.fresh.feat` namespace.

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
longstrikeltmean[x]              | Length of the longest subsequence in `x` less than the mean of `x`
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

Feature-extraction functions are not, typically, called individually. A detailed explanation of each operation is therefore excluded

## Feature extraction

Feature-extraction involves applying a set of aggregations to subsets of the initial input data, with the goal of obtaining information that is more informative than the raw time series. 

The `.ml.fresh.createfeatures` function applies a set of aggregation functions to derive features. There are 57 such functions available in the `.ml.fresh.feat` namespace, though users may select a subset based on requirements.

Syntax: `.ml.fresh.createfeatures[t;aggs;cnames;ptab]`

Where

-   `t` is the input data in the form of a simple table.
-   `aggs` is the id column name (syms).
-   `cnames` are the column names (syms) on which extracted features will be calculated (these columns should contain only numerical values).
-   `ptab` is a table containing the functions and parameters to be applied to the `cnames` columns. This should be a modified version of `.ml.fresh.params`

This returns a table keyed by id column and containing the features extracted from the subset of the data identified by the id.

```q 
q)m:30;n:100
q)10#tab:([]date:raze m#'"d"$til n;time:(m*n)#"t"$til m;col1:50*1+(m*n)?20;col2:(m*n)?1f)
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
q)show ptab:.ml.fresh.params
f                       | pnum pnames         pvals                        valid
------------------------| ------------------------------------------------------
absenergy               | 0    ()             ()                               1    
abssumchange            | 0    ()             ()                               1    
count                   | 0    ()             ()                               1    
countabovemean          | 0    ()             ()                               1    
countbelowmean          | 0    ()             ()                               1    
firstmax                | 0    ()             ()                               1    
firstmin                | 0    ()             ()                               1    
autocorr                | 1    ,`lag          ,0 1 2 3 4 5 6 7 8 9             1    
binnedentropy           | 1    ,`lag          ,2 5 10                          1    
c3                      | 1    ,`lag          ,1 2 3                           1    
cidce                   | 1    ,`boolean      ,01b                             1    
eratiobychunk           | 1    ,`numsegments  ,3                               1    
rangecount              | 2    `minval`maxval -1 1                             1    
changequant             | 3    `ql`qh`isabs   (0.1 0.2;0.9 0.8;01b)            1    
q)5#cfeats:.ml.fresh.createfeatures[tab;`date;2_ cols tab;ptab]
date      | col1_absenergy col1_abssumchange col1_count col1_countabovemean col1_countb..
----------| ---------------------------------------------------------------------------..
2000.01.01| 1.33e+07       10100             30         13                  17         ..
2000.01.02| 1.023e+07      11450             30         14                  16         ..
2000.01.03| 7805000        9200              30         13                  17         ..
2000.01.04| 8817500        9950              30         17                  13         ..
2000.01.05| 7597500        7300              30         12                  18         ..
q)count 1_cols cfeats	/ 595 features have been produced from 2 columns
595

/ update ptab to not include hyperparameter dependant functions 
q)show ptabnew:update valid:0b from ptab where pnum>0
f                       | pnum pnames         pvals                        valid
------------------------| ------------------------------------------------------
absenergy               | 0    ()             ()                               1
abssumchange            | 0    ()             ()                               1
count                   | 0    ()             ()                               1
countabovemean          | 0    ()             ()                               1
countbelowmean          | 0    ()             ()                               1
firstmax                | 0    ()             ()                               1
firstmin                | 0    ()             ()                               1
autocorr                | 1    ,`lag          ,0 1 2 3 4 5 6 7 8 9             0
binnedentropy           | 1    ,`lag          ,2 5 10                          0
c3                      | 1    ,`lag          ,1 2 3                           0
cidce                   | 1    ,`boolean      ,01b                             0
eratiobychunk           | 1    ,`numsegments  ,3                               0
rangecount              | 2    `minval`maxval -1 1                             0
changequant             | 3    `ql`qh`isabs   (0.1 0.2;0.9 0.8;01b)            0
q)5#cfeatsnew:.ml.fresh.createfeatures[tab;`date;2_ cols tab;ptabnew]
date      | col1_absenergy col1_abssumchange col1_count col1_countabovemean col1_countb..
----------| ---------------------------------------------------------------------------..
2000.01.01| 1.33e+07       10100             30         13                  17         ..
2000.01.02| 1.023e+07      11450             30         14                  16         ..
2000.01.03| 7805000        9200              30         13                  17         ..
2000.01.04| 8817500        9950              30         17                  13         ..
2000.01.05| 7597500        7300              30         12                  18         ..
q)count 1_cols cfeatsnew     / 74 columns now being produced with subset of functions
74
```

!!!note
	Modifications to the file `hyperparam.txt` within the FRESH folder allows for fine tuning of the number and variety of calculations being completed to be made. Functions can be user defined within the the `.ml.fresh.feat` namespace in the fresh.q file and provided their associated hyper-parameters are defined in `hyperparam.txt` they will execute via the above syntax.
!!!warning
	The operating principal of this function has changed relative to that in versions `0.1.x`. In the previous version parameter 4 had been a dictionary of the functions to be applied to the table was supplied. This worked well for producing features from functions that only took the data as input. To account for multi-parameter functions the structure outlined above has been used.


## Feature significance

Statistical-significance tests can be applied to the derived features to determine how useful each feature is in predicting a target vector. The specific significance test applied, depends on the characteristics of the feature and target. The following table outlines the test applied in each case.

feature type       | target type       | significance test 
:------------------|:------------------|:------------------
Binary             | Real              | Kolmogorov-Smirnov
Binary             | Binary            | Fisher-Exact      
Real               | Real              | Kendall Tau-b     
Real               | Binary            | Kolmogorov-Smirnov

Each test returns a p-value, which can then be passed to a selection procedure chosen by the user. The feature selection procedures available are as follows;

1. The Benjamini-Hochberg-Yekutieli (BHY) procedure: determines if the feature meets a defined False Discovery Rate (FDR) level (set at 5% by default).
2. K-best features: choose the K features which have the lowest p-values and thus have been determined to be the most important features to prediction of the target vector.
3. Percentile based selection: set a percentile threshold for p-values below which features are selected.

Each of these procedures can be implemented as below;

## `.ml.fresh.benjhochfeat`

_Benjamini Hochberg Procedure for feature selection_

Syntax: `.ml.fresh.benjhochfeat[t;tgt]`

Where

-   `t` is the unkeyed side of a table of created features
-   `tgt` is a list of targets corresponding to the rows of table `t` 

returns a list of features deemed statistically significant as deemed by the Benjamini-Hochberg procedure.

```q
q)target:value exec avg col2+.001*col2 by date from tab / combination of col avgs
q)show sigfeats:.ml.fresh.benjhochfeat[value mulfeatures;target]  / threshold defaulted to 5%
`mean_col2`sumval_col2`absenergy_col2`c3_1_col2`c3_2_col2`med_col2`quantile_0..
q)count 2_cols tab      / number of raw features
2
q)count 1_cols mulfeatures / number of extracted features
260
q)count sigfeats        / number of selected features
21
```

!!! note 
	In the previous release this procedure was contained in the function `.ml.fresh.significantfeatures` to maintain consistency for those using FRESH versions `v0.1.x`. It should be noted that `.ml.fresh.benjhochfeat` is an aliased version of this and the base operation of `.ml.fresh.significantfeatures` has not changed.

## `.ml.fresh.ksigfeat`

_Select the K-best features based on p-value_

Syntax: `.ml.fresh.ksigfeat[t;tgt;k]`

Where

-  `t` is the unkeyed side of a table of created features
-  `tgt` is a list of targets corresponding to the rows of table `t`
-  `k` is the number of features to be selected as an int

returns a list of the k-best features defined as those with the lowest p-values.

```q
q)show sigfeats:.ml.fresh.ksigfeat[value features;target;2]  / find the best 2 features
`mean_col2`sumval_col2
```

## `.ml.fresh.percentilesigfeat`

_Select features within the top p percentile_

Syntax: `.ml.fresh.percentilesigfeat[t;tgt;p]`

Where

-  `t` is the unkeyed side of a table of created features
-  `tgt` is a list of targets corresponding to the rows of table `t`
-  `p` is the percentile threshold as a float in range 0-1 

returns a list of features in the top `p` percentile which are deemed most statistically significant based on p-values

```q
q)show sigfeats:.ml.fresh.percentilesigfeat[value features;target;.05]  / percentile set at 5%
`absenergy_col2`mean_col2`med_col2`sumval_col2`c3_1_col2`c3_2_col2`c3_3_col2`..
q)count sigfeats        / number of selected features
8
```
