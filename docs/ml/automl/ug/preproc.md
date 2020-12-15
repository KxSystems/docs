---
title: Data preprocessing for the Kx automated machine-learning platform | Machine Learning | Documentation for q and kdb+
description: Default behavior of the Kx automated machine learning tools; common processes completed across all forms of automated machine learning and the differences between offerings
author: 
date: 
keywords: machine learning, automated, ml, model definition, type checking, symbol encoding, infinity replace, null encoding, data cleansing
---
# :fontawesome-solid-share-alt: Automated data preprocessing

:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl)

The preprocessing of data is of critical importance in all machine learning applications, particularly within automated pipelines where the majority of control is, by definition, removed from the user.

Running the function [`.automl.run`](index.md) in its default configuration is achieved by setting the final parameter `dict` to `::`. 

The following are the procedures completed when the default system configuration is deployed:

1. Appropriate models are chosen for the problem type being explored (classification/regression).
2. Columns with inappropriate types are removed from the user defined dataset.
3. A check is applied to ensure that the number of targets is appropriate for the dataset type ```(`fresh/`normal/`nlp)```.
4. Symbol data columns are encoded via either one-hot or frequency encoding.
5. Constant columns are removed from the data.
6. Nulls are replaced and an additional column is added to encode their original position.
7. Positive/negative infinities are replaced by the non-infinite max/min value of the column.
8. Features are created and selected using (``` `fresh/`nlp/`normal ```) feature extraction and significance procedures.
9. Created features are split into training and testing sets ready for machine learning models to be applied.

## Preprocessing nodes

<div markdown="1" class="typewriter">
.automl.x.node.function   **Top-level preprocessing node functions**
  configuration        Entry point used to pass run configuration into AutoML graph
  featureData          Loading of feature dataset from process/alternative data source
  targetData           Loading of the target dataset from process/alternative data source
  dataCheck            Add default parameters to configuration while checking dataset is suitable for AutoML
  modelGeneration      Create list of models to apply based on problem type and user configuration
  featureDescription   Retrieve initial information needed for report generation or running on new data
  labelEncode          Encode symbol label data
  dataPreprocessing    Preprocess data prior to application of ML algorithms
  featureCreation      Generate appropriate features based on problem type
  featureSignificance  Apply feature significance logic to data and return the columns deemed to be significant
  trainTestSplit       Split features and target into training and testing sets
</div>

## `.automl.configuration.node.function`

__

Syntax: `.automl.configuration.node.function[]`

Where

returns 

```q
```

## `.automl.featureData.node.function`

__

Syntax: `.automl.featureData.node.function[]`

Where

returns 

```q
```

## `.automl.targetData.node.function`

__

Syntax: `.automl.targetData.node.function[]`

Where

returns 

```q
```

## `.automl.dataCheck.node.function`

__

Syntax: `.automl.dataCheck.node.function[]`

Where

returns 

```q
```

## Automatic type checking

Given the automated nature of the pipeline, it is important to ensure that only those datatypes handled by the current feature extraction procedures are passed through the workflow. If any columns within the user-defined dataset contain inappropriate types, they will be removed and this will be communicated to the user via the console.

The following lists the restricted types for each problem type. In each case, these types are not handled gracefully within the feature extraction workflow and thus are omitted.

```txt
Normal Feature Extraction    FRESH Feature Extraction    NLP Feature Extraction
  - guid                       - guid                      - guid
  - byte                       - byte                      - byte
  - list                       - list                      - list
  - character                  - character			 
                               - time/date types		
```

The following example shows a truncated output from a normal feature-creation procedure where columns containing byte objects and lists are removed.

```q
// Non-time series (normal) dataset
q)2#normalTable:([]100?1f;100?1f;100?1f;100?0x;100?(5?1f;5?1f))
x         x1        x2        x3 x4                                    ..
-----------------------------------------------------------------------..
0.3620099 0.5804319 0.6001448 00 0.9466946 0.2705882 0.7578669 0.41526 ..
0.9295825 0.2729249 0.848779  00 0.9466946 0.2705882 0.7578669 0.41526 ..
// Regression target
q)5#regTarget:100?1f
0.459111 0.2454972 0.5347477 0.09913289 0.7093666
// Feature extraction type
q)featExtractType:`normal
// Problem type
q)problemType:`reg
// Use default system parameters
q)dict:(::)
// Output truncated to highlight inappropriate column removal
q).automl.run[normalTable;regTarget;featExtractType;problemType;dict]
...
Executing node: dataCheck

 Removed the following columns due to type restrictions for normal
`x3`x4
...
```

## Target consistency

Given the requirement that feature data produced in the feature extraction process must have a 1-to-1 mapping to the input target vector, target consistency is checked prior to the application of feature extraction. The logic behind this check varies for each problem type and is specified below.

problem type | description
:------------|:-----------
FRESH        | The number of unique combinations of aggregate columns must equal the number of targets
Normal       | The number of rows in the input table must equal the number of target values
NLP          | The number of rows in the input table must equal the number of target values

The example below shows the resulting errors for each problem type if this 1-to-1 mapping is not present.

```q
// Feature table
q)table:([]100?1f;100?1f;100?1f)
// Target vector
q)target:50?1f
// Configuration dictionaries
q)freshDict :`featExtractType`aggcols!`fresh`x
q)normalDict:enlist[`featExtractType]!enlist`normal
q)nlpDict   :enlist[`featExtractType]!enlist`nlp
// FRESH example
q).automl.dataCheck.length[table;target;freshDict]
'Target count must equal count of unique agg values for fresh
// Normal example
q).automl.dataCheck.length[table;target;normalDict]
'Must have the same number of targets as values in table
// NLP example
q).automl.dataCheck.length[table;target;nlpDict]
'Must have the same number of targets as values in table
```

## `.automl.modelGeneration.node.function`

__

Syntax: `.automl.modelGeneration.node.function[]`

Where

returns 

```q
```

## Applied models

The models applied in an individual run of AutoML are selected based on the user defined problem type, paired with additional information about the target data. The models available within the framework for each problem type are as follows:


### Binary-classification models

```txt
AdaBoostClassifier
RandomForestClassifier
GradientBoostingClassifier
LogisticRegression
GaussianNB                 
KNeighborsClassifier
MLPClassifier
SVC 
LinearSVC
Keras binary-classification model
```


### Multi-classification models

```txt
AdaBoostClassifier
RandomForestClassifier
GradientBoostingClassifier
KNeighborsClassifier
MLPClassifier
Keras multi-classification model
```


### Regression models

```txt
AdaBoostRegressor
RandomForestRegressor
GradientBoostingRegressor
KNeighborsRegressor
MLPRegressor
Lasso
LinearRegression
Keras regression model
```

These models can be augmented through modification of `models.json` contained within the folder `automl/code/customization/models/modelConfig/` within the repository.

The following example shows how these models are defined within the workflow for a regression problem.

```q
// Regression target
q)5#regTarget:100?1f
0.3927524 0.5170911 0.5159796 0.4066642 0.1780839
// Problem type
q)problemType:`reg
// Configuration dictionary
q)config:enlist[`problemType]!enlist problemType
// Generate model table
q).automl.modelGeneration.node.function[config;regTarget]
model                     lib     fnc            seed typ minit              ..
-----------------------------------------------------------------------------..
AdaBoostRegressor         sklearn ensemble       seed reg {[x;y;z].p.import[x..
RandomForestRegressor     sklearn ensemble       seed reg {[x;y;z].p.import[x..
GradientBoostingRegressor sklearn ensemble       seed reg {[x;y;z].p.import[x..
KNeighborsRegressor       sklearn neighbors      ::   reg {[x;y;z].p.import[x..
MLPRegressor              sklearn neural_network seed reg {[x;y;z].p.import[x..
Lasso                     sklearn linear_model   seed reg {[x;y;z].p.import[x..
LinearRegression          sklearn linear_model   ::   reg {[x;y;z].p.import[x..
regkeras                  keras   reg            seed reg {[x;y;z].p.import[x..
```

The model table produced contains the following columns:

```txt
model   name of the model to be applied
lib     Python library from which the model is derived
fnc     sub module within the python library from which a model is derived
seed    is the model capable of being seeded (seed for yes, null for no)
typ     type of problem being solved
minit   definition of the model which will to be applied within the workflow
```

!!! note "Keras architectures"

    The Keras models first introduced in V0.1 are basic single-layer neural networks. 

    A user can [define more complex Keras architectures](../faq.md) as desired for the use case in question if an appropriate architecture is known.


## `.automl.featureDescription.node.function`

__

Syntax: `.automl.featureDescription.node.function[]`

Where

returns 

```q
```

## `.automl.labelEncode.node.function`

__

Syntax: `.automl.labelEncode.node.function[]`

Where

returns 

```q
```

## `.automl.dataPreprocessing.node.function`

__

Syntax: `.automl.dataPreprocessing.node.function[]`

Where

returns 

```q
```

## Symbol encoding

Within the pipeline, symbol columns are encoded as follows:

-  If there are fewer than 10 unique symbols in a particular column the data is one-hot encoded.
-  If a column contains more than 10 unique symbols the values are frequency encoded.

!!! note

    In the case of FRESH, the above limitations are performed on an aggregation-bucket basis for frequency encoding rather than for an entire column. This ensures that encoding on new data is as fair as possible where each aggregation bucket is associated with an individual target.

The following example shows the application of both one-hot and frequency encoding on a dataset.

```q
// Non-time series (normal) dataset
q)table:([]1000?`1;1000?`a`b`c;1000?1f)
// Maximum number of symbols in column to one-hot encode (default in pipeline is 10)
q)maxOneHot:10
// Configuration dictionary
q)config:enlist[`featExtractType]!enlist`normal
// Symbol encoding to apply
q)show symEncode:.automl.featureDescription.symEncodeSchema[table;maxOneHot;config]
freq| x
ohe | x1
// Apply symbol encoding
q)2#symEncodedData:.automl.dataPreprocessing.symEncoding[table;config;symEncode]
x2        x_freq x1_a x1_b x1_c
-------------------------------
0.6601404 0.062  0    0    1
0.413299  0.077  0    0    1
```

## Null and infinity replacement

Both null and infinite values are replaced within the feature data due to the inability of both sklearn and keras machine learning models to handle this form of data. The below table highlights the values used to replace each of these values where the process aims to limit changes to the data distribution.

value             | symbol  | replacement
:-----------------|:--------|:-------------
Positive infinity | `0w`    | Maximum column value
Negative infinity | `-0w`   | Minimum column value
Null              | `0n`    | Median column value

It should be noted that in cases where nulls are present, an additional column is added to the feature table denoting the location of the null prior to filling of the dataset, thus encoding the null location in the case that this is an important signal for prediction.

Below demonstrates the method used to preprocess the data in this manner.

```q
// Feature table
q)show data:([](3?1f),0n;(3?1f),-0w;4?1f)
x         x1        x2
-----------------------------
0.3102458 0.4618064 0.9397608
0.6723847 0.168868  0.3619267
0.3372559 0.6151447 0.4695611
          -0w       0.3203361
// Apply null encoding (median used as default fill function)
q)show preprocData:.automl.dataPreprocessing.nullEncode[data;med]
x         x1        x2        x_null
------------------------------------
0.3102458 0.4618064 0.9397608 0
0.6723847 0.168868  0.3619267 0
0.3372559 0.6151447 0.4695611 0
0.3237509 -0w       0.3203361 1
// Apply infinity replace
q)show preprocData:.automl.dataPreprocessing.infreplace preprocData
x         x1        x2        x_null
------------------------------------
0.3102458 0.4618064 0.9397608 0
0.6723847 0.168868  0.3619267 0
0.3372559 0.6151447 0.4695611 0
0.3237509 0.168868  0.3203361 1   
```


## `.automl.featureCreation.node.function`

__

Syntax: `.automl.featureCreation.node.function[]`

Where

returns 

```q
```

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


## `.automl.featureSignificance.node.function`

__

Syntax: `.automl.featureSignificance.node.function[]`

Where

returns 

```q
```

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

## `.automl.trainTestSplit.node.function`

__

Syntax: `.automl.trainTestSplit.node.function[]`

Where

returns 

```q
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

