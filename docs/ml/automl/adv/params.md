---
title: Advanced parameter options for the Kx automated machine learning platform
author: Deanna Morgan
description: This document outlines the optional behaviour available within the Kx automated machine learning offering in particular highlighting the affect changing the input parameter dictionary has on common processes completed across all forms of automated machine learning and the differences between offerings
date: October 2019
keywords: machine learning, ml, automated, processing, cross validation, grid search, models
---

# <i class="fas fa-share-alt"></i> Advanced Parameter Options

<i class="fab fa-github"></i>
[KxSystems/automl](https://github.com/kxsystems/automl)


The other sections of the automl documentation describe the default behaviour of the platform, where `(::)` is passed in as the parameter dictionary to `.aml.runexample`. This section will focus on the options available within the parameter dictionary and how these affect the overall behaviour of the pipeline if changed by the user. The specific parameters are detailed below.

```q
Parameters:
  aggcols     Aggregation columns for FRESH
  params      Parameter dictionary for FRESH
  hld         Size of holdout set
  tts         Train-test split function
  sz          Size of test set for train-test split function
  seed        Random seed
  xv          Mixed list containing cross validation function and associated no. of folds/percentage
  scf         Dictionary of scoring functions for both class/reg tasks
  gs          Mixed list containing grid search function and associated no. of folds/percentage
  saveopt     Number of outputs (images, plots, reports)
```

This section will be cover the behaviour contained within processing and post-processong which is altered by changing the values of the parameter dictionary. 

## Outline of Procedures

__Processing__:

1. FRESH parameters and aggregation columns
2. Size, number of folds and type of datasplit
3. Random seeding
4. Type of cross validation and scoring metric to apply
5. Type of grid search

__Post-processing__:

1. Output options following model selection

### Processing

#### FRESH

When FRESH feature extraction is used, both the aggregation columns and FRESH parameter table can be altered by the user. In the default configuration, the first column is always taken as the aggregation column, as shown below.

```q
q)5#tb1:([]asc 1000?"d"$til 50;1000?1f;1000?1f;1000?1f;1000?10;1000?`a`b`c)
x          x1         x2         x3        x4 x5
------------------------------------------------
2000.01.01 0.18956    0.01199094 0.8203575 5  a 
2000.01.01 0.08331423 0.346107   0.3022948 1  a 
2000.01.01 0.104807   0.9722498  0.8909094 5  c 
2000.01.01 0.30073    0.09336937 0.8399883 9  b 
2000.01.01 0.3847399  0.2896479  0.7630746 7  c 
// binary classification problem
q)tgt1:50?0b
// default parameters
q).aml.runexample[tb1;tgt1;`fresh;`class;::]
```

This can be changed by the user, as long as the number of distinct entries in the aggregation columns match the number of distinct target values. In the example below, a second aggregation column and new target vector are defined. The new aggregation columns are passed in under the dictionary parameter `aggcols`.

```q
q)5#tb2:([]asc 1000?"d"$til 50;asc 1000?5?0t;1000?1f;1000?1f;1000?1f;1000?10;1000?`a`b`c)
x          x1           x2         x3         x4        x5 x6
-------------------------------------------------------------
2000.01.01 07:27:55.433 0.1872061  0.2627136  0.1187479 4  a 
2000.01.01 07:27:55.433 0.6790457  0.467528   0.3508021 1  c 
2000.01.01 07:27:55.433 0.2163943  0.6746799  0.7759487 1  a 
2000.01.01 07:27:55.433 0.9159549  0.04129306 0.9215819 1  a 
2000.01.01 07:27:55.433 0.04729689 0.8410767  0.95253   9  b 
// count distinct entries to define target
q)count distinct flip tb2`x`x1
54
// define new target
q)tgt2:54?0b
// pass in new aggcols
q).aml.runexample[tb2;tgt2;`fresh;`class;enlist[`aggcols]!enlist`x`x1]
```

To change the FRESH parameters, the user must create a keyed table with the same format as `.ml.fresh.params`, used in the default configuration, and pass this in as the value for `params` in the dictionary argument. Below is an example of doing so, where the original FRESH parameter table has been altered to only include those function with at least one parameter. Note that `tb1` and `tgt1` have been used from the previous example.

```q
// default parameters
q).aml.runexample[tb1;tgt1;`fresh;`class;::]
...
Total features being passed to the models = 369
...
// user defined FRESH parameters
q)newparam:update valid:0b from .ml.fresh.params where pnum>0
q).aml.runexample[tb1;tgt1;`fresh;`class;enlist[`params]!enlist newparam]
...
Total features being passed to the models = 64
...
```

#### Train-Test Split

As described in the [processing](https://code.kx.com/v2/ml/automl/userguide/proc/) section of the automl documentation, the default configuration uses 20% of the overall dataset as the holdout set, 20% of the remaining dataset as the validation set and splits the remaining data into 5-folds for cross validation, shown below.

<img src="../../userguide/img/5fold.png">

This is achieved by passing `::` as the dictionary argument to `runexample`:
```q
q).aml.runexample[tb;tgt;feat_typ;prob_typ;::]
```

This data split can be altered by changing values of parameters within the input dictionary, namely `hld`, `sz` and `xv`/`gs`:

-   `hld` determines the size of the holdout set
-   `sz` determines the size of the validation set
-   `xv` and `gs` are mixed lists containing cross validation and grid search functions and their associated value of k or a percentage (described in more detail in the [Cross Validation](#### Cross Validation) and [Grid Search](####Grid Search) sections below).

For example, the user could choose to pass in the below parameters for the dictionary:

```q
q).aml.runexample[tb;tgt;`fresh;`class;`hld`sz`xv`gs!(.3;.1),2#enlist(`kfshuff;3)]
```

This will split the data in the below fashion, where there 3-fold cross validation and grid search, a 10% validation set and a 30% holdout set.

<img src="../../userguide/img/3fold.png">

There is also the ability to change the type of splitting function used by changing the parameter `tts`. The example below shows how to use the user defined function `tts_strat`, which ensures that data from each class appears in each data split, compared to the default `.ml.traintestsplit`.

```q
q)5#tb:([]asc 100?0t;100?1f;100?1f;100?10;100?0x;100?(5?1f;5?1f);asc 100?10?`1)
x            x1         x2        x3 x4 x5                                                x6
--------------------------------------------------------------------------------------------
00:05:47.306 0.4520729  0.315151  1  00 0.2437381 0.8423177 0.7056326 0.81604  0.01814654 c 
00:09:13.781 0.07141803 0.6559971 5  00 0.1778226 0.4928689 0.6004873 0.390837 0.6876976  c 
00:18:32.674 0.2531992  0.4942834 5  00 0.2437381 0.8423177 0.7056326 0.81604  0.01814654 c 
00:37:24.732 0.1876413  0.3317289 7  00 0.1778226 0.4928689 0.6004873 0.390837 0.6876976  c 
00:50:11.909 0.9072513  0.8600681 1  00 0.2437381 0.8423177 0.7056326 0.81604  0.01814654 c 
// multi-class classification problem
q)tgt:asc 100?10?`1
// default configuration
q).aml.runexample[tb;tgt;`normal;`class;::]
...
 Test set does not contain examples of each class. Removed MultiKeras from models
...
Scores for all models, using .ml.accuracy
KNeighborsClassifier      | 0.8576923
GradientBoostingClassifier| 0.7807692
RandomForestClassifier    | 0.7807692
MLPClassifier             | 0.7
AdaBoostClassifier        | 0.45
...
// run with user defined parameters
q)tts_strat:{[x;y;sz]`xtrain`ytrain`xtest`ytest!raze(x;y)@\:/:r@'i.shuffle each r:(,'/){x@(0,floor n*1-y)_neg[n]?n:count x}[;.2]each value n@'i.shuffle each n:group y}
q)i.shuffle:{neg[n]?n:count x}
q).aml.runexample[tb;tgt;`normal;`class;enlist[`tts]!enlist tts_strat]
...
Scores for all models, using .ml.accuracy
RandomForestClassifier    | 0.9151515
GradientBoostingClassifier| 0.8621212
KNeighborsClassifier      | 0.8090909
MLPClassifier             | 0.6893939
AdaBoostClassifier        | 0.5530303
MultiKeras                | 0.03484848
...
```

As the user defined splitting function ensures that each class appears in every data split, Keras models are not removed, which is seen for the default case in the above example.

#### Random Seed

... doesn't work just now - look at having random unless seed passed ...

#### Cross Validation

The methods of cross validation available within the ML-Toolkit and thus the automl platform are listed below. In the default configuration, `kfshuff` is used with 5-folds.

```q
.ml.xv - Cross-validation functions
  .kfshuff     K-Fold cross validation with randomized indices
  .kfsplit     K-Fold cross validation with sequential indices
  .kfstrat     K-Fold cross validation with stratified indices
  .mcsplit     Monte-Carlo cross validation with random split indices
  .pcsplit     Percentage-split cross validation
  .tschain     Chain-forward cross validation
  .tsrolls     Roll-forward cross validation
```

!!!note
        For time-dependent datasets, users should consider splitting data using either `.ml.xv.tschain` or `.ml.xv.tsrolls` (explained in depth in the [ML-Toolkit documentation](https://code.kx.com/v2/ml/toolkit/xval/)).

Users can specify the type of cross validation using the `xv` parameter, where the default is `.ml.xv.kfshuff`.

The scoring metric used to calculate the performance of each classifier is defined by the `scf` parameter, a dictionary containing a scoring metric for both regression and classification problems. The default value for `scf` has the form:

```q
q)`class`reg!(`.ml.accuracy;`.ml.mse)
```

The options currently available within the ML-Toolkit are detailed below, accompanied by the function used to order the scores within the pipeline.

```q
.ml - Statistical analysis metrics with automl score order
  .accuracy         Accuracy of classification results        desc
  .crossentropy     Categorical cross entropy                 asc
  .f1score          F1-score on classification results        desc
  .fbscore          Fbeta-score on classification results     desc
  .logloss          Logarithmic loss                          asc
  .mae              Mean absolute error                       asc
  .mape             Mean absolute percentage error            desc
  .matcorr          Matthews correlation coefficient          desc
  .mse              Mean square error                         asc
  .precision        Precision of a binary classifier          desc
  .rmse             Root mean square error                    asc
  .rmsle            Root mean square logarithmic error        asc
  .r2score          R2-score                                  desc
  .sensitivity      Sensitivity of a binary classifier        desc
  .smape            Symmetric mean absolute error             desc
  .specificity      Specificity of a binary classifier        desc
  .sse              Sum squared error                         asc
```

#### Grid Search

The methods of grid search available within the ML-Toolkit and thus the automl platform are listed below. In the default configuration, `kfshuff` is used with 5-folds.

```q
.ml.gs - Grid-search functions
  .kfshuff            K-Fold cross validation with randomized indices
  .kfsplit            K-Fold cross validation with sequential indices
  .kfstrat            K-Fold cross validation with stratified indices
  .mcsplit            Monte-Carlo cross validation with random split indices
  .pcsplit            Percentage-split cross validation
  .tschain            Chain-forward cross validation
  .tsrolls            Roll-forward cross validation
```

As shown in the [Train-Test Split](####Train-Test Split) section, to change the cross validation or grid search functionality and associated parameter, a mixed list must be passed in as the dictionary parameter. In the below example, `.ml.xv.kfsplit` is used to perform cross validation with 4-folds, while `.ml.gs.mcsplit` is used to perform grid search with an 80-20% split. The performance metrics have also been changed, using `.ml.r2score` as the metric for the classification problem.

```q
q)5#tb:([]asc 1000?"d"$til 50;1000?1f;1000?1f;1000?1f;1000?10;1000?`a`b`c)
x          x1        x2        x3        x4 x5
----------------------------------------------
2000.01.01 0.4216349 0.6297507 0.85339   5  b 
2000.01.01 0.6329419 0.5618693 0.7169903 6  c 
2000.01.01 0.1959696 0.725458  0.514287  5  b 
2000.01.01 0.121249  0.4265559 0.9040834 6  c 
2000.01.01 0.4664259 0.3213726 0.3438525 7  c 
// classification problem
q)tgt:50?0b
// change xval, gsearch and scoring metric
q).aml.runexample[tb;tgt;`fresh;`class;`xv`gs`scf!((`kfsplit;4);(`mcsplit;.2);enlist[`class]!enlist`.ml.r2score)]
...
Scores for all models, using .ml.r2score
...
```

### Post-Processing

#### Outputs

Continuing on from the above example, this section will demonstrate the possible outputs available within the pipeline. Outputs can be altered by the user by changing the `saveopt` parameter, where the default has ```enlist[`saveopt]!enlist 2``` and saves the report, plots, models and parameters outlined in the [processing](link) section of the documentation.

The expected output in the default case is as follows:

```q
q).aml.runexample[tb;tgt;`fresh;`class;::]
...
Feature impact calculated for features associated with LinearSVC model - 
see img folder in current directory for results

The best model has been selected as LinearSVC, continuing to grid-search and final model fitting on holdout set

Grid search/final model fitting now completed the final score on the holdout set was: 0.8
Now saving down a report on this run to Outputs/2019.10.22/Run_16:22:35.777/Reports/

Saving to pdf has been completed
"LinearSVC model saved to /home/deanna/automl/Outputs/2019.10.22/Run_16:22:35..
```

This can be altered to save nothing at all (`0`), just the model (`1`) or everything (matching the default, `2`).

```q
// save nothing
q).aml.runexample[tb;tgt;`fresh;`class;enlist[`saveopt]!enlist 0]
...
The best model has been selected as LinearSVC, continuing to grid-search and final model fitting on holdout set

Grid search/final model fitting now completed the final score on the holdout set was: 0.8

// save model
q).aml.runexample[tb;tgt;`fresh;`class;enlist[`saveopt]!enlist 1]
...
The best model has been selected as LinearSVC, continuing to grid-search and final model fitting on holdout set

Grid search/final model fitting now completed the final score on the holdout set was: 0.8
"LinearSVC model saved to /home/deanna/automl/Outputs/2019.10.22/Run_16:22:17..
```
