---
title: Data preprocessing for the Kx automated machine learning platform | Machine Learning | Documentation for q and kdb+
description: Default behavior of the Kx automated machine learning tools; common processes completed across all forms of automated machine learning and the differences between offerings
author: Deanna Morgan
date: December 2020
keywords: machine learning, automated, ml, model definition, type checking, symbol encoding, infinity replace, null encoding, data cleansing
---
# :fontawesome-solid-share-alt: Automated data preprocessing

:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl)

The below details the nodes that are used to preprocess data within the pipeline. Data preprocessing is a necessary step in any robust machine learning application. It is particularly important when it comes to automated pipelines where, by definition, the majority of the control is removed from the user. 

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

_Entry point used to pass run configuration into AutoML graph_

Syntax: `.automl.configuration.node.function[config]`

Where

-   `config` is a dictionary with custom configuration information relevant to the present run

returns the configuration dictionary ready to be passed to the relevant nodes within the pipeline.

## `.automl.featureData.node.function`

_Loading of feature dataset from process/alternative data source_

Syntax: `.automl.featureData.node.function[config]`

Where

-   `config` is a dictionary with the location and method by which to retrieve the data

returns feature data as a table.

```q
```

## `.automl.targetData.node.function`

_Loading of the target dataset from process/alternative data source_

Syntax: `.automl.targetData.node.function[config]`

Where

-   `config` is a dictionary with the location and method by which to retrieve the data

returns a numerical or symbol target vector.

```q
```

## `.automl.dataCheck.node.function`

_Add default parameters to configuration while checking dataset is suitable for AutoML_

### Data checking within AutoML

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

Additionally, given the requirement that feature data produced in the feature extraction process must have a 1-to-1 mapping to the input target vector, target consistency is checked prior to the application of feature extraction. The logic behind this check varies for each problem type and is specified below.

problem type | description
:------------|:-----------
FRESH        | The number of unique combinations of aggregate columns must equal the number of targets
Normal       | The number of rows in the input table must equal the number of target values
NLP          | The number of rows in the input table must equal the number of target values

Syntax: `.automl.dataCheck.node.function[config;features;target]`

Where

-   `config` is a dictionary information related to the current run of AutoML
-   `features` is the feature data as a table 
-   `target` is a numerical or symbol target vector

returns modified configuration, feature and target datasets. The function will error on issues with configuration, setup, target or feature dataset.

```q
```

## `.automl.modelGeneration.node.function`

_Create list of models to apply based on problem type and user configuration_

### Applied models

The models applied in an individual run of AutoML are selected based on the user-defined problem type, paired with additional information about the target data. The models available within the framework for each problem type are as follows:

```txt
Binary-classification models      Multi-classification models       Regression models
  - AdaBoostClassifier              - AdaBoostClassifier              - AdaBoostRegressor
  - RandomForestClassifier          - RandomForestClassifier          - RandomForestRegressor
  - GradientBoostingClassifier      - GradientBoostingClassifier      - GradientBoostingRegressor
  - KNeighborsClassifier            - KNeighborsClassifier            - KNeighborsRegressor
  - MLPClassifier                   - MLPClassifier                   - MLPRegressor
  - Keras binary-classifier         - Keras multi-classifier          - Keras regressor
  - LogisticRegression                                                - LinearRegression
  - GaussianNB                                                        - Lasso
  - SVC 
  - LinearSVC
```

These models can be augmented through modification of `models.json` contained within the folder `automl/code/customization/models/modelConfig/` within the repository.

!!! note "Keras architectures"

    The Keras models first introduced in V0.1 are basic single-layer neural networks. 

    A user can [define more complex Keras architectures](../faq.md) as desired for the use case in question if an appropriate architecture is known.


Syntax: `.automl.modelGeneration.node.function[config;target]`

Where

-   `config` is a dictionary information related to the current run of AutoML
-   `target` is a numerical or symbol target vector

returns a table containing information needed to apply appropriate models to data.

```q
```


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

## `.automl.featureDescription.node.function`

_Retrieve initial information needed for report generation or running on new data_

Syntax: `.automl.featureDescription.node.function[config;features]`

Where

-   `config` is a dictionary containing information related to the current run of AutoML
-   `features` is feature data as a table 

returns a dictionary with symbol encoding, feature data and description.

```q
```

## `.automl.labelEncode.node.function`

_Encode symbol label data_

Syntax: `.automl.labelEncode.node.function[target]`

Where

-   `target` is a numerical or symbol target vector

returns a dictionary mapping between symbol encoding and the encoded target data.

```q
```

## `.automl.dataPreprocessing.node.function`

_Preprocess data prior to application of ML algorithms_

### Preprocessing procedures

Within the pipeline, symbol columns are encoded as follows:

-  If there are fewer than 10 unique symbols in a particular column the data is one-hot encoded.
-  If a column contains more than 10 unique symbols the values are frequency encoded.

!!! note

    In the case of FRESH, the above limitations are performed on an aggregation-bucket basis for frequency encoding rather than for an entire column. This ensures that encoding on new data is as fair as possible where each aggregation bucket is associated with an individual target.
    
Additionally, both null and infinite values are replaced within the feature data, due to the inability of both sklearn and keras machine learning models to handle this form of data. The below table highlights the values used to replace each of these values where the process aims to limit changes to the data distribution.

value             | symbol  | replacement
:-----------------|:--------|:-------------
Positive infinity | `0w`    | Maximum column value
Negative infinity | `-0w`   | Minimum column value
Null              | `0n`    | Median column value

It should be noted that in cases where nulls are present, an additional column is added to the feature table denoting the location of the null prior to filling of the dataset, thus encoding the null location in the case that this is an important signal for prediction.

Syntax: `.automl.dataPreprocessing.node.function[config;features;symEncode]`

Where

-   `config` is a dictionary information related to the current run of AutoML
-   `features` is the feature data as a table 
-   `symEncode` is a dictionary containing columns to symbol encode and their required encoding

returns the feature table with the data preprocessed appropriately.

```q
```

## `.automl.featureCreation.node.function`

_Generate appropriate features based on problem type_

### FRESH, NLP and normal feature extraction

Feature extraction is the process of building derived or aggregate features from a dataset in order to provide the most useful inputs for a machine learning algorithms. Within the AutoML framework, there are currently 3 types of feature extraction available - FRESH, normal and NLP feature extraction.

The early-stage releases of this repository limit the feature extraction procedures that are performed by default on the tabular data for a number of reasons:

1. The naïve application of many relevant feature extraction procedures (truncated singular-value decomposition/bulk transforms) while potentially informative can expand the memory usage and computation time beyond an acceptable level.
2. Procedures being applied in one field of use may not be relevant in another. As such, the framework is provided to allow a user to complete feature extractions which are domain-specific if required, rather than assuming procedures to be applied are ubiquitous in all cases.

Over time the system will be updated to perform tasks in a way which is cognizant of the above limitations and where general frameworks can be assumed to be informative.

**FRESH**

The FRESH (FeatuRe Extraction and Scalable Hypothesis testing) algorithm is used specifically for time series datasets. The data passed to FRESH should contain an identifying (ID) column, which groups the time series into subsets, from which features can be extracted. Note that each subset will have an associated target.

The feature extraction functions applied within the FRESH procedure are defined within the [ML Toolkit](../../toolkit/fresh.md). A full explanation of this algorithm is also provided there.

!!! note

    When running `.automl.fit` for FRESH data, by default the first column of the dataset is defined as the identifying (ID) column. 

    See instructions on [how to modify this](options.md).

**NLP**

The NLP (Natural Language Processing) feature extraction within AutoML makes use of the Kx [NLP library](../../nlp/index.md) in addition to the python `gensim` library for data preprocessing.

The following are the steps applied independently to all columns containing text data:

1. Use `.nlp.findRegex` to retrieve information surrounding the occurrances of various expressions, e.g. references to urls, money, the presence of phone numbers, etc.
2. Apply named entity recognition to detect references to products, individuals, references to art, etc.
3. Apply sentiment analysis to the dataset to extract information about the positive/negative/neutral and compound nature of the text.
4. Apply the function `.nlp.newParser` to extract stop words, tokens and any references to numbers. Using this data, calculate the percentages of a sentence that are numeric values, stop words or particular parts of speech.
5. Using the corpus tokens extracted in 4, use the Python library `gensim` to create a word2vec encoding of the dataset, such that we have a numerical representation of the 'meaning' of a sentence.

If any other non-text based columns are present, normal feature extraction is applied to those remaining columns in order to ensure no relevant information is ignored.

**Normal feature extraction**

Normal feature extraction can be applied to non-time series problems that have a 1-to-1 mapping between features and targets. The current implementation of normal feature extraction splits time/date type columns into their component parts.

Syntax: `.automl.featureCreation.node.function[config;features]`

Where

-   `config` is a dictionary containing information related to the current run of AutoML
-   `features` is feature data as a table 

returns a dictionary containing original features with any additional ones created, along with time taken and any saved models. 

```q
```

## `.automl.featureSignificance.node.function`

_Apply feature significance logic to data and return the columns deemed to be significant_

### Feature selection procedures

In order to reduce dimensionality in the data following feature extraction, significance tests are performed by default using the FRESH [feature significance](../../toolkit/fresh.md) function contained within the ML Toolkit. The default procedure will use the Benjamini-Hochberg-Yekutieli (BHY) procedure to identify significant features within the dataset. If no significant columns are returned, the top 25th percentile of features will be selected.

Syntax: `.automl.featureSignificance.node.function[config;features;target]`

Where

-   `config` is a dictionary information related to the current run of AutoML
-   `features` is the feature data as a table 
-   `target` is a numerical or symbol target vector

returns a dictionary containing a symbol list of significant features and the feature data post-feature extraction.

```q
```

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

_Split features and target into training and testing sets_

### Preparing training and testing sets

Once the most significant features have been selected, the data is split into training and testing sets, where the testing set is required later in the process for optimizing the best model.

In order to split the data, a number of train-test split procedures are implemented for the different problem types:

problem type | function                | description 
-------------|-------------------------|-------------
Normal       |.ml.traintestsplit       | Shuffle the dataset and split into training and testing set with defined percentage in each
FRESH        |.automl.utils.ttsNonShuff| Without shuffling, the dataset is split into training and testing set with defined percentage in each to ensure no time leakage.
NLP          |.ml.traintestsplit       | Shuffle the dataset and split into training and testing set with defined percentage in each

For classification problems, it cannot be guaranteed that all of the distinct target classes will appear in both the training and testing sets. This is an issue for the Keras neural network models which requires that a sample from each target class is present in both splits of the data.

For this reason, the function `.automl.selectModels.targetKeras` must be applied to the data split prior to model training. The function determines if all classes are present in each split of the data. If not, the Keras models will be removed from the list of models to be tested.

Below shows the expected output `.automl.fit` should the same number of classes not be present in each dataset.

```q
q).automl.fit[table;target;`normal;`class;(::)]
...
Executing node: selectModels

Test set does not contain examples of each class. Removed any multi-keras models.
...
```

At this stage it is possible to begin model training and validation using cross-validation procedures. To do so, the data which is currently in the training set must be further split into training and validation sets. Following the same process as before, the Keras check must be applied again if Keras models are still present.

Syntax: `.automl.trainTestSplit.node.function[]`

Where

-   `config` is a dictionary information related to the current run of AutoML
-   `features` is the feature data as a table 
-   `target` is a numerical or symbol target vector
-   `sigFeats` is a symbol list of significant features

returns a dictionary containing data separated into training and testing sets.

```q
```