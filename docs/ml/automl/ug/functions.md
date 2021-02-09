---
title: Automated machine learning user guide | Machine Learning | Documentation for kdb+ and q
description: Top-level user-callable functions within the automated machine learning platform
author: Deanna Morgan
date: December 2020
keywords: machine learning, automated, ml, automl, fit, predict, persisted models
---

# :fontawesome-solid-share-alt: Interacting with the framework

:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl/)

There are two primary methods of interacting with this framework:

1. Apply a function and manipulate models within a q process
2. With command-line arguments and customized configuration


## Run within a q process

The top-level functions in the repository are:

<div markdown="1" class="typewriter">
.automl   **Top-level functions**

Generate, retrieve, delete models
  [fit](#automlfit)                   Apply AutoML to provided features and associated targets
  [getModel](#automlgetmodel)              Retrieve a previously fit AutoML model
  [deleteModels](#deletemodels)          Delete model/s

Generate configuration 
  [newConfig](#automlnewconfig)             Generate a new JSON parameter file for use with .automl.fit

Updates
  [updateIgnoreWarnings](#automlupdateignorewarnings)  Update print warning severity level
  [updateLogging](#automlupdatelogging)         Update logging state
  [updatePrinting](#automlupdateprinting)        Update printing state
</div>

You can call `.automl.fit` with arguments to suit a specific use case. 
The functions listed above cover a wide range of options. 
You can also extend them.

:fontawesome-solid-hand-point-right:
[Advanced section](advanced.md)

The examples following outline the most basic applications of AutoML: non-timeseries-specific machine-learning examples, and timeseries examples which use the [FRESH algorithm](../../toolkit/fresh) and [NLP Library](../../nlp/index.md).


### Model prediction

The AutoML library contains no explicit predict function callable as a standalone entity. 
Instead, predictions are made based on the output of a previously fit model. As for `.automl.fit` and `.automl.getModel`, there are two methods by which such models can be made available to a user.

1. As the output of an in process run of the AutoML framework.
2. By retrieving the model information and its associated prediction function from disk.

In each case the output is a dictionary containing the `predict` function required to make predictions based on newly-retrieved data. Below are example invocations.
For simplicity, any unnecessary text which would normally be printed to screen is ignored.

```q
q)trainingFeatures:([]1000?1f;asc 1000?1f)
q)trainingTargets:desc 1000?1f
q)testingFeatures:([]100?1f;100?1f)

q)// Fit a regression model within the current process
q)fitModel:.automl.fit[trainingFeatures;trainingTargets;`normal;`reg;::]
q)fitModel
modelInfo| `startDate`startTime`featureExtractionType`problemType`saveO..
predict  | {[config;features]
  original_print:utils.printing;
  utils.printi..

q)// Predict targets for the testing features
q)show fitPredictions:fitModel.predict[testingFeatures]
0.7963151 0.734172 0.9847206 0.9817364 0.9709857 0.2008781 0.9781675 0...

q)// Retrieve the same model from disk (latest fit model)
q)retrievedModel:.automl.getModel[`startDate`startTime!(.z.D;.z.t)]
q)retrievedModel
modelInfo| `startDate`startTime`featureExtractionType`problemType`saveO..
predict  | {[config;features]
  original_print:utils.printing;
  utils.printi..

q)// Predict targets for the testing features
q)show retrievedPredictions:retrievedModel.predict[testingFeatures]
0.7963151 0.734172 0.9847206 0.9817364 0.9709857 0.2008781 0.9781675 0...

q)// Show that both methods are the same
q)fitPredictions~retrievedPredictions
1b
```


### `.automl.deleteModels`

_Delete a model/set of models from disk_

```syntax
.automl.deleteModels modelDetails
```

Where `modelDetails` is a dictionary containing information related to previously fit models to facilitate models being deleted from disk, returns null on successful invocation, otherwise errors with an appropriate response

Options for `modelDetails`:

-   A `startDate` and `startTime` to denote the dates/times to be deleted: either an exact match or a regex string matching appropriate saved model dates/times
-   In the case of a model saved according to a specified name models can be deleted individually by passing in an exact match denoting the model name or a regex string where multiple models are to be deleted.

```q
q)// Delete a single dated/timed model
q)modelDetails:`startDate`startTime!(2020.08.01;14:10:10.100)
q).automl.deleteModels[modelDetails]

q)// Delete all models on a specific date any time between 4pm and 5pm
q)modelDetails:`startDate`startTime!(2020.08.01;"16:*")
q).automl.deleteModels[modelDetails]

q)// Delete all models for dates within a certain range
q)modelDetails:`startDate`startTime!("2020.08.0[1-9]";"*")
q).automl.deleteModels[modelDetails]

q)// Attempt to delete a model that does not exist
q)modelDetails:`startDate`startTime!(2000.01.01;10:10:10.100)
q).automl.deleteModels[modelDetails]
'startDate provided was not present within the list of available dates

q)// Delete a model based on its exact name
q)modelDetails:enlist[`savedModelName]!enlist "testModel"
q).automl.deleteModels[modelDetails]

q)// Delete a set of models matching an appropriate regex string
q)modelDetails:enlist[`savedModelName]!enlist "test*"
q).automl.deleteModels[modelDetails]

q)// Attempt to delete a named model that does not exist
q)modelDetails:enlist[`savedModelName]!enlist "myModel"
q).automl.deleteModels[modelDetails]
'No files matching the user provided savedModelName were found for deletion
```


### `.automl.fit`

_Apply AutoML to provided features and associated targets_

```syntax
.automl.fit[features;target;ftype;ptype;params]
```

Where

-   `features` is an unkeyed tabular feature data or a dictionary outlining how to retrieve the data in accordance with `.ml.i.loaddset`
-   `target` is target vector of any type or a dictionary outlining how to retrieve the target vector in accordance with `.ml.i.loaddset`
-   `ftype` is the feature-extraction type as a symbol (`` `nlp``, `` `normal``, or `` `fresh``)
-   `ptype` is the problem type as a symbol (`` `reg`` or `` `class``)
-   `params` is one of
  -   Path to a JSON configuration file, either relative to the working directory or in `code/customization/configuration/customConfig`
  -   Dictionary of non-default behaviors
  -   Generic null `(::)` – run AutoML with default parameters 

returns the configuration produced within the current run of AutoML along with a prediction function which can be used to make predictions using the best model produced.

The default setup saves the following items from an individual run:

1. The best model, saved as a HDF5 file, or ‘pickled’ byte object.
2. A saved report indicating the procedure taken and scores achieved.
3. A saved binary-encoded dictionary denoting the procedure to be taken for reproducing results, running on new data and outlining all important information relating to a run.
4. Results from each step of the pipeline saved to the generated report.
5. On application NLP techniques a word2vec model is saved outlining the text to numerical mapping for a specific run.

The following examples demonstrate how to apply data in various use cases to `.automl.fit`. Note that while only one example is shown for each feature-extraction type, datasets with binary-classification, multi-classification and regression targets can all be used in each case. 
The terminal output is shown here only for the last example.

```q
// Non-time series (normal) regression example table
features:([]asc 100?0t;100?1f;desc 100?0b;100?1f;asc 100?1f)
// Regression target
target:asc 100?1f
// Feature extraction type
featExtractType:`normal
// Problem type
problemType:`reg
// Use default system parameters
params:(::)
// Run example
.automl.fit[features;target;featExtractType;problemType;params]

// Non-time series (normal) multi-classification example table
features:([]100?1f;100?1f)
// Multi-classification target
target:100?5
// Feature extraction type
featExtractType:`normal
// Problem type
problemType:`class
// Use default system parameters
params:(::)
// Run example
.automl.fit[features;target;featExtractType;problemType;params]

// NLP binary-classification example table
features:([]100?1f;asc 100?("Testing the application of nlp";"With different characters"))
// Binary-classification target
target:asc 100?0b
// Feature extraction type
featExtractType:`nlp
// Problem type
ptype:`class
// Use default system parameters
params:(::)
// Run example
.automl.fit[features;target;featExtractType;ptype;params]

// FRESH regression example table
features:([]5000?100?0p;asc 5000?1f;5000?1f;desc 5000?10f;5000?0b)
// Regression target
target:desc 100?1f
// Feature extraction type
featExtractType:`fresh
// Problem type
problemType:`reg
// Use default system parameters
params:(::)

// Run example
.automl.fit[features;target;featExtractType;problemType;params]
```
```txt
Executing node: automlConfig
Executing node: configuration
Executing node: targetDataConfig
Executing node: targetData
Executing node: featureDataConfig
Executing node: featureData
Executing node: dataCheck
Executing node: featureDescription

The following is a breakdown of information for each of the relevant columns in the dataset

  | count unique mean      std       min          max       type
--| ---------------------------------------------------------------
x1| 5000  5000   0.5004232 0.2908372 0.0001313207 0.999641  numeric
x2| 5000  5000   0.4967023 0.2897377 0.0007908894 0.9998165 numeric
x3| 5000  5000   5.036043  2.904289  0.002741043  9.998293  numeric
x | 5000  100    ::        ::        ::           ::        time
x4| 5000  2      ::        ::        ::           ::        boolean

Executing node: dataPreprocessing

Data preprocessing complete, starting feature creation

Executing node: featureCreation
Executing node: labelEncode
Executing node: featureSignificance

Total number of significant features being passed to the models = 214

Executing node: trainTestSplit
Executing node: modelGeneration
Executing node: selectModels

Starting initial model selection - allow ample time for large datasets

Executing node: runModels

Scores for all models using .ml.mse

RandomForestRegressor    | 0.04202918
GradientBoostingRegressor| 0.04534999
Lasso                    | 0.04583557
KNeighborsRegressor      | 0.04822146
AdaBoostRegressor        | 0.05129247
LinearRegression         | 0.4422226
MLPRegressor             | 848.683

Best scoring model = RandomForestRegressor

Executing node: optimizeModels

Continuing to hyperparameter search and final model fitting on testing set

Best model fitting now complete - final score on testing set = 0.2106325

Executing node: predictParams
Executing node: preprocParams
Executing node: pathConstruct
Executing node: saveGraph

Saving down graphs to automl/outputs/dateTimeModels/2020.12.17/run_14.57.20.206/images/

Executing node: saveReport

Saving down procedure report to automl/outputs/dateTimeModels/2020.12.17/run_14.57.20.206/report/

Executing node: saveMeta

Saving down model parameters to automl/outputs/dateTimeModels/2020.12.17/run_14.57.20.206/config/

Executing node: saveModels

Saving down model to automl/outputs/dateTimeModels/2020.12.17/run_14.57.20.206/models/

modelInfo| `startDate`startTime`featureExtractionType`problemType`saveOption`..
predict  | {[config;features]
  original_print:utils.printing;
  utils.printi..
```


### `.automl.getModel`

_Retrieve a previously fit AutoML model to use for prediction_

```syntax
.automl.getModel modelDetails
```

Where `modelDetails` is a dictionary containing information related to a previously fit model to facilitate model retrieval from disk, returns relevant model metadata and the prediction function associated with the model.

Options for `modelDetails`:

-   Provide a `startDate` and `startTime` to retrieve the closest prevailing model i.e. nearest model before this time
-   In the case of a model saved according to a specified name, retrieve this by providing a `savedModelName`

```q
q)// Persisted model at a specific date/time
q)modelDetails:`startDate`startTime!(2020.12.17;14:57:20.206)
q)// Retrieve model
q).automl.getModel[modelDetails]
modelInfo| `modelLib`modelFunc`startDate`startTime`featureExt..
predict  | {[config;features]
  original_print:utils.printing;
  utils.printi..

q)// Retrieve the most recent saved model
q)modelDetails:`startDate`startTime(.z.D;.z.t)
q).automl.getModel[modelDetails]
modelInfo| `modelLib`modelFunc`startDate`startTime`featureExt..
predict  | {[config;features]
  original_print:utils.printing;
  utils.printi..

q)// Retrieve the earliest model saved
q)modelDetails:`startDate`startTime("d"$0;"t"$0)
q).automl.getModel[modelDetails]
modelInfo| `modelLib`modelFunc`startDate`startTime`featureExt..
predict  | {[config;features]
  original_print:utils.printing;
  utils.printi..

q)// Retrieve a model based on a name associated with the model
q)modelDetails:enlist[`savedModelName]!enlist "testModel"
q).automl.getModel[modelDetails]
modelInfo| `modelLib`modelFunc`startDate`startTime`featureExt..
predict  | {[config;features]
  original_print:utils.printing;
  utils.printi..
```


### `.automl.newConfig`

_Generate a new JSON parameter file for use with `.automl.fit`_

```syntax
.automl.newConfig fileName
```

Where `fileName` is the name of a new JSON configuration file as a string, symbol or symbolic file handle, in `code/customization/configuration` saves a copy of `default.json` to `customConfig/fileName` and returns generic null.

```q
q)// Path where new JSON configuration file will be saved
q)configPath:hsym`$.automl.path,"/code/customization/configuration/customConfig/"
q)// Check files present in directory at present
q)key configPath
`symbol$()
q)// Generate new configuration file called "newConfigFile"
q).automl.newConfig[`newConfigFile]
q)// Check files present in directory - new configuration file has been generated
q)key configPath
,`newConfigFile
```


### `.automl.updateIgnoreWarnings`

_Update print warning severity level_

```syntax
.automl.updateIgnoreWarnings warningLevel
```

Where  `warningLevel` is `0j`, `1j` or `2j`, updates `.automl.utils.ignoreWarnings` and returns null.

Warning levels:

```txt
0   ignore warnings completely and continue evaluation
1   alert user a warning was flagged and continue
2   exit evaluation of AutoML, telling the user why 
```

```q
q)// Exit pipeline on error
q).automl.updateIgnoreWarnings 2
q)// Fit AutoML
q).automl.fit[features;target;featExtractType;problemType;params]
Executing node: automlConfig
Executing node: configuration
Executing node: targetDataConfig
Executing node: targetData
Executing node: featureDataConfig
Executing node: featureData
Executing node: dataCheck
Error: The savePath chosen already exists, this run will be exited

q)// Highlight warnings
q).automl.updateIgnoreWarnings 1
q)// Fit AutoML
q).automl.fit[features;target;featExtractType;problemType;params]
Executing node: automlConfig
Executing node: configuration
Executing node: targetDataConfig
Executing node: targetData
Executing node: featureDataConfig
Executing node: featureData
Executing node: dataCheck

The savePath chosen already exists and will be overwritten

Executing node: featureDescription
..

q)// Ignore warnings
q).automl.updateIgnoreWarnings 0
q)// Fit AutoML
q).automl.fit[features;target;featExtractType;problemType;params]
Executing node: automlConfig
Executing node: configuration
Executing node: targetDataConfig
Executing node: targetData
Executing node: featureDataConfig
Executing node: featureData
Executing node: dataCheck
Executing node: featureDescription
..
```


### `.automl.updateLogging`

_Toggle logging state_

```syntax
.automl.updateLogging[]
```

Toggles the flag `.automl.utils.logging` and returns null.

`.automl.utils.logging` is a boolean: whether to print statements from `.automl.fit` to a log file. 
Its default value is `0b`.


### `.automl.updatePrinting`

_Toggle printing state_

```syntax
.automl.updatePrinting[]
```

Toggles the flag `.automl.utils.printing` and returns null.

`.automl.utils.printing` is a boolean: whether to print statements to the console.
Its default value is `1b`.


## Run from the command line

You may wish to run the AutoML framework from the command line:

-   to overwrite the default parameters of a process running AutoML such that each run uses these parameters
-   when running the entirety of the framework in a ‘one-shot’ manner, fitting a model and saving it to disk and exiting the process immediately

Both of the above require custom JSON files, in particular a customized version of [`default.json`](config.md#default-configuration). 
Use [`.automl.newConfig`](#automlnewconfig) to generate a named custom version of the `default.json` file. 
When editing it follow [these instructions](config.md#default-configuration).

In the examples the custom JSON files used can be in either of two locations:

-   Within folder `code/customization/configuration/customConfig` relative to `.automl.path`
-   Relative to the working directory


### Overwriting default parameters

Command to run with a custom configuration:

```bash
$ q automl.q -config newConfig.json
```

In the example following, a custom JSON file `myConfig.json` in folder `code/customization/configuration/customConfig` sets the testing set size to 0.3 and modifies the target limit to 1000.

First, start AutoML in a q process and display defaults.

```q
$ q automl.q
q).automl.loadfile`:init.q
q).automl.paramDict[`general;`testingSize`targetLimit]
0.2
10000
q)\\
```

Next, start AutoML using the new configuration file

```q
$ q automl.q -config myConfig.json
q).automl.loadfile`:init.q
q).automl.paramDict[`general;`testingSize`targetLimit]
0.3
1000
```


### Full run from command line

The following is the command line input used when running the entirety of `.automl.fit` from command line.

```bash
$ q automl.q -config newConfig.json -run
```


