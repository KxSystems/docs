---
title: Automated machine learning user guide | Machine Learning | Documentation for kdb+ and q
description: Top-level user-callable functions within the automated machine learning platform
author: Deanna Morgan
date: December 2020
keywords: keywords: machine learning, automated, ml, automl, fit, predict, persisted models
---

# :fontawesome-solid-share-alt: Interacting with the framework

:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl/)

There are two primary methods of interacting with this framework

1. Applying function and manipulating models within a q process
2. Interacting with the interface using command line arguments and customized configuration

The following page outlines each of these methods

## Interacting within a q process

The top-level functions in the repository are:

<div markdown="1" class="typewriter">
.automl   **Top-level functions**
  [fit](#automlfit)                   Apply AutoML to provided features and associated targets
  [getModel](#automlgetmodel)              Retrieve a previously fit AutoML model
  [newConfig](#automlnewconfig)             Generate a new JSON parameter file for use with .automl.fit
  [updateIgnoreWarnings](#automlupdateignorewarnings)  Update print warning severity level
  [updateLogging](#automlupdatelogging)         Update logging state
  [updatePrinting](#automlupdateprinting)        Update printing state
</div>

`.automl.fit` can be modified by a user to suit specific use cases. Where possible, the functions listed above have been designed to cover a wide range of functional options and to be extensible to a users needs. Details regarding all available modifications which can be made are outlined in the [advanced section](advanced.md).

The following examples and function descriptions outline the most basic vanilla implementations of AutoML specific to each supported use case. Namely, non-time series specific machine learning examples, along with time series examples which make use of the [FRESH algorithm](../../toolkit/fresh) and [NLP Library](../../nlp/index.md).


### `.automl.fit`

_Apply AutoML to provided features and associated targets_

Syntax: `.automl.fit[features;target;ftype;ptype;params]`

Where

-   `features` is an unkeyed tabular feature data or a dictionary outlining how to retrieve the data in accordance with `.ml.i.loaddset`
-   `target` is target vector of any type or a dictionary outlining how to retrieve the target vector in accordance with `.ml.i.loaddset`
-   `ftype` is the feature extraction type as a symbol (``` `nlp/`normal/`fresh ```)
-   `ptype` is the problem type being solved as a symbol (``` `reg/`class ```)
-   `params` is one of the following:
      1. Path relative to `.automl.path` pointing to a user defined JSON file for modifying default parameters
      2. Dictionary containing the default behaviours to be overwritten
      3. Null (::) indicating to run AutoML using default parameters 

returns the configuration produced within the current run of AutoML along with a prediction function which can be used to make predictions using the best model produced.

The default setup saves the following items from an individual run:

1. The best model, saved as a HDF5 file, or ‘pickled’ byte object.
2. A saved report indicating the procedure taken and scores achieved.
3. A saved binary encoded dictionary denoting the procedure to be taken for reproducing results, running on new data and outlining all important information relating to a run.
4. Results from each step of the pipeline saved to the generated report.
5. On application NLP techniques a word2vec model is saved outlining the text to numerical mapping for a specific run.

The following examples demonstrate how to apply data in various use cases to `.automl.fit`. Note that while only one example is shown for each feature extraction type, datasets with binary-classification, multi-classification and regression targets can all be used in each case. Additionally, the terminal output has only been displayed for the last example.

```q
// Non-time series (normal) regression example table
q)features:([]asc 100?0t;100?1f;desc 100?0b;100?1f;asc 100?1f)
// Regression target
q)target:asc 100?1f
// Feature extraction type
q)featExtractType:`normal
// Problem type
q)problemType:`reg
// Use default system parameters
q)params:(::)
// Run example
q).automl.fit[features;target;featExtractType;problemType;params]

// Non-time series (normal) multi-classification example table
q)features:([]100?1f;100?1f)
// Multi-classification target
q)target:100?5
// Feature extraction type
q)featExtractType:`normal
// Problem type
q)problemType:`class
// Use default system parameters
q)params:(::)
// Run example
q).automl.fit[features;target;featExtractType;problemType;params]

// NLP binary-classification example table
q)features:([]100?1f;asc 100?("Testing the application of nlp";"With different characters"))
// Binary-classification target
q)target:asc 100?0b
// Feature extraction type
q)featExtractType:`nlp
// Problem type
q)ptype:`class
// Use default system parameters
q)params:(::)
// Run example
q).automl.fit[features;target;featExtractType;ptype;params]

// FRESH regression example table
q)features:([]5000?100?0p;asc 5000?1f;5000?1f;desc 5000?10f;5000?0b)
// Regression target
q)target:desc 100?1f
// Feature extraction type
q)featExtractType:`fresh
// Problem type
q)problemType:`reg
// Use default system parameters
q)params:(::)
// Run example
q)outputs:.automl.fit[features;target;featExtractType;problemType;params]
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
```

!!! note Predict on new data
    Predictions can be made using the model output by `.automl.fit`. Users simply need to pass in the new feature data as shown below:
    
    ```q
    
    // Non-time series (normal) regression example table - training features
    
    q)xtrain:([]asc 100?0t;100?1f;desc 100?0b;100?1f;asc 100?1f)
    
    // Regression target - training target
    
    q)ytrain:asc 100?1f
    
    // Generate model
    
    q)outputModel:.automl.fit[xtrain;ytrain;`normal;`reg;(::)]
    
    // Testing features
    
    q)xtest:([]asc 10?0t;10?1f;desc 10?0b;10?1f;asc 10?1f)
    
    // Make predicts on generated model
    
    q)outputModel.predict[xtest]
    
    0.02526887 0.2412723 0.2432483 0.3049373 0.330132 0.3727415 0.4536485..
        "port"  :"",
        "select":""
    ```

### `.automl.getModel`

_Retrieve a previously fit AutoML model and use for predictions_

Syntax: `.automl.getModel[modelDetails]`

Where

-   `modelDetails` a dictionary with information regarding the location of the model and metadata within the outputs directory

returns the predict function (generated using `.automl.utils.generatePredict`) and all relevant metadata for the model.

```q
// Persisted model details
q)modelDetails:`startDate`startTime!(2020.12.17;14:57:20.206)
// Retrieve model
q).automl.getModel[modelDetails]
modelInfo| `modelLib`modelFunc`startDate`startTime`featureExtractionType`prob..
predict  | {[config;features]
  original_print:utils.printing;
  utils.printi..
```

!!! note Predict on new data
    The model retrieved using `.automl.getModel` can be used to make predictions on new data using the same method detailed above for `.automl.fit`.

### `.automl.newConfig`

_Generate a new JSON parameter file for use with .automl.fit_

Syntax: `.automl.newConfig[fileName]`

Where

-   `fileName` is the name to call the newly generated JSON configuration file as a string, symbol or symbolic file handle. This file is stored in 'code/customization/configuration/customConfig'.

returns generic null on successful invocation and saves a copy of the file 'code/customization/configuration/default.json' to the appropriately named file.

```q
// Path where new JSON configuration file will be saved
q)configPath:hsym`$.automl.path,"/code/customization/configuration/customConfig/"
// Check files present in directory at present
q)key configPath
`symbol$()
// Generate new configuration file called "newConfigFile"
q).automl.newConfig[`newConfigFile]
// Check files present in directory - new configuration file has been generated
q)key configPath
,`newConfigFile
```

### `.automl.updateIgnoreWarnings`

_Update print warning severity level_

Syntax: `.automl.updateIgnoreWarnings[warningLevel]`

Where

-   `warningLevel` is `0`, `1` or `2` long denoting how severely warnings are to be handled:
      - `0` - Ignore warnings completely and continue evaluation
      - `1` - Highlight to a user that a warning was being flagged but continue
      - `2` - Exit evaluation of AutoML highlighting to the user why this happened

returns null on success, with `.automl.utils.ignoreWarnings` updated to new level.

```q
// Exit pipeline on error
q).automl.updateIgnoreWarnings 2
// Fit AutoML
q).automl.fit[features;target;featExtractType;problemType;params]
Executing node: automlConfig
Executing node: configuration
Executing node: targetDataConfig
Executing node: targetData
Executing node: featureDataConfig
Executing node: featureData
Executing node: dataCheck
Error: The savePath chosen already exists, this run will be exited
// Highlight warnings
q).automl.updateIgnoreWarnings 1
// Fit AutoML
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
// Ignore warnings
q).automl.updateIgnoreWarnings 0
// Fit AutoML
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

_Update logging state_

Syntax: `.automl.updateLogging[]`

Function takes no parameters and returns null on success when the boolean representating `.automl.utils.logging` has been inverted, where:

  - `0b` - No log file is created
  - `1b` - Print statements from `.automl.fit` are saved to a log file

!!! note 
    The default value of `automl.utils.logging` is `0b`.

### `.automl.updatePrinting`

_Update printing state_

Syntax: `.automl.updatePrinting[]`

Function takes no parameters and returns null on success when the boolean representating `.automl.utils.printing` has been inverted, where:

  - `0b` - Print statements to console are disabled
  - `1b` - Print statements are displayed to console

!!! note
    The default value of `automl.utils.printing` is `1b`.

## Interacting via command line

There are at present two circumstances under which users may wish to interact with the AutoML framework via optional command line arguments

1. When a user wishes to overwrite the default parameters of a process running AutoML such that each run uses these parameters.
2. When running the entirety of the framework in a 'one-shot' manner. fitting a model and saving it to disk and exiting the process immediately.

Both of the above examples rely on users making use of custom JSON files, in particular a customized version of `default.json` oulined [here](config.md#default-configuration). To generate a named custom version of the `default.json` file use the function [`.automl.newConfig`](#automlnewconfig). When editing this file a user should follow the instructions outlined [here](config.md#default-configuration).

???Note "Location of JSON files"
	It should be noted in the examples presented below that the custom JSON files used can be in one of two locations.

	1. Within the folder `code/customization/configuration/customConfig` relative to `.automl.path`.
	2. Relative to the location that the user is currently positioned within their file system.

### Overwriting default parameters

The following is the command line input used to overwrite default parameters with a custom configuration.

```bash
$ q automl.q -config newConfig.json
```

In the below example a custom JSON file `myConfig.json` exists within the folder `code/customization/configuration/customConfig` which sets the testing set size to 0.3 and modifies the target limit to 1000.

```q
// Start automl in a q process normally and retrieve the appropriate defaults
$ q automl.q
q).automl.loadfile`:init.q
q).automl.paramDict[`general;`testingSize`targetLimit]
0.2
10000

// Start automl using the new configuration file
$ q automl.q -config myConfig.json
q).automl.loadfile`:init.q
q).automl.paramDict[`general;`testingSize`targetLimit]
0.3
1000
```

### Running AutoML from command line

The following is the command line input used when running the entirety of `.automl.fit` from command line.

```bash
$ q automl.q -config newConfig.json -run
```

In the above example invocation it should be noted that the file `newConfig.json` can exist either relative to the users current location within their file system or in the folder `code/customization/configuration/customConfig`.

