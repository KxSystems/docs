---
title: FRESH – a feature-extraction and feature-significance toolkit – Machine Learning – kdb+ and q documentation
author: Conor McCarthy
description: Feature extraction and selection are vital components of many machine-learning pipelines. Here we outline an implementation of the FRESH (FeatuRe Extraction and Scalable Hypothesis testing) algorithm.
date: August 2018
---
# :fontawesome-solid-share-alt: FRESH: a feature-extraction and feature-significance toolkit

<div markdown="1" class="typewriter">
.ml.fresh **Feature extraction and significance**

\  [.ml.fresh.createFeatures](#mlfreshcreateFeatures)       Apply functions to subsets of initial data 
                                 to create features
\  [.ml.fresh.significantFeatures](#mlfreshsignificantFeatures)   Statistically significant features
</div>

:fontawesome-brands-github: [KxSystems/ml](https://github.com/kxsystems/ml)

Feature extraction and selection are vital components of many machine-learning pipelines. Here we outline an implementation of the [FRESH](https://arxiv.org/pdf/1610.07717v3.pdf) (FeatuRe Extraction and Scalable Hypothesis testing) algorithm.

Feature extraction is the process of building derived, aggregate features from a time-series dataset. The features created are designed to characterize the underlying time series in a way that is easier to interpret and often provides a more suitable input to machine-learning algorithms.

Following feature extraction, statistical significance tests between feature and target vectors can be applied. This allows selection of only those features with relevance (in the form of a p-value) as defined by the user.

Feature selection can improve the accuracy of a machine-learning algorithm by

-  Simplifying the models used
-  Shortening the training time needed
-  Mitigating the curse of dimensionality
-  Reducing variance in the dataset to reduce overfitting

!!! example ":fontawesome-brands-github: [Notebook examples](https://github.com/KxSystems/mlnotebooks) of the FRESH algorithm used in different applications"


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

!!! tip "A range of formatting functions (e.g. null-filling and one-hot encoding) are supplied in the [preprocessing section](utilities/preproc.md) of the toolkit"


## Calculated features

Feature extraction functions are defined in the script `fresh.q` and found within the `.ml.fresh.feat` namespace.

function                         | returns 
:--------------------------------|:--------------
absEnergy[data]                               | Sum of squares
absSumChange[data]                            | Absolute sum of the differences between successive datapoints
aggAutoCorr[data]                             | Aggregation (mean, median, variance and standard deviation) of an autocorrelation over all possible lags (1 - count[x]) 
aggLinTrend[data;chunkLen]                    | Slope, intercept and rvalue for the series over aggregated max, min, variance or average for chunks of size `chunklen`
augFuller[data]                               | Hypothesis test to check for a unit root in series
autoCorr[data;lag]                            | Autocorrelation over specified lag
binnedEntropy[data;numBins]                   | Entropy of the series binned into `nbins` equidistant bins
c3[data;lag]                                  | Measure of the non-linearity of the series lagged by `lag`
changeQuant[data;lowerQuant;upperQuant;isAbs] | Aggregated value of successive changes within corridor specified by lower quantile `lowerQuant` and upper quantile `upperQuant` (boolean `isAbs` defines whether absolute values are considered)
cidCe[data;isAbs]                             | Measure of series complexity based on peaks and troughs in the dataset (boolean `isAbs` defines whether absolute values are considered)
count[data]                                   | Number of values within the series
countAboveMean[data]                          | Number of values in the series with a value greater than the mean
countBelowMean[data]                          | Number of values in the series with a value less than the mean
eRatioByChunk[data;numSeg]                    | Sum of squares of each region of the series split into `numsegments` segments, divided by the sum of squares for the entire series
firstMax[data]                                | Position of the first occurrence of the maximum value in the series relative to the series length 
firstMin[data]                                | Position of the first occurrence of the minimum value in the series relative to the series length
fftAggReg[data]                               | Spectral centroid (mean), variance, skew, and kurtosis of the absolute Fourier-transform spectrum
fftCoeff[data;coeff]                          | Fast-Fourier transform `coeff` coefficient, given real inputs and extracting real, imaginary, absolute and angular components
hasDup[data]                                  | Boolean: the series contains any duplicate values
hasDupMax[data]                               | Boolean: a duplicate of the maximum value exists in the series
hasDupMin[data]                               | Boolean: a duplicate of the minimum value exists in the series
indexMassQuantile[data;quantile]              | Relative index such that `q`% of the series' mass lies to the left
kurtosis[data]                                | Adjusted G2 Fisher-Pearson kurtosis of the series
largestDev[data;ratio]                        | Boolean: the standard deviation is `ratio` times larger than the max - min values of the series
lastMax[data]                                 | Position of the last occurrence of the maximum value in the series relative to the series length
lastMin[data]                                 | Position of the last occurrence of the minimum value in the series relative to the series length
linTrend[data]                                | Slope, intercept and r-value associated with the series
longStrikeAboveMean[data]                     | Length of the longest subsequence in the series greater than the series mean
longStrikeBelowMean[data]                     | Length of the longest subsequence in the series less than the series mean
max[data]                                     | Maximum value of the series
mean[data]                                    | Mean value of the series
meanAbsChange[data]                           | Mean over the absolute difference between subsequent series values
meanChange[data]                              | Mean over the difference between subsequent series values
mean2DerCentral[data]                         | Mean value of the central approximation of the second derivative of the series
med[data]                                     | Median value of the series
min[data]                                     | Minimum value of the series
numCrossing[data;crossVal]                    | Number of crossings in the series over the value `crossval`
numCwtPeaks[data;width]                       | Number of peaks in the series following data smoothing via application of a Ricker wavelet of defined `width`
numPeaks[data;support]                        | Number of peaks in the series with a specified `support`
partAutoCorrelation[data;lag]                 | Partial autocorrelation of the series with a specified `lag`
perRecurToAllData[data]                       | Ratio of count of values occurring more than once to count of different values
perRecurToAllVal[data]                        | Ratio of count of values occurring more than once to count of data
quantile[data;quantile]                       | The value of series greater than the `quantile` percent of the ordered series
rangeCount[data;minVal;maxVal]                | The number of values greater than or equal to `minval` and less than `maxval`
ratioBeyondRSigma[data;r]                     | Ratio of values more than `r*dev[x]` from the mean
ratioValNumToSeriesLength[data]               | Ratio of number of unique values to total number of values
skewness[data]                                | Skew of the series indicating asymmetry within the series
spktWelch[data;coeff]                         | Cross power spectral density of the series at given `coeff`
stdDev[data]                                  | Standard deviation of series
sumRecurringDataPoint[data]                   | Sum of all points present in the series more than once
sumRecurringVal[data]                         | Sum of all the values present within the series more than once
sumVal[data]                                  | Sum of values within the series
symmetricLooking[data;ratio]                  | Measure of symmetry in the series `|mean(x)-median(x)|-y*(max[x]-min[x])` with y in range 0-&gt;1
treverseAsymStat[data;lag]                    | Measure of asymmetry of the series based on `lag`
valCount[data;val]                            | Number of occurrences of `val` within the series
var[data]                                     | Variance of the series
varAboveStdDev[data]                          | Boolean: the variance of the dataset is larger than the standard deviation

!!! warning "Some of the above functions are deprecated"

    They are still callable but will be removed after version 3.0.

## Feature extraction

Feature extraction involves applying a set of aggregations to subsets of the initial input data, with the goal of obtaining information that is more informative to the prediction of the target vector than the raw time series. 

The `.ml.fresh.createFeatures` function applies a set of aggregation functions to derive features. There are 57 such functions callable within the `.ml.fresh.feat` namespace, although users may select a subset of these based on requirement.

As of version 0.1.3 the creation of features using the function `.ml.fresh.createFeatures` is invoked at console initialization. If a process is started with `$q -s -4 -p 4321`, then four processes will automatically be used to process feature creation. 


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

---


## `.ml.fresh.createFeatures`

_Apply functions to subsets of initial data to create features_

```txt
.ml.fresh.createFeatures[data;idCol;cols2Extract;params]
```

Where

-   `data` is the input data in the form of a simple table.
-   `idCol` is the ID column name (syms).
-   `cols2Extract` are the column names (syms) on which extracted features will be calculated (these columns should contain only numerical values).
-   `params` is a table containing the functions/parameters to be applied to cols2Extract. This should be a modified version of `.ml.fresh.params`

returns a table keyed by ID column and containing the features extracted from the subset of the data identified by the `ID` column.

```q 
q)m:30;n:100
q)tab:([]date:raze m#'"d"$til n;
  time:(m*n)#"t"$til m;
  col1:50*1+(m*n)?20;
  col2:(m*n)?1f )
q)10#tab
date       time         col1 col2       
----------------------------------------
2000.01.01 00:00:00.000 450  0.6859514  
2000.01.01 00:00:00.001 150  0.009530776
2000.01.01 00:00:00.002 500  0.3867134  
2000.01.01 00:00:00.003 750  0.04674769 
2000.01.01 00:00:00.004 1000 0.06310223 
2000.01.01 00:00:00.005 200  0.5888565  
2000.01.01 00:00:00.006 250  0.302542   
2000.01.01 00:00:00.007 1000 0.7859634  
2000.01.01 00:00:00.008 250  0.9453783  
2000.01.01 00:00:00.009 650  0.9575708  

q)show params:.ml.fresh.params / truncated for documentation purposes 
f                  | pnum pnames     pvals                valid
-------------------| ------------------------------------------
absEnergy          | 0    ()         ()                   1    
absSumChange       | 0    ()         ()                   1    
aggAutoCorr        | 0    ()         ()                   1    
augFuller          | 0    ()         ()                   1    
count              | 0    ()         ()                   1    
countAboveMean     | 0    ()         ()                   1    
countBelowMean     | 0    ()         ()                   1  
sumVal             | 0    ()         ()                   1    
var                | 0    ()         ()                   1    
varAboveStdDev     | 0    ()         ()                   1    
aggLinTrend        | 1    ,`chunkLen ,5 10 50             1    
autoCorr           | 1    ,`lag      ,0 1 2 3 4 5 6 7 8 9 1    
binnedEntropy      | 1    ,`numBins  ,2 5 10              1    
c3                 | 1    ,`lag      ,1 2 3               1    

q)5#feats:.ml.fresh.createFeatures[tab;`date;2_ cols tab;params]
date      | col1_absEnergy col1_absSumChange col1_count col1_..
----------| -------------------------------------------------..
2000.01.01| 1.1385e+07     11400             30         16   ..
2000.01.02| 1.0455e+07     9500              30         15   ..
2000.01.03| 1.31825e+07    9500              30         17   ..
2000.01.04| 1.1515e+07     10600             30         13   ..
2000.01.05| 9492500        8800              30         16   ..
q)count 1_cols feats	/ 595 features have been produced from 2 columns
566

// Update ptab to exclude hyperparameter-dependent functions 
q)paramsNew:update valid:0b from params where pnum>0

q)5#featsNew:.ml.fresh.createFeatures[tab;`date;2_ cols tab;paramsNew]
date      | col1_absEnergy col1_absSumChange col1_count col1_..
----------| -------------------------------------------------..
2000.01.01| 1.1385e+07     11400             30         16   ..
2000.01.02| 1.0455e+07     9500              30         15   ..
2000.01.03| 1.31825e+07    9500              30         17   ..
2000.01.04| 1.1515e+07     10600             30         13   ..
2000.01.05| 9492500        8800              30         16   ..
// Less columns now being created via a subset of initial functions
q)count 1_cols featsNew     
92
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.fresh.createfeatures`.
    That is still callable but will be removed after version 3.0.

The following functions contain some Python dependency.

```q
funcs:`aggAutoCorr`augFuller`fftAggReg`fftCoeff`numCwtPeaks`partAutoCorrelation`spktWelch
```

If only q-dependent functions are to be applied, run the following update
command on the `.ml.fresh.params` table.

```q
q)update valid:0b from `.ml.fresh.params where f in funcs
```

Modifications to the file `hyperparameters.json` within the FRESH folder allows fine tuning of the number and variety of calculations to be made. Users can create their own features by defining a function within the `.ml.fresh.feat` namespace within `feat.q` and, if necessary, providing relevant hyperparameters in `.ml.fresh.params`.


## `.ml.fresh.significantFeatures`

_Statistically significant features based on defined selection procedure_

```txt
.ml.fresh.significantFeatures[tab;target;func]
```

Where

-   `tab` is the value side of a table of created features
-   `target` is a list of targets corresponding to the rows of table `tab` 
-   `func` is a projection with example syntax `.ml.fresh.kSigFeat 10`

returns a list of features deemed statistically significant according to the user defined procedure within parameter `func`.

```q
// Combination of col avgs
q)target:value exec avg col2+.001*col2 by date from tab   

// BHY procedure with a FDR level of 0.05
q)show sigBH:.ml.fresh.significantFeatures[value feats;target;.ml.fresh.benjhoch 0.05]
`col2_mean`col2_sumVal`col2_fftCoeff_coeff_10_coeff_0_real`col2_fftCoeff_coef..

// Extract the top 20 best features
q)show sigK:.ml.fresh.significantFeatures[value feats;target;.ml.fresh.kSigFeat 20]
`col2_mean`col2_sumVal`col2_fftCoeff_coeff_10_coeff_0_real`col2_fftCoeff_coef..

// Extract the top 5th percentile of created features
q)show sigP:.ml.fresh.significantFeatures[value feats;target;.ml.fresh.percentile 0.05]
`col2_absEnergy`col2_mean`col2_med`col2_skewness`col2_sumVal`col2_c3_lag_1`co..

// Check the count of each method to show differences in outputs
q)count each (sigBH;sigK;sigP)
30 20 22
```

!!! warning "Deprecated"

    Earlier versions of this function were defined as `.ml.fresh.significantfeatures` and `.ml.fresh.ksigfeat`.

    They are still callable but will be removed after version 3.0.

