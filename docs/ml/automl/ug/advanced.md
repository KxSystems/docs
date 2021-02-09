---
title: Advanced options for automated machine learning | Machine Learning | Documentation for q and kdb+
description: Optional behavior available from the KX automated machine learning framework; the effect of changing the input parameters
author: Deanna Morgan
date: December 2020
keywords: machine learning, ml, automated, processing, cross validation, grid search, models
---
# :fontawesome-solid-share-alt: Advanced options

_Parameters that change the default behavior of `.automl.fit`_

:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl)

<div markdown="1" class="typewriter">
**AutoML user-modifiable parameters**
[aggregationColumns](#aggregationcolumns)              Aggregation columns (FRESH only)
[crossValidationFunction](#crossvalidationfunctionargument)         Cross validation function
[crossValidationArgument](#crossvalidationfunctionargument)         Number of folds/percentage of data in validation set
[functions](#functions)                       Functions to be applied for feature extraction
[gridSearchFunction](#gridsearchfunctionargument)              Grid search function
[gridSearchArgument](#gridsearchfunctionargument)              Number of folds/percentage of data in validation set
[holdoutSize](#holdoutsize)                     Size of holdout set used
[hyperparameterSearchType](#hyperparametersearchtype)        Form of hyperparameter search to perform
[loggingDir](#loggingdir)                      Directory to save log files in
[loggingFile](#loggingfile)                     Name of logging file produced for a run
[numberTrials](#numbertrials)                    Number of random/sobol hyperparameters to generate
[overWriteFiles](#overwritefiles)                  Overwrite any saved models or log files that exist
[predictionFunction](#predictionfunction)              Fit-predict function to be applied
[pythonWarning](#pythonwarning)                   Should Python warning be displayed
[randomSearchFunction](#randomsearchfunctionargument)            Random search function
[randomSearchArgument](#randomsearchfunctionargument)            Number of folds/percentage of data in validation set
[savedModelName](#savedmodelname)                  Name assigned to a run of AutoML
[saveOption](#saveoption)                      Option for what is to be saved to disk during a run
[scoringFunctionClassification](#scoringfunctionclassificationregression)    Scoring functions for classification tasks
[scoringFunctionRegression](#scoringfunctionclassificationregression)       Scoring functions for regression tasks
[seed](#seed)                            Random seed to be used
[significantFeatures](#significantfeatures)              Feature significance procedure to be applied to data
[targetLimit](#targetlimit)                     Ignore NN models when above this number of targets
[testingSize](#testingsize)                     Size of testing set on which final model is tested
[trainTestSplit](#traintestsplit)                  Train-test split function to be applied
[w2v](#w2v)                             Word2Vec embedding methodology used (NLP only)
</div>

The other sections describe the default behavior of the framework, when the last argument of `.automl.fit` is the generic null `(::)`.

The argument can be used to change the default behavior.
Replace the null with either

-   a dictionary
-   path to a JSON file

of non-default parameter values.
The parameter names above are the keys of either the dictionary or the JSON object.


## JSON files

The parameters are illustrated below as q dictionary entries.
They can also be set in JSON files.

The defaults are defined in

```txt
automl/code/customization/configuration/default.json
```

You can modify this file.

Or make one or more custom parameter sets: save versions of `default.json` in sibling folder `customConfig`:

```treeview
automl
└── code
    └── customization
        └── configuration
            ├── default.json
            └── customConfig
                ├── custom1.json
                └── custom2.json
```

Use it (as symbol, string or file symbol) as the last argument to `.automl.fit`.

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)

// Multi-classification target
target:100?5

// Feature extraction type
ftype:`normal

// Problem type
ptype:`class

// Custom configuration file
params:"custom2.json"

// Run AutoML
.automl.run[features;target;ftype;ptype;params]
```

---

## `aggregationColumns`

_Columns to be used for aggregations in FRESH_

By default the aggregation column for any FRESH based feature extraction is assumed to be the first column in the dataset. In certain circumstances, this may not be sufficient and a more complex aggregation setup may be required, as outlined below.

```q
// Characteristic vector
v:100?50

// FRESH feature table
features:([]timestamp:"p"$v;v:v;100?1f;100?1f;100?1f)

// Target vector
target:count[distinct v]?1f

// Feature extraction type
ftype:`fresh

// Problem type
ptype:`reg

// In this example we want `timestamp`v as aggregation columns
params:enlist[`aggregationColumns]!enlist`timestamp`v

// Run AutoML
.automl.fit[features;target;ftype;ptype;params]
```


## `crossValidationFunction/Argument`

_Cross validation function and number of folds/percentage of data in validation set_

`crossValidationFunction` is the name of the cross-validation function to apply as a symbol and `crossValidationArgument` is the associated argument – either the number of folds to apply or the percentage of data in the validation set.

By default, the cross-validation procedure being implemented is a 5-fold shuffled cross validation using the function `.ml.xv.kfshuff`. You can augment this for different use cases.

For example, you could change `crossValidationFunction` to `.ml.xv.tsrolls` to suit a more timeseries-specific problem and change `crossValidationArgument` to 7 to split the data into more folds than the default configuration.

For simplicity, where possible, use the functions within the `.ml.xv` namespace for this task.

```q
// Non-timeseries (normal) feature data
features:([]asc 100?1f;100?1f;100?1f)

// Target vector
target:asc 100?1f

// Feature extraction type
ftype:`normal

// Problem type
ptype:`reg

// Change cross validation procedure
// Use percentage split, with 20% data in the testing set
params:`crossValidationFunction`crossValidationArgument!
  (`.ml.xv.pcsplit;.2)

// Run AutoML
.automl.fit[features;target;ftype;ptype;params]
```

!!! warning "Custom crossvalidation function"

    To add a custom cross-validation function to those provided, follow the [guidelines for function definition](../../toolkit/xval.md).

  	Contact ai@kx.com with questions on this: it is more complicated than other customizations.


## `functions`

_Functions to be applied for feature extraction_

FRESH

: By default, the feature-extraction functions applied for any FRESH-based problem are those contained in `.ml.fresh.params`. This comprises approximately 60 functions. To augment or apply a subset of these functions see the example below and the [instructions](../../../toolkit/fresh).

Normal

: By default, normal feature extraction simply entails the decomposition of any temporal types into their component parts. you can augnment this to add new functionality where a list of supplied functions must input/output a simple table.

NLP

: By default, feature-extraction steps taken for NLP models include parsing the text data using `.nlp.newParser` and applying sentiment anaylsis, regular expression searching and named-entity recognition tagging. The text is then vectorized using a [`Word2Vec`](https://en.wikipedia.org/wiki/Word2vec) model and concatenated with the created features. Normal feature extraction is then applied to any remaining non-textual columns. Much as above, you can augment the normal feature extraction.

```q
// Characteristic vector
v:100?50

// Feature table
features:([]tm:"t"$v;asc 100?1f;100?1f;100?1f;100?1f)

// FRESH target vector
target:count[distinct v]?1f

// Feature extraction type
ftype:`fresh

// Problem type
ptype:`reg

// Select functions which only take data as input with no extra parameters
dataFuncs:select from .ml.fresh.params where pnum=0
params:enlist[`functions]!enlist dataFuncs

// Run feature extraction using user defined function table for FRESH
.automl.fit[features;target;ftype;ptype;params]
```

!!! danger "Do not add data rows"

    A user-defined function for feature extraction should take a simple table as input and return a simple table with the desired feature-extraction procedures applied.

    Changing the number of rows in the dataset will cause in errors in the pipeline.


## `gridSearchFunction/Argument`

_Grid search function and number of folds/percentage of data in validation set_

`gridSearchFunction` is the name of the grid-search function to apply as a symbol, while `gridSearchArgument` is an argument associated with this function defining either the number of folds to apply or the percentage of data in the validation set.

By default, the grid-search procedure being implemented is a 5-fold shuffled grid search using the function `.automl.gs.kfshuff`.
You can augment this for different use cases.

For example, when using timeseries data, you could use a method like chain-forward grid search, `.automl.gs.tschain`, in the ML Toolkit, paired with three folds.

For simplicity, use the functions within the `.automl.gs` namespace for this task.

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)

// Regression target
target:100?1f

// Feature extraction type
ftype:`normal

// Problem type
ptype:`reg

// Change hyperparameter search procedure
// Use roll-forward grid search with 6 folds
params:`gridSearchFunction`gridSearchArgument!
  (`.ml.gs.tsrolls;6)

// Run AutoML
.automl.fit[features;target;ftype;ptype;params]
```

!!! warning "Custom grid-search function"

    To add a custom grid search function, follow the [guidelines for function definition](../../toolkit/xval.md).

    Contact ai@kx.com with questions on this: it is more complicated than other customizations.


## `holdoutSize`

_Size of holdout set used to validate the models run_

By default the holdout set across all problem types is set to 20%.
For problems with a small number of data points, you may wish increase the number of datapoints being trained on. The opposite may be true on larger datasets.

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)

// Regression target
target:100?1f

// Feature extraction type
ftype:`normal

// Problem type
ptype:`reg

// Set the holdout set to contain 10% of the dataset
params:enlist[`holdoutSize]!enlist .1

// Run AutoML
.automl.fit[features;target;ftype;ptype;params]
```


## `hyperparameterSearchType`

_Type of hyperparameter search to perform_

By default, an exhaustive grid search is applied to the best model found for a given dataset. Random or Sobol-random methods are also available within AutoML and can be applied by changing the parameter `hyperparameterSearchType`.

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
target:100?1f
// Feature extraction type
ftype:`normal
// Problem type
ptype:`reg

// Change hyperparameter search procedure
// Use random search
params:enlist[`hyperparameterSearchType]!enlist`random
// Run AutoML
.automl.fit[features;target;ftype;ptype;params]

// Change hyperparameter search procedure
// Use Sobol-random search
params:enlist[`hyperparameterSearchType]!enlist`sobol
// Run AutoML
.automl.fit[features;target;ftype;ptype;params]
```


## `loggingDir`

_Directory to store logging files_

When `.automl.utils.logging` is `1b`, this parameter sets (relative to the current directory) where a log file is stored.

By default, the log file is saved to the same directory that the reports, models, meta and images are stored.

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)

// Regression target
target:100?1f

// Feature extraction type
ftype:`normal

// Problem type
ptype:`reg

// Update logging function
.automl.updateLogging[]
```
```q
q)// Check to ensure logging is enabled
q).automl.utils.logging
1b

q)// Set the logging directory to logDir
q)params:enlist[`loggingDir]!enlist"logDir"

q)// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```


## `loggingFile`

_Name of saved logging file_

When `.automl.utils.logging` is `1b`, this is the name of the saved log file.

By default, the log file is named as: `logFile_date_time.txt`.

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)

// Regression target
target:100?1f

// Feature extraction type
ftype:`normal

// Problem type
ptype:`reg

// Update logging function
.automl.updateLogging[]
```
```q
q)// Check to ensure logging is enabled
q).automl.utils.logging
1b

q)// Define the name of the logging file
q)params:enlist[`loggingFile]!enlist"logFileNew"

q)// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```


## `numberTrials`

_Number of random/Sobol-random hyperparameters to generate_

For the random and Sobol-random hyperparameter methods, a user specified number of hyperparameter sets are generated for a given hyperparameter space.

For Sobol, the number of trials must equal $2^n$, while for random, any number of distinct sets can be generated.

The default for both cases is 264.

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
target:100?1f
// Feature extraction type
ftype:`normal
// Problem type
ptype:`reg

// Random search - set number of hyperparameter sets
params:`hyperparameterSearchType`numberTrials!(`random;10)
// Run AutoML
.automl.fit[features;target;ftype;ptype;params]
```
```q
// Sobol-random search - set number of hyperparameter sets to equal 2^n
q)show n:"j"$xexp[2;9]
512
q)params:`hyperparameterSearchType`numberTrials!(`sobol;n)

q)// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```


## `overWriteFiles`

_Overwrite any saved models or log files that exist_

If a defined `savedModelName` or `loggingFile` of the same name already exists in the system, setting this parameter to `1b` will allow `.automl.fit` to overwrite these files.

By default the value is `0b` and the code will exit with a warning message if the files already exist.

```q
q)// Non-timeseries (normal) feature table
q)features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)

q)// Multi-classification target
q)target:100?0b

q)// Feature extraction type
q)ftype:`normal

q)// Problem type
q)ptype:`class

q)// Use a `savedModelName` that already exists
q)params:enlist[`savedModelName]!enlist"test"

q)// AutoML returns an error because the savePath already exists
q).automl.fit[features;target;ftype;ptype;params]
Error: The savePath chosen already exists, this run will be exited

q)// Set overWriteFiles to 1b
q)show params,:enlist[`overWriteFiles]!enlist 1b
savedModelName| "test"
overWriteFiles| 1b

q)// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
modelInfo| `startDate`startTime`featureExtractionType`problemType`..
predict  | {[config;features]
  original_print:utils.printing;
  utils.printi..
```


## `predictionFunction`

_Fit-predict function to be applied_

Ternary fitting and prediction function for cross validation and hyperparameter search. Both models fit on a training set and return the predicted scores based on supplied scoring function.

Syntax:

```syntax
myFun[func;hyperParam;data]
```

Where

-   `func` is a scoring function that takes parameters and data as input and returns appropriate score
-   `hyperParam` is a dictionary of hyperparameters to be searched
-   `data` is data split into training and testing sets of format `((xtrn;ytrn);(xval;yval))`

`myFun` returns the predicted and true validation values.

By default `.automl.utils.fitPredict` is used.

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)

// Regression target
target:100?1f

// Feature extraction type
ftype:`normal

// Problem type
ptype:`reg

// Define updated prediction function
fitPredictUpd:{[func;hyperParam;data]
  numpyArray:.p.import[`numpy]`:Array;
  preds:@[.[func[][hyperParam]`:fit;numpyArray data 0]`:predict;data[1]0]`;
  (preds;data[1]1) }

params:enlist[predictionFunction]!enlist fitPredictUpd

// Run AutoML
.automl.fit[features;target;ftype;ptype;params]
```


## `pythonWarning`

_Display Python warnings_

Boolean atom: whether Python warning messages are to be displayed to standard output.

By default this is `0b`.

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)

// Regression target
target:100?0b

// Feature extraction type
ftype:`normal

// Problem type
ptype:`class

// Set python warnings to display to standard output
params:enlist[`pythonWarnings]!enlist 1b
```
```q
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
/lib/python3.7/site-packages/sklearn/neural_network/_multilayer_pe...
/lib/python3.7/site-packages/sklearn/neural_network/_multilayer_pe...
...
```


## `randomSearchFunction/Argument`

_Random search function and number of folds/percentage of data in validation set_

`randomSearchFunction` is the name of the random search function to apply as a symbol, while `randomSearchArgument` is an argument associated with this function defining either the number of folds to apply or the percentage of data in the validation set.

By default, the random search procedure being implemented (assuming `hyperparameterSearchType` is set to ``` `random```) is a 5-fold shuffled random search using the function `.automl.rs.kfshuff`. 
You can augment this for different use cases.

For example, when using timeseries data, you might wish to use a method like chain-forward grid search, `.automl.rs.tschain`, in the ML Toolkit, paired with three folds.

For simplicity, use the functions within the `.automl.rs` namespace for this task.

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)
// Regression target
target:100?1f
// Feature extraction type
ftype:`normal
// Problem type
ptype:`reg

// Change hyperparameter search procedure
// Use percentage split random search with 20% validation set
params:`hyperparameterSearchType`randomSearchFunction`randomSearchArgument!
  (`random;`.ml.rs.pcsplit;.2)
// Run AutoML
.automl.fit[features;target;ftype;ptype;params]

// Use chain-forward Sobol-random search function with 6-folds
params:`hyperparameterSearchType`randomSearchFunction`randomSearchArgument!
  (`sobol;`.ml.rs.tschain;6)
// Run AutoML
.automl.fit[features;target;ftype;ptype;params]
```

!!! warning "Custom random/Sobol-random search function"

    To add a custom random/Sobol-random search function, follow the [guidelines for function definition](../../toolkit/xval.md).

    Contact ai@kx.com with questions on this: it is more complicated than other customizations.


## `savedModelName`

_Folder name where all outputs related to a run will be saved_

The folder created is saved in `/outputs/namedModels/`.

By default, the outputs are saved named by the start date/time of a run in the format `/outputs/dateTimeModels/date/run_time`

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)

// Regression target
target:100?1f

// Feature extraction type
ftype:`normal

// Problem type
ptype:`reg

// Define the folder name where outputs are to be saved
params:enlist[`savedModelName]!enlist"exampleModel"

// Run AutoML
.automl.fit[features;target;ftype;ptype;params]
```


## `saveOption`

_Option defining what is to be saved to disk during a run_

There are three options.

```txt
0    Save nothing: the models run, but nothing is persisted to disk
1    Save model/metadata only: images and report are not generated
2    Save all: reports, images, metadata and models are saved to disk
```

The default is 2: save everything.

Example:

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)

// Regression target
target:100?1f

// Feature extraction type
ftype:`normal

// Problem type
ptype:`reg

// Save only the minimal outputs
params:enlist[`saveOption]!enlist 1
// Run AutoML
.automl.fit[features;target;ftype;ptype;params]

// No outputs saved
params:enlist[`saveOption]!enlist 0
// Run AutoML
.automl.fit[features;target;ftype;ptype;params]
```


## `scoringFunctionClassification/Regression`

_Scoring functions used in model validation and optimization_

The scoring metrics used to evaluate model performance for regression and classification tasks are defined respectively by the parameters 

```txt
scoringFunctionClassification
scoringFunctionRegression
```

The following functions are supported within the framework at present along with the ordering which allows the best model to be chosen displayed as defined in 

```txt
automl/code/customization/scoring/scoring.json
```

<div markdown="1" class="typewriter">
.ml   **Statistical analysis metrics with AutoML score order**
  accuracy         accuracy of classification results       desc
  mae              mean absolute error                      asc
  mape             mean absolute percentage error           desc
  matcorr          matthews correlation coefficient         desc
  mse              mean square error                        asc
  rmse             root mean square error                   asc
  rmsle            root mean square logarithmic error       asc
  r2score          r2-score                                 desc
  smape            symmetric mean absolute error            desc
  sse              sum squared error                        asc
</div>

The default values for these two parameters are

```txt
scoringFunctionRegression      .ml.mse
scoringFunctionClassification  .ml.accuracy
```

Example: modifying the regression metric

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)

// Regression target
target:100?1f

// Feature extraction type
ftype:`normal

// Problem type
ptype:`reg

// Use Mean Average Error as scoring function
params:enlist[`scoringFunctionRegression]!enlist`.ml.mae

// Run AutoML
.automl.fit[features;target;ftype;ptype;params]
```

To use a custom scoring metric function, define it in the central process and add it to `automl/code/customization/scoring/scoring.json`.

The function must be a binary with vector arguments:

1.  predicted labels
2.  true labels

and return the score. 

Functions within the ML Toolkit which take additional parameters, such as `.ml.f1score`, can be accessed in this way and could be defined as a projection.


## `seed`

_The seed used to ensure model reruns are consistent_

By default, each run of the framework is completed with a ‘random’ seed derived from the time of a run. The seed can be set to a user-specified value to ensure results are consiustent across runs, thus allowing the impact of modifications to the pipeline to be accurately monitored.

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)

// Regression target
target:100?1f

// Feature extraction type
ftype:`normal

// Problem type
ptype:`reg

// User-defined seed
params:enlist[`seed]!enlist 42

// Run AutoML - can run twice to show consistency
.automl.fit[features;target;ftype;ptype;params]
```

??? tip "Reproducing results"

    For full reproducibility between q processes of the NLP [word2vec](#w2v) implementation, set the [`PYTHONHASHSEED`](https://docs.python.org/3.3/using/cmdline.html#envvar-PYTHONHASHSEED) environment variable upon initializing q. 

    === "Linux/Mac"
        `PYTHONHASHSEED=0 q`
    === "Windows"
        `set PYTHONHASHSEED=0`. 

    :fontawesome-solid-globe:
    [`models.word2vec` – Word2vec embeddings](https://radimrehurek.com/gensim/models/word2vec.html "radimrehurek.com")


## `significantFeatures`

_Feature significance function to be applied to data to reduce feature set_

By default, the system will apply the feature-significance tests in the AutoML: 

```txt
.automl.featureSignificance.significance
```

The function uses the Benjamini-Hochberg-Yekutieli (BHY) procedure to identify significant features within the dataset. If no significant columns are returned, the top 25th percentile of features will be selected.

Users can alter AutoML to apply different significance tests as shown below.

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)

// Regression target
target:100?1f

// Feature extraction type
ftype:`normal

// Problem type
ptype:`reg

// Define the function to be applied for feature significance tests
newSigFeats:{.ml.fresh.significantfeatures[x;y;.ml.fresh.ksigfeat 2]}

// Pass in new function as a symbol
params:enlist[`significantFeatures]!enlist`newSigFeats

// Run AutoML
.automl.fit[features;target;ftype;ptype;params]
```

A alternative function must be binary, with arguments

1.  simple feature table
2.  target vector

and return a list of table columns deemed significant.


## `targetLimit`

_Number of targets above which long-running models are removed_

If the number of targets in the dataset exceeds this, the following models will be removed from the processing stage: `keras`, `svm`, `neuralNetwork`

The default value is 10,000.

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)

// Regression target
target:100?1f

// Feature extraction type
ftype:`normal

// Problem type
ptype:`reg

// Lower the target limit
params:enlist[`targetLimit]!enlist 1000

// Run AutoML
.automl.fit[features;target;ftype;ptype;params]
```


## `testingSize`

_Size of testing set on which final model is tested_

By default the testing set across all problem types is set to 20%. 
For problems with a small number of data points, you may wish to increase the number of data points being trained on. The opposite may be true for larger datasets.

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)

// Regression target
target:100?1f

// Feature extraction type
ftype:`normal

// Problem type
ptype:`reg

// Set the testing set to contain 30% of the dataset
params:enlist[`testingSize]!enlist .3

// Run AutoML
.automl.fit[features;target;ftype;ptype;params]
```


## `trainTestSplit`

_Function used to split the data into training and testing sets_

Default functions for splitting the data into training and testing sets:

problem type | function            | description
-------------|---------------------|-------------
Normal       | .ml.traintestsplit  | Shuffle the dataset and split into training and testing set with a defined percentage in each
FRESH        | .automl.ttsNonShuff | Without shuffling, the dataset is split into training and testing set with defined percentage in each to ensure no time leakage
NLP          | .ml.traintestsplit  | Shuffle the dataset and split into training and testing set with a defined percentage in each

For specific use cases this may not be sufficient. For example if you wish to split the data such that an equal distribution of target classes occur in the training and testing sets, this could be implemented as follows.

```q
// Non-timeseries (normal) feature table
features:([]100?1f;asc 100?1f;100?1f;100?1f;100?1f)

// Multi-classification target
target:100?5

// Feature extraction type
ftype:`normal

// Problem type
ptype:`class

// Create new TTS function
ttsStrat:{[x;y;sz]
  `xtrain`ytrain`xtest`ytest!
  raze(x;y)@\:/:r@'shuffle each r:(,'/){
    x@(0,floor n*1-y)_neg[n]?n:count x
    }[;sz]each value n@'shuffle each n:group y }

// Update parameters
params:enlist[`trainTestSplit]!enlist`ttsStrat

// Run AutoML
.automl.fit[features;target;ftype;ptype;params]
```

A alternative function for this must take arguments

1.   simple table
1.   target vector
1.   size-splitting criteria used (number folds/percentage of data in validating model)

and return a dictionary with keys `` `xtrain`ytrain`xtest`ytest`` where the `x` components are tables containing the split data and `y` components are the associated target vectors.


## `w2v`

_Word2Vec method used for NLP models_

Methods:

```txt
0   Continuous-Bag-of-Words (default)
1   skip-gram
```

:fontawesome-solid-globe:
[A crash course in word embedding](https://towardsdatascience.com/nlp-101-word2vec-skip-gram-and-cbow-93512ee24314 "towardsdatascience.com")

```q
q)// NLP feature table
q)3#table
comment                                                                      ..
-----------------------------------------------------------------------------..
"If you like plot turns, this is your movie. It is impossible at any moment t..
"It's a real challenge to make a movie about a baby being devoured by wild ca..
"What a good film! Made Men is a great action movie with lots of twists and t..

q)// Binary-classification target
q)target:count[table]?0b

q)// Feature extraction type
q)ftype:`nlp

q)// Problem type
q)ptype:`class

q)// Apply skip-gram (1)
q)params:enlist[`w2v]!enlist 1

q)// Run AutoML
q).automl.fit[features;target;ftype;ptype;params]
```

