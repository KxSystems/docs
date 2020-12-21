---
title: Advanced options for automated machine learning | Machine Learning | Documentation for q and kdb+
description: Optional behavior available from the Kx automated machine learning platform; the effect of changing the input parameters
author: Deanna Morgan
date: December 2020
keywords: machine learning, ml, automated, processing, cross validation, grid search, models
---
# :fontawesome-solid-share-alt: Advanced options

:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl)

The other sections of the AutoML documentation describe the default behavior of the platform, where `(::)` is passed in as the final parameter to `.automl.run`. This section will focus on how this final parameter can be modified to apply changes to the default behavior.

Within the platform, there are two available methods to alter the final parameter:

1. q dictionary outlining the changes to default behaviour that are to be made.
2. The path to JSON file containing human-readable updates to the parameter set.

Given that both options allow for the same modifications to be made, the full list of parameters which can be modified are outlined here first and an implementation of each is described at the end of this page.


## Parameters

The following lists the parameters which can be altered by users to modify the functionality of the AutoML platform. In each case, the parameter name corresponds to the kdb+ dictionary key which would be passed, alongside its user defined value, to the `.automl.fit` function in order to update functionality.

<div markdown="1" class="typewriter">
**AutoML user-modifiable parameters**
[aggregationColumns](#aggregationcolumns)               (FRESH only) Aggregation columns
[crossValidationFunction](#crossvalidationfunctionargument)          Cross validation function
[crossValidationArgument](#crossvalidationfunctionargument)          Number of folds/percentage of data in validation set
[functions](#functions)                        Functions to be applied for feature extraction
[gridSearchFunction](#gridsearchfunctionargument)               Grid search function
[gridSearchArgument](#gridsearchfunctionargument)               Number of folds/percentage of data in validation set
[holdoutSize](#holdoutsize)                      Size of holdout set used
[hyperparameterSearchType](#hyperparametersearchtype)         Hyperparameter search to perform
[loggingDir](#loggingdir)                       Directory to save logs in
[loggingFile](#loggingfile)                      Name of logging file produced for run
[numberTrials](#numbertrials)                     Number of random/sobol hyperparameters to generate
[overWriteFiles](#overwritefiles)                   Overwrite any saved models or log files that exist
[predictionFunction](#predictionfunction)               Fit-predict function to be applied 
[pythonWarning](#pythonwarning)                    Python warning severity
[randomSearchFunction](#randomsearchfunctionargument)             Random search function
[randomSearchArgument](#randomsearchfunctionargument)             Number of folds/percentage of data in validation set
[savedModelName](#savedmodelname)                   File name for saving best model to disk
[saveOption](#saveoption)                       Option for what is to be saved to disk during a run
[scoringFunctionClassification](#scoringfunctionclassificationregression)    Scoring functions for classification tasks
[scoringFunctionRegression](#scoringfunctionclassificationregression)        Scoring functions for regression tasks
[seed](#seed)                             Random seed to be used
[significantFeatures](#significantfeatures)              Feature significance procedure to be applied to data
[targetLimit](#targetlimit)                      Target limit in which models are removed if exceeded 
[testingSize](#testingsize)                      Size of testing set on which final model is tested
[trainTestSplit](#traintestsplit)                   Train-test split function to be applied
[w2v](#w2v)                              (NLP only) Word2Vec method used
</div>

### `aggregationColumns`

_Columns to be used for aggregations in FRESH_

By default the aggregation column for any FRESH based feature extraction is assumed to be the first column in the dataset. In certain circumstances, this may not be sufficient and a more complex aggregation setup may be required, as outlined below.

```q
// Characteristic vector
q)v:100?50
// FRESH feature table
q)features:([]timestamp:"p"$v;v:v;100?1f;100?1f;100?1f)
// Target vector
q)target:count[distinct v]?1f
// Feature extraction type
q)ftype:`fresh
// Problem type
q)ptype:`reg
// In this example we want `timestamp`v as aggregation columns
q)params:enlist[`aggcols]!enlist`timestamp`v
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

### `crossValidationFunction/Argument`

_Cross validation function and number of folds/percentage of data in validation set_

`crossValidationFunction` is the name of the cross validation function to apply as a symbol and `crossValidationArgument` is the associated argument - either the number of folds to apply or the percentage of data in the validation set.

By default, the cross validation procedure being implemented is a 5-fold shuffled cross validation using the function `.ml.xv.kfshuff`. This can be augmented by a user for different use-cases.

For example, a user could change `crossValidationFunction` to `.ml.xv.tsrolls` to suit a more timeseries-specific problem and change `crossValidationArgument` to 7 to split the data into more folds than the default configuration.

For simplicity of implementation, where possible use the functions within the `.ml.xv` namespace for this task.

```q
// Non-timeseries (normal) feature data
q)features:([]asc 100?1f;100?1f;100?1f)
// Target vector
q)target:asc 100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg
// Change cross validation procedure
// Use percentage split, with 20% data in the testing set
q)params:`crossValidationFunction`crossValidationArgument!
  (.ml.xv.pcsplit;.2)
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

To add a custom cross validation function outside of those provided follow the [guidelines for function definition](../../toolkit/xval.md).

If you have any questions on this please contact ai@kx.com. When compared to other custom functionality within the AutoML framework this can become a complicated procedure.

### `functions`

_Functions to be applied for feature extraction_

**FRESH**
By default, the feature extraction functions applied for any FRESH-based problem are all those contained in `.ml.fresh.params`. This incorporates approximately 60 functions in total. A user who wishes to augment or apply a subset of these functions can do so as seen in the below example.

**Normal**
By default, normal feature extraction simply entails the decomposition of any time/date types into their component parts. This can be augmented by a user to add new functionality where functions must input/output a simple table.

**NLP**
By default, feature extraction steps taken for NLP models include parsing the text data using `.nlp.newParser` and applying sentiment anaylsis, regular expression searching and named entity recognition tagging. The text is then vectorized using a `Word2Vec` model and concatenated with the created features. Normal feature extraction is then applied to any remaining non-textual columns. Similar to above, the normal feature extraction applied to the data can be augmented by a user.

```q
// Characteristic vector
q)v:100?50
// Feature table
q)features:([]tm:"t"$v;asc 100?1f;100?1f;100?1f;100?1f)
// FRESH target vector
q)target:count[distinct v]?1f
// Feature extraction type
q)ftype:`fresh
// Problem type
q)ptype:`reg
// Select functions which only take data as input with no extra parameters
q)dataFuncs:select from .ml.fresh.params where pnum=0
q)params:enlist[`funcs]!enlist dataFuncs
// Run feature extraction using user defined function table for FRESH
q).automl.fit[features;target;ftype;ptype;params]
```

!!! warning "Do not add data rows"

    Any user-defined function should take a simple table as input and then return a simple table with the desired feature extraction procedures applied. These features should not augment the number of rows in the dataset as this will result in errors within the pipeline.


### `gridSearchFunction/Argument`

_Grid search function and number of folds/percentage of data in validation set_

`gridSearchFunction` is the name of the grid search function to apply as a symbol and `gridSearchArgument` is the associated argument - either the number of folds to apply or the percentage of data in the validation set.

By default, the grid search procedure being implemented is a 5-fold shuffled grid search using the function `.automl.gs.kfshuff`. This can be augmented by a user for different use-cases.

For example, when using timeseries data, users may look to use a method like chain-forward grid search, `.automl.gs.tschain`, provided within the ML Toolkit, paired with 3 folds.

For simplicity, users are advised to use the functions within the `.automl.gs` namespace for this task.

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
q)target:100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg
// Change hyperparameter search procedure
// Use roll-forward grid search with 6 folds
q)params:`gridSearchFunction`gridSearchArgument!
  (`.ml.gs.tsrolls;6)
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

!!! warning "Custom grid search function"

    To add a custom grid search function, follow the [guidelines for function definition](../../toolkit/xval.md).

    If you have any questions on this please contact ai@kx.com. When compared to other custom function definitions within the AutoML framework, this can become a complicated procedure.


### `holdoutSize`

_Size of holdout set used to validate the models run_

By default the holdout set across all problem types is set to 20%. For problems with a small number of data points, a user may wish to increase the number of datapoints being trained on. The opposite may be true on larger datasets.

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
q)target:100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg
// Set the holdout set to contain 10% of the dataset
q)params:enlist[`holdoutSize]!enlist .1
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

### `hyperparameterSearchType`

_Type of hyperparameter search to perform_

By default, an exhaustive grid search is applied to the best model found for a given dataset. Random or Sobol-random methods are also available within AutoML and can be applied by changing the `hyperparameterSearchType` parameter.

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
q)target:100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg

// Change hyperparameter search procedure
// Use random search
q)params:enlist[`hyperparameterSearchType]!enlist`random
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]

// Change hyperparameter search procedure
// Use Sobol-random search
q)params:enlist[`hyperparameterSearchType]!enlist`sobol
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

### `loggingDir`

_Directory to store logging files_

If `.automl.utils.logging` is set to `1b`, this defines the directory in which the log file is stored. 

By default, the log file is saved to the same directory that the reports, models, meta and images are stored. 

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
q)target:100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg
// Update logging function
q).automl.updateLogging[]
// Check to ensure logging is enabled
q).automl.utils.logging
1b
// Set the logging directory to logDir
q)params:enlist[`loggingDir]!enlist"logDir"
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

### `loggingFile`

_Name of saved logging file_

If `.automl.utils.logging` is set to `1b`, this defines the name of the saved log file. 

By default, the log file is saved in the following format `logFile_date_time.txt`.

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
q)target:100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg
// Update logging function
q).automl.updateLogging[]
// Check to ensure logging is enables
q).automl.utils.logging
1b
// Define the name of the logging file
q)params:enlist[`loggingFile]!enlist"logFileNew"
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
``` 

### `numberTrials`

_Number of random/Sobol-random hyperparameters to generate_

For the random and Sobol-random hyperparameter methods, a user specified number of hyperparameter sets are generated for a given hyperparameter space. 

For Sobol, the number of trials must equal $2^n$, while for random, any number of distinct sets can be generated.

The default for both cases is 264.

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
q)target:100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg

// Random search - set number of hyperparameter sets
q)params:`hyperparameterSearchType`numberTrials!
  (`random;10)
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]

// Sobol-random search - set number of hyperparameter sets to equal 2^n
q)show n:"j"$xexp[2;9]
512
q)params:`hyperparameterSearchType`numberTrials!
  (`sobol;n)
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

### `overWriteFiles`

_Overwrite any saved models or log files that exist_

If a defined `savedModelName` or `loggingFile` of the same name already exists in the system, setting this parameter to `1b` will allow `.automl.fit` to overwrite these files.

By default this value is `0b` and the code will exit with a warning message if the files already exist

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Multi-classification target
q)target:100?0b
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`class

// Use a `savedModelName` that already exists
q)params:enlist[`savedModelName]!enlist"test"
// AutoML returns an error because the savePath already exists
q).automl.fit[features;target;ftype;ptype;params]
Error: The savePath chosen already exists, this run will be exited

// Set overWriteFiles to 1b
q)show params,:enlist[`overWriteFiles]!enlist 1b
savedModelName| "test"
overWriteFiles| 1b
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
modelInfo| `startDate`startTime`featureExtractionType`problemType`..
predict  | {[config;features]
  original_print:utils.printing;
  utils.printi..
```  

### `predictionFunction`

_Fit-predict function to be applied_

Fitting and prediction functions for cross validation and hyperparameter search. Both models fit on a training set and return the predicted scores based on supplied scoring function. Must take the following as inputs 

-   `func` Scoring function that takes parameters and data as input and returns appropriate score
-   `hyperParam` Dictionary of hyperparameters to be searched
-   `data` Data split into training and testing sets of format ((xtrn;ytrn);(xval;yval))

and returns the predicted and true validation values

By default `.automl.utils.fitPredict` is used

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
q)target:100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg
// Define updated predition function
q)fitPredictUpd:{[func;hyperParam;data]
  numpyArray:.p.import[`numpy]`:Array;
  preds:@[.[func[][hyperParam]`:fit;numpyArray data 0]`:predict;data[1]0]`;
  (preds;data[1]1)
  }
q)params:enlist[predictionFunction]!enlist firPredictUpd
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

### `pythonWarning`

_Display python warnings_

Indicate whether python warning messages are to be displayed to standard output (`1b`) or suppressed (`0b`)

By default this is set to `0b`

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
q)target:100?0b
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`class
// Set python warnings to display to standard output
q)params:enlist[`pythonWarnings]!enlist 1b
q).automl.fit[features;target;ftype;ptype;params]
Executing node: automlConfig
Executing node: configuration
Executing node: targetDataConfig
Executing node: targetData
Executing node: featureDataConfig
Executing node: featureData
Executing node: dataCheck
Executing node: featureDescription
Executing node: dataPreprocessing
Executing node: featureCreation
Executing node: labelEncode
Executing node: featureSignificance
Executing node: trainTestSplit
Executing node: modelGeneration
Executing node: selectModels
Executing node: runModels
Executing node: optimizeModels
/lib/python3.7/site-packages/sklearn/neural_network/_multilayer_perceptron...
/lib/python3.7/site-packages/sklearn/neural_network/_multilayer_perceptron...
...
``` 

### `randomSearchFunction/Argument`

_Random search function and number of folds/percentage of data in validation set_

`randomSearchFunction` is the name of the random search function to apply as a symbol and `randomSearchArgument` is the associated argument - either the number of folds to apply or the percentage of data in the validation set.

By default, the random search procedure being implemented (assuming `hyperparameterSearchType` is set to ``` `random```) is a 5-fold shuffled random search using the function `.automl.rs.kfshuff`. This can be augmented by a user for different use-cases.

For example, when using timeseries data, users may look to use a method like chain-forward grid search, `.automl.rs.tschain`, provided within the ML Toolkit, paired with 3 folds.

For simplicity, users are advised to use the functions within the `.automl.rs` namespace for this task.

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
q)target:100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg

// Change hyperparameter search procedure
// Use percentage split random search with 20% validation set
q)params:`hyperparameterSearchType`randomSearchFunction`randomSearchArgument!
  (`random;`.ml.rs.pcsplit;.2)
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]

// Use chain-forward Sobol-random search function with 6-folds
q)params:`hyperparameterSearchType`randomSearchFunction`randomSearchArgument!
  (`sobol;`.ml.rs.tschain;6)
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

!!! warning "Custom random/Sobol-random search function"

    To add a custom random/Sobol-random search function, follow the [guidelines for function definition](../../toolkit/xval.md).

    If you have any questions on this please contact ai@kx.com. When compared to other custom function definitions within the AutoML framework, this can become a complicated procedure.

### `savedModelName`

_Folder name where all outputs will be saved to disk_ 

The folder created will be saved within `/outputs/namedModels/`. 

By default, the outputs are saved using the following format `/outputs/dateTimeModels/date/run_time`

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
q)target:100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg
// Define the folder name where outputs are to be saved
q)params:enlist[`savedModelName]!enlist"exampleModel"
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

### `saveOption`

_Option for what is to be saved to disk during a run_

By default, the system will save all outputs to disk (reports, images, config file, models). Where a user does not wish for all outputs to be saved, there are currently three options:

Option | Effect
:-----:|:--
0      | Nothing is saved - the models will run, but nothing is persisted to disk
1      | Save model/config only - images and report will not be generated
2      | Save all - reports, images, config file and models will be saved to disk

An normal example of how to modify the `saveOption` parameter is shown below.

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
q)target:100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg

// Save only the minimal outputs
q)params:enlist[`saveopt]!enlist 1
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]

// No outputs saved
q)params:enlist[`saveopt]!enlist 0
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

### `scoringFunctionClassification/Regression`

_Scoring functions used in model validation and optimization_

The scoring metric used to calculate the performance of each classifier is defined by this parameter, which is a dictionary containing a scoring metric for both regression and classification problems. The default behaviour is to use `.ml.accuracy` for classification tasks and `.ml.mse` for regression tasks. Modifying these may be required in order to correctly optimize a model for a specific use case.

The following functions are supported within the platform at present with the ordering which allows the best model to be chosen displayed below and defined in `automl/code/customization/scoring/scoring.json`

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

The following is an example implementation:

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
q)target:100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg
// Use Mean Average Error as scoring function
q)params:enlist[`scoringFunctionRegression]!enlist`.ml.mae
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

To use a custom scoring metric this function must be defined within the central process and added to `automl/code/customization/scoring/scoring.json` in order to define how optimization is completed. This function must take arguments

-   `x` - vector of predicted labels
-   `y` - vector of true labels

The function should return the score as defined by the user-defined metric. Functions within the ML-Toolkit which take additional parameters such as `.ml.f1score` can be accessed in this way and could be defined as a projection.

### `seed`

_The seed used to ensure model reruns are consistent_

By default, each run of the platform is completed with a ‘random’ seed derived from the time of a run. The seed can be set to a user-specified value to ensure that each run of the platform returns consistent results run-to-run, thus allowing for the impact of modifications to the pipeline to be accurately monitored.

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
q)target:100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg
// User-defined seed
q)params:enlist[`seed]!enlist 42
// Run AutoML - can run twice to show consistency
q).automl.fit[features;target;ftype;ptype;params]
```

!!! note
    For full reproducibility between q processes of the NLP [word2vec](#w2v) implementation, the [PYTHONHASHSEED](https://docs.python.org/3.3/using/cmdline.html#envvar-PYTHONHASHSEED) environment variable must be set upon initializing q. Linux/Mac: `$ PYTHONHASHSEED=0 q`, Windows: `$ set PYTHONHASHSEED=0`. More information can be found [here](https://radimrehurek.com/gensim/models/word2vec.html).

### `significantFeatures`

_Feature significance function to be applied to data to reduce feature set_

By default, the system will apply feature significance tests provided within the AutoML, namely `.automl.featureSignificance.significance`. The function uses the Benjamini-Hochberg-Yekutieli (BHY) procedure to identify significant features within the dataset. If no significant columns are returned, the top 25th percentile of features will be selected.

Users can alter AutoML to apply different significance tests as shown below.

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
q)target:100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg
// Define the function to be applied for feature significance tests
q)newSigFeats:{.ml.fresh.significantfeatures[x;y;.ml.fresh.ksigfeat 2]}
// Pass in new function as a symbol
q)params:enlist[`significantFeatures]!enlist`newSigFeats
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

The function that replaces the default feature significance tests should take arguments:

-   `x` - simple feature table
-   `y` - target vector

The result of this function should be a list of those columns in `x` deemed to be significant.

### `targetLimit`

_Target limit which requires specific models to be removed if exceeded_

If the number of targets in the dataset exceeds this amount, the following models will be removed from the processing stage: `keras`, `svm`, `neuralNetwork`

By default this value is 10,000

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
q)target:100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg
// Lower the target limit
q)params:enlist[`targetLimit]!enlist 1000
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

### `testingSize`

_Size of testing set on which final model is tested_

By default the testing set across all problem types is set to 20%. For problems with a small number of data points, a user may wish to increase the number of data points being trained on. The opposite may be true on larger datasets.

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
q)target:100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg
// Set the testing set to contain 30% of the dataset
q)params:enlist[`testingSize]!enlist .3
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

### `trainTestSplit`

_Function used to split the data into training and testing sets_

The default functions used for splitting the data into a training and testing set are as follows

problem type | function | description
-------------|----------|-------------
Normal       |.ml.traintestsplit | Shuffle the dataset and split into training and testing set with defined percentage in each
FRESH        |.ml.ttsnonshuff    | Without shuffling, the dataset is split into training and testing set with defined percentage in each to ensure no time leakage
NLP          |.ml.traintestsplit | Shuffle the dataset and split into training and testing set with defined percentage in each

For specific use cases this may not be sufficient, for example if a user wishes to split the data such that an equal distribution of target classes occur in the training and testing sets this could be implemented as follows.

```q
// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Multi-classification target
q)target:100?5
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`class
// Create new TTS function
q)ttsStrat:{[x;y;sz]
  `xtrain`ytrain`xtest`ytest!
  raze(x;y)@\:/:r@'shuffle each r:(,'/){
    x@(0,floor n*1-y)_neg[n]?n:count x
    }[;sz]each value n@'shuffle each n:group y
  }
// Update parameters
q)params:enlist[`trainTestSplit]!enlist`ttsStrat
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

A user-defined function for this must take the following arguments:

-   `x` - simple table
-   `y` - target vector
-   `z` - size-splitting criteria used (number folds/percentage of data in validating model)

The result from this function must be a dictionary with keys `` `xtrain`ytrain`xtest`ytest`` where the `x` components are tables containing the split data and `y` components are the associated target vectors.

### `w2v`

_Word2Vec method used for NLP models_

When applying word2vec embedding to text, the Continuous-Bag-of-Words(0) or skip-gram(1) methods can be applied. The default algorithm used is Continuous-Bag-of-Words.

```q
// NLP feature table
q)3#table
comment                                                                      ..
-----------------------------------------------------------------------------..
"If you like plot turns, this is your movie. It is impossible at any moment t..
"It's a real challenge to make a movie about a baby being devoured by wild ca..
"What a good film! Made Men is a great action movie with lots of twists and t..
// Binary-classification target
q)target:count[table]?0b
// Feature extraction type
q)ftype:`nlp
// Problem type
q)ptype:`class
// Apply skip-gram (1)
q)params:enlist[`w2v]!enlist 1
// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```
