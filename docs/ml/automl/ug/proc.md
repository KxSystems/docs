---
title: Processing procedures Kx automated machine-learning | Machine Learning | Documentation for q and kdb+
author: Deanna Morgan
description: Default behavior of automated machine learning; common processes completed across all forms of automated machine learning
date: November 2020
keywords: machine learning, ml, automated, feature extraction, feature selection, cross validation, grid search, random search, sobol-random search, models, optimization
---
# :fontawesome-solid-share-alt: Automated data processing



:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl)

The procedures outlined below describe the steps required to prepare extracted features for training a model, perform cross validation to determine the most generalizable model and optimize this model using hyperparameter search. These steps follow on from the [data preprocessing methods](preproc.md).

The following are the procedures completed when the default system configuration is deployed:

1. Feature extraction is performed using FRESH, normal or NLP feature extraction methods.
2. Feature significance tests are applied to the extracted features in order to determine those features most relevant for model training.
3. Data is split into training, validation and testing sets.
4. Cross validation procedures are performed on a selection of models.
5. Models are scored using a pre-defined performance metric, based on the problem type (classification/regression), with the best model selected and scored on the validation set.
6. Best model saved following optimization using hyperparameter searching procedures.


## Feature extraction

Feature extraction is the process of building derived or aggregate features from a dataset in order to provide the most useful inputs for a machine learning algorithms. Within the AutoML framework, there are currently 3 types of feature extraction available - FRESH, normal and NLP feature extraction.


### FRESH

The FRESH (FeatuRe Extraction and Scalable Hypothesis testing) algorithm is used specifically for time series datasets. The data passed to FRESH should contain an identifying (ID) column, which groups the time series into subsets, from which features can be extracted. Note that each subset will have an associated target.

The feature extraction functions applied within the FRESH procedure are defined within the [ML Toolkit](../../toolkit/fresh.md). A full explanation of this algorithm is also provided there.

The example below shows the application of FRESH to a time series dataset with a date-time ID column and 4 additional feature columns which will be used to derive more features using FRESH.

```q
// FRESH feature table
q)5#table:([]date:100?2001.01.01+til 5;100?1.;100?1.;100?100;100?10)
date       x          x1        x2 x3
-------------------------------------
2001.01.05 0.1461295  0.8416288 4  8
2001.01.01 0.2032099  0.7250709 46 1
2001.01.05 0.2310648  0.481804  99 9
2001.01.04 0.3138309  0.9351307 52 5
2001.01.04 0.01974141 0.7093398 10 4
// ID column name
q)idCol:`date
// Remaining features to apply FRESH to
q)freshCols:1_cols table
// Dictionary of functions to apply within FRESH
q)paramDict:.ml.fresh.params
// Number of features before feature extraction
q)count freshCols
4
// Apply FRESH feature extraction
q)show freshFeats:.ml.fresh.createfeatures[table;idCol;freshCols;paramDict]
date      | x_absenergy x_abssumchange x_count x_countabovemean x_countbelowm..
----------| -----------------------------------------------------------------..
2001.01.01| 5.228462    5.30979        19      11               8            ..
2001.01.02| 7.681104    4.635133       22      10               12           ..
2001.01.03| 8.718458    6.1629         18      9                9            ..
2001.01.04| 6.354958    8.313009       20      10               10           ..
2001.01.05| 6.820029    5.889657       21      13               8            ..
// Number of features after feature extraction
q)count 1_cols freshFeats
1132
```

!!! note

    When running `.automl.run` for FRESH data, by default the first column of the dataset is defined as the identifying (ID) column. 

    See instructions on [how to modify this](options.md).




### Natural Language Processing

NLP feature extraction within AutoML makes use of the Kx [NLP library](../../nlp/index.md) in addition to the python `gensim` library for data preprocessing.

The following are the steps applied independently to all columns containing text data:

1. Use `.nlp.findRegex` to retrieve information surrounding the occurrances of various expressions, e.g. references to urls, money, the presence of phone numbers, etc.
2. Apply named entity recognition to detect references to products, individuals, references to art, etc.
3. Apply sentiment analysis to the dataset to extract information about the positive/negative/neutral and compound nature of the text.
4. Apply the function `.nlp.newParser` to extract stop words, tokens and any references to numbers. Using this data, calculate the percentages of a sentence that are numeric values, stop words or particular parts of speech.
5. Using the corpus tokens extracted in 4, use the Python library `gensim` to create a word2vec encoding of the dataset, such that we have a numerical representation of the 'meaning' of a sentence.

If any other non-text based columns are present, normal feature extraction is applied to those remaining columns in order to ensure no relevant information is ignored.

Below is an example of NLP feature extraction being applied to a dataset containing strictly text data.

```q
// NLP feature table
q)5#table
comment                                                                     ..
----------------------------------------------------------------------------..
"If you like plot turns, this is your movie. It is impossible at any moment ..
"It's a real challenge to make a movie about a baby being devoured by wild  ..
"What a good film! Made Men is a great action movie with lots of twists and ..
"This is a movie that is bad in every imaginable way. Sure we like to know  ..
"There is something special about the Austrian movies not only by Seidl, but..
// Configuration dictionary:
// w2v - NLP training algorithm (0 - CBOW (Continuous Bag of words) by default)
// seed - Model seed for reproducible results
q)config:`w2v`seed!(0;1234)
// Number of features before feature extraction
p)count cols table
1
// Apply NLP feature creation
q)show nlpFeats:.automl.featureCreation.nlp.create[table;config]`features
ADJ        ADP        ADV        AUX        CCONJ      DET       INTJ        ..
-----------------------------------------------------------------------------..
0.1037736  0.04716981 0.0754717  0.0754717  0.02830189 0.1509434 0           ..
0.07643312 0.1210191  0.02547771 0.06369427 0.06369427 0.1719745 0.006369427 ..
0.06153846 0.09230769 0.01538462 0.07692308 0.04615385 0.1384615 0           ..
0.1515152  0.05050505 0.06060606 0.1212121  0.02020202 0.1111111 0.02020202  ..
0.09195402 0.1310345  0.05747126 0.05747126 0.04137931 0.1632184 0           ..
0.07211538 0.08173077 0.09615385 0.07692308 0.0625     0.1442308 0           ..
// Number of features after feature extraction
q)count cols nlpFeats
346
```

### Normal

Normal feature extraction can be applied to non-time series problems that have a 1-to-1 mapping between features and targets. The current implementation of normal feature extraction splits time/date type columns into their component parts.

```q
// Normal feature table
q)5#table:([]asc 100?0t;100?1.;100?1.;100?1.;100?100;100?10)
x            x1        x2        x3        x4 x5
------------------------------------------------
00:49:20.155 0.3298905 0.2966022 0.1671079 52 2
00:49:31.925 0.5721476 0.153475  0.5256145 38 2
01:30:35.693 0.7611596 0.9069809 0.1577109 22 8
01:56:27.030 0.4314355 0.7556175 0.2924597 79 9
02:15:41.653 0.854204  0.8512139 0.6712163 51 0
// Configuration dictionary containing functions to apply (below is default)
q)config:enlist[`funcs]!enlist`.automl.featureCreation.normal.default
// Number of features before feature extraction
q)count cols table
6
// Apply normal feature creation
q)show 5#normFeats:.automl.featureCreation.normal.create[table;config]`features
x1        x2        x3        x4 x5 x_hh x_uu x_ss
--------------------------------------------------
0.3298905 0.2966022 0.1671079 52 2  0    49   20
0.5721476 0.153475  0.5256145 38 2  0    49   31
0.7611596 0.9069809 0.1577109 22 8  1    30   35
0.4314355 0.7556175 0.2924597 79 9  1    56   27
0.854204  0.8512139 0.6712163 51 0  2    15   41
// Number of features after feature extraction
q)count cols normFeats
8
```

The early-stage releases of this repository limit the feature extraction procedures that are performed by default on the tabular data for a number of reasons:

1.  The naïve application of many relevant feature extraction procedures (truncated singular-value decomposition/bulk transforms) while potentially informative can expand the memory usage and computation time beyond an acceptable level.

2. Procedures being applied in one field of use may not be relevant in another. As such, the framework is provided to allow a user to complete feature extractions which are domain-specific if required, rather than assuming procedures to be applied are ubiquitous in all cases.

Over time the system will be updated to perform tasks in a way which is cognizant of the above limitations and where general frameworks can be assumed to be informative.



## Feature selection

In order to reduce dimensionality in the data following feature extraction, significance tests are performed by default using the FRESH [feature significance](../../toolkit/fresh.md) function contained within the ML Toolkit. The default procedure will use the Benjamini-Hochberg-Yekutieli (BHY) procedure to identify significant features within the dataset. If no significant columns are returned, the top 25th percentile of features will be selected.

The regression example below demonstrates the steps required to extract significant features within the AutoML pipeline. 

```q
// Normal feature table
q)5#table:([]asc 100?1f;100?1f;100?1f;100?10;100?5?1f;100?10)
x           x1         x2         x3 x4        x5
-------------------------------------------------
0.003918537 0.141434   0.6194124  6  0.4620557 6
0.01164076  0.1468753  0.06252215 8  0.9667906 4
0.01278544  0.563207   0.4760213  5  0.3847399 9
0.02044124  0.09405027 0.7666556  4  0.6893925 9
0.06234204  0.8794027  0.4539865  6  0.6893925 7
// Regression target
q)target:asc 100?1f
// Configuration dictionary containing functions to apply (below is default)
q)config:enlist[`sigFeats]!enlist`.automl.featureSignificance.significance
// Number of features before feature selection
q)count cols table
6
// Apply feature selection
q)show 5#sigFeats:.automl.featureSignificance.node.function[config;table;target][`sigFeats]#table
x
-----------
0.003918537
0.01164076
0.01278544
0.02044124
0.06234204
// Number of features after feature selection
q)count cols sigFeats
1
```

## Train-test split

Once the most significant features have been selected, the data is split into training and testing sets, where the testing set is required later in the process for optimizing the best model.

In order to split the data, a number of train-test split procedures are implemented for the different problem types:

problem type | function                | description 
-------------|-------------------------|-------------
Normal       |.ml.traintestsplit       | Shuffle the dataset and split into training and testing set with defined percentage in each
FRESH        |.automl.utils.ttsNonShuff| Without shuffling, the dataset is split into training and testing set with defined percentage in each to ensure no time leakage.
NLP          |.ml.traintestsplit       | Shuffle the dataset and split into training and testing set with defined percentage in each

An example shows `.ml.traintestsplit` being used within the automated pipeline.

```q
// Normal feature table
q)5#table:([]100?1f;100?1f;100?1f;100?10;100?5?1f)
x         x1         x2         x3 x4
--------------------------------------------
0.4290586 0.2513957  0.1796457  9  0.2627599
0.7203001 0.795993   0.3726246  2  0.3275659
0.6850917 0.09576055 0.4763966  5  0.2627599
0.4656794 0.1901566  0.04412882 7  0.2627599
0.6565776 0.8952948  0.6522315  6  0.2627599
// Convert to matrix to pass to Python ML models
q)matrix:flip value flip table
// Multi-classification target
q)target:100?10
// Split into training and testing sets
q)show trainTestSplit:.ml.traintestsplit[matrix;target;.2]
xtrain| ((0.1347387;0.3313455;0.9583562;4;0.3275659);(0.4969388;0.8638165;0.1..
ytrain| 8 2 2 6 6 1 9 0 6 7 8 7 4 4 5 7 2 5 1 8 9 3 0 8 1 7 2 4 6 0 3 6 5 1 6..
xtest | ((0.5786161;0.1787912;0.5867965;7;0.5207425);(0.1491161;0.11833;0.059..
ytest | 8 4 7 7 3 6 5 2 8 6 9 8 0 1 7 8 3 9 7 4
// Number of datapoints in each set
q)count each trainTestSplit
xtrain| 80
ytrain| 80
xtest | 20
ytest | 20
```

For classification problems, similar to the one above, it cannot be guaranteed that all of the distinct target classes will appear in both the training and testing sets. This is an issue for the Keras neural network models which requires that a sample from each target class is present in both splits of the data.

For this reason, the function `.automl.selectModels.targetKeras` must be applied to the data split prior to model training. The function determines if all classes are present in each split of the data. If not, the Keras models will be removed from the list of models to be tested.

Below shows the expected output `.automl.run` should the same number of classes not be present in each dataset.

```q
q).automl.run[table;target;`normal;`class;(::)]
...
Executing node: selectModels

Test set does not contain examples of each class. Removed any multi-keras models.
...
```

At this stage it is possible to begin model training and validation using cross-validation procedures. To do so, the data which is currently in the training set must be further split into training and validation sets. Following the same process as before, the Keras check must be applied again if Keras models are still present.


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

