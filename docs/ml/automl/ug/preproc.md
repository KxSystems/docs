---
title: Data preprocessing for the Kx automated machine-learning platform | Machine Learning | Documentation for q and kdb+
author: Deanna Morgan
description: Default behavior of the Kx automated machine learning tools; common processes completed across all forms of automated machine learning and the differences between offerings
date: November 2020
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

These models can be augmented through modification of `regmodels.txt` and `classmodels.txt` contained within the folder `automl/code/customization/models/modelConfig/
` within the repository.

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


## Constant column removal

Constant columns are those within the dataset which contain only one unique value. These columns are removed as they do not provide useful information in the prediction of a target due to a lack of signal within the data.

The following is the code implemented to achieve this.

```q
q)5#data:([]100?1f;100#0f;100?1f)
x          x1 x2
------------------------
0.1093845  0  0.1040803
0.8781257  0  0.05934195
0.01354385 0  0.8520804
0.8539798  0  0.06290421
0.5498438  0  0.7098129
q)5#preprocData:.ml.dropconstant data
x          x2
---------------------
0.1093845  0.1040803
0.8781257  0.05934195
0.01354385 0.8520804
0.8539798  0.06290421
0.5498438  0.7098129
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
