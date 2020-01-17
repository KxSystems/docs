---
title: Advanced parameter options for the Kx automated machine learning platform
author: Deanna Morgan
description: This document outlines the optional behaviour available within the Kx automated machine learning offering in particular highlighting the affect changing the input parameter dictionary has on common processes completed across all forms of automated machine learning and the differences between offerings
date: October 2019
keywords: machine learning, ml, automated, processing, cross validation, grid search, models
---

# <i class="fas fa-share-alt"></i> Advanced Parameter Options

<i class="fab fa-github"></i> [KxSystems/automl](https://github.com/kxsystems/automl)


The other sections of the automl documentation describe the default behaviour of the platform, where `(::)` is passed in as the parameter dictionary to `.aml.run`. This section will focus on how this final parameter can be modified to apply changes to the default behaviour. There are two options for how this final parameter can be input

1. kdb+ dictionary outlining the changes to default behaviour that are to be made
2. The path to a flat file containing more human readable updates to the parameter set.

Given that both options allow for the same modifications to be made the full list of parameters which can be modified is outlined first and the implementation of each is described at the end of this page.

## Advanced parameters

The following lists the parameters which can be altered by users to modify the functionality of the automl platform. In each case, the parameter name corresponds to the kdb+ dictionary key which would be passed, alongside its user defined value, to the `.aml.run` function in order to update functionality.

```q
Parameters:
  aggcols     Aggregation columns for FRESH
  funcs       Functions to be applied for feature extraction
  gs          Grid search function and associated no. of folds/percentage
  hld         Size of holdout set on which the final model is tested
  saveopt     Saving options outlining what is to be saved to disk from a run
  scf         Scoring functions for classification/regression tasks
  seed        Random seed to be used
  sigfeats    Feature significance procedure to be applied to the data
  sz          Size of test set for train-test split function
  tts         Train-test split function to be applied
  xv          Cross validation function and associated no. of folds/percentage
```

For simplicity, each of these modifications will be handled seperately below with example implementations where possible.

### `aggcols`

_Denotes the columns to be used for aggregations in FRESH_

By default the aggregation column for any FRESH based feature extraction is assumed to be the first column in the dataset. In certain circumstances this may not be sufficient and a more complex aggregation setup may be required as outlined below.

```q
q)uval:100?50
q)tab:([]tstamp:"p"$uval;val:uval;100?1f;100?1f;100?1f)
q)tgt:count[distinct uval]?1f
// In this case we wist to have tstamp and val as aggregation columns
// all other parameters are left as default
q).aml.run[tab;tgt;`fresh;`reg;enlist[`aggcols]!enlist `tstamp`val]
```

### `funcs`

_Denotes the functions that are to be applied for feature extraction_

**FRESH**
By default the feature extraction functions applied for any FRESH based problem are all those contained in `.ml.fresh.params`. This incorporates approximately 60 functions. A user who wishes to augment these functions or choose a subsection therein contained, can do so as seen in the below example.

**Normal**
By default feature extraction in the case of Normal feature extraction procedures is the decomposistion of time/date types into their component parts, this can be augmented by a user to add new functionality. Functions supported are any that take as input a simple table and return a simple table.

```q
q)uval:100?50
q)tab:([]tm:"t"$uval;asc 100?1f;100?1f;100?1f;100?1f)
q)fresh_tgt:count[distinct uval]?1f
q)norm_tgt :asc 100?1f
// Select only functions which take < 1 argument for a FRESH based problem
q).aml.newfuncs:select from .ml.fresh.params where pnum<1
// Run feature extraction using user defined function table for FRESH
q).aml.run[tab;fresh_tgt;`fresh;`reg;enlist[`funcs]!enlist `.aml.newfuncs]
// Run feature extraction on Normal data using a set of functions provided by a user
q)funcs:`.aml.prep.i.truncsvd`.aml.prep.i.bulktransform
q).aml.run[tab;norm_tgt;`normal;`reg;enlist[`funcs]!enlist funcs]
```

!!!Note
	User defined functions should take as input
	
	* x = a simple table

	This function should return a simple table with the feature extraction procedure applied. These features should not augment the number of rows in the dataset as this will result in errors within the pipeline

### `gs`

_Grid search procedure being implemented_

In each case, the default grid search procedure being implemented is a shuffled 5-fold cross validation. This can be augmented by a user for different use cases, for example in the case of applying grid search to time series data.

The input for this parameter is a mixed list containing the grid search function name as a symbol and the number of folds to split the data into

For simplicity of implementation, a user should where possible use the functions within the `.ml.gs` namespace for this task.

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// Roll forward grid search with 6 folds
q)roll_forward:(`.ml.gs.tsrolls;6)
q).aml.run[tab;tgt;`normal;`reg;enlist[`gs]!enlist roll_forward]
```

!!!Warning
        If you intend to add a custom grid search function please follow the guidelines for function definition provided [here](../../../toolkit/xval). If you have any questions on this please contact ai@kx.com. When compared to other custom function definitions within the automl framework this can become a complicated procedure.

### `hld`

_Size of the holdout set on which the best grid searched model is tested_

By default the holdout set across all problem types is set to 20%. For problems with a small number of data points a user may augment this to increase the number of datapoints being trained on 

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// Set holdout set to contain 10% of the dataset
q)hldout:0.1
q).aml.run[tab;tgt;`normal;`reg;enlist[`hld]!enlist hldout]
```


### `saveopt`

_Save options to be used_

By default, the system will save all outputs to disk (reports, images, config file, models). In a case where a user does not wish for all outputs to be saved, there are currently 3 options

1. 0 = Nothing is saved the models will run and display results to console but nothing persisted
2. 1 = Save the model and configuration file only, will not generate a report for the user or any images
3. 2 = Save all possible outputs to disk for the user including reports, images, config and models

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// Save only the minimal outputs
q).aml.run[tab;tgt;`normal;`reg;enlist[`saveopt]!enlist 1]
// No outputs saved
q).aml.run[tab;tgt;`normal;`reg;enlist[`saveopt]!enlist 0]
```


### `scf`

_Scoring functions used in model validation and optimization_

The scoring metric used to calculate the performance of each classifier is defined by this parameter which is a dictionary containing a scoring metric for both regression and classification problems. The default behaviour is to use `.ml.accuracy` for classification tasks and `.ml.mse` for regression tasks. Modifying these may be required in order to correctly optimise a model for a specific use case.

The following functions are supported within the platform at present with the ordering which allows the best model to be chosen displayed below and defined in `code/mdldef/scoring.txt`

```
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

The following is an example implementation

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
q)reg_scf:enlist[`reg]!enlist `.ml.mae
q).aml.run[tab;tgt;`normal;`reg;enlist[`scf]!enlist reg_scf]
```

!!!Note
	If a user wishes to use a custom scoring metric this function must be defined within the central process and added to `code/mdldef/scoring.txt` in order to define how optimisation is completed. This function must take as input

	* x = vector of predicted labels
	* y = vector of true labels

	The function should return the score as defined by the user defined metric.


### `seed`

_The seed which is used to ensure model reruns are consistent_

By default each run of the platform is completed with a 'random' seed derived based on the time of a run. If a user wishes to have more explicit control of this behaviour the seed can be set to a user specified value. This ensures that each run of the platform will return results which are consistent run to run, thus allowing for the impact of modifications to the pipeline to be accurately monitored

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// User defined seed
q)seed:42
q).aml.run[tab;tgt;`normal;`reg;enlist[`seed]!enlist seed]
// Run the workflow again to show run to run consistency
q).aml.run[tab;tgt;`normal;`reg;enlist[`seed]!enlist seed]
```


### `sigfeats`

_Feature significance function to be applied to data to reduce feature set_

By default the system will apply a feature significance test provided within the ML toolkit [here](https://code.kx.com/q/ml/toolkit/fresh/#mlfreshsignificantfeatures). The function uses the 25th percentile of important features based on the p-values returned from a number of statistical tests, comparing each column within the dataset with the target vector. This can be modified by a user as follows

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;asc 100?1f)
q)tgt:desc 100?1f
// Define the function to be applied for feature significance tests
q).aml.newsigfeat:{.ml.fresh.significantfeatures[x;y;.ml.fresh.ksigfeat 2]}
q).aml.run[tab;tgt;`normal;`reg;enlist[`sigfeats]!enlist `.aml.newsigfeat]
```

!!!Note
	The function which replaces the default feature significance tests should take as input

	* x = A simple table
	* y = The target vector

	The return from this function should be a simple table with unimportant features (as deemed by the user) removed.

### `sz`

_Size of the validation set on which the non grid searched best model is tested_

By default the validation set for testing prior to the application of a grid search across all problem types is set to 20%. For problems with a small number of data points a user may wish to modify this to increase the number of datapoints being trained on

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// Set holdout set to contain 10% of the dataset
q)size:0.1
q).aml.run[tab;tgt;`normal;`reg;enlist[`sz]!enlist size]
```


### `tts`

_Function used when splitting the data into training and testing sets_

As described when outlining the default behaviour of the systems [here](../../userguide/preproc) The default functions used for splitting the data into a training and testing set are as follows

Problem Type | Function | Description |
-------------|----------|-------------|
Normal       |.ml.traintestsplit | Shuffle the dataset and split into training and testing set with defined percentage in each
FRESH        |.ml.ttsnonshuff    | Without shuffling, the dataset is split into training and testing set with defined percentage in each to ensure no time leakage

For specific use cases this may not be sufficient, for example if a user wishes to split the data such that an equal distribution of target classes occur in the training and testing sets this could be implemented as in the following example

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?5
q)shuffle:.ml.xv.i.shuffle
q).ml.ttstrat:{[x;y;sz]`xtrain`ytrain`xtest`ytest!raze(x;y)@\:/:r@'shuffle each r:(,'/){x@(0,floor n*1-y)_neg[n]?n:count x}[;sz]each value n@'shuffle each n:group y}
q).aml.run[tab;tgt;`normal;`class;enlist[`tts]!enlist `.ml.ttstrat]
```

!!!Note
	When using a user defined function, it must take the following as input 
	
	* x = A simple table
	* y = The target vector
	* z = the size splitting criteria used (number folds/percentage of data in holdout)
	
	The return from this function should be a dictionary containing keys ``` `xtrain`ytrain`xtest`ytest! ... ``` where the x components are tables containing the split data and y components are the associated target vector components


### `xv`

_Cross validation procedure being implemented_

In each case by default the cross validation procedure being implemented is a 5 fold shuffled cross validation. This can be augmented by a user for different use cases for example more time series specific cross validations. 

The input for this parameter is a mixed list containing the cross validation function name as a symbol and the number of cross validation folds to split the data into.

For simplicity of implementation a user should where possible, should use the functions within the `.ml.xv` namespace for this task.

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// Chain forward cross validation with 3 folds
q)chain:(`.ml.xv.tschain;3)
q).aml.run[tab;tgt;`normal;`reg;enlist[`xv]!enlist chain]
```

!!!Warning
	If you intend to add a custom cross validation function please follow the guidelines for function definition provided [here](../../../toolkit/xval). If you have any questions on this please contact ai@kx.com . When compared to other custom functionality within the automl framework this can become a complicated procedure.

## File based input

In each of the above examples the final parameter input has been a kdb+ dictionary, while this may be the easiest method to modify parameters for some users a more human readable flat-file based version is also provided. The following is an example of a flatfile which can be user modified and passed as a parameter.

```
// Fresh parameter file
aggcols |{first cols x}
params  |.ml.fresh.params
xv      |.ml.xv.kfshuff;5
gs      |.ml.gs.kfshuff;5
prf     |.aml.xv.fitpredict
scf     |class=.ml.accuracy;reg=.ml.mse
seed    |rand_val
saveopt |2
hld     |0.2
tts     |.ml.ttsnonshuff
sz      |0.2

// Normal parameter file
xv      |.ml.xv.kfshuff;5
gs      |.ml.gs.kfshuff;5
prf     |.aml.xv.fitpredict
scf     |class=.ml.accuracy;reg=.ml.mse
seed    |rand_val
saveopt |2
hld     |0.2
tts     |.ml.traintestsplit
sz      |0.2
```

These files can be generated in the folder `code/mdldef/` using the following functions

```q
q).aml.savedefault["fresh_params.txt";`fresh]
q).aml.savedefault["normal_params.txt";`normal]
```

Once modified the function `.aml.run` can be used with one of these files as follows

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
q).aml.run[tab;tgt;`normal;`reg;"normal_params.txt"]
```

## Complex examples

While the above documentation outlines how each parameter can be modified it is important to note that multiple of these parameters can be changed simultaneously. The flat-file based input option is useful for this but the same functionality is possible using a kdb+ dictionary as in the following example

Assume we want to run the following updated parameters in a FRESH use case

1. Seeded run with seed = 100
2. 3-fold sequentially split cross validation and grid search
3. Hold out set of 25%
4. Only save the model and configuration file

```q
q)uval:100?50
q)tab:([]tstamp:"p"$uval;val:uval;100?1f;100?1f;100?1f)
q)tgt:count[distinct uval]?1f
q)key_vals:`seed`hld`saveopt`xv`gs
q)vals:(100;0.25;1;(`.ml.xv.kfsplit;3);(`.ml.gs.kfsplit;3))
q).aml.run[tab;tgt;`fresh;`reg;key_vals!vals]
```
