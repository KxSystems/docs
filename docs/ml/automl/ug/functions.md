---
title: Automated machine learning user guide | Machine Learning | Documentation for kdb+ and q
description: Top-level user-callable functions within the automated machine learning platform
author: Deanna Morgan
date: December 2020
keywords: keywords: machine learning, automated, ml, automl, fit, predict, persisted models
---

# :fontawesome-solid-share-alt: Top-level user-callable functions

:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl)

The top-level functions in the repository are:

<div markdown="1" class="typewriter">
.automl   **Top-level functions**
  fit                   Apply AutoML to provided features and associated targets
  getModel              Retrieve a previously fit AutoML model and use for predictions
  newConfig             Generate a new JSON parameter file for use with .automl.fit
  updateIgnoreWarnings  Update print warning severity level
  updateLogging         Update logging state
  updatePrinting        Update printing state
</div>

`.automl.fit` can be modified by a user to suit specific use cases. Where possible, the functions listed above have been designed to cover a wide range of functional options and to be extensible to a users needs. Details regarding all available modifications which can be made are outlined in the [advanced section](options.md).

The following examples and function descriptions outline the most basic vanilla implementations of AutoML specific to each supported use case. Namely, non-time series specific machine learning examples, along with time series examples which make use of the [FRESH algorithm](../../toolkit/fresh) and [NLP Library](../../nlp/index.md).


## `.automl.fit`

_Apply AutoML to provided features and associated targets_

Syntax: `.automl.fit[features;target;ftype;ptype;dict]`

Where

-   `features` 
-   `target` 
-   `ftype` 
-   `ptype` 
-   `dict` 

returns 

The default setup saves the following items from an individual run:

1. The best model, saved as a HDF5 file, or ‘pickled’ byte object.
2. A saved report indicating the procedure taken and scores achieved.
3. A saved binary encoded dictionary denoting the procedure to be taken for reproducing results, running on new data and outlining all important information relating to a run.
4. Results from each step of the pipeline saved to the generated report.
5. On application NLP techniques a word2vec model is saved outlining the text to numerical mapping for a specific run.

The following examples demonstrate how to apply data in various use cases to `.automl.fit`. Note that while only one example is shown for each feature extraction type, datasets with binary-classification, multi-classification and regression targets can all be used in each case. Additionally, the terminal output has only been displayed for the last example.

```q
// Non-time series (normal) regression example table
q)table:([]asc 100?0t;100?1f;desc 100?0b;100?1f;asc 100?1f)
// Regression target
q)regTarget:asc 100?1f
// Feature extraction type
q)featExtractType:`normal
// Problem type
q)problemType:`reg
// Use default system parameters
q)dict:(::)
// Run example
q).automl.run[table;regTarget;featExtractType;problemType;dict]

// Non-time series (normal) multi-classification example table
q)table:([]100?1f;100?1f)
// Multi-classification target
q)classTarget:100?5
// Feature extraction type
q)featExtractType:`normal
// Problem type
q)problemType:`class
// Use default system parameters
q)dict:(::)
// Run example
q).automl.run[table;classTarget;featExtractType;problemType;dict]

// FRESH regression example table
q)table:([]5000?100?0p;asc 5000?1f;5000?1f;desc 5000?10f;5000?0b)
// Regression target
q)regTarget:desc 100?1f
// Feature extraction type
q)featExtractType:`fresh
// Problem type
q)problemType:`reg
// Use default system parameters
q)dict:(::)
// Run example
q).automl.run[table;regTarget;featExtractType;problemType;dict]

// NLP binary-classification example table
q)table:([]100?1f;asc 100?("Testing the application of nlp";"With different characters"))
// Binary-classification target
q)classTarget:asc 100?0b
// Feature extraction type
q)featExtractType:`nlp
// Problem type
q)ptype:`class
// Use default system parameters
q)dict:(::)
// Run example
q).automl.run[table;classTarget;featExtractType;ptype;dict]
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

Scores for all models using .ml.accuracy:
AdaBoostClassifier        | 0.9384615
RandomForestClassifier    | 0.9384615
GaussianNB                | 0.9384615
KNeighborsClassifier      | 0.9384615
LinearSVC                 | 0.9384615
GradientBoostingClassifier| 0.9371795
SVC                       | 0.9371795
MLPClassifier             | 0.8128205
LogisticRegression        | 0.6910256

Best scoring model = AdaBoostClassifier

Executing node: optimizeModels

Confusion matrix for testing set:

      | true_0 true_1
------| -------------
pred_0| 10     0
pred_1| 0      10
Executing node: predictParams

Best model fitting now complete - final score on testing set = 1

Executing node: preprocParams
Executing node: pathConstruct
Executing node: saveGraph
Executing node: saveReport

Saving down procedure report to automl/outputs/date/run_time/report/

Executing node: saveMeta

Saving down model parameters to automl/outputs/date/run_time/config/

Executing node: saveModels

Saving down AdaBoostClassifier model to automl/outputs/date/run_time/models/

2020.11.23
09:57:27.894
```

## `.automl.getModel`

_Retrieve a previously fit AutoML model and use for predictions_

Syntax: `.automl.getModel[]`

Where



returns 

```q
```

**add predict**

## `.automl.newConfig`

_Generate a new JSON parameter file for use with .automl.fit_

Syntax: `.automl.newConfig[]`

Where



returns 

```q
```

## `.automl.runCommandLine`

_Run AutoML based on user provided custom JSON files_

Syntax: `.automl.runCommandLine[]`

Where



returns 

```q
```

## `.automl.updateIgnoreWarnings`

_Update print wanring severity level_

Syntax: `.automl.updateIgnoreWarnings[]`

Where



returns 

```q
```

## `.automl.updateLogging`

_Update logging state_

Syntax: `.automl.updateLogging[]`

Where



returns 

```q
```

## `.automl.updatePrinting`

_Update printing state_

Syntax: `.automl.updatePrinting[]`

Where



returns 

```q
```