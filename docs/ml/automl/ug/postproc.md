---
title: Data postprocessing procedures for automated machine learning | Machine Learning | Documentation for kdb+ and q
author: Deanna Morgan
description: Default behavior of automated machine learning; common processes completed across all forms of automated machine learning
date: March 2020
keywords: machine learning, ml, automated, processing, cross validation, grid search, models
---
# :fontawesome-solid-share-alt: Automated Post-Processing



:fontawesome-brands-github: 
[KxSystems/automl](https://github.com/kxsystems/automl)

This section describes the outputs produced following model selection and optimization. All outputs are contained in an `outputs` directory within the `automl` repository from which the user has executed the pipeline. In its default configuration, the pipeline returns 

1. A feature impact plot visualizing the most important features
2. The best model saved as a H5/binary file 
3. A configuration file outlining the procedure taken for a run which can be used in rerunning a pipeline
4. A report outlining the steps taken and results achieved at each step of a run.

These outputs are contained within subfolders for `images`, `models`, `config`, and `reports` respectively, contained within a directory specific to the date and time of the run. The folder structure for each unique run is as follows: `automl/outputs/date/run_time/...`.


## Visualizations

### Feature impact

The feature-impact plot identifies the features which have the highest impact when predicting the outcomes of a model. Within the framework, the impact of a single feature column is determined by shuffling the values in that column and running the best model again with this new, scrambled feature.

It should be expected that if a feature is an important contributor to the output of a model, then scambling or shuffling that feature will cause the model to not perform as well. Conversely, if the model performs better on the shuffled data, which is effectively noise, it is safe to say that the feature is not relevant for model training.

A score is produced by the model for each shuffled column, with all scores ordered and scaled using `.ml.minmaxscaler` contained within the ML Toolkit. An example plot is shown below for a table comprised of four features, using a Gradient Boosting Regressor.

![Feature-impact chart](img/featureimpact.png)


### Confusion matrix

A confusion matrix is produced for classification problems and highlights how well the predictions produced by a model predict the actual class. This gives a user a visual representation of the success or otherwise of their produced model.

![Confusion matrix](img/confusion.png)


## Models

The model which produced the best score throughout the pipeline is saved such that it can be used on new data and maintained for a production environment. The following describes form of model is saved to disk.

model library | save type 
--------------|-----------
Sklearn       | pickled binary file
Keras         | a hdf5 file containing model information


## Report

A report is generated containing the following information:

- Total extracted features
- Cross validation scores
- Scoring metrics
- Feature impact plot for top 20 most significant features
- Best model and holdout score
- Runtimes for each section
- Feature impact plot


## Configuration

Once the pipeline has been completed a configuration dictionary is saved down as a binary file. This file is used for running on new data and can be used for oversight purposes in cases where configuration data is important for regulation.

The following is an example of the contents of one of the config files.

```q
q)get`:metadata
best_scoring_name| `RandomForestRegressor
cnt_feats        | 1
features         | ,`x2
test_score       | 0.0005079553
symencode        | `freq`ohe!``
feat_time        | 00:00:00.001
describe         | `x`x1`x2!+`count`unique`mean`std`min`max`type!(100 100 100..
hyper_params     | `n_estimators`criterion`min_samples_leaf!(10;`mse;1)
xv               | (`.ml.xv.kfshuff;5)
gs               | (`.ml.gs.kfshuff;5)
funcs            | `.automl.prep.i.default
prf              | `.automl.xv.fitpredict
scf              | `class`reg!`.ml.accuracy`.ml.mse
seed             | 55701248
saveopt          | 2
hld              | 0.2
tts              | `.ml.traintestsplit
sz               | 0.2
sigfeats         | `.automl.prep.freshsignificance
tf               | 0b
typ              | `normal
pylib            | `sklearn
mtyp             | `reg
```
