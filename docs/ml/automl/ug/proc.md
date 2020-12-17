---
title: Processing procedures Kx automated machine-learning | Machine Learning | Documentation for q and kdb+
description: Default behavior of automated machine learning; common processes completed across all forms of automated machine learning
author: Diane O'Donoghue
date: December 2020
keywords: machine learning, ml, automated, feature extraction, feature selection, cross validation, grid search, random search, sobol-random search, models, optimization
---
# :fontawesome-solid-share-alt: Automated data processing

:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl)

The procedures outlined below describe the steps required to prepare extracted features for training a model, perform cross validation to determine the most generalizable model and optimize this model using hyperparameter search. These steps follow on from the [data pre-processing methods](preproc.md).

The following are the procedures completed when the default system configuration is deployed:

1. Models are selected to be applied to the data.
2. Cross validation procedures are performed on a selection of models.
3. Models are scored using a pre-defined performance metric, based on the problem type (classification/regression), with the best model selected and scored on the validation set.
4. Best model optimized using hyperparameter searching procedures.

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

### Cross validation

Cross validation procedures are commonly used in machine learning as a means of testing how robust or stable a model is to changes in the volume of data or the specific subsets of data used for validation. The technique ensures that the best model selected at the end of the process is the one that best generalizes to new unseen data.

The cross validation techniques implemented within AutoML are those contained within the [ML Toolkit](../../toolkit/xval.md). In the default configuration of the pipeline, a shuffled 5-fold cross validation procedure is applied.

For clarity, in the default configuration, 20% of the overall dataset is used as the testing set, 20% of the remaining dataset is used as the holdout (validation) set and then the remaining data is split into 5-folds for cross validation to be carried out.

![](img/5fold.png)


### Model selection

Once the relevant models have undergone cross validation using the training data, scores are calculated using the relevant scoring metric for the problem type (classification/regression).

The file `scoring.json` contained within `automl/code/customization/scoring` specifies the possible scoring metrics and how to order the resulting scores (ascending/descending) to ensure that the best model is being returned. The default metric for classification problems is `.ml.accuracy`, while `.ml.mse` is used for regression. 

If necessary, `scoring.json` can be altered by the user in order to expand the number of metrics available. An extensive list of the metrics provided within the ML Toolkit and thus AutoML can be found [here](../../toolkit/utilities/metric.md), but users can also add their own custom metrics.

### Functionality

Syntax: `.automl.runModels.node.function[]`

Where

returns 

```q
```

## `.automl.optimizeModels.node.function`

__

### Optimization

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

### Functionality

Syntax: `.automl.optimizeModels.node.function[]`

Where

returns 

```q
```