---
title: Data preprocessing for the KX automated machine learning platform | Machine Learning | Documentation for q and kdb+
description: Default behavior of the KX automated machine-learning tools; common processes completed across all forms of automated machine learning and the differences between offerings
author: Deanna Morgan
date: December 2020
keywords: machine learning, automated, ml, model definition, type checking, symbol encoding, infinity replace, null encoding, data cleansing
---
# :fontawesome-solid-share-alt: Automated data preprocessing

_Nodes used to preprocess data within the AutoML framework_

:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl)


Data preprocessing is a necessary step in any robust machine-learning application. 
It is particularly important when it comes to automated pipelines where, by definition, most control is removed from the user. 


## Preprocessing nodes

<div markdown="1" class="typewriter">
.automl.X.node.function    **Top-level preprocessing node functions**
  [configuration](#automlconfigurationnodefunction)        Pass run configuration into AutoML graph
  [featureData](#automlfeaturedatanodefunction)          Load feature data from process/alternative data source
  [targetData](#automltargetdatanodefunction)           Load target vector from process/alternative data source
  [dataCheck](#automldatachecknodefunction)            Build configuration dictionary and check dataset is suitable
  [modelGeneration](#automlmodelgenerationnodefunction)      Create table of models to apply
  [featureDescription](#automlfeaturedescriptionnodefunction)   Information needed for report generation or running on new data
  [labelEncode](#automllabelencodenodefunction)          Encode symbol target data
  [dataPreprocessing](#automldatapreprocessingnodefunction)    Preprocess data prior to application of ML algorithms
  [featureCreation](#automlfeaturecreationnodefunction)      Generate appropriate features based on problem type
  [featureSignificance](#automlfeaturesignificancenodefunction)  Apply feature-significance tests and return significant features
  [trainTestSplit](#automltraintestsplitnodefunction)       Split features and target into training and testing sets
</div>


## Data checking

Given the automated nature of the pipeline, it is important to ensure only datatypes handled by the current feature-extraction procedures are passed through the workflow. If any columns within the user-defined dataset contain inappropriate types, they will be removed and this will be communicated to the user via the console.

The following lists the restricted types for each problem type. In each case, these types are not handled gracefully within the feature-extraction workflow and are omitted.

```txt
FRESH     guid, byte, list, character, time/date
Normal    guid, byte, list, character
NLP       guid, byte, list
```

Further, given the requirement that feature data produced in the feature extraction process must have a 1-to-1 mapping to the input target vector, target consistency is checked prior to the application of feature extraction. The logic behind this check varies for each problem type and is specified below.

```txt
FRESH    number of unique combinations of aggregate columns must equal number of targets
Normal   number of rows in the input table must equal number of target values
NLP      number of rows in the input table must equal number of target values
```


## Applied models

The models applied in an individual run of AutoML are selected based on the user-defined problem type, paired with additional information about the target data. 
The models available within the framework for each problem type are:

```txt
binary-classification         multi-classification          regression      
-------------------------------------------------------------------------------------
AdaBoostClassifier            AdaBoostClassifier            AdaBoostRegressor
RandomForestClassifier        RandomForestClassifier        RandomForestRegressor
GradientBoostingClassifier    GradientBoostingClassifier    GradientBoostingRegressor
KNeighborsClassifier          KNeighborsClassifier          KNeighborsRegressor
MLPClassifier                 MLPClassifier                 MLPRegressor
Keras binary-classifier       Keras multi-classifier        Keras regressor
LogisticRegression                                          LinearRegression
GaussianNB                                                  Lasso
SVC                                                             
LinearSVC                                                            
```

These models can be augmented by modifying `models.json` in the folder `automl/code/customization/models/modelConfig/`. 

:fontawesome-solid-hand-point-right:
[`models.json`](config.md#models)

??? detail "Keras architectures"

    The Keras models first introduced in V0.1 are basic single-layer neural networks. 

    A user can [define more complex Keras architectures](../faq.md) as desired for the use case in question if an appropriate architecture is known.


## Preprocessing procedures

Within the pipeline, a symbol column is encoded according to the number of unique symbols it has:

-   &lt; 10: one-hot encoded
-   &gt; 10: frequency encoded

For FRESH, the above is performed on an aggregation-bucket basis for frequency encoding rather than for an entire column. 
This ensures encoding on new data is as fair as possible, with each aggregation bucket associated with an individual target.
    
Further, both null and infinite values are replaced within the feature data, due to the inability of both sklearn and keras machine-learning models to handle this form of data. The table below shows the replacement for each of these values. 
The aim is to limit changes to the data distribution as far as possible.

```txt
value               symbol   replacement
-------------------------------------------------
positive infinity     0w     maximum column value
negative infinity    -0w     minimum column value
null                  0n     median column value
```

Where nulls are present an additional column is added to the feature table denoting the location of the null prior to filling of the dataset, thus encoding the null location in the case it is an important signal for prediction.


## Feature extraction

Feature extraction is the process of building derived or aggregate features from a dataset in order to provide the most useful inputs for machine-learning algorithms. Within the AutoML framework, there are three types of feature extraction available – normal, NLP and FRESH.

The early-stage releases of this repository limit the feature-extraction procedures that are performed by default on the tabular data for two reasons:

-   Naïve application of many relevant feature-extraction procedures (truncated singular-value decomposition/bulk transforms) while potentially informative can expand memory usage and computation time beyond an acceptable level.
-   Procedures applied in one field of use may not be relevant in another. The framework is designed for you to complete feature extractions which are domain-specific if required, rather than assuming procedures to be applied are ubiquitous in all cases.

Over time the system will come to perform tasks in a way cognizant of the above limitations, and where general frameworks can be assumed to be informative.


### Normal

Normal feature extraction can be applied to non-timeseries problems that have a 1-to-1 mapping between features and targets. The current implementation of normal feature extraction splits time/date type columns into their component parts. No further feature extraction is applied by default.


### NLP

The NLP (Natural Language Processing) feature extraction within AutoML makes use of the KX [NLP library](../../nlp/index.md) in addition to the Python `gensim` library for data preprocessing.

The following steps are applied independently to all columns containing text data:

1.  Use `.nlp.findRegex` to retrieve information surrounding the occurrences of various expressions, e.g. references to URLs, money, the presence of phone numbers, etc.
2.  Apply named entity recognition to detect references to products, individuals, art, etc.
3.  Apply sentiment analysis to the dataset to extract information about the positive/negative/neutral and compound nature of the text.
4.  Apply the function `.nlp.newParser` to extract stop words, tokens and any references to numbers. Using this data, calculate the percentages of a sentence that are numeric values, stop words or particular parts of speech.
5.  Using the corpus tokens extracted in 4, use the Python library `gensim` to create a word2vec encoding of the dataset, such that we have a numerical representation of the ‘meaning’ of a sentence.

If any other non-text based columns are present, normal feature extraction is applied to those remaining columns to ensure no relevant information is ignored.


### FRESH

The FRESH (FeatuRe Extraction and Scalable Hypothesis testing) algorithm is used specifically for timeseries datasets. The data passed to FRESH should contain an identifying (ID) column, which groups the timeseries into subsets, from which features can be extracted. Note that each subset must have an associated target.

The feature-extraction functions applied within the FRESH procedure are defined within the [ML Toolkit](../../toolkit/fresh.md). A full explanation of this algorithm is also provided there.

Default setup:
  
1.  When running `.automl.fit` for FRESH data, by default the first column of the dataset is defined as the identifying (ID) column.
2.  By default all functions defined within `.ml.fresh.params` are applied during the feature extraction phase.

Each of the above can be [modified](advanced.md) on a per-run basis.


## Training and testing sets

Once the most significant features have been selected, the data is split into training and testing sets, where the testing set is required later in the process for optimizing the best model.

To split the data, a number of train-test split procedures are implemented for the different problem types:

problem type | function                | description 
-------------|-------------------------|-------------
Normal       |.ml.traintestsplit       | Shuffle the dataset and split into training and testing set with defined percentage in each
FRESH        |.automl.utils.ttsNonShuff| Without shuffling, the dataset is split into training and testing set with defined percentage in each to ensure no time leakage.
NLP          |.ml.traintestsplit       | Shuffle the dataset and split into training and testing set with defined percentage in each

For classification problems, not all the distinct target classes will necessarily appear in both the training and testing sets. This is an issue for the Keras neural-network models, which require a sample from each target class present in both splits of the data.

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


## Feature-selection procedures

To reduce dimensionality in the data following feature extraction, significance tests are performed by default using the FRESH [feature significance](../../toolkit/fresh.md) function contained within the ML Toolkit. 

The default procedure uses the Benjamini-Hochberg-Yekutieli (BHY) procedure to identify significant features within the dataset. If no significant columns are returned, the top 25th percentile of features is selected.

---

## `.automl.configuration.node.function`

_Entry point used to pass run configuration into AutoML graph_

```syntax
.automl.configuration.node.function config
```

Where `config` is a dictionary with custom configuration information relevant to the present run, returns the configuration dictionary ready to be passed to the relevant nodes within the pipeline.


## `.automl.dataCheck.node.function`

_Add default parameters to configuration while checking dataset is suitable for AutoML_

```syntax
.automl.dataCheck.node.function[config;features;target]
```

Where

-   `config` is a dictionary containing information related to the current run of AutoML
-   `features` is the feature data as a table 
-   `target` is a numerical or symbol target vector

returns modified configuration, feature and target datasets. The function will error on issues with configuration, setup, target or feature dataset.

```q
// Non-time series (normal) regression example table
features:([]asc 100?0t;100?1f;desc 100?0b;100?1f;asc 100?1f)
// Regression target
target:asc 100?1f
// Create run configuration dictionary
config:`startDate`startTime`featureExtractionType`problemType`savedModelName!
  (.z.D;.z.T;`normal;`reg;`)
// Join onto default dictionaries
config:.automl.paramDict[`general],.automl.paramDict[`normal],config
```
```q
q)// Perform data checks
q).automl.dataCheck.node.function[config;features;target]
config  | `startDate`startTime`featureExtractionType`problemType`saveOption`s..
features| +`x`x1`x2`x3`x4!(`s#00:06:00.139 00:12:17.160 00:43:43.460 00:45:23..
target  | `s#0.009530776 0.01837959 0.0244211 0.0269967 0.03035461 0.05011425..
```


## `.automl.dataPreprocessing.node.function`

_Preprocess data prior to application of ML algorithms_

```syntax
.automl.dataPreprocessing.node.function[config;features;symEncode]
```

Where

-   `config` is a dictionary containing information related to the current run of AutoML
-   `features` is the feature data as a table 
-   `symEncode` is a dictionary containing columns to symbol encode and their required encoding

returns the feature table with the data preprocessed appropriately.

```q
q)// Non-time series (normal) example table
q)5#features:([]0n,99?1f;0.5,0n,98?1f;100?`5;100#10?`a`b`c)
x         x1        x2    x3
----------------------------
          0.5       kgnje b
0.9484394           fengd b
0.8146544 0.6096089 mmocm b
0.3859185 0.9320707 dmfif a
0.1676035 0.9610061 kmlcf b

q)// Configuration dictionary
q)config:`featureExtractionType`logFunc!
  (`normal;.automl.utils.printFunction[`testLog;;1;1])

q)// Columns to symbol encode
q)symEncode:`freq`ohe!(`x2;`x3)

q)// Apply preprocessing
q)5#.automl.dataPreprocessing.node.function[config;features;symEncode]

Data preprocessing complete, starting feature creation

x         x1        x2_freq x3_a x3_b x3_c x_null x1_null
---------------------------------------------------------
0.5359828 0.5       0.01    0    1    0    1      0
0.9484394 0.5366546 0.01    0    1    0    0      1
0.8146544 0.6096089 0.01    0    1    0    0      0
0.3859185 0.9320707 0.01    1    0    0    0      0
0.1676035 0.9610061 0.01    0    1    0    0      0
```


## `.automl.featureCreation.node.function`

_Generate appropriate features based on problem type_

```syntax
.automl.featureCreation.node.function[config;features]
```

Where

-   `config` is a dictionary containing information related to the current run of AutoML
-   `features` is feature data as a table 

returns a dictionary containing original features with any additional ones created, along with time taken and any saved models in the case of generation of a word2vec model. 

```q
q)// Non-time series (normal) example table
q)3#features:([]asc 100?0t;100?1f;100?2;100?1f;asc 100?1f)
x            x1        x2 x3        x4
-----------------------------------------------
00:07:28.748 0.3852334 0  0.6497915 0.005637949
00:11:06.877 0.6474614 0  0.848094  0.009473082
00:14:38.117 0.2007083 0  0.1653044 0.009778301

q)// Configuration dictionary
q)config:`featureExtractionType`functions!
    (`normal;`.automl.featureCreation.normal.default)

q)// Run feature creation
q).automl.featureCreation.node.function[config;features]
creationTime| 00:00:00.001
features    | +`x1`x2`x3`x4`x_hh`x_uu`x_ss!(0.3852334 0.6474614 0.2007083 0.0..
featModel   | ()

q)// NLP example table
q)3#features:([]100?1f;100?("Testing the application of nlp";"With different characters"))
x         x1
------------------------------------------
0.173315  "With different characters"
0.2901047 "With different characters"
0.8082814 "Testing the application of nlp"

q)// Configuration dictionary
q)config:`featureExtractionType`functions`w2v`savedWord2Vec`seed!
  (`nlp;`.automl.featureCreation.normal.default;0;0b;42)

q)// Run feature creation
q).automl.featureCreation.node.function[config;features]
creationTime| 00:00:05.978
features    | +`ADJ`ADP`DET`NOUN`VERB`col0`col1`col2`col3`col4`col5`col6`col7..
featModel   | {[f;x]embedPy[f;x]}[foreign]enlist

q)// FRESH example table
q)3#features:([]5000?100?0p;asc 5000?1f;5000?1f;desc 5000?10f;5000?0b)
x                             x1           x2        x3       x4
----------------------------------------------------------------
2001.12.07D11:54:52.182176560 0.000267104  0.3443026 9.99641  0
2000.08.06D11:21:24.919296204 0.0004898147 0.6505359 9.996256 0
2002.09.06D00:33:11.276746992 0.001093083  0.5621585 9.995282 1

q)// Configuration dictionary
q)config:`featureExtractionType`functions`aggregationColumns!`fresh`.ml.fresh.params`x

q)// Run feature creation
q).automl.featureCreation.node.function[config;features]
creationTime| 00:00:06.176
features    | +`x1_absenergy`x1_abssumchange`x1_count`x1_countabovemean`x1_co..
featModel   | ()
```


## `.automl.featureData.node.function`

_Loading of feature dataset from process/alternative data source_

```syntax
.automl.featureData.node.function config
```

Where `config` is a dictionary with the location and method by which to retrieve the data, returns feature data as a table.

```q
q)// Dictionary with information for .ml.i.loaddset
q)config:`directory`fileName`typ`schema`separator!
    ("home/data";"features.csv";`csv;"FFSJ";enlist",")
q)// Load in feature dataset
q).automl.featureData.node.function config
x          x1         x2 x3
---------------------------
0.831001   0.06119115 b  0
0.2386444  0.5510458  c  4
0.4626596  0.456294   a  5
0.7125073  0.6581265  b  0
0.4478417  0.9841029  b  1
0.236602   0.5767729  a  7
0.6568185  0.05316387 c  8
0.9114983  0.6573407  c  3
0.01380875 0.987491   b  2
0.4625509  0.8070207  b  1
0.6369492  0.7927667  b  8
0.5779229  0.8195301  a  7
0.1649935  0.2466953  a  6
0.9628137  0.3021382  c  0
0.8119738  0.3621913  c  7
..
```


## `.automl.featureDescription.node.function`

_Retrieve information needed for report generation and running on new data_

```syntax
.automl.featureDescription.node.function[config;features]
```

Where

-   `config` is a dictionary containing information related to the current run of AutoML
-   `features` is feature data as a table 

returns a dictionary with symbol encoding, feature data and description.

```q
q)// FRESH regression example table
q)5#features:([]idx:100?`4;100?1f;100?`4;100?`a`b`c;100?1f)
idx  x           x1   x2 x3
----------------------------------
fjcj 0.1252898   ggfk c  0.6136512
pnoj 0.5655123   ghlj a  0.9441251
cphm 0.2613049   nega b  0.603996
cedn 0.004608619 dmad c  0.3888924
kihe 0.5062673   lkaj c  0.0486924

q)// Configuration with logging function and feature extraction type
q)config:`logFunc`featureExtractionType!
    (.automl.utils.printFunction[`testLog;;1;1];`fresh)

q)// Run node
q)show output:.automl.featureDescription.node.function[config;features]

The following is a breakdown of information for each of the relevant columns in the dataset

   | count unique mean      std       min        max       type
-  | -----------------------------------------------------------------
x  | 100   100    0.4860504 0.3116851 0.0035863  0.9785984 numeric
x3 | 100   100    0.5086307 0.276274  0.00969842 0.9988041 numeric
idx| 100   100    ::        ::        ::         ::        categorical
x1 | 100   100    ::        ::        ::         ::        categorical
x2 | 100   3      ::        ::        ::         ::        categorical

symEncode      | `freq`ohe!(`idx`x1;,`x2)
dataDescription| `x`x3`idx`x1`x2!+`count`unique`mean`std`min`max`type!(100 10..
features       | +`idx`x`x1`x2`x3!(`fjcj`pnoj`cphm`cedn`kihe`gcbf`gidn`jcen`i..
```


## `.automl.featureSignificance.node.function`

_Apply feature significance logic to data and return the columns deemed to be significant_

```syntax
.automl.featureSignificance.node.function[config;features;target]
```

Where

-   `config` is a dictionary containing information related to the current run of AutoML
-   `features` is the feature data as a table 
-   `target` is a numerical or symbol target vector

returns a dictionary containing a symbol list of significant features and the feature data post-feature extraction.

```q
q)// Normal feature table
q)5#features:([]asc 100?1f;100?1f;100?1f;100?10;100?5?1f;100?10)
x          x1        x2         x3 x4         x5
------------------------------------------------
0.01976295 0.831001  0.06119115 2  0.3520493  7
0.03947309 0.2386444 0.5510458  2  0.05040009 3
0.0486924  0.4626596 0.456294   8  0.5467665  1
0.06382153 0.7125073 0.6581265  9  0.7096579  4
0.06708218 0.4478417 0.9841029  0  0.05040009 0

q)// Regression target
q)target:asc 100?1f

q)// Configuration dictionary containing functions to apply (below is default)
q)config:`logFunc`significantFeatures!
  (.automl.utils.printFunction[`testLog;;1;1];`.automl.featureSignificance.significance)

q)// Number of features before feature selection
q)count cols features
6

q)// Apply feature selection
q)show 5#sigFeats:.automl.featureSignificance.node.function[config;features;target][`sigFeats]#features

Total number of significant features being passed to the models = 1

x
----------
0.01976295
0.03947309
0.0486924
0.06382153
0.06708218

q)// Number of features after feature selection
q)count cols sigFeats
1
```


## `.automl.labelEncode.node.function`

_Encode non numeric target data_

```syntax
.automl.labelEncode.node.function[target]
```

Where `target` is a numerical or symbol target vector, returns a dictionary containing a mapping between symbols and associated labels, if necessary, and the numerical representation of the encoded target used throughout the framework.

```q
q)// Multi-classification target
q)show target:100?`a`b`c
`a`a`b`a`c`c`a`a`b`a`c`a`b`c`c`a`b`c`c`b`c`b`c`b`c`b`b`b`a`c`b`c`a`b`b`c`c`a`..

q)// Encode target vector
q).automl.labelEncode.node.function target
symMap| `s#`a`b`c!0 1 2
target| 0 0 1 0 2 2 0 0 1 0 2 0 1 2 2 0 1 2 2 1 2 1 2 1 2 1 1 1 0 2 1 2 0 1 1..

q)// Multi-classification non symbol target
q)show target:100?3
2 2 2 2 2 1 0 2 1 0 0 1 2 2 1 0 2 1 2 0 2 1 0 2 0 1 2 2 2 0 2 0 1 2 2 2 1 0 2..

q)// Encode target vector
q).automl.labelEncode.node.function target
symMap| ()!()
target| 2 2 2 2 2 1 0 2 1 0 0 1 2 2 1 0 2 1 2 0 2 1 0 2 0 1 2 2 2 0 2 0 1 2 2..
```


## `.automl.modelGeneration.node.function`

_Create the table of models to apply based on problem type and user configuration_

```syntax
.automl.modelGeneration.node.function[config;target]
```

Where

-   `config` is a dictionary containing information related to the current run of AutoML
-   `target` is a numerical or symbol target vector

returns a table containing information needed to apply appropriate models to data.

```q
q)// Binary-classification target
q)show target:100?0b
11110000000100001010111101101000100111101110011000000010100100111100011101011..

q)// Configuration with problem type
q)config:enlist[`problemType]!enlist`class

q)// Generate model table
q).automl.modelGeneration.node.function[config;target]
model                      lib     fnc            seed  typ    apply minit   ..
-----------------------------------------------------------------------------..
AdaBoostClassifier         sklearn ensemble       `seed multi  1     {[x;y;z]..
RandomForestClassifier     sklearn ensemble       `seed multi  1     {[x;y;z]..
GradientBoostingClassifier sklearn ensemble       `seed multi  1     {[x;y;z]..
LogisticRegression         sklearn linear_model   `seed binary 1     {[x;y;z]..
GaussianNB                 sklearn naive_bayes    ::    binary 1     {[x;y;z]..
KNeighborsClassifier       sklearn neighbors      ::    multi  1     {[x;y;z]..
MLPClassifier              sklearn neural_network `seed multi  1     {[x;y;z]..
SVC                        sklearn svm            `seed binary 1     {[x;y;z]..
LinearSVC                  sklearn svm            `seed binary 1     {[x;y;z]..
BinaryKeras                keras   binary         `seed binary 1     {[x;y;z]..
```

The model table produced contains the following columns:

```txt
model    name of the model to be applied
lib      Python library from which the model is derived
fnc      sub module within the Python library from which a model is derived
seed     is the model capable of being seeded (seed for yes, null for no)
typ      type of problem being solved
apply    if model is to be applied within the pipeline
minit    definition of the model to be applied within the workflow
```


## `.automl.targetData.node.function`

_Load the target dataset from process/alternative data source_

```syntax
.automl.targetData.node.function config
```

Where `config` is a dictionary with the location and method by which to retrieve the data, returns a numerical or symbol target vector.

```q
q)// Dictionary with information for .ml.i.loaddset
q)config:`typ`directory`fileName`schema!
    (`splay;system"cd";"target";"B")

q)// Load in target vector
q).automl.targetData.node.function config
11001100110011000100100001100110010011100100001010010011110100110010010110000..
```


## `.automl.trainTestSplit.node.function`

_Split features and target into training and testing sets_

```syntax
.automl.trainTestSplit.node.function[config;features;target;sigFeats]
```

Where

-   `config` is a dictionary containing information related to the current run of AutoML
-   `features` is the feature data as a table 
-   `target` is a numerical or symbol target vector
-   `sigFeats` is a symbol list of significant features

returns a dictionary containing data separated into training and testing sets.

```q
q)// Non-time series (normal) multi-classification example table
q)5#features:([]asc 100?1f;desc 100?1f;100?1f;100?1f)
x          x1        x2         x3
------------------------------------------
0.02242087 0.9955855 0.05310517 0.168436
0.02380346 0.9833302 0.2166502  0.9325573
0.02425821 0.9758116 0.1526076  0.7633987
0.04089465 0.9730643 0.7080534  0.5577644
0.05110413 0.9657049 0.5551035  0.05737207

q)// Multi-classification target
q)target:asc 100?5

q)// Significant features
q)sigFeats:`x`x1

q)// Configuration dictionary with TTS function and testing size
q)config:`trainTestSplit`testingSize!(`.ml.traintestsplit;.2)

q)// Split data
q).automl.trainTestSplit.node.function[config;features;target;sigFeats]
xtrain| (0.9587189 0.08810016;0.8257742 0.2153339;0.1260167 0.8713021;0.94780..
ytrain| 4 3 0 4 0 3 1 4 3 3 4 2 2 2 3 4 3 4 2 2 4 0 3 0 0 4 4 0 2 0 3 1 2 0 2..
xtest | (0.7512502 0.3852997;0.3269671 0.6824045;0.9601101 0.05887977;0.66922..
ytest | 3 1 4 2 0 3 2 0 3 4 4 2 2 1 3 0 2 3 2 1
```
