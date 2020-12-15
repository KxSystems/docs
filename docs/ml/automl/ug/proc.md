---
title: Processing procedures Kx automated machine-learning | Machine Learning | Documentation for q and kdb+
description: Default behavior of automated machine learning; common processes completed across all forms of automated machine learning
author: 
date: 
keywords: machine learning, ml, automated, feature extraction, feature selection, cross validation, grid search, random search, sobol-random search, models, optimization
---
# :fontawesome-solid-share-alt: Automated data processing

:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl)

The procedures outlined below describe the steps required to prepare extracted features for training a model, perform cross validation to determine the most generalizable model and optimize this model using hyperparameter search. These steps follow on from the [data preprocessing methods](preproc.md).

The following are the procedures completed when the default system configuration is deployed:

1. Cross validation procedures are performed on a selection of models.
2. Models are scored using a pre-defined performance metric, based on the problem type (classification/regression), with the best model selected and scored on the validation set.
3. Best model saved following optimization using hyperparameter searching procedures.

## Processing nodes

<div markdown="1" class="typewriter">
.automl.x.node.function   **Top-level processing node functions**
  selectModels    Select subset of models based on limitations imposed by the dataset
  runModels       Select most promising model from list of models provided for the user defined problem
  optimizeModels  Apply user defined optimization method (grid/random/sobol) if feasible
</div>

## `.automl.selectModels.node.function`

__

Syntax: `.automl.selectModels.node.function[]`

Where

returns 

```q
```

## `.automl.runModels.node.function`

__

Syntax: `.automl.runModels.node.function[]`

Where

returns 

```q
```

## Cross validation

Cross validation procedures are commonly used in machine learning as a means of testing how robust or stable a model is to changes in the volume of data or the specific subsets of data used for validation. The technique ensures that the best model selected at the end of the process is the one that best generalizes to new unseen data.

The cross validation techniques implemented within AutoML are those contained within the [ML Toolkit](../../toolkit/xval.md). In the default configuration of the pipeline, a shuffled 5-fold cross validation procedure is applied.

For clarity, in the default configuration, 20% of the overall dataset is used as the testing set, 20% of the remaining dataset is used as the holdout (validation) set and then the remaining data is split into 5-folds for cross validation to be carried out.

![](img/5fold.png)


## Model selection

Once the relevant models have undergone cross validation using the training data, scores are calculated using the relevant scoring metric for the problem type (classification/regression).

The file `scoring.txt` contained within `automl/code/customization/scoring
` specifies the possible scoring metrics and how to order the resulting scores (ascending/descending) to ensure that the best model is being returned. The default metric for classification problems is `.ml.accuracy`, while `.ml.mse` is used for regression. 

If necessary, `scoring.txt` can be altered by the user in order to expand the number of metrics available. An extensive list of the metrics provided within the ML Toolkit and thus AutoML can be found [here](../../toolkit/utilities/metric.md), but users can also add their own custom metrics.

Below is an example of the expected output for a regression problem following cross validation. All models are scored using the default regression scoring metric, with the best scoring model selected and used to make predictions on the validation set.

```q
// Normal feature table
q)5#table:([]100?1f;desc 100?1f;100?1f;100?0x;100?(5?1f;5?1f);asc 100?`A`B`C;100?10)
x          x1        x2         x3 x4                                       ..
----------------------------------------------------------------------------..
0.1939619  0.9891722 0.5677955  00 0.2558739 0.9197373 0.4027977  0.1238801 ..
0.8012285  0.9790551 0.06008889 00 0.5414435 0.9448511 0.07606771 0.5823235 ..
0.5504081  0.9653547 0.1905626  00 0.5414435 0.9448511 0.07606771 0.5823235 ..
0.1814507  0.9527033 0.5418338  00 0.5414435 0.9448511 0.07606771 0.5823235 ..
0.04943121 0.9478732 0.811551   00 0.2558739 0.9197373 0.4027977  0.1238801 ..
// Regression target
q)5#target:asc 100?1f
// Feature extraction type
q)featExtractType:`normal
// Problem type
q)problemType:`reg
// Use default system parameters
q)dict:(::)
// Output truncated to highlight model scoring following cross validation
q).automl.run[table;target;featExtractType;problemType;dict]
...
Executing node: runModels

Scores for all models using .ml.mse:
RandomForestRegressor    | 0.0005332644
GradientBoostingRegressor| 0.0005795398
AdaBoostRegressor        | 0.0007657092
LinearRegression         | 0.001347141
KNeighborsRegressor      | 0.001536742
MLPRegressor             | 0.008924621
Lasso                    | 0.06263649
...
```


## `.automl.optimizeModels.node.function`

__

Syntax: `.automl.optimizeModels.node.function[]`

Where

returns 

```q
```

## Optimization

In order to optimize the best model, hyperparameter searching procedures are implemented. This includes the grid, random and Sobol-random search functionality contained within the [ML Toolkit](../../toolkit/xval.md).

The hyperparameters searched for each model contained within the default configuration of AutoML are listed below.

```txt
Models and default grid/random search hyperparameters:
  AdaBoost Regressor               learning_rate, n_estimators
  Gradient Boosting Regressor      criterion, learning_rate, loss
  KNeighbors Regressor             n_neighbors, weights
  Lasso                            alpha, max_iter, normalize, tol
  MLP Regressor                    activation, alpha, learning_rate_init, solver
  Random Forest Regressor          criterion, min_samples_leaf, n_estimators
  AdaBoost Classifier              learning_rate, n_estimators
  Gradient Boosting Classifier     criterion, learning_rate, loss, n_estimators
  KNeighbors Classifier            leaf_size, metric, n_neighbors
  Linear SVC                       C, tol
  Logistic Regression              C, penalty, tol
  MLP Classifier                   activation, alpha, learning_rate_init, solver
  Random Forest Classifier         criterion, min_samples_leaf, min_samples_split
  SVC                              C, degree, tol
```

The values to search for each model and their hyperparameters are specified in the JSON scripts `gsHyperParameters.json` and `rsHyperParameters.json` contained within `automl/code/customization/hyperParameters/`. These can be modified by the user if required.

Once the hyperparameter search has been performed, the optimized model is validated using the testing set, with the final score returned and the best model saved down.

A normal classification example is shown below.

```q
// Normal feature table
q)5#table:([]100?1f;100?1f;100?1f;100?0x;100?(5?1f;5?1f);100?`A`B`C;100?10)
x         x1        x2        x3 x4                                      ..
------------------------------------------------------------------------ ..
0.9372403 0.4290299 0.8453588 00 0.2306148 0.5457702 0.3724991 0.1701194 ..
0.4486143 0.7320771 0.0315015 00 0.2306148 0.5457702 0.3724991 0.1701194 ..
0.1325819 0.1719545 0.7837591 00 0.2543924 0.6105435 0.9996476 0.805952  ..
0.1727493 0.2803566 0.5617684 00 0.2543924 0.6105435 0.9996476 0.805952  ..
0.2754858 0.3462235 0.4277178 00 0.2543924 0.6105435 0.9996476 0.805952  ..
// Multi-classification target
q)target:100?5
// Feature extraction type
q)featExtractType:`normal
// Problem type
q)problemType:`class
// Use default system parameters
q)dict:(::)
// Output truncated to highlight best model score and saving
q).automl.run[table;target;featExtractType;problemType;dict]
...
Executing node: optimizeModels
Executing node: predictParams

Best model fitting now complete - final score on testing set = 0.0001545625
...
Executing node: saveModels

Saving down RandomForestRegressor model to automl/outputs/date/run_time/models/
```

