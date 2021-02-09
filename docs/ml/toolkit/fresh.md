---
title: FRESH – a feature-extraction and feature-significance toolkit – Machine Learning – kdb+ and q documentation
author: Conor McCarthy
description: Feature extraction and selection are vital components of many machine-learning pipelines. Here we outline an implementation of the FRESH (FeatuRe Extraction and Scalable Hypothesis testing) algorithm.
date: August 2018
---
# :fontawesome-solid-share-alt: FRESH: a feature-extraction and feature-significance toolkit

:fontawesome-brands-github: [KxSystems/ml](https://github.com/kxsystems/ml)

Feature extraction and selection are vital components of many machine-learning pipelines. Here we outline an implementation of the [FRESH](https://arxiv.org/pdf/1610.07717v3.pdf) (FeatuRe Extraction and Scalable Hypothesis testing) algorithm.

Feature extraction is the process of building derived, aggregate features from a time-series dataset. The features created are designed to characterize the underlying time series in a way that is easier to interpret and often provides a more suitable input to machine-learning algorithms.

Following feature extraction, statistical significance tests between feature and target vectors can be applied. This allows selection of only those features with relevance (in the form of a p-value) as defined by the user.

Feature selection can improve the accuracy of a machine-learning algorithm by

-  Simplifying the models used
-  Shortening the training time needed
-  Mitigating the curse of dimensionality
-  Reducing variance in the dataset to reduce overfitting

!!! tip "Examples"

    Interactive notebook implementations showing examples of the FRESH algorithm used in different applications can be found at :fontawesome-brands-github: [KxSystems/mlnotebooks](https://github.com/KxSystems/mlnotebooks)


## Loading

Load the FRESH library in isolation from the utilities section of the toolkit using

```q
q)\l ml/ml.q
q).ml.loadfile`:fresh/init.q
```


## Data formatting

Data passed to the feature extraction procedure should contain an identifying (ID) column, which groups the time series into subsets from which features can be extracted. The ID column can be inherent to the data or derived for a specific use-case (e.g. applying a sliding window onto the dataset).

Null values in the data should be replaced with derived values most appropriate to the column.

The feature-extraction procedure supports columns of boolean, integer and floating-point types. Other datatypes should not be passed to the extraction procedure.

In particular, data should not contain text (strings or symbols), other than within the ID column. If a text-based feature is thought to be important, one-hot, frequency or lexigraphical encoding can be used to convert the symbolic data to appropriate numerical values.

!!! tip "Formatting"

    A range of formatting functions (e.g. null-filling and one-hot encoding) are supplied in the [preprocessing section](utilities/preproc.md) of the toolkit.


## Calculated features

Feature extraction functions are defined in the script `fresh.q` and found within the `.ml.fresh.feat` namespace.

function                         | returns 
:--------------------------------|:--------------
absenergy[x]                     | Sum of squares
abssumchange[x]                  | Absolute sum of the differences between successive datapoints
aggautocorr[x]                   | Aggregation (mean, median, variance and standard deviation) of an autocorrelation over all possible lags (1 - count[x]) 
agglintrend[x;chunklen]          | Slope, intercept and rvalue for the series over aggregated max, min, variance or average for chunks of size `chunklen`
augfuller[x]                     | Hypothesis test to check for a unit root in series
autocorr[x;lag]                  | Autocorrelation over specified lag
binnedentropy[x;nbins]           | Entropy of the series binned into `nbins` equidistant bins
c3[x;lag]                        | Measure of the non-linearity of the series lagged by `lag`
changequant[x;ql;qh;isabs]       | Aggregated value of successive changes within corridor specified by lower quantile `ql` and upper quantile `qh` (boolean `isabs` defines whether absolute values are considered)
cidce[x;isabs]                   | Measure of series complexity based on peaks and troughs in the dataset (boolean `isabs` defines whether absolute values are considered)
count[x]                         | Number of values within the series
countabovemean[x]                | Number of values in the series with a value greater than the mean
countbelowmean[x]                | Number of values in the series with a value less than the mean
eratiobychunk[x;numsegments]     | Sum of squares of each region of the series split into `numsegments` segments, divided by the sum of squares for the entire series
firstmax[x]                      | Position of the first occurrence of the maximum value in the series relative to the series length 
firstmin[x]                      | Position of the first occurrence of the minimum value in the series relative to the series length
fftaggreg[x]                     | Spectral centroid (mean), variance, skew, and kurtosis of the absolute Fourier-transform spectrum
fftcoeff[x;coeff]                | Fast-Fourier transform `coeff` coefficient, given real inputs and extracting real, imaginary, absolute and angular components
hasdup[x]                        | Boolean: the series contains any duplicate values
hasdupmax[x]                     | Boolean: a duplicate of the maximum value exists in the series
hasdupmin[x]                     | Boolean: a duplicate of the minimum value exists in the series
indexmassquantile[x;q]           | Relative index such that `q`% of the series' mass lies to the left
kurtosis[x]                      | Adjusted G2 Fisher-Pearson kurtosis of the series
largestdev[x;ratio]              | Boolean: the standard deviation is `ratio` times larger than the max - min values of the series
lastmax[x]                       | Position of the last occurrence of the maximum value in the series relative to the series length
lastmin[x]                       | Position of the last occurrence of the minimum value in the series relative to the series length
lintrend[x]                      | Slope, intercept and r-value associated with the series
longstrikegtmean[x]              | Length of the longest subsequence in the series greater than the series mean
longstrikeltmean[x]              | Length of the longest subsequence in the series less than the series mean
max[x]                           | Maximum value of the series
mean[x]                          | Mean value of the series
meanabschange[x]                 | Mean over the absolute difference between subsequent series values
meanchange[x]                    | Mean over the difference between subsequent series values
mean2dercentral[x]               | Mean value of the central approximation of the second derivative of the series
med[x]                           | Median value of the series
min[x]                           | Minimum value of the series
numcrossingm[x;crossval]         | Number of crossings in the series over the value `crossval`
numcwtpeaks[x;width]             | Number of peaks in the series following data smoothing via application of a Ricker wavelet of defined `width`
numpeaks[x;support]              | Number of peaks in the series with a specified `support`
partautocorrelation[x;lag]       | Partial autocorrelation of the series with a specified `lag`
perrecurtoalldata[x]             | Ratio of count of values occurring more than once to count of different values
perrecurtoallval[x]              | Ratio of count of values occurring more than once to count of data
quantile[x;quantile]             | The value of series greater than the `quantile` percent of the ordered series
rangecount[x;minval;maxval]      | The number of values greater than or equal to `minval` and less than `maxval`
ratiobeyondrsigma[x;r]           | Ratio of values more than `r*dev[x]` from the mean
ratiovalnumtserieslength[x]      | Ratio of number of unique values to total number of values
skewness[x]                      | Skew of the series indicating asymmetry within the series
spktwelch[x;coeff]               | Cross power spectral density of the series at given `coeff`
stddev[x]                        | Standard deviation of series
sumrecurringdatapoint[x]         | Sum of all points present in the series more than once
sumrecurringval[x]               | Sum of all the values present within the series more than once
sumval[x]                        | Sum of values within the series
symmetriclooking[x;y]            | Measure of symmetry in the series `|mean(x)-median(x)|-y*(max[x]-min[x])` with y in range 0-&gt;1
treverseasymstat[x;lag]          | Measure of asymmetry of the series based on `lag`
valcount[x;val]                  | Number of occurrences of `val` within the series
var[x]                           | Variance of the series
vargtstdev[x]                    | Boolean: the variance of the dataset is larger than the standard deviation


## Feature extraction

Feature extraction involves applying a set of aggregations to subsets of the initial input data, with the goal of obtaining information that is more informative to the prediction of the target vector than the raw time series. 

The `.ml.fresh.createfeatures` function applies a set of aggregation functions to derive features. There are 57 such functions callable within the `.ml.fresh.feat` namespace, although users may select a subset of these based on requirement.

As of version 0.1.3 the creation of features using the function `.ml.fresh.createfeatures` is invoked at console initialization. If a process is started with `$q -s -4 -p 4321`, then four processes will automatically be used to process feature creation. 


### `.ml.fresh.createfeatures`

_Applies functions to subsets of initial data to create features_

```txt
.ml.fresh.createfeatures[t;aggs;cnames;ptab]
```

Where

-   `t` is the input data in the form of a simple table.
-   `aggs` is the Id column name (syms).
-   `cnames` are the column names (syms) on which extracted features will be calculated (these columns should contain only numerical values).
-   `ptab` is a table containing the functions and parameters to be applied to the `cnames` columns. This should be a modified version of `.ml.fresh.params`

This returns a table keyed by ID column and containing the features extracted from the subset of the data identified by the `id` column.

```q 
m:30;n:100
tab:([]date:raze m#'"d"$til n;
  time:(m*n)#"t"$til m;
  col1:50*1+(m*n)?20;
  col2:(m*n)?1f )
```
```q
q)10#tab
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

q)show ptab:.ml.fresh.params / truncated for documentation purposes 
f              | pnum pnames         pvals                 valid
---------------| -----------------------------------------------
absenergy      | 0    ()             ()                        1    
abssumchange   | 0    ()             ()                        1    
count          | 0    ()             ()                        1    
countabovemean | 0    ()             ()                        1    
countbelowmean | 0    ()             ()                        1    
firstmax       | 0    ()             ()                        1    
firstmin       | 0    ()             ()                        1    
autocorr       | 1    ,`lag          ,0 1 2 3 4 5 6 7 8 9      1    
binnedentropy  | 1    ,`lag          ,2 5 10                   1    
c3             | 1    ,`lag          ,1 2 3                    1    
cidce          | 1    ,`boolean      ,01b                      1    
eratiobychunk  | 1    ,`numsegments  ,3                        1    
rangecount     | 2    `minval`maxval -1 1                      1    
changequant    | 3    `ql`qh`isabs   (0.1 0.2;0.9 0.8;01b)     1    

q)5#cfeats:.ml.fresh.createfeatures[tab;`date;2_ cols tab;ptab]
date      | col1_absenergy col1_abssumchange col1_count col1_countabovemean ..
----------| ----------------------------------------------------------------..
2000.01.01| 1.33e+07       10100             30         13                  ..
2000.01.02| 1.023e+07      11450             30         14                  ..
2000.01.03| 7805000        9200              30         13                  ..
2000.01.04| 8817500        9950              30         17                  ..
2000.01.05| 7597500        7300              30         12                  ..
q)count 1_cols cfeats	/ 595 features have been produced from 2 columns
568

/ update ptab to exclude hyperparameter-dependent functions 
q)show ptabnew:update valid:0b from ptab where pnum>0
f               | pnum pnames         pvals                 valid
----------------| -----------------------------------------------
absenergy       | 0    ()             ()                        1
abssumchange    | 0    ()             ()                        1
count           | 0    ()             ()                        1
countabovemean  | 0    ()             ()                        1
countbelowmean  | 0    ()             ()                        1
firstmax        | 0    ()             ()                        1
firstmin        | 0    ()             ()                        1
autocorr        | 1    ,`lag          ,0 1 2 3 4 5 6 7 8 9      0
binnedentropy   | 1    ,`lag          ,2 5 10                   0
c3              | 1    ,`lag          ,1 2 3                    0
cidce           | 1    ,`boolean      ,01b                      0
eratiobychunk   | 1    ,`numsegments  ,3                        0
rangecount      | 2    `minval`maxval -1 1                      0
changequant     | 3    `ql`qh`isabs   (0.1 0.2;0.9 0.8;01b)     0

q)5#cfeatsnew:.ml.fresh.createfeatures[tab;`date;2_ cols tab;ptabnew]
date      | col1_absenergy col1_abssumchange col1_count col1_countabovemean ..
----------| ----------------------------------------------------------------..
2000.01.01| 1.33e+07       10100             30         13                  ..
2000.01.02| 1.023e+07      11450             30         14                  ..
2000.01.03| 7805000        9200              30         13                  ..
2000.01.04| 8817500        9950              30         17                  ..
2000.01.05| 7597500        7300              30         12                  ..
q)/74 columns now being created via a subset of initial functions
q)count 1_cols cfeatsnew     
92
```

The following functions contain some Python dependency.

```q
fns:`aggautocorr`augfuller`fftaggreg`fftcoeff`numcwtpeaks`partautocorrelation`spktwelch
```

If only q-dependent functions are to be applied, run the following update
command on the `.ml.fresh.params` table.

```q
q)update valid:0b from `.ml.fresh.params where f in fns
```

Modifications to the file `hyperparam.txt` within the FRESH folder allows fine tuning of the number and variety of calculations to be made. Users can create their own features by defining a function within the `.ml.fresh.feat` namespace and, if necessary, providing relevant hyperparameters in `.ml.fresh.params`.

!!! warning "Change from version 0.1"

	The operating principal of this function has changed relative to that in versions `0.1.x`. In the previous version parameter #4 was a dictionary denoting the functions to be applied to the table. This worked well for producing features from functions that only took the data as input (using `.ml.fresh.getsingleinputfeatures`). 

    To account for multi-parameter functions the structure outlined above has been used as it provides more versatility to function application.


## Feature significance

Statistical significance tests can be applied to the derived features to determine how useful each feature is in predicting a target vector. The specific significance test applied, depends on the characteristics of the feature and target. The following table outlines the test applied in each case.

```txt
feature type    target type   significance test 
------------------------------------------------
Binary          Real          Kolmogorov-Smirnov
Binary          Binary        Fisher-Exact      
Real            Real          Kendall Tau-b     
Real            Binary        Kolmogorov-Smirnov
```

Each test returns a p-value, which can then be passed to a selection procedure chosen by the user. The feature selection procedures available at present are as follows;

1. The Benjamini-Hochberg-Yekutieli (BHY) procedure: determines if the feature meets a defined False Discovery Rate (FDR) level. The recommended input is 5% (0.05).
2. K-best features: choose the K features which have the lowest p-values and thus have been determined to be the most important features to allow us to predict the target vector.
3. Percentile based selection: set a percentile threshold for p-values below which features are selected.

Each of these procedures can be implemented by modifying parameter input to the following function;

### `.ml.fresh.significantfeatures`

_Return statistically significant features based on defined selection procedure_

```txt
.ml.fresh.significantfeatures[t;tgt;f]
```

Where

-   `t` is the value side of a table of created features
-   `tgt` is a list of targets corresponding to the rows of table `t` 
-   `f` is a projection with example syntax `.ml.fresh.ksigfeat 10`

returns a list of features deemed statistically significant according to the userdefined procedure within parameter `f`.

```q
q)tgt:value exec avg col2+.001*col2 by date from tab      / combination of col avgs

q)/ BHY procedure with a FDR level of 0.05
q)show sigBH:.ml.fresh.significantfeatures[value cfeats;tgt;.ml.fresh.benjhoch 0.05]
`col2_mean`col2_sumval`col2_fftcoeff_maxcoeff_10_coeff_0_real`col2_fftcoeff_m..

q)/ Extract the top 20 best features
q)show sigK:.ml.fresh.significantfeatures[value cfeats;tgt;.ml.fresh.ksigfeat 20]
`mean_col2`sumval_col2`absenergy_col2`c3_1_col2`c3_2_col2`med_col2`quantile_0..

q)/ Extract the top 5th percentile of created features
q)show sigP:.ml.fresh.significantfeatures[value cfeats;tgt;.ml.fresh.percentile 0.05]
`col2_absenergy`col2_mean`col2_med`col2_skewness`col2_sumval`col2_c3_lag_1`co..

q)/ Check the count of each method to show differences in outputs
q)count each (sigBH;sigK;sigP)
30 20 22
```

!!! warning "Change from version 0.1"

	The input behavior of `.ml.fresh.significantfeatures` has changed to accommodate an increased number of feature-selection methods.


