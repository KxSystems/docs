---
title: Postprocessing procedures for the Kx automated machine learning platform
author: Deanna Morgan
description: This document outlines the default behaviour of the Kx automated machine learning offering in particular highlighting the common processes completed across all forms of automated machine learning and the differences between offerings
date: October 2019
keywords: machine learning, ml, automated, processing, cross validation, grid search, models
---

# <i class="fas fa-share-alt"></i> Automated Post-Processing


<i class="fab fa-github"></i> [KxSystems/automl](https://github.com/kxsystems/automl)

This section describes the outputs produced following model selection and optimization. All outputs are contained in an `outputs` directory within the `automl` repository from which the user has executed the pipeline. In its default configuration, the pipeline returns 

1. A feature impact plot visualising the most important features
2. The best model saved down as a h5/binary file 
3. A configuration file outlining the procedure taken for a run which can be used in rerunning a pipeline
4. A report outlining the steps taken and results achieved at each step of a run.

These outputs are contained within sub folders for `images`, `models` and `config` and `reports` respectively, contained within a directory specific to the date and time of that run. The folder structure for each unique run is as follows: `automl/outputs/date/run_time/...`.


### Visualizations

**Feature Impact**

The feature impact plot identifies the features which have the highest impact when predicting the outcomes of a model. Within the framework, the impact of a single feature column is determined by shuffling the values in that column and running the best model again with this new, scrambled feature.

It should be expected that if a feature is an important contributor to the output of a model, then scambling or shuffling that feature will cause the model to not perform as well. Conversely, if the model performs better on the shuffled data, which is effectively noise, it is safe to say that the feature is not relevant for model training.

A score is produced by the model for each scrambled column, with all scores ordered and scaled using `.ml.minmaxscaler` contained within the ML-Toolkit. An example plot is shown below for a table comprised of 4 features, using a Gradient Boosting Regressor.

<img src="../img/featureimpact.png"> 

### Models

The model which produced the best score throughout the pipeline is saved down such that it can be used on new data and maintained for a production environment the following describes form of model is saved to disk.

Model Library | Save type |
--------------|-----------|
Sklearn       | pickled binary file
Keras         | a hdf5 file containing model information

### Report

A report is generated containing the following information:

- Total extracted features
- Cross validation scores
- Scoring metrics
- Feature impact plot for top 20 most significant features
- Best model and holdout score
- Runtimes for each section
- Feature impact plot

### Configuration

Once the pipeline has been completed a configuration dictionary is saved down as a binary file. This file is used for running on new data and can be used for oversight purposes in cases where configuration data is important for regulation.

The following is an example of the contents of one of the config files.

```q
q)get`:metadata
xv        | (`.ml.xv.kfshuff;5)
gs        | (`.ml.gs.kfshuff;5)
prf       | `.aml.xv.fitpredict
scf       | `class`reg!`.ml.accuracy`.ml.mse
seed      | 45760980
saveopt   | 2
hld       | 0.2
tts       | `.ml.traintestsplit
sz        | 0.2
tf        | 0b
typ       | `normal
features  | `x3`x4`xx4_trsvd`xx1_v_trsvd`x4x2_freq_trsvd`x4x1_v_trsvd
test_score| 0.09685584
best_model| `LinearRegression
symencode | `freq`ohe!(,`x2;,`x1)
pylib     | `sklearn
```
