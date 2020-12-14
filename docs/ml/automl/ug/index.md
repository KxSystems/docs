---
title: Automated machine learning user guide | Machine Learning | Documentation for kdb+ and q
author: Deanna Morgan
description: How to call the top-level functions in the automated machine learning repository. 
date: November 2020
keywords: keywords: machine learning, automated, ml, feature extraction, feature selection, data cleansing, model selection, optimization, time series
---
# User interface



The top-level functions in the repository are:

`.automl.fit`

: Run the automated machine learning pipeline on user-defined data and target.

`.automl.new`

: Using a previously fit model, along with the date and time from a previous execution of `.automl.run`, return predicted values for new tabular data.

Both of these functions are modifiable by a user to suit specific use cases. Where possible, they have been designed to cover a wide range of functional options and to be extensible to a users needs. Details regarding all available modifications which can be made are outlined in the [advanced section](options.md).

The following examples and function descriptions outline the most basic vanilla implementations of AutoML specific to each supported use case. Namely, non-time series specific machine learning examples, along with time series examples which make use of the [FRESH algorithm](../../toolkit/fresh) and [NLP Library](../../nlp/index.md).


## `.automl.run`

_Apply automated machine learning based on user provided data and target values_

Syntax: `.automl.run[tab;tgt;ftype;ptype;dict]`

Where

-   `tab` is unkeyed tabular data from which the models will be created
-   `tgt` is the target vector
-   `ftype` type of feature extraction being completed on the dataset as a symbol (`` `fresh/`normal/`nlp ``)
-   `ptype` type of problem, regression/class, as a symbol (`` `reg/`class ``)
-   `dict` is one of `::` for default behavior, a kdb+ dictionary or path to a user-defined flat file for modifying default parameters.

returns the date and time at which the run was initiated.

The default setup saves the following items from an individual run:

1. The best model, saved as a HDF5 file, or ‘pickled’ byte object.
2. A saved report indicating the procedure taken and scores achieved.
3. A saved binary encoded dictionary denoting the procedure to be taken for reproducing results, running on new data and outlining all important information relating to a run.
4. Results from each step of the pipeline saved to the generated report.
5. On application NLP techniques a word2vec model is saved outlining the text to numerical mapping for a specific run.

The following examples demonstrate how to apply data in various use cases to `.automl.run`. Note that while only one example is shown for each feature extraction type, datasets with binary-classification, multi-classification and regression targets can all be used in each case. Additionally, the terminal output has only been displayed for the last example.

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


## `.automl.new`

_Apply the workflow and fitted model associated with a specified run to new data_

Syntax: `.automl.new[tab;dt;tm]`

Where

-   `tab` is an unkeyed tabular dataset which has the same schema as the input data from the run specified in `fpath`
-   `dt` is the date of a run as a q date, or string representation i.e. `"yyyy.mm.dd"`
-   `tm` is the time of a run as a q time, or string representation either in the form `"hh:mm:ss.xxx"/"hh.mm.ss.xxx"`.

returns the target predictions for new data based on a previously fitted model and workflow.

!!!Note
	In the below example the date and time are related to a previous run and taken from the return of `.automl.new` the below examples should be run based on a users own run date and time.

```q
// New dataset
q)newTable:([]asc 10?0t;10?1f;desc 10?0b;10?1f;asc 10?1f)
// string date/time input
q).automl.new[newTable;"2020.01.02";"11.21.47.763"]
0.1404663 0.255114 0.255114 0.2683779 0.2773197 0.487862 0.6659926 0.8547356 ..
// q date/time input
q).automl.new[newTable;2020.01.02;11:21:47.763]
0.1953181 0.449196 0.6708352 0.5842918 0.230593 0.4713597 0.1953181 ..
```