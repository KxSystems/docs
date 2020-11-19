---
title: Advanced options for automated machine-learning | Machine Learning | Documentation for q and kdb+
author: Deanna Morgan
description: Optional behavior available from the Kx automated machine learning platform; the effect of changing the input parameters
date: March 2020
keywords: machine learning, ml, automated, processing, cross validation, grid search, models
---
# :fontawesome-solid-share-alt: Advanced options


:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl)

The other sections of the AutoML documentation describe the default behavior of the platform, where `(::)` is passed in as the final parameter to `.automl.run`. This section will focus on how this final parameter can be modified to apply changes to the default behavior. The two methods to complete this based on modifiying the final parameter with

1. q dictionary outlining the changes to default behavior that are to be made
2. The path to a flat file containing human-readable updates to the parameter set.

Given that both options allow for the same modifications to be made, the full list of parameters which can be modified are outlined here first and an implementation of each is described at the end of this page.


## Parameters

The following lists the parameters which can be altered by users to modify the functionality of the AutoML platform. In each case, the parameter name corresponds to the kdb+ dictionary key which would be passed, alongside its user defined value, to the `.automl.run` function in order to update functionality.

```txt
aggcols     Aggregation columns for FRESH
funcs       Functions to be applied for feature extraction
gs          Grid search function and no. of folds/percentage of data in validation set
hld         Size of the testing set on which the final model is tested
hp          Type of hyperparameter search to perform - `grid`random`sobol
rs          Random search function and no. of folds/percentage of data in validation set
saveopt     Saving options outlining what is to be saved to disk from a run
scf         Scoring functions for classification/regression tasks
seed        Random seed to be used
sigfeats    Feature significance procedure to be applied to the data
sz          Size of validation set used.
trials      Number of random/Sobol-random hyperparameters to generate
tts         Train-test split function to be applied
w2v         Word2Vec method used for NLP models
xv          Cross-validation function and # of folds/percentage of data in validation set
```

### `aggcols`

_Columns to be used for aggregations in FRESH_

By default the aggregation column for any FRESH based feature extraction is assumed to be the first column in the dataset. In certain circumstances this may not be sufficient and a more complex aggregation setup may be required as outlined below.

```q
q)uval:100?50
q)tab:([]tstamp:"p"$uval;val:uval;100?1f;100?1f;100?1f)
q)tgt:count[distinct uval]?1f
// In this case we wish to have tstamp and val as aggregation columns
// all other parameters are left as default
q).automl.run[tab;tgt;`fresh;`reg;enlist[`aggcols]!enlist `tstamp`val]
```


### `funcs`

_Functions to be applied for feature extraction_

**FRESH**
By default, the feature extraction functions applied for any FRESH-based problem are all those contained in `.ml.fresh.params`. This incorporates approximately 60 functions. A user who wishes to augment these functions or choose a subsection therein contained, can do so as seen in the below example.

**Normal**
By default, feature extraction for Normal feature-extraction procedures is the decomposition of time/date types into their component parts, this can be augmented by a user to add new functionality. Functions supported are any that take as input a simple table and return a simple table.

**NLP**
By default, feature extraction steps taken for NLP models include parsing the text data using `.nlp.newParser` and applying sentiment anaylsis, regular expression searching and named entity recognition tagging. The text is then vectorized using a `Word2Vec` model and concatenated with the created features. Normal feature extraction is also applied to any remaining non textual columns. Similar to above, the normal feature extraction applied to the data can be augmented by a user.

```q
q)uval:100?50
q)tab:([]tm:"t"$uval;asc 100?1f;100?1f;100?1f;100?1f)
q)fresh_tgt:count[distinct uval]?1f
q)norm_tgt :asc 100?1f
// Select only functions which take < 1 argument for a FRESH based problem
q).automl.newfuncs:select from .ml.fresh.params where pnum<1
// Run feature extraction using user defined function table for FRESH
q).automl.run[tab;fresh_tgt;`fresh;`reg;enlist[`funcs]!enlist `.automl.newfuncs]
// Run feature extraction on Normal data using a set of functions provided by a user
q)funcs:`.automl.prep.i.truncsvd`.automl.prep.i.bulktransform
q).automl.run[tab;norm_tgt;`normal;`reg;enlist[`funcs]!enlist funcs]
```

!!! warning "Do not add data rows"

    Any user-defined function should take as input a simple table and return a simple table with the desired feature extraction procedures applied. These features should not augment the number of rows in the dataset as this will result in errors within the pipeline


### `gs`

_Grid search procedure_

In each case, the default grid search procedure being implemented is a shuffled 5-fold cross validation. This can be augmented by a user for different use cases, for example in the case of applying grid search to time series data.

The input for this parameter is a mixed list containing the grid-search function name as a symbol and the number of folds to split the data into or the percentage of data in each fold depending on the procedure undertaken.

For simplicity of implementation, a user should where possible use the functions within the `.ml.gs` namespace for this task.

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// Roll forward grid search with 6 folds
q)roll_forward:(`.ml.gs.tsrolls;6)
q).automl.run[tab;tgt;`normal;`reg;enlist[`gs]!enlist roll_forward]
```

!!! warning "Custom grid-search function"

    To add a custom grid search function, follow the [guidelines for function definition](../../toolkit/xval.md).

    If you have any questions on this please contact ai@kx.com. When compared to other custom function definitions within the AutoML framework this can become a complicated procedure.


### `hld`

_Size of the testing set_

By default the testing set across all problem types is set to 20%. For problems with a small number of data points, a user may wish to increase the number of datapoints being trained on. The opposite may be true on larger datasets.

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// Set the testing set to contain 10% of the dataset
q)tst:0.1
q).automl.run[tab;tgt;`normal;`reg;enlist[`hld]!enlist tst]
```

### `hp`

_Type of hyperparameter search to perform_

By default, an exhaustive grid search is applied to the best model found for a given dataset. Random or Sobol-random methods are also available within AutoML and can be applied by changing the hp parameter.

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// Random search - change hp parameter from default
q).automl.run[tab;tgt;`normal;`reg;enlist[`hp]!enlist`random]
// Sobol search - change hp parameter from default
q).automl.run[tab;tgt;`normal;`reg;enlist[`hp]!enlist`sobol]
```

### `rs`

_Random search procedure_

Assuming `hp` has been changed to `random` or `sobol`, shuffled 5-fold cross validation will be implemented by default. This can be modified by a user for different use cases, for example in the case a user wishes to apply random/sobol search to time series data.

The input for this parameter is a mixed list containing the random-search function name as a symbol and the number of folds to split the data into or the percentage of data in each fold.

For simplicity of implementation, a user should where possible use the functions within the `.ml.rs` namespace for this task.

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// Random search - roll forward random search with 6 folds
q)roll_forward:(`.ml.rs.tsrolls;6)
q).automl.run[tab;tgt;`normal;`reg;`hp`rs!(random;roll_forward)]
// Sobol search - chain forward sobol search with 4 folds
q)chain_forward:(`.ml.rs.tschain;4)
q).automl.run[tab;tgt;`normal;`reg;`hp`rs!(sobol;chain_forward)]
```

!!! warning "Custom random/sobol search function"

    To add a custom random/sobol search function, follow the [guidelines for function definition](../../toolkit/xval.md).

    If you have any questions on this please contact ai@kx.com. When compared to other custom function definitions within the AutoML framework this can become a complicated procedure.

### `saveopt`

_Save options_

By default, the system will save all outputs to disk (reports, images, config file, models). Where a user does not wish for all outputs to be saved, there are currently three options:

option | effect
:-----:|:--
0 | Nothing is saved, the models will run and display results to console, but nothing is persisted to disk
1 | Save the model and configuration file only, will not generate a report for the user or any images
2 | Save all possible outputs to disk for the user including reports, images, config and models

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// Save only the minimal outputs
q).automl.run[tab;tgt;`normal;`reg;enlist[`saveopt]!enlist 1]
// No outputs saved
q).automl.run[tab;tgt;`normal;`reg;enlist[`saveopt]!enlist 0]
```


### `scf`

_Scoring functions used in model validation and optimization_

The scoring metric used to calculate the performance of each classifier is defined by this parameter, which is a dictionary containing a scoring metric for both regression and classification problems. The default behavior is to use `.ml.accuracy` for classification tasks and `.ml.mse` for regression tasks. Modifying these may be required in order to correctly optimize a model for a specific use case.

The following functions are supported within the platform at present with the ordering which allows the best model to be chosen displayed below and defined in `code/mdldef/scoring.txt`

<div markdown="1" class="typewriter">
.ml   **Statistical analysis metrics with AutoML score order**
  accuracy         accuracy of classification results        desc
  mae              mean absolute error                       asc
  mape             mean absolute percentage error            desc
  matcorr          matthews correlation coefficient          desc
  mse              mean square error                         asc
  rmse             root mean square error                    asc
  rmsle            root mean square logarithmic error        asc
  r2score          r2-score                                  desc
  smape            symmetric mean absolute error             desc
  sse              sum squared error                         asc
</div>

The following is an example implementation

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
q)reg_scf:enlist[`reg]!enlist `.ml.mae
q).automl.run[tab;tgt;`normal;`reg;enlist[`scf]!enlist reg_scf]
```

To use a custom scoring metric this function must be defined within the central process and added to `code/mdldef/scoring.txt` in order to define how optimization is completed. This function must take arguments

-   `x`, a vector of predicted labels
-   `y`, a vector of true labels

The function should return the score as defined by the user-defined metric. Functions within the ML Toolkit which take additional parameters such as `.ml.f1score` can be accessed in this way and could be defined as a projection.


### `seed`

_The seed used to ensure model reruns are consistent_

By default each run of the platform is completed with a ‘random’ seed derived from the time of a run. The seed can be set to a user-specified value to ensure that each run of the platform returns consistent results run-to-run, thus allowing for the impact of modifications to the pipeline to be accurately monitored.

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// User defined seed
q)seed:42
q).automl.run[tab;tgt;`normal;`reg;enlist[`seed]!enlist seed]
// Run the workflow again to show run to run consistency
q).automl.run[tab;tgt;`normal;`reg;enlist[`seed]!enlist seed]
```

!!! Note
	For full reproducibility between q processes of the NLP [word2vec](#w2v) implementation, the [PYTHONHASHSEED](https://docs.python.org/3.3/using/cmdline.html#envvar-PYTHONHASHSEED) environment variable must be set upon initializing q. Linux/Mac: `$ PYTHONHASHSEED=0 q`, Windows: `$ set PYTHONHASHSEED=0`. More information can be found [here](https://radimrehurek.com/gensim/models/word2vec.html)

### `sigfeats`

_Feature significance function to be applied to data to reduce feature set_

By default the system will apply a feature-significance test provided within the [ML Toolkit](../../toolkit/fresh.md#mlfreshsignificantfeatures). The function uses the 25th percentile of important features based on the p-values returned from a number of statistical tests, comparing each column within the dataset to the target vector. This can be modified by a user as follows

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;asc 100?1f)
q)tgt:desc 100?1f
// Define the function to be applied for feature significance tests
q).automl.newsigfeat:{.ml.fresh.significantfeatures[x;y;.ml.fresh.ksigfeat 2]}
q).automl.run[tab;tgt;`normal;`reg;enlist[`sigfeats]!enlist`.automl.newsigfeat]
```

The function that replaces the default feature-significance tests should take arguments

-   `x`, a simple table
-   `y`, the target vector

The result of this function should be a simple table with unimportant features (as deemed by the user-defined function) removed.


### `sz`

_Size of the validation set on which the non grid-searched best model is tested_

By default the validation set prior to the application of a grid search across all problem types is set to 20%. For problems with a small number of data points a user may wish to modify this to increase the number of datapoints being trained on. The ooposite may be required for larger data sets.

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// Set the size of the validation set to contain 10% of the dataset
q)size:0.1
q).automl.run[tab;tgt;`normal;`reg;enlist[`sz]!enlist size]
```

### `trials`

_Number of random/Sobol-random hyperparameters to generate_

For the random and Sobol-random hyperparameter methods, a user specified number of hyperparameter sets are generated for a given hyperparameter space. 

For sobol, the number of trials must equal 2^n, while for random, any number of distinct sets can be generated.

The default for both cases is 264.

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// Random - set number of hp sets
q)n:100
q).automl.run[tab;tgt;`normal;`reg;`hp`trials!(`random;n)]
// Sobol - set number of hp sets to equal 2^n
q)show n:"j"$xexp[2;9]
512
q).automl.run[tab;tgt;`normal;`reg;`hp`trials!(`sobol;n)]
```

### `w2v`

_Word2Vec method used for NLP models_

When applying word2vec embedding to text, the Continuous-Bag-of-Words(0) or skip-gram(1) methods can be applied. The default algorithm used is Continuous-Bag-of-Words.

```q
q)3#tab
comment                                                                      ..
-----------------------------------------------------------------------------..
"If you like plot turns, this is your movie. It is impossible at any moment t..
"It's a real challenge to make a movie about a baby being devoured by wild ca..
"What a good film! Made Men is a great action movie with lots of twists and t..
q)tgt:count[tab]?0b
q)sg:1
q).automl.run[tab;tgt;`normal;`reg;enlist[`w2v]!enlist sg]


### `tts`

_Function used to split the data into training and testing sets_

The default functions used for splitting the data into a training and testing set are as follows

problem type | function | description
-------------|----------|-------------
Normal       |.ml.traintestsplit | Shuffle the dataset and split into training and testing set with defined percentage in each
FRESH        |.ml.ttsnonshuff    | Without shuffling, the dataset is split into training and testing set with defined percentage in each to ensure no time leakage
NLP          |.ml.traintestsplit | Shuffle the dataset and split into training and testing set with defined percentage in each

For specific use cases this may not be sufficient, for example if a user wishes to split the data such that an equal distribution of target classes occur in the training and testing sets this could be implemented as follows.

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?5
q)shuffle:.ml.xv.i.shuffle
q).ml.ttstrat:{[x;y;sz]`xtrain`ytrain`xtest`ytest!raze(x;y)@\:/:r@'shuffle each r:(,'/){x@(0,floor n*1-y)_neg[n]?n:count x}[;sz]each value n@'shuffle each n:group y}
q).automl.run[tab;tgt;`normal;`class;enlist[`tts]!enlist `.ml.ttstrat]
```

A user-defined function for this must take the following arguments.

-   `x`, a simple table
-   `y`, the target vector
-   `z`, the size-splitting criteria used (number folds/percentage of data in validating model)

The result from this function must be a dictionary with keys `` `xtrain`ytrain`xtest`ytest`` where the `x` components are tables containing the split data and `y` components are the associated target vector components


### `xv`

_Cross-validation procedure_

By default the cross-validation procedure being implemented is a 5-fold shuffled cross validation. This can be augmented by a user for different use cases, for example, more timeseries-specific cross validations.

The argumment for this parameter is a mixed list containing the cross-validation function name as a symbol and the number of cross-validation folds to split the data into or percentage of data within the validation set.

For simplicity of implementation, where possible use the functions within the `.ml.xv` namespace for this task.

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
// Chain forward cross validation with 3 folds
q)chain:(`.ml.xv.tschain;3)
q).automl.run[tab;tgt;`normal;`reg;enlist[`xv]!enlist chain]
```

To add a custom cross-validation function outside of those provided follow the [guidelines for function definition](../../toolkit/xval.md).

If you have any questions on this please contact ai@kx.com. When compared to other custom functionality within the AutoML framework this can become a complicated procedure.


## File-based input

In each of the above examples the final parameter input has been a kdb+ dictionary. While this may be the easiest method to modify parameters, for some users a more human-readable flat-file based version is also provided. The following is an example of a flat file which can be user modified and passed as a parameter.

```q
// Fresh parameter file
aggcols  |{first cols x}
funcs    |`.ml.fresh.params
xv       |.ml.xv.kfshuff;5
gs       |.ml.gs.kfshuff;5
rs       |.ml.rs.kfshuff;5
hp       |`grid
trials   |256
prf      |`.automl.xv.fitpredict
scf      |class=.ml.accuracy;reg=.ml.mse
seed     |`rand_val
saveopt  |2
hld      |0.2
tts      |`.ml.ttsnonshuff
sz       |0.2
sigfeats |`.automl.prep.freshsignificance

// Normal parameter file
xv       |.ml.xv.kfshuff;5
gs       |.ml.gs.kfshuff;5
rs       |.ml.rs.kfshuff;5
hp       |`grid
trials   |256
funcs    |`.automl.prep.i.default
prf      |`.automl.xv.fitpredict
scf      |class=.ml.accuracy;reg=.ml.mse
seed     |`rand_val
saveopt  |2
hld      |0.2
tts      |`.ml.traintestsplit
sz       |0.2
sigfeats |`.automl.prep.freshsignificance

// NLP parameter file 
xv       |.ml.xv.kfshuff;5
gs       |.ml.gs.kfshuff;5
rs       |.ml.rs.kfshuff;5
hp       |`grid
trials   |256
funcs    |`.automl.prep.i.default
prf      |`.automl.xv.fitpredict
scf      |class=.ml.accuracy;reg=.ml.mse
seed     |`rand_val
saveopt  |2
hld      |0.2
tts      |`.ml.traintestsplit
sz       |0.2
sigfeats |`.automl.prep.freshsignificance
w2v      |0
``

These files can be generated in the folder `code/models/` using the following functions

```q
q).automl.savedefault["fresh_params.txt";`fresh]
q).automl.savedefault["normal_params.txt";`normal]
q).automl.savedefault["nlp_params.txt";`nlp]
```

Once modified the function `.automl.run` can be used with one of these files as follows

```q
q)tab:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
q)tgt:100?1f
q).automl.run[tab;tgt;`normal;`reg;"normal_params.txt"]
```


## Complex examples

While the above documentation outlines how each parameter can be modified it is important to note that more than one of these parameters can be changed simultaneously. The flat-file based input option is useful for this but the same functionality is possible using a kdb+ dictionary as in the following example.

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
q).automl.run[tab;tgt;`fresh;`reg;key_vals!vals]
```
