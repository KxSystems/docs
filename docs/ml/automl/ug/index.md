---
title: Automated machine-learning user guide | Machine Learning | Documentation for kdb+ and q
author: Conor McCarthy
description: How to call the top-level functions in the automated machine-learning repository. 
date: March 2020
keywords: machine learning, automated, ml, feature extraction, feature selection, data cleansing
---
# User interface



The top-level functions in the repository are:

`.automl.run`

: Run the automated machine -learning pipeline on user-defined data and target.

`.automl.new`

: Using a previously fit model along with the date and time from a previous execution of `.automl.run`, return predicted values for new tabular data.

Both of these functions are modifiable by a user to suit specific use cases and have been designed where possible to cover a wide range of functional options and to be extensible to a users needs. Details regarding all available modifications which can be made are outlined in the [advanced section](options.md).

The following examples and function descriptions outline the most basic implementations of each of the above functions for each of the use cases to which this platform can currently be applied. Namely non-timeseries-specific machine-learning examples and implementations making use of the [FRESH algorithm](../../toolkit/fresh) and [NLP Library](../../nlp/index.md).


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
3. A saved binary encoded dictionary denoting, the procedure to be taken for reproducing results, running on new data and outlining all important information relating to a run.
4. Results from each step of the pipeline published to console.
5. On application NLP techniques a word2vec model is saved outlining the text to numerical mapping for a specific run.

The following shows the execution of the function `.automl.run` in a regression task for a non-time series application. Data and implementation code is provided for other problem types however for brevity, output is displayed in full for one example only.

```q
// Non time-series regression example table
q)tab:([]asc 100?0t;100?1f;desc 100?0b;100?1f;asc 100?1f)
// Regression target
q)reg_tgt:asc 100?1f
// Feature extraction type
q)ftype:`normal
// Problem type
q)ptype:`reg
// Use default system parameters
q)dict:(::)
// Run example
q).automl.run[tab;reg_tgt;ftype;ptype;dict]

// Non time-series multi-classification example
q).automl.run[([]100?1f;100?1f);100?5;`normal;`class;::]

The following is a breakdown of information for each of the relevant columns in the dataset

  | count unique mean      std       min        max       type
- | -------------------------------------------------------------
x | 100   100    0.4742613 0.2656773 0.02455057 0.9953159 numeric
x1| 100   100    0.4885036 0.272643  0.01589433 0.9696383 numeric

Data preprocessing complete, starting feature creation

Feature creation and significance testing complete
Starting initial model selection - allow ample time for large datasets

Total features being passed to the models = 1

Scores for all models, using .ml.accuracy
MLPClassifier             | 0.2487179
AdaBoostClassifier        | 0.2346154
RandomForestClassifier    | 0.2051282
GradientBoostingClassifier| 0.2051282
KNeighborsClassifier      | 0.2051282

Best scoring model = MLPClassifier

Score for validation predictions using best model = 0.3125

Feature impact calculated for features associated with MLPClassifier model
Plots saved in /outputs/2020.07.20/run_12.38.51.152/images/

Continuing to hyperparameter search and final model fitting on testing set

Best model fitting now complete - final score on testing set = 0.3

Confusion matrix for testing set:

      | pred_0 pred_1 pred_2 pred_3 pred_4
------| ----------------------------------
true_0| 0      0      3      0      0
true_1| 0      0      0      0      1
true_2| 0      0      4      0      0
true_3| 0      0      5      0      0
true_4| 0      0      5      0      2

Saving down procedure report to /outputs/2020.07.20/run_12.38.51.152/report/
Saving down MLPClassifier model to /outputs/2020.07.20/run_12.38.51.152/models/
Saving down model parameters to /outputs/2020.07.20/run_12.38.51.152/config/
2020.07.20
12:38:51.152

// Example data for various problem types
q)bin_target:asc 100?0b
q)multi_target:desc 100?3
q)fresh_data:([]5000?100?0p;asc 5000?1f;5000?1f;desc 5000?10f;5000?0b)
q)nlp_data:([]100?1f;asc 100?("Testing the application of nlp";"With different characters"))
// FRESH regression example
q).automl.run[fresh_data;reg_tgt;`fresh;`reg;::]
// non-time series/FRESH binary classification example
q).automl.run[tab;bin_target;`normal;`class;::]
// NLP binary classification example
q).automl.run[nlp_data;bin_target;`nlp;`class;::]
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
q)new_tab:([]asc 10?0t;10?1f;desc 10?0b;10?1f;asc 10?1f)
// string date/time input
q).automl.new[new_tab;"2020.01.02";"11.21.47.763"]
0.1404663 0.255114 0.255114 0.2683779 0.2773197 0.487862 0.6659926 0.8547356 ..
// q date/time input
q).automl.new[new_tab;2020.01.02;11:21:47.763]
0.1953181 0.449196 0.6708352 0.5842918 0.230593 0.4713597 0.1953181 0.0576498..
```

