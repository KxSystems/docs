---
title: Data prepocessing for the Kx automated machine-learning platform | Machine Learning | Documentation for q and kdb+
author: Conor McCarthy
description: Default behavior of the Kx automated machine learning tools; common processes completed across all forms of automated machine learning and the differences between offerings
date: October 2019
keywords: machine learning, ml, automated, preprocessing, feature extraction, feature selection, time-series, cleansing
---
# :fontawesome-solid-share-alt: Automated data preprocessing



:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl)

The preprocessing of data is of critical importance in all machine-learning applications, particularly within automated pipelines where the majority of control is, by definition, removed from the user.

Running the function [`.automl.run`](index.md) in its default configuration is achieved by setting the final parameter `dict` to `::`. 

The following are the procedures completed when the default system configuration is deployed:

1. Appropriate models are chosen for the use-case type being explored (classification/regression).
2. Inappropriate columns within the dataset are removed based on their types.
3. A check is applied to ensure that the number of targets is appropriate for the dataset type (`FRESH`/`normal`/`nlp`).
4. Symbol data columns are encoded via either one-hot or frequency encoding.
5. Constant columns are removed from the data.
6. Nulls are replaced and an additional column is added to encode their original position
7. Positive/negative infinities are replaced by the non-infinite max/min value of the column


## Applied models

Models applied are chosen based on user definition of the type of machine learning task being explored, paired with additional information about the target data. For clarity, the models available are listed below:


### Binary classification models

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


### Multi-class classification models

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

These models can be augmented through modification of `regmodels.txt` and `classmodels.txt` within the `mdldef` folder of the repository.

The following examples show how these models are defined within the workflow for a regression example with an explanation of the meaning of the columns provided for completeness

```q
// Tabular dataset
q)2#tab:([]100?1f;100?1f;100?1f)
x         x1        x2        
------------------------------
0.7250709 0.724948  0.06165008
0.481804  0.8112026 0.285799  

// Regression task
q)5#tgt:100?1f
0.3927524 0.5170911 0.5159796 0.4066642 0.1780839
// .automl.run[tab;tgt;`normal;`reg;::]
q).automl.i.models[`reg;tgt;::]
model                     lib     fnc            seed typ minit              ..
-----------------------------------------------------------------------------..
AdaBoostRegressor         sklearn ensemble       seed reg {[x;y;z].p.import[x..
RandomForestRegressor     sklearn ensemble       seed reg {[x;y;z].p.import[x..
GradientBoostingRegressor sklearn ensemble       seed reg {[x;y;z].p.import[x..
KNeighborsRegressor       sklearn neighbors      ::   reg {[x;y;z].p.import[x..
MLPRegressor              sklearn neural_network seed reg {[x;y;z].p.import[x..
Lasso                     sklearn linear_model   seed reg {[x;y;z].p.import[x..
LinearRegression          sklearn linear_model   ::   reg {[x;y;z].p.import[x..
RegKeras                  keras   reg            seed reg {[d;s;mtype]
```

In the above example the following describe the columns for the defined tables.

```txt
model   name of the model to be applied
lib     Python library from which the model is derived
fnc     sub module within the python library from which a model is derived
seed    is a model capable of being seeded allowing for consistent rerunning?
typ     type of problem being solved
minit   definition of the model which will to be applied in the workflow
```

!!! note "Keras architectures"

    The Keras models first introduced in V0.1 are basic single-layer neural networks. 

    A user can [define more complex Keras architectures](../faq.md) as desired for the use case in question if an appropriate architecture is known.


## Automatic type checking

Given the automated nature of the machine-learning pipeline, it is important to ensure that only types which can be handled by the feature extraction procedures are passed through the workflow. These types are problem-type specific, as outlined below. Note that when a column of an incompatible type is removed, its omission will be communicated to the user via the console output.

The following lists show the restricted types for each problem type. In each case these types are not handled gracefully within the feature extraction workflow and thus are omitted

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
q).automl.run[data;tgt;`normal;`reg;::]
...
Removed the following columns due to type restrictions for normal
`x3`x4
...
```


## Target consistency

Given the requirement for a one-to-one mapping between the rows output after feature extraction and the number of target values, target consistency is checked prior to the application of feature extraction or machine learning algorithms. The logic behind this check varies for different problem types.

problem type | description
:------------|:-----------
FRESH        | The number of unique combinations of aggregate columns must equal the number of targets
Normal       | The number of rows in the input table must equal the number of target values
NLP          | The number of rows in the input table must equal the number of target values

The example below show a failure for each problem type.

```q
q)data:([]100?1f;100?1f;100?1f)
q)tgt:50?1f
q)fresh_dict:enlist[`aggcols]!enlist `x
q)norm_dict:(::)
q).automl.prep.i.lencheck[data;tgt;`fresh;fresh_dict]
'Target count must equal count of unique agg values for fresh
q).automl.prep.i.lencheck[data;tgt;`normal;norm_dict]
'Must have the same number of targets as values in table
```


## Symbol encoding

In the FRESH and all non-FRESH example symbol columns are encoded as follows:

-  If there are fewer than 10 unique symbols in a particular column the data is one-hot encoded.
-  If a column contains more than 10 unique symbols the values are frequency encoded

!!! note

    In the case of FRESH the above limitations are performed on an aggregation-bucket basis for frequency encoding rather than for an entire column. This ensures that encoding on new data is as fair as possible in the case of FRESH since each aggregation bucket is associated with an individual target

The following example shows the application of this encoding for on two columns one of which will be one-hot encoded while the other is frequency encoded.

```q
q)tab:([]1000?`1;1000?`a`b`c;1000?1f)
q).automl.prep.i.symencode[tab;10;0b;::;::]
x2         x_freq x1_a x1_b x1_c
--------------------------------
0.7701313  0.06   0    1    0   
0.9673079  0.058  0    0    1   
0.5634727  0.048  1    0    0   
0.1465967  0.071  0    0    1   
0.6474446  0.071  0    1    0 
```


## Constant-column removal

Constant columns are those within the dataset which contain only one unique value. These columns are removed as they do not provide useful information in the prediction of a target. This is due to a lack of signal within the data. The following is the implemented code to achieve this.

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


## Null and infinity replacement

Both null values and infinities are removed from the data due to the inability of machine-learning models in both sklearn and keras to handle this form of data. In the case of `+/-0w`, the values are replaced by the minimum/maximum value of the column, while `0n`'s are replaced by the median value of the column in order to limit changes to the data distribution. 

In any cases where nulls are present, an additional column is added denoting the location of the null prior to filling of the dataset, thus encoding the null location in the case that this is an important signal for prediction.

```q
q)show data:([](3?1f),0n;(3?1f),-0w;4?1f)
x         x1        x2       
-----------------------------
0.5347096 0.1780839 0.3927524
0.7111716 0.3017723 0.5170911
0.411597  0.785033  0.5159796
          -0w       0.4066642
q).automl.prep.i.nullencode[.ml.infreplace data;med]
x         x1        x2         x_null
-------------------------------------
0.9764793 0.8737778 0.02064306 0     
0.5706695 0.4463957 0.9888238  0     
0.4079939 0.7378628 0.5247357  0     
0.4893317 0.4463957 0.4674091  1     
```
