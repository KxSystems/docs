---
title: Prepocessing procedures for the Kx automated machine learning platform
author: Conor McCarthy
description: This document outlines the default behaviour of the Kx automated machine learning offering in particular highlighting the common processes completed across all forms of automated machine learning and the differences between offerings
date: October 2019
keywords: machine learning, ml, automated, preprocessing, feature extraction, feature selection, time-series, cleansing
---
# <i class="fas fa-share-alt"></i> Automated Preprocessing.

<i class="fab fa-github"></i>
[KxSystems/automl](https://github.com/kxsystems/automl)

As highlighted in the description of the function used to run the Kx automl offering [here](Insert the link here), the system can be run in a default configuration by setting the final function parameter to (`::`). The behaviour exhibited in this case is highlighted here with the full range of possible modifications outlined in the advanced description section [here](../../adv/params).

The procedures described below outline the steps taken to preprocess data, initialize appropriate models and correctly parameterize the system prior to the application and scoring of machine learning algorithms on the data. In cases where it is appropriate this page will highlight use-case specific differences in the procedures followed. The preprocessing of data is of critical importance in all machine learning applications but in particular within automated pipelines as the majority of control is by definition removed from the user.

Data preprocessing ensures the following:

-  The formatting of the data is consistent with the requirements of the machine learning models being applied.
-  Only appropriate data types are passed through the machine learning workflow.
-  Features which would not provide relevant information to a model are removed.
-  Characters such as infinities and nulls are handled appropriately such that columns containing them do not need to be removed, while also ensuring that this information is not lost.

The procedures outlined below are those found to be the most effective in ensuring that the data being passed to the feature extraction and algorithm application procedures are consistent and managable.


## Outline of procedures

The following are the procedures completed when the system is in its default configuration.

1. Appropriate models are chosen for the use-case being explored.
2. Inappropriate columns within the dataset are removed based on types.
3. A check is applied to ensure that the number of targets is appropriate for the dataset.
4. Symbol data is encoded via either one-hot or frequency encoding.
5. Constant columns are removed from the data.
6. Nulls are replaced and an indicating column is added to encode their original position.

### Models applied

The applied models are chosen based on user definitions of the type of machine learning task being explored and information about the target data. For clarity the models which can be applied are as follow

Model                       | Task 
:---------------------------|:--------------
AdaBoostClassifier          | binary/multi-class classification 
RandomForestClassifier      | binary/multi-class classification
GradientBoostingClassifier  | binary/multi-class classification
LogisticRegression          | binary-class classification
GaussianNB                  | binary-class classification
KNeighborsClassifier        | binary/multi-class classification
MLPClassifier               | binary/multi-class classification
SVC                         | binary-class classification
LinearSVC                   | binary-class classification
Binary class Keras model    | binary-class classification
Multi class Keras model     | multi-class classification
AdaBoostRegressor           | regression
RandomForestRegressor       | regression
GradientBoostingRegressor   | regression
KNeighborsRegressor         | regression
MLPRegressor                | regression
Lasso                       | regression
LinearRegression            | regression
RegKeras                    | regression 

These models can be augmented through modification of the text files `regmodels.txt` and `classmodels.txt` within the `mdl_def` folder of the github repository

The following examples show how the models would be defined within the workflow as a result of changes to initial input. For clarity the application of `.aml.runexample` is provided.

```q
q)5#data:([]100?1f;100?1f;100?1f)
x         x1        x2        
------------------------------
0.7250709 0.724948  0.06165008
0.481804  0.8112026 0.285799  
0.9351307 0.2086614 0.6684724 
0.7093398 0.9907116 0.9133033 
0.9452199 0.5794801 0.1485357 

// Regression task
q)5#tgt:100?1f
0.3927524 0.5170911 0.5159796 0.4066642 0.1780839
// .aml.runexample[data;tgt;`normal;`reg;::]
q).aml.models[`reg;tgt]
model                     lib     fnc            seed typ minit                        ..
---------------------------------------------------------------------------------------..
AdaBoostRegressor         sklearn ensemble       seed reg {[x;y;z].p.import[x]y}[`sklea..
RandomForestRegressor     sklearn ensemble       seed reg {[x;y;z].p.import[x]y}[`sklea..
GradientBoostingRegressor sklearn ensemble       seed reg {[x;y;z].p.import[x]y}[`sklea..
KNeighborsRegressor       sklearn neighbors      ::   reg {[x;y;z].p.import[x]y}[`sklea..
MLPRegressor              sklearn neural_network ::   reg {[x;y;z].p.import[x]y}[`sklea..
Lasso                     sklearn linear_model   seed reg {[x;y;z].p.import[x]y}[`sklea..
LinearRegression          sklearn linear_model   ::   reg {[x;y;z].p.import[x]y}[`sklea..
RegKeras                  keras   regfitscore    seed reg {
 npa:.p.import[`numpy]`:arr..

// Binary classification task
q)5#tgt:100?0b
01001b
// .aml.runexample[data;tgt;`normal;`class;::]
q).aml.models[`class;tgt]
model                      lib     fnc            seed typ    minit                    ..
---------------------------------------------------------------------------------------..
AdaBoostClassifier         sklearn ensemble       seed multi  {[x;y;z].p.import[x]y}[`s..
RandomForestClassifier     sklearn ensemble       seed multi  {[x;y;z].p.import[x]y}[`s..
GradientBoostingClassifier sklearn ensemble       seed multi  {[x;y;z].p.import[x]y}[`s..
LogisticRegression         sklearn linear_model   seed binary {[x;y;z].p.import[x]y}[`s..
GaussianNB                 sklearn naive_bayes    ::   binary {[x;y;z].p.import[x]y}[`s..
KNeighborsClassifier       sklearn neighbors      ::   multi  {[x;y;z].p.import[x]y}[`s..
MLPClassifier              sklearn neural_network seed multi  {[x;y;z].p.import[x]y}[`s..
SVC                        sklearn svm            seed binary {[x;y;z].p.import[x]y}[`s..
LinearSVC                  sklearn svm            seed binary {[x;y;z].p.import[x]y}[`s..
BinaryKeras                keras   binfitscore    seed binary {
 npa:.p.import[`numpy]`..

// Multi-class classification task
q)5#tgt:100?5
1 3 4 4 2
// .aml.runexample[data;tgt;`normal;`class;::]
q).aml.models[`class;tgt]
model                      lib     fnc            seed typ   minit                     ..
---------------------------------------------------------------------------------------..
AdaBoostClassifier         sklearn ensemble       seed multi {[x;y;z].p.import[x]y}[`sk..
RandomForestClassifier     sklearn ensemble       seed multi {[x;y;z].p.import[x]y}[`sk..
GradientBoostingClassifier sklearn ensemble       seed multi {[x;y;z].p.import[x]y}[`sk..
KNeighborsClassifier       sklearn neighbors      ::   multi {[x;y;z].p.import[x]y}[`sk..
MLPClassifier              sklearn neural_network seed multi {[x;y;z].p.import[x]y}[`sk..
MultiKeras                 keras   multifitscore  seed multi {
 npa:.p.import[`numpy]`:..

```

### Automatic type checking

Given the automated nature of the machine learning pipeline being produced it is important to ensure that only types which can be handled by the feature extraction procedures are passed through the workflow. These types are problem type specific as outlined below. It should be noted that if a column is removed due to an inability to handle this type this omission will be highlighted in the output to console.

#### Non time-series/time-aware model

Due to restrictions in the the feature extraction procedures for "normal" feature extraction the following types are omitted from the extraction procedure

- guid
- byte
- list
- character

Example output on passing of inappropriate type

```q
q)5#data:([]100?1f;100?1f;100?1f;100?0x;100?(5?1f;5?1f))
x         x1        x2         x3 x4                                                
------------------------------------------------------------------------------------
0.2777906 0.377558  0.9743168  00 0.3603064  0.1821269 0.7626891 0.6216393 0.3886478
0.9461053 0.6467861 0.08110583 00 0.03301238 0.3722512 0.2911225 0.7153449 0.2740865
0.1837247 0.8117767 0.7526589  00 0.3603064  0.1821269 0.7626891 0.6216393 0.3886478
0.3238577 0.6004456 0.9495261  00 0.03301238 0.3722512 0.2911225 0.7153449 0.2740865
0.6081598 0.8784222 0.3745857  00 0.03301238 0.3722512 0.2911225 0.7153449 0.2740865
q)tgt:100?1f
// output truncated to only include appropriate information
q).aml.runexample[data;target;`normal;`reg;::]
...
Removed the following columns due to type restrictions for normal
`x3`x4
...
```

#### FRESH

Given the feature extraction procedures completed by the FRESH algorithm as outlined [here](../../../toolkit/fresh.md) the list of omitted types is extensive, for clarity the id columns are not subject to these restrictions

- guid
- byte
- time/date types
- list
- character

Example output on passing of inappropriate type

```q
q)5#data:([]100?5?0p;100?0p;100?`time$10?100;100?1f;100?0f;100?0f;100?0x)
x                             x1                            x2           x3         x4 ..
---------------------------------------------------------------------------------------..
2001.11.17D03:43:34.704083648 2000.07.20D10:53:23.066901862 00:00:00.052 0.5898436  0  ..
2000.10.31D17:06:42.021188288 2001.12.01D05:48:39.442939016 00:00:00.026 0.8530844  0  ..
2001.08.27D00:41:11.301421520 2002.02.08D23:46:16.352224496 00:00:00.077 0.592908   0  ..
2003.08.10D17:18:14.377742704 2003.03.07D22:49:27.928487056 00:00:00.070 0.2352599  0  ..
2001.08.27D00:41:11.301421520 2003.06.20D03:55:14.609259360 00:00:00.073 0.09766787 0  ..
q)tgt:5?1f
// output truncated to only include appropriate information
q).aml.runexample[data;target;`fresh;`reg;::]
...
 Removed the following columns due to type restrictions for fresh
`x1`x2`x6
...
```

### Target consistency

Given the requirement for a one-to-one mapping between the rows output after feature extraction and the number of target values this is checked prior to the application of feature extraction or machine learning algorithms. The logic behind this check is different for the FRESH algorithm and the other forms of automated learning provided.

#### FRESH

In the default configuration target consistency in FRESH is determined by checking that the number of unique values in the first column of the input table and comparing this to the number of targets. For cases where multiple 'aggregation' columns are required see the advanced options section [here](insert).

The following truncated output is indicative of incorrect lengths targets mapped to rows being given, the function to apply to replicate the behaviour is provided for execution while invocation using `runexample` is also supplied.

```q
q)data:([]100?1f;100?1f;100?1f)
q)tgt:50?1f

// .aml.i.runexample[data;tgt;`fresh;`reg;::]
q)dict:enlist[`aggcols]!enlist `x // This is defined in the macro function
q).aml.i.lencheck[data;tgt;`fresh;dict]
'Target count must equal count of unique agg values for fresh
```

#### Non-FRESH

In the case of non-FRESH automated machine learning the comparison is much simpler. If the number of rows in the input table does not equal the number of targets an error will be flagged. The following is an example of such an error.

```q
q)data:([]100?1f;100?1f;100?1f)
q)tgt:50?1f

//.aml.runexample[data;tgt;`normal;`reg;::]
q).aml.i.lencheck[data;tgt;`normal;::]
'Must have the same number of targets as values in table
```

### Symbol encoding

In the FRESH and all non-FRESH example symbol columns are encoded as follows,

-  If there are less than 10 unique symbols in a particular column the data is one-hot encoded.
-  If a column contains more than 10 unique symbols the values are frequency encoded

The following example shows the application of this encoding for two columns which between the two of them meet both of the above criteria

```q
q).aml.i.symencode[x;10]
x          x2_freq    x1_b x1_d x1_e x1_h x1_i x1_j x1_n x1_o
-------------------------------------------------------------
0.8585142  0.09090909 0    0    1    0    0    0    0    0   
0.4174982  0.09090909 0    0    0    0    0    0    0    1   
0.8838377  0.09090909 0    0    0    0    1    0    0    0   
0.7256753  0.09090909 0    1    0    0    0    0    0    0   
0.5056055  0.09090909 0    1    0    0    0    0    0    0   
0.9348517  0.09090909 0    0    0    0    0    1    0    0   
0.5689362  0.09090909 0    0    0    1    0    0    0    0   
0.07686201 0.09090909 0    0    0    1    0    0    0    0   
0.7035851  0.09090909 1    0    0    0    0    0    0    0   
0.7945502  0.09090909 0    0    0    0    0    0    1    0   
0.7611306  0.09090909 0    0    0    0    0    1    0    0   
```

### Constant column removal

Columns which contain only one unique value are removed from the dataset as they cannot provide useful information to prediction of a target due a lack of signal within the data. The following is the implemented code to achieve this.

```q
q)5#data:([]100?1f;100#0f;100?1f)
x         x1 x2       
----------------------
0.4774146 0  0.4286866
0.4041947 0  0.3158067
0.7717654 0  0.9003969
0.3876964 0  0.719155 
0.1433602 0  0.6433137
q).ml.dropconstant[data]
x          x2       
--------------------
0.4774146  0.4286866
0.4041947  0.3158067
0.7717654  0.9003969
0.3876964  0.719155 
0.1433602  0.6433137
```

### Null and infinity replacement

Both null values and infinities are removed from the data due to the inability of machine learning models in sklearn and keras to handle this form of data. In the case of `+/-0w` the values are replaced by the minimum/maximum value of the column while `0n`'s is replaced by the median value of the column. In cases where nulls are present an additional column is added denoting the location of the null prior to filling of the dataset thus encoding the null in the case that this is an important signal.

```q
q)show data:([](3?1f),0n;(3?1f),-0w;4?1f)
q).aml.i.null_encode[.ml.infreplace data;med]
x         x1        x2         x_null
-------------------------------------
0.9764793 0.8737778 0.02064306 0     
0.5706695 0.4463957 0.9888238  0     
0.4079939 0.7378628 0.5247357  0     
0.4893317 0.4463957 0.4674091  1     
```
