---
title: Advanced parameter options for the Kx automated machine learning platform
author: Deanna Morgan
description: This document outlines the optional behaviour available within the Kx automated machine learning offering in particular highlighting the affect changing the input parameter dictionary has on common processes completed across all forms of automated machine learning and the differences between offerings
date: October 2019
keywords: machine learning, ml, automated, processing, cross validation, grid search, models
---

# <i class="fas fa-share-alt"></i> Advanced Parameter Options

<i class="fab fa-github"></i> [KxSystems/automl](https://github.com/kxsystems/automl)


The other sections of the automl documentation describe the default behaviour of the platform, where `(::)` is passed in as the parameter dictionary to `.aml.runexample`. This section will focus on how this final parameter can be modified to input changes to the default behaviour. There are two options for how this final parameter can be input

1. kdb+ dictionary outlining the changes to default behaviour that are to be made
2. The path to a flat file containing more human readable updates to the parameter set.

Given that both options allow for the same modifications to be made the full list of parameters which can be modified is outlined first and the implementation of each is described at the end of this page.

## Advanced parameters

The following are all the parameters which can be modified by a user to modify the functionality of the automl platform. In each case the parameter name corresponds to the kdb+ key which would be passed to the function to update the functionality.

```q
Parameters:
  aggcols     Aggregation columns for FRESH
  params      Functions to be applied for FRESH feature extraction
  hld         Size of holdout set on which the final model is tested
  tts         Train-test split function to be applied
  sz          Size of test set for train-test split function
  seed        Random seed to be used
  xv          Cross validation function and associated no. of folds/percentage
  scf         Scoring functions for classification/regression tasks
  gs          Grid search function and associated no. of folds/percentage
  saveopt     Saving options outlining what is to be saved to disk from a run
```

For simplicity each of these modifications will be handled seperately with, where possible example implementations provided

### `aggcols`

_Denotes the columns to be used for aggregations in FRESH_

By default the aggregation column for any FRESH based feature extraction is assumed to be the first column in the dataset, in certain circumstances this may not be sufficient and a more complex aggregation setup may be required as outlined below.

```q
q)uval:100?50
q)tab:([]tstamp:"p"$uval;val:uval;100?1f;100?1f;100?1f)
q)tgt:count[distinct uval]?1f
// In this case we wist to have tstamp and val as aggregation columns
// all other parameters are left as default
q).aml.run[tab;tgt;`fresh;`reg;enlist[`aggcols]!enlist `tstamp`val]
```

### `params`

_Denotes the functions that are to be applied to features when using FRESH_

By default the feature extraction functions applied for any FRESH based problem are all those contained in `.ml.fresh.params`. This incorporates approximately 60 functions. If a user wishes to augment these functions or choose a subsection of them this can be completed as follows

```q
q)uval:100?50
q)tab:([]tstamp:"p"$uval;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:count[distinct uval]?1f
// Select only functions to apply which take < 1 argument
q).aml.newfuncs:select from .ml.fresh.params where pnum<1
// Run feature extraction using user defined function table
q).aml.run[tab;tgt;`fresh;`reg;enlist[`params]!enlist `.aml.newfuncs]
```

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

### `tts`

_Function used when splitting the data into training and testing sets_

As described when outlining the default behaviour of the systems [here](../../userguide/preproc) The default functions used for splitting the data into a training and testing set are as follows

Problem Type | Function | Description |
-------------|----------|-------------|
Normal       |.ml.traintestsplit | Shuffle the dataset and split into training and testing set with defined percentage in each
FRESH        |.ml.ttsnonshuff    | Without shuffling the dataset split into training and testing set with defined percentage in each to ensure no time leakage

For specific use cases this may not be sufficient, for example if a user wishes to split the data such that a equal distribution of target classes occur in the training and testing sets this could be implemented as in the following example

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?5
q)shuffle:.ml.xv.i.shuffle
q).ml.ttstrat:{[x;y;sz]`xtrain`ytrain`xtest`ytest!raze(x;y)@\:/:r@'shuffle each r:(,'/){x@(0,floor n*1-y)_neg[n]?n:count x}[;sz]each value n@'shuffle each n:group y}
q).aml.run[tab;tgt;`normal;`class;enlist[`tts]!enlist `.ml.ttstrat]
```

!!!Note
	In this case the user defined function must take as input the dataset, target vector and size of the split between training and testing sets. It must also return a dictionary containing ````xtrain`ytrain`xtest`ytest! ... ``` to ensure consistency with the rest of the workflow

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

### `seed`

_The seed which is used to ensure model reruns are consistent_

By default each run of the platform is completed with a 'random' seed derived based on the time of a run. If a user wishes to have more explicit control of this behaviour the seed can be set to a user specified value. This allows ensures that each run of the platform will return results which are consistent run to run thus allowing for the impact of modifications to the pipeline to be accurately monitored

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// User defined seed
q)seed:42
q).aml.run[tab;tgt;`normal;`reg;enlist[`seed]!enlist seed]
// Run the workflow again to show run to run consistency
q).aml.run[tab;tgt;`normal;`reg;enlist[`seed]!enlist seed]
```

### `xv`

_Cross validation procedure being implemented_

In each case by default the cross validation procedure being implemented is a 5 fold shuffled cross validation. This can be augmented by a user for different use cases for example more time series specific cross validations. 

The input for this parameter is a mixed list containing the cross validation function name as a symbol and the number of cross validation folds to split the data into

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// Chain forward cross validation with 3 folds
q)chain:(`.ml.xv.tschain;3)
q).aml.run[tab;tgt;`normal;`reg;enlist[`xv]!enlist chain]
```

### `scf`

_Scoring functions used in model validation and optimization_

The scoring metric used to calculate the performance of each classifier is defined by this parameter which is a dictionary containing a scoring metric for both regression and classification problems. The default behaviour is to use `.ml.accuracy` for classification tasks and `.ml.mse` for regression tasks. Modifying these may be required in order to correctly optimise a model for a specific use case. 

The following functions are supported within the platform at present with the ordering which allows the best model to be chosen are displayed below and defined in `code/mdldef/scoring.txt`

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

### `gs`

_Grid search procedure being implemented_

In each case by default the grid search procedure being implemented is a 5 fold shuffled cross validation. This can be augmented by a user for different use cases for example more time series specific grid searches. 

The input for this parameter is a mixed list containing the grid search function name as a symbol and the number of folds to split the data into

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// Roll forward grid search with 6 folds
q)roll_forward:(`.ml.gs.tsrolls;6)
q).aml.run[tab;tgt;`normal;`reg;enlist[`gs]!enlist roll_forward]
```

### `saveopt`

_Save options to be used_

By default the system will save all outputs to disk (reports, images, config file, models). In a case a user does not wish for all outputs to be saved there are currently 3 options

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
