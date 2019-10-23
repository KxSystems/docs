---
title: Processing procedures for the Kx automated machine learning platform
author: Deanna Morgan
description: This document outlines the default behaviour of the Kx automated machine learning offering in particular highlighting the common processes completed across all forms of automated machine learning and the differences between offerings
date: October 2019
keywords: machine learning, ml, automated, processing, cross validation, grid search, models
---

# <i class="fas fa-share-alt"></i> Automated Post-Processing


<i class="fab fa-github"></i>

[KxSystems/automl](https://github.com/kxsystems/automl)

This section describes the outputs produced following model selection and optimization. All outputs are contained in an `Outputs` directory within `automl`. In the default configuration, the pipeline produces a feature impact plot, best model and procedure report. The outputs are contained within folders for `Images`, `Models` and `Reports` respectively, contained within a directory specific to the date and time of that run. The folder structure for each unique run is as follows: `automl/Outputs/date/Run_time/`.

Within the current framework, functions have been provided to plot the feature impact, along with the gain, lift and ROC curves. In the default configuration, only the feature impact is generated for the procedure report as this is applicable to both classification and regression tasks. The additional visualizations available for classification tasks can be run by updating the dictionary input for `.aml.runexample` (see [advanced](link) section).

## Outline of Procedures

The following are the procedures completed when the default system configuration is deployed:

1. Visualizations are produced using holdout data with best model.
2. A report is generated describing the procedures followed throughout the pipeline.
3. Example: expected output within the pipeline for each type of output.

### Visualizations

#### Feature Impact

The feature impact plot identifies the features which have the highest impact on the outcomes of a model. Within the framework, the impact of a single feature is determined by shuffling the values in that column and running the best model again with the new, scrambled feature.

It should be expected that if a feature is an important contributor to the output of a model, then scambling or shuffling that feature will cause the model to perform worse. Conversely, if the model performs better on the shuffled data, which is effectively noise, it is safe to say that the feature is not relevant for model training.

A score is produced by the model for each scrambled column, with all scores ordered and scaled using `.ml.minmaxscaler` contained within the ML-Toolkit. An example plot is shown below for a table comprised of 4 features, using a Gradient Boosting Regressor.

<img src="../img/featureimpact.png"> 

#### Gain/Lift Chart

Gain and lift charts are used to measure of the effectiveness of classification models. Both are calculated as the ratio between results produced with and without the model. 

<img src="../img/liftgain.png">

#### ROC Curve

The ROC (Receiver Operating Characteristic) curve plot depicts a comparison between the false positive rate (1-specificity) and the true positive rate (sensitivity). The ideal ROC curve would climb quickly toward the top left corner, indicating that the model performed well. For a random model, a diagonal line would be shown. The AUC (Area Under Curve) is often used as metric for determining how well classification models perform. A perfect classifier would have an AUC value of 1.

<img src="../img/roc.png">

### Report

A report is generated containing the following information:

- Total extracted features
- Cross validation scores
- Scoring metrics
- Feature impact plot for top 20 most significant features
- Best model and holdout score
- Runtimes for each section
- Feature impact plot

### Expected Output

As mentioned above, in the default configuration the pipeline will produce a feature impact plot, a best model (which has undergone grid search procedures) and a procedure report. Below is an example of the expected output within the pipeline in the default case, where a Lasso model has been returned as the best model for the given regression problem.

```q
q)5#tb:([]asc 100?0t;100?1.;100?1.;100?1.;100?100;100?10)
x            x1        x2        x3         x4 x5 
-------------------------------------------------
00:01:35.123 0.5329983 0.7977537 0.0976921  40 8 
00:18:29.765 0.1845285 0.8333091 0.8125524  96 6  
00:43:35.557 0.9882378 0.6337624 0.05990699 47 2
01:34:27.738 0.1813194 0.8897166 0.1235016  30 5
01:44:33.082 0.2194873 0.0269993 0.3126942  86 3
q)tgt:100?1.
q).aml.runexample[tb;tgt;`normal;`reg;::]
...
Feature impact calculated for features associated with Lasso model -
see img folder in current directory for results

The best model has been selected as Lasso, continuing to grid-search and final model fitting on holdout set

Now saving down a report on this run to Outputs/2019.10.21/Run_10:47:54.325/Reports/

Saving to pdf has been completed
Grid search/final model fitting now completed the final score on the holdout set was: 0.09567505
"Lasso model saved to /home/user/automl/Outputs/2019.10.21/Run_10:47:54.325..
```

