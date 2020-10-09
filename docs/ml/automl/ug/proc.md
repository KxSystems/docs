---
title: Processing procedures Kx automated machine-learning | Machine Learning | Documentation for q and kdb+
author: Deanna Morgan
description: Default behavior of automated machine learning; common processes completed across all forms of automated machine learning
date: October 2019
keywords: machine learning, ml, automated, processing, cross validation, grid search, models
---
# :fontawesome-solid-share-alt: Automated data processing



:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl)

The procedures outlined below describe the steps required to prepare extracted features for training a model, perform cross validation to determine the most generalizable model and optimize this model using grid search. These steps follow on from the [data preprocessing methods](preproc.md).

The following are the procedures completed when the default system configuration is deployed:

1. Feature extraction is performed using FRESH, normal or NLP feature extraction methods.
2. Feature significance tests are applied to extracted features in order to determine those features most relevant for model training.
3. Data is split into training, validation and testing sets.
4. Cross-validation procedures are performed on a selection of models.
5. Models are scored using a predefined performance metric, based on the problem type (classification/regression), with the best model selected and scored on the validation set.
6. Best model saved following optimization using hyperparameter searching procedures.


## Feature extraction

Feature extraction is the process of building derived or aggregate features from a dataset in order to provide the most useful inputs for a machine learning algorithms. Within the automated machine learning framework, there are currently 3 types of feature extraction available, FRESH, normal and NLP feature extraction.


### FRESH

The FRESH (FeatuRe Extraction and Scalable Hypothesis testing) algorithm is used specifically for time-series datasets. The data passed to FRESH should contain an identifying (ID) column, which groups the time-series into subsets from which features can be extracted. Note that each subset will have an associated target. The feature extraction functions applied within the FRESH procedure are defined within the [ML Toolkit](../../toolkit/fresh.md). A full explanation of this algorithm is also provided there.

The example below shows the application of FRESH to a time-series dataset with a date-time ID column and 4 columns from which we derive features.

```q
q)5#tb:([]d:100?2001.01.01+til 5;100?1.;100?1.;100?100;100?10)
d          x         x1        x2 x3
------------------------------------
2001.01.02 0.2966022 0.1671079 52 2 
2001.01.03 0.153475  0.5256145 38 2 
2001.01.03 0.9069809 0.1577109 22 8 
2001.01.04 0.7556175 0.2924597 79 9 
2001.01.04 0.8512139 0.6712163 51 0 
// no. of features before feature extraction
q)count 1_cols tb
4
// apply FRESH feature extraction
q)show freshfeats:.ml.fresh.createfeatures[tb;`d;1_cols tb;.ml.fresh.params]
d         | x_absenergy x_abssumchange x_count x_countabovemean x_countbelowm..
----------| -----------------------------------------------------------------..
2001.01.01| 5.984048    8.764463       23      9                14           ..
2001.01.02| 6.028151    7.374439       18      8                10           ..
2001.01.03| 8.588659    7.321894       23      14               9            ..
2001.01.04| 8.098905    6.28368        17      9                8            ..
2001.01.05| 7.946673    5.334232       19      11               8            ..
// no. of features after feature extraction
q)count 1_cols freshfeats
1132
```

!!! note

    When running `.automl.run` for FRESH data, by default the first column of the dataset is defined as the identifying (ID) column. 

    See instructions on [how to modify this](options.md)


### Natural Language Processing

NLP feature extraction within AutoML makes use of the Kx [NLP library](../../nlp/index.md) in addition to the python `gensim` library for data preprocessing. The following are the steps applied independently to all columns containing text data.

1. Using `.nlp.findRegex` retrieve information surrounding the occurrances of various expressions, for example references to urls, money, the presence of phone numbers etc.
2. Apply named entity recognition to detect references to products, individuals, references to art etc.
3. Apply sentiment analysis to the dataset to extract information about the positive/negative/neutral and compound nature of the text.
4. Apply the function `.nlp.newParser` to extract stop words, tokens and any references to numbers. Using this data calculate the percentage of a sentence that are numeric values, stop words or a particular part of speech.
5. Using the corpus tokens extracted in 4, use the python library `gensim` to create a word2vec encoding of the dataset such that we have a numerical representation of the 'meaning' of a sentence.

If any other non text based columns are present, normal feature extraction is applied to those remaining columns in order to ensure no relevant information is ignored.

Below is an example of NLP feature extraction being applied to a dataset containing strictly text data.

```q
q)5#tb
comment                                                                      ..
-----------------------------------------------------------------------------..
"If you like plot turns, this is your movie. It is impossible at any moment t..
"It's a real challenge to make a movie about a baby being devoured by wild ca..
"What a good film! Made Men is a great action movie with lots of twists and t..
"This is a movie that is bad in every imaginable way. Sure we like to know wh..
"There is something special about the Austrian movies not only by Seidl, but ..
// no. of features before feature extraction
p)count cols tb
1
// Define dictionary to be passed to nlp feature creation
q)dict:enlist[`seed]!enlist 1234
// apply nlp feature creation
q)show nlpfeat:.automl.prep.nlpcreate[tb;dict;0b]`preptab
ADJ        ADP        ADV        AUX        CCONJ      DET       INTJ        ..
-----------------------------------------------------------------------------..
0.1037736  0.04716981 0.0754717  0.0754717  0.02830189 0.1509434 0           ..
0.07643312 0.1210191  0.02547771 0.06369427 0.06369427 0.1719745 0.006369427 ..
0.06153846 0.09230769 0.01538462 0.07692308 0.04615385 0.1384615 0           ..
0.1515152  0.05050505 0.06060606 0.1212121  0.02020202 0.1111111 0.02020202  ..
0.09195402 0.1310345  0.05747126 0.05747126 0.04137931 0.1632184 0           ..
0.07211538 0.08173077 0.09615385 0.07692308 0.0625     0.1442308 0           ..
// no. of features after feature extraction
q)count cols nlpfeat
346
```

### Normal

Normal feature extraction can be applied to ‘normal’ problems, which are independent of time and have one target value per row. The current implementation of normal feature extraction splits time/date type columns into their component parts.

```q
q)5#tb:([]asc 100?0t;100?1.;100?1.;100?1.;100?100;100?10)
x            x1        x2        x3        x4 x5
------------------------------------------------
00:27:44.097 0.4370286 0.1024512 0.6908697 75 1 
00:37:16.725 0.7071204 0.6892404 0.3227387 58 5 
00:52:06.423 0.3053207 0.5529379 0.7147758 4  9 
00:55:03.447 0.5192614 0.7592389 0.4201505 23 7 
01:03:26.039 0.5691797 0.3437228 0.3924408 22 0 
// no. of features before feature extraction
q)count cols tb
6
// Define the functions to be applied in normal feature creation
q)funcs:enlist[`funcs]!enlist `.automl.prep.i.default
// apply normal feature extraction
q)show normfeat:flip first .automl.prep.normalcreate[tb;funcs]
x1        | 0.1312281  0.3667245  0.1415448  0.8186288  0.5973116 0.2413466  ..
x2        | 0.5068552  0.9532577  0.8768543  0.6690883  0.8108164 0.07458746 ..
x3        | 0.9967246  0.07262924 0.1245068  0.5506067  0.1330347 0.1533462  ..
x4        | 68         28         77         78         47        8          ..
x5        | 3          2          1          6          8         3          ..
x_hh      | 0          0          0          0          0         0          ..
x_uu      | 0          11         13         30         31        45         ..
x_ss      | 32         31         48         2          12        50         ..
// no. of features after feature extraction
q)count normfeat
8
```

The early-stage releases of this repository limit the feature extraction procedures that are performed by default on the tabular data for a number of reasons.

1.  The naïve application of many relevant feature-extraction procedures (truncated singular-value decomposition/bulk transforms) while potentially informative can expand the memory usage and computation time beyond an acceptable level.

2. Procedures being applied in one field of use may not be relevant in another field. As such the framework is provided to allow a user to complete feature extractions which are domain-specific if required, rather than assuming procedures to be applied are ubiquitous in all cases.

Over time the system will be updated to perform tasks in a way which is cognizant of the above limitations and where general frameworks can be assummed to be informative.



## Feature selection

In order to reduce dimensionality in the data following feature extraction, significance tests are performed by default using the FRESH [feature significance](../../toolkit/fresh.md) function contained within the ML Toolkit. When default parameters are used, the top 25th percentile of features are selected. The regression example below demonstrates the steps required to extract significant features within the AutoML pipeline. 

```q
q)5#tb:([]100?1f;100?1f;100?1f;100?0x;100?(5?1f;5?1f);100?`A`B`C;100?10)
x         x1         x2         x3 x4                                                 x5 x6
-------------------------------------------------------------------------------------------
0.7856908 0.6066074  0.03652362 00 0.7456247 0.1210367  0.8790503 0.4303547 0.8694497 A  4 
0.634117  0.7527148  0.3851139  00 0.841519  0.04855508 0.4478229 0.2979644 0.4757531 A  3 
0.837205  0.938271   0.8312463  00 0.7456247 0.1210367  0.8790503 0.4303547 0.8694497 B  1 
0.9516154 0.06719988 0.2472061  00 0.841519  0.04855508 0.4478229 0.2979644 0.4757531 B  0 
0.7042753 0.8352592  0.9241053  00 0.841519  0.04855508 0.4478229 0.2979644 0.4757531 A  7 
// regression example
q)tgt:100?1f
...
// preprocessing steps taken in automl pipeline
...
// features created
q)5#tb
x         x1         x2         x6 x5_A x5_B x5_C xx1_trsvd xx2_trsvd xx6_trsvd  xx5_A_trsvd..
--------------------------------------------------------------------------------------------..
0.7856908 0.6066074  0.03652362 4  1    0    0    0.9847321 0.5715507 4.051885   1.265838   ..
0.634117  0.7527148  0.3851139  3  1    0    0    0.9804841 0.7173443 3.042683   1.161163   ..
0.837205  0.938271   0.8312463  1  0    1    0    1.255319  1.179496  1.06683    0.5781603  ..
0.9516154 0.06719988 0.2472061  0  0    1    0    0.7215467 0.8383892 0.07998563 0.6571703  ..
0.7042753 0.8352592  0.9241053  7  1    0    0    1.088445  1.154103  7.034425   1.209613   ..
q)count cols tb
28
// select top 25th percentile of extracted features
q)show feats:.automl.prep.freshsignificance[tb;tgt]
`xx1_trsvd`xx5_A_trsvd`x1x5_A_trsvd`x2x5_A_trsvd`x5_Ax5_B_trsvd`x5_Ax5_C_trsvd`x5_A
q)count feats
7
```

In the example above, the columns `` `x3`x4`` were first removed due to type restrictions. Following this, 28 features were created using normal feature extraction, with 7 selected for model training using the FRESH significance tests.


## Train-test split

Once the most significant features have been selected, the data is split into a training and testing set. The testing set is required later in the process for optimizing the best model.

In order to split the data a number of train-test split procedures are implemented for the different problem types

problem type | function | description |
-------------|----------|-------------|
Normal       |.ml.traintestsplit | Shuffle the dataset and split into training and testing set with defined percentage in each
FRESH        |.ml.ttsnonshuff    | Without shuffling, the dataset is split into training and testing set with defined percentage in each to ensure no time leakage.
NLP          |.ml.traintestsplit | Shuffle the dataset and split into training and testing set with defined percentage in each

An example shows `.ml.traintestsplit` being used within the automated pipeline.

```q
q)5#tb:([]100?1f;100?1f;100?1f;100?0x;100?(5?1f;5?1f))
x         x1        x2         x3 x4                                         ..
-----------------------------------------------------------------------------..
0.8477153 0.3496333 0.01611913 00 0.8200469 0.9857311 0.4629496 0.8518719 0.9..
0.927854  0.6202434 0.1841156  00 0.8200469 0.9857311 0.4629496 0.8518719 0.9..
0.8390122 0.8223493 0.4659199  00 0.8200469 0.9857311 0.4629496 0.8518719 0.9..
0.681369  0.5082821 0.3996036  00 0.8200469 0.9857311 0.4629496 0.8518719 0.9..
0.8917179 0.7072718 0.970522   00 0.8200469 0.9857311 0.4629496 0.8518719 0.9..
// classification problem
q)tgt:100?10?`1
// split into training and testing sets
q)show tts:.ml.traintestsplit[tb;tgt;.2]
xtrain| +`x`x1`x2`x3`x4!(0.6646666 0.7103449 0.2865525 0.08858732 0.4145759 0..
ytrain| `n`i`e`b`o`b`o`k`c`k`e`e`o`e`k`d`c`p`d`n`b`e`c`o`e`p`c`o`o`d`p`k`e`k`..
xtest | +`x`x1`x2`x3`x4!(0.9274054 0.9187341 0.927854 0.9512318 0.9469828 0.5..
ytest | `n`d`b`d`e`e`c`c`i`b`b`c`o`k`c`k`k`c`c`d
// count features and targets in each set
q)count each tts
xtrain| 80
ytrain| 80
xtest | 20
ytest | 20
```

For classification problems, similar to the one above, it cannot be guaranteed that all of the distinct target classes will appear in both the training and testing sets. This is an issue for the Keras neural network models which require that a sample from each target class is present in both splits of the data.

For this reason, the utility function `.automl.i.kerascheck` must be applied to the data split prior to model training. The function determines if all classes are present in each split of the data. If not, the Keras models will be removed from the list of models to be tested.

Below shows the output to be expected from `.automl.run` when the same number of classes are not present in each dataset.

```q
q).automl.run[tb;tgt;`normal;`class;(::)]
...
Test set does not contain examples of each class. Removed MultiKeras from models
...
```

At this stage it is possible to begin model training and validation using cross-validation procedures. To do so, the data which is currently in the training set must be further split into training and validation sets. Following the same process as before, the Keras check must be applied again if Keras models are still present.


## Cross validation

Cross-validation procedures are commonly used in machine learning as a means of testing how robust or stable a model is to changes in the volume of data or the specific subsets of data used for validation. The technique ensures that the best model selected at the end of the process is the one that best generalizes to new unseen data.

The cross validation techniques implemented in the automated machine-learning platform are those contained within the [ML Toolkit](../../toolkit/xval.md)). The specific type of cross validation applied to the training data in each case is a shuffled 5-fold cross-validation procedure.

For clarity, the splitting of data to this point as implemented in the default configuration is depicted below, where 20% of the overall dataset is used as the testing set, 20% of the remaining dataset is used as the validation set and then the remaining data is split into 5-folds for cross validation to be carried out.

![](img/5fold.png)


## Model selection

Once the relevant models have undergone cross validation using the training data, scores are calculated using the relevant scoring metric for the problem type (classification or regression). The file `scoring.txt` is provided within the platform which specifies the possible scoring metrics and how results should be ordered (ascending/descending) for each of these metrics in order to ensure that the best model is being returned. This file can be altered by the user if necessary in order to expand the number of metrics available or to add custom metrics. The default metric for classification problems is accuracy, while MSE is used for regression. An extensive list of example metric functions  applied in kdb can be found in the [ML-Toolkit](../../toolkit/utilities/metric.md)

Below is an example of the expected output for a regression problem following cross validation. All models are scored using the default regression scoring metric, with the best scoring model selected and used to make predictions on the validation set.

```q
q)5#tb:([]100?1f;100?1f;100?1f;100?0x;100?(5?1f;5?1f);100?`A`B`C;100?10)
x          x1         x2        x3 x4                                        ..
-----------------------------------------------------------------------------..
0.06119115 0.1102437  0.9265934 00 0.002184472 0.06670537 0.6918339 0.4301331..
0.5510458  0.08516535 0.307924  00 0.002184472 0.06670537 0.6918339 0.4301331..
0.456294   0.3164178  0.1045391 00 0.002184472 0.06670537 0.6918339 0.4301331..
0.6581265  0.2706949  0.8376952 00 0.002184472 0.06670537 0.6918339 0.4301331..
0.9841029  0.3510406  0.7041609 00 0.002184472 0.06670537 0.6918339 0.4301331..
// regression example
q)tgt:100?1f
q).automl.run[tb;tgt;`normal;`reg;(::)]
...
Scores for all models, using .ml.mse
LinearRegression         | 0.08938869
KNeighborsRegressor      | 0.09325071
Lasso                    | 0.09390912
AdaBoostRegressor        | 0.09654465
RandomForestRegressor    | 0.1206891
MLPRegressor             | 0.1398568
GradientBoostingRegressor| 0.1399826
regkeras                 | 0.3604642

Best scoring model = LinearRegression
Score for validation predictions using best model = 0.1263564
```


## Optimization

In order to optimize the best model, hyperparameter searching procedures are implemented. Similarly to the cross validation methods above, this includes the grid search functionality contained within the ML-Toolkit, along with new random and Sobol-random search functionality.

In the default configuration, grid search is applied to the best model using the combined training and validation data. The parameters changed for each model in the default configuration are those listed below. The specific values for each parameter are contained within the q script `grid/random_hyperparameters.q` and can be altered by the user if required. 

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

Once the hyperparameter search has been performed, the optimized model is tested using the testing set, with the final score returned and the best model saved down. A normal classification example is shown below.

```q
q)5#tb:([]100?1f;100?1f;100?1f;100?0x;100?(5?1f;5?1f);100?`A`B`C;100?10)
x         x1         x2         x3 x4                                        ..
-----------------------------------------------------------------------------..
0.734461  0.3435291  0.6891676  00 0.8372026 0.4100884 0.7181567 0.7001034 0...
0.9741231 0.8266936  0.1658819  00 0.8372026 0.4100884 0.7181567 0.7001034 0...
0.6970151 0.1212986  0.7434879  00 0.8372026 0.4100884 0.7181567 0.7001034 0...
0.1726593 0.5145226  0.9719498  00 0.8372026 0.4100884 0.7181567 0.7001034 0...
0.2092798 0.02959764 0.03549935 00 0.3442338 0.1319948 0.6779861 0.2621923 0...
// regression example
q)tgt:100?5
q).automl.run[tb;tgt;`normal;`class;::]
...
Best scoring model = AdaBoostClassifier

Best model fitting now complete - final score on testing set = 0.2

Saving down AdaBoostClassifier model to /outputs/2020.04.28/run_15.16.55.074/models/
```

