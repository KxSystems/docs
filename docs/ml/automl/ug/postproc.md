---
title: Data post-processing procedures for automated machine learning | Machine Learning | Documentation for kdb+ and q
description: Default behavior of automated machine learning; common processes completed across all forms of automated machine learning
author: Deanna Morgan
date: December 2020
keywords: machine learning, ml, automated, processing, cross validation, grid search, models
---
# :fontawesome-solid-share-alt: Automated Post-Processing

:fontawesome-brands-github: 
[KxSystems/automl](https://github.com/kxsystems/automl)

This section describes the outputs produced following model selection and optimization. All outputs are contained in an `outputs` directory within the `automl` repository.

In its default configuration, the pipeline returns:

1. Visualizations - data split, target distribution, feature impact, confusion matrix (classification only) and regression analysis (regression only) plots.
2. The best model saved as a H5/binary file.
3. A configuration file outlining the procedure carried out for a run which can be used in re-running a pipeline.
4. A report outlining the steps taken and results achieved at each step of a run.

These outputs are contained within subfolders for `images`, `models`, `config`, and `reports` respectively, contained within a directory specific to the date and time of the run. The folder structure for each unique run is as follows: `automl/outputs/date/run_time/...`.

## Processing nodes

<div markdown="1" class="typewriter">
.automl.X.node.function   **Top-level processing node functions**
  [preprocParams](#automlpreprocparamsnodefunction)  Collect parameters for report/graph generation from preprocessing nodes
  [predictParams](#automlpredictparamsnodefunction)  Collect parameters for report/graph generation from prediction stages
  [pathConstruct](#automlpathconstructnodefunction)  Construct save paths for generated graphs/reports
  [saveGraph](#automlsavegraphnodefunction)      Save all the graphs required for report generation
  [saveMeta](#automlsavemetanodefunction)       Save relevant metadata for use with a persisted model on new data
  [saveReport](#automlsavereportnodefunction)     Save Python generated report summarizing current run via pyLatex/reportlab
  [saveModels](#automlsavemodelsnodefunction)     Save encoded representation of best model retrieved during run of AutoML
</div>

## `.automl.preprocParams.node.function`

_Collect parameters for report/graph generation from preprocessing nodes_

Syntax: `.automl.preprocParams.node.function[config;descrip;cTime;sigFeats;symEncode;symMap;featModel;tts]`

Where

-   `config` is a dictionary with location and method by which to retrieve the data
-   `descrip` is a table with symbol encoding, feature data and description
-   `cTime` is the time taken for feature creation
-   `sigFeats` is a symbol list of significant features
-   `symEncode` is a dictionary with columns to symbol encode and their required encoding
-   `symMap` is a dictionary with a mapping of symbol encoded target data
-   `featModel` is the embedPy NLP feature creation model used (if required)
-   `tts` is a dictionary with feature and target data split into training/testing sets

returns dictionary of consolidated parameters to be used to generate reports/graphs.

## `.automl.predictParams.node.function`

_Collect parameters for report/graph generation from prediction stages_

Syntax: `.automl.predictParams.node.function[bestModel;hyperParams;modelName;testScore;analyzeModel;modelMetaData]`

Where

-   `bestModel` is the best fitted model as an embedPy object
-   `hyperParmams` is a dictionary of hyperparameters used for the best model (if any)
-   `modelName` is the name of the best model as a string
-   `testScore` is the floating point score of the best model on used on testing data
-   `modelMetaData` is a dictionary with the metadata produced in finding the best model

returns a dictionary with consolidated parameters to be used to generate reports/graphs.

## `.automl.pathConstruct.node.function`

_Construct save paths for generated graphs/reports_

Syntax: `.automl.pathConstruct.node.function[preProcParams;predictionStore]`

Where

-   `preProcParams` is a dictionary with data generated during the preprocess stage
-   `predictionStore` is a dictionary with data generated during the prediction stage

returns a dictionary containing all the data collected along the entire process along with paths to where graphs/reports will be generated.

## `.automl.saveGraph.node.function`

_Save all the graphs required for report generation_

### Visualizations

A number of visualizations are produced within the pipeline and are saved to disk (in the default setting of AutoML) to be used within the run report, or otherwise. The specific images produced are detailed below and depend on the problem type of the current run.

**Data split**

Within any run, an image showing the specific split applied to the data will be generated. In the default case (depicted below), 20% of the data is used as the testing set, then 20% of the remaining data is used as a holdout set, while the rest of the data used as the training set.

![Data Split](img/5fold.png)

**Target distribution**

A target distribution plot it generated for both classification and regression tasks. For classification, the plot simply shows the split between the classes within the target vector. While in the regression case, the target values are separated into 10 bins, as demonstrated in the example below.

![Target Distribution](img/targetdistribution.png)

**Feature impact**

The feature impact plot identifies the features which have the highest impact when predicting the outcomes of a model. Within the framework, the impact of a single feature column is determined by shuffling the values in that column and running the best model again with this new, scrambled feature.

It should be expected that if a feature is an important contributor to the output of a model, then scrambling or shuffling that feature will cause the model to not perform as well. Conversely, if the model performs better on the shuffled data, which is effectively noise, it is safe to say that the feature is not relevant for model training.

A score is produced by the model for each shuffled column, with all scores ordered and scaled using `.ml.minmaxscaler` contained within the ML Toolkit. An example plot is shown below for a table containing four features, using a Gradient Boosting Regressor.

![Feature Impact](img/featureimpact.png)

**Confusion matrix**

A confusion matrix is produced for classification problems and highlights how well the predictions produced by a model predict the actual class. This gives a user a visual representation of the success or otherwise of their produced model.

![Confusion Matrix](img/confusion.png)

**Regression analysis**

For regression problems, plots of true vs predicted targets and their residuals values are produced. Users can use these plots to determine how well their model performed given that a model which produced perfect predictions would show a perfect correlation between predicted and true values, with all residuals equal to zero. An example is shown below for a Random Forest Regressor model. 

![Regression Analysis](img/rfr_regression.png)

### Functionality

Syntax: `.automl.saveGraph.node.function[params]`

Where

-   params {dict} All data generated during the preprocessing and  prediction stages

returns a null on success, where all graphs needed for reports will have been saved to appropriate locations. 

## `.automl.saveMeta.node.function`

_Save relevant metadata for use with a persisted model on new data_

### Configuration

Once the pipeline has been completed a configuration dictionary is saved down as a binary file. This file is used for running on new data and can be used for oversight purposes in cases where configuration data is important for regulation.

The following is an example of the config file produced for a single run of AutoML which used FRESH classification data.

```q
q)get`:automl/outputs/dateTimeModels/2020.12.17/run_14.57.20.206/config/metadata
modelLib                     | `sklearn
modelFunc                    | `ensemble
startDate                    | 2020.12.17
startTime                    | 14:57:20.206
featureExtractionType        | `fresh
problemType                  | `reg
saveOption                   | 2
seed                         | 53840238
crossValidationFunction      | `.ml.xv.kfshuff
crossValidationArgument      | 5
gridSearchFunction           | `.automl.gs.kfshuff
gridSearchArgument           | 5
randomSearchFunction         | `.automl.rs.kfshuff
randomSearchArgument         | 5
hyperparameterSearchType     | `grid
holdoutSize                  | 0.2
testingSize                  | 0.2
numberTrials                 | 256
significantFeatures          | `.automl.featureSignificance.significance
predictionFunction           | `.automl.utils.fitPredict
scoringFunctionClassification| `.ml.accuracy
scoringFunctionRegression    | `.ml.mse
loggingDir                   | `
loggingFile                  | `
pythonWarning                | 0
overWriteFiles               | 0
targetLimit                  | 10000
savedModelName               | `
functions                    | `.ml.fresh.params
trainTestSplit               | `.automl.utils.ttsNonShuff
aggregationColumns           | `x
configSavePath               | "C:/Users/dmorgan1/AppData/Local/Continuum/ana..
modelsSavePath               | "C:/Users/dmorgan1/AppData/Local/Continuum/ana..
imagesSavePath               | "C:/Users/dmorgan1/AppData/Local/Continuum/ana..
reportSavePath               | "C:/Users/dmorgan1/AppData/Local/Continuum/ana..
mainSavePath                 | "C:/Users/dmorgan1/AppData/Local/Continuum/ana..
logFunc                      | {[filename;val;nline1;nline2]
savedWord2Vec                | 0b
modelName                    | `RandomForestRegressor
symEncode                    | `freq`ohe!``
sigFeats                     | `x1_countbelowmean`x1_mean2dercentral`x1_med`x..
```

### Functionality

Syntax: `.automl.saveMeta.node.function[params]`

Where

-   `params` is a dictionary with all the data generated during the preprocessing and prediction stages

returns is a dictionary containing all metadata information needed to generate predict function.

## `.automl.saveReport.node.function`

_Save Python generated report summarizing current run via pyLatex/reportlab_

### Report

A report is generated containing the following information:

- Total extracted features
- Cross validation scores
- Scoring metrics
- Above listed plots
- Best model and holdout score
- Runtimes for each section

Syntax: `.automl.saveReport.node.function[params]`

Where

-   `params` is a dictionary with all the data generated during the preprocessing and prediction stages

returns null on success, where a report will have been saved to a location defined by run date and time.

## `.automl.saveModels.node.function`

_Save encoded representation of best model retrieved during run of AutoML_

### Models

The best performing model produced by the pipeline is saved to disk such that it can be used on new data and maintained for a production environment. The following describes the format models are saved in based on their library:

Model library | Save type 
--------------|-----------
Sklearn       | Pickled binary file
Keras         | hdf5 file containing model information

### Functionality

Syntax: `.automl.saveModels.node.function[params]`

Where

-   `params` is a dictionary with all the data generated during the preprocessing and prediction stages

returns null on success, where all models have been saved to an appropriate location.