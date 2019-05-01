---
author: Conor McCarthy
date: March 2019
keywords: time-series, cross validation, grid search, roll-forward, chain-forward, grid search fit, data splitting, stratified splitting, kdb+, q
---

# <i class="fa fa-share-alt"></i> Cross Validation Procedures 


The `.ml.xval` namespace contains functions used for the application of various cross-validation procedures, these offer the ability to test how robust/stable a model is to changes in the volume of data being interrogated or the subsets of data being used in validation procedures.

<i class="fab fa-github"></i>
[KxSystems/ml/xval/](https://github.com/kxsystems/ml/tree/master/xval)

The following functions are those contained at present within the `.ml.xval` namespace

```txt
.ml.xval - Cross validation functions
  .gridsearch         Grid search returns scores associated with ML-model params
  .gridsearchfit      Grid search returns score/params on test data set for optimal model
  .kfshuff            K-Fold cross validation, randomized indiced
  .kfsplit            K-Fold cross validation, sequential split indices
  .kfstrat            K-Fold cross validation, indices stratified based on target categories
  .mcsplit            Monte-Carlo cross validation with random split indices
  .tschain            Score from chain-forward cross validation
  .tsroll             Roll forward cross validation
```


## `.ml.xval.gridsearch`

_Find optimal parameters for machine-learning model through cross validation_

Syntax: `.ml.xval.gridsearch[xv;x;y;mdl;mthds;pd]`

Where

-   `xv` is a projection of the type of cross validation to be completed for the gridsearch
-   `x` is a matrix
-   `y` is a target vector
-   `mdl` is the model being tested in the gridsearch
-   `mthds` is a function indicating the behaviour to be applied during search (fit-score etc)
-   `pd` is a dictionary of hyperparameters to be searched

returns the score for the best model and the hyper-parameters which led to this score.

```q
q)lrm:.p.import[`sklearn.linear_model]`:LinearRegression
q)dcm:.p.import[`sklearn.tree]`:DecisionTreeClassifier
q)n:10000
q)x:flip(n?100f;asc n?100f)
q)yr:asc n?100f    / regression
q)yc:n?0 1         / classification
q)xval_func:.ml.xval.kfshuff[5;1]    / 5 fold shuffled xval 1 repetition
q)algo_func:.ml.xval.fitscore lrm    / fit & score linear regressor
q)param_dict:`fit_intercept`normalize!(01b;01b)
q).ml.xval.gridsearch[xval_func;x;yr;algo_func;param_dict]
fit_intercept normalize|                                                  
-----------------------| -------------------------------------------------
0             0        | 0.9999225 0.9999263 0.9999261 0.9999235 0.9999241
0             1        | 0.9999234 0.9999245 0.9999248 0.9999245 0.9999255
1             0        | 0.9999363 0.9999361 0.9999331 0.9999337 0.9999359
1             1        | 0.9999351 0.9999389 0.9999299 0.9999357 0.9999357
q)xval_func:.ml.xval.kfstrat[5;1]
q)algo_func:.ml.xval.fitscore dcm
q)param_dict:enlist[`max_depth]!enlist(::;1;2;3;4;5)
q).ml.xval.gridsearch[xval_func;x;yc;algo_func;param_dict]
max_depth|                                  
---------| ---------------------------------
::       | 0.5215 0.51   0.508  0.48  0.507 
1        | 0.493  0.5265 0.49   0.504 0.5065
2        | 0.503  0.5125 0.5035 0.532 0.5005
3        | 0.5135 0.5155 0.4995 0.511 0.5015
4        | 0.5165 0.5095 0.5125 0.493 0.507 
5        | 0.5185 0.504  0.5045 0.503 0.5175
```


## `.ml.xval.gridsearchfit`

_K-Fold validated grid-search with optimal model fit to testing set_

Syntax: `.ml.xval.gridsearchfit[xv;x;y;mdl;mthds;pd;pc]`

Where

-   `xv` is a projection of the type of cross validation to be completed for the gridsearch
-   `x` is a matrix
-   `y` is a target vector
-   `mdl` is the model being tested in the gridsearch
-   `mthds` is a function indicating the behaviour to be applied during search (fit-score etc)
-   `pd` is a dictionary of hyperparameters to be searched
-   `pc` is the percentage of data comprising the testing set

returns the score on the testing set for the best model.

!!!note
	As with `.ml.gridsearch`, this function performs a cross validated grid-search over all combinations of hyperparameters to find the best model. This function splits the data into a train/test sets, performs grid-search on the training set (with k-fold cross validation defined within `xv`), fits the model with the highest score to the testing set.

```q
q)lrm:.p.import[`sklearn.linear_model]`:LinearRegression
q)dcm:.p.import[`sklearn.tree]`:DecisionTreeClassifier
q)n:10000
q)x:flip(n?100f;asc n?100f)
q)yr:asc n?100f / regression
q)yc:n?0 1      / classification
q)xval_func:.ml.xval.kfshuff[5;1]
q)algo_func:.ml.xval.fitscore lrm
q)param_dict:`fit_intercept`normalize!(01b;01b)
q).ml.xval.gridsearchfit[xval_func;x;yc;algo_func;param_dict;0.2]
`fit_intercept`normalize!11b
-0.0006069159
q)algo_func:.ml.xval.fitscore dcm
q)param_dict:enlist[`max_depth]!enlist(::;1;2;3;4;5)
q).ml.xval.gridsearchfit[xval_func;x;yc;algo_func;param_dict;0.2]
(,`max_depth)!,::
0.4925
```


## `.ml.xval.kfshuff`

_Randomized non-repeating indices for K-fold cross validation_

Syntax: `.ml.xval.kfshuff[x;y]`

Where

-   `x` is the target vector
-   `y` is the number of 'folds' which the data is to be split into

returns randomized non-repeating indices associated with each of the K-folds.

```q
q)yg:asc 1000?100f
q).ml.xval.kfshuff[yg;5]
647 755 790 152 948 434 583 536 156 637 699 159 315 698 41  345 565 680 775 6..
118 402 34  601 833 877 762 703 129 294 593 634 192 939 545 98  641 266 910 4..
795 69  664 393 519 722 616 55  132 802 448 140 361 194 977 97  247 74  733 6..
633 430 346 267 102 201 123 295 487 418 606 108 154 899 398 932 994 643 944 5..
919 354 119 478 954 567 497 848 665 471 406 541 307 82  984 198 134 622 550 9..
```

!!! note
	An aliased version of this function is contained in the root namespace and defined as `.ml.kfshuff`. This coincides with the existance of the aliased function `.ml.kfoldx` in the root namespace. Thus makes it easier to create indices to be passed to the cross validation function.

## `.ml.xval.kfsplit`

_Ascending indices in K-folds_

Syntax: `.ml.xval.kfsplit[x;y]`

Where

-   `x` is the target vector
-   `y` is the number of 'folds' which the data is to be split into

returns the ascending indices associated with each of the K-fold.

```q
q)yg:asc 1000?100f                              / this is a proxy for the target vector
q)folds:3                                       / number of folds for data
q)show i:.ml.xval.kfsplit[yg;folds]
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 ..
333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 3..
666 667 668 669 670 671 672 673 674 675 676 677 678 679 680 681 682 683 684 6..
```


## `.ml.xval.kfstrat`

_Distribute data into K-Folds with approx equal distribution of classes_

Syntax: `.ml.xval.kfstrat[x;y]`

Where

-   `x` is the target vector
-   `y` is the number of 'folds' which the data is to be split into

returns the indices for each of the K-folds with an approximately equal distribution of classes between folds. This is used extensively in cases where the distribution of classes in the data is unbalanced.

```q
q)yg:(100#0b),10#1b                  / this is a proxy for the target vector
q).ml.xval.kfstrat[yg;5]             / split the data into 5 stratified folds
7  69 93 100 15  94 42  27 107 85 62  12 4  53  58 47 29 105 101 56 35 106
59 26 49 8   20  44 31  6  0   43 30  40 95 54  99 39 98 16  33  52 51 3
87 48 45 64  109 72 70  68 9   61 81  1  36 104 5  55 91 24  78  76 79 71
46 28 21 83  25  2  102 34 23  60 108 13 67 86  18 75 90 89  97  22 57 65
32 63 10 19  74  96 103 66 11  84 41  73 38 77  17 14 92 37  82  88 50 80
q)yg .ml.xval.kfstrat[yg;5]
0000000000000000000011b
0000000000000000000011b
0000000000000000000011b
0000000000000000000011b
0000000000000000000011b
```


## `.ml.xval.tschain`

_Score from a chain-forward cross validation_

Syntax: `.ml.xval.tschain[x;y;n;algo]`

Where

-   `x` is a matrix of data for prediction
-   `y` is a target vector
-   `n` is the number of splits performed on the dataset
-   `algo` is the algorithm being tested

returns the averaged score for the model over all chained iterations.

```q
q)n:10000
q)x:flip value flip([]n?100f;asc n?100f)
q)y:asc n?100f
q)reg:.p.import[`sklearn.linear_model][`:LinearRegression][]
q).ml.xval.tschain[x;y;10;reg]
0.972491
```

!!! note
        This works as shown in the following image:

        ![Figure 1](img/chainforward.png)

        The data is split into equi-sized bins with increasing amounts of the data incorporated in the testing set at each step. This avoids testing a model on historical information which would be counter-productive in testing a model for time-series forecasting. It also allows the robustness of the model to increasing data volumes to be probed.



## `.ml.xval.mcxval`

_Score for monte-carlo cross validated model_

Syntax: `.ml.xval.mcxval[x;y;sz;algo;n]`

Where

-   `x` is a matrix of data to be fit
-   `y` is the target vector
-   `sz` is an numeric atom in the range 0-1, representing the percentage of data in the testing set
-   `algo` is the algorithm being tested
-   `n` is the number of validation iterations to be completed

returns the average score for all iterations of the monte-carlo cross validation.

```q
q)n:10000
q)xg:flip value flip([]n?100;asc n?100f)
q)yg:asc n?5
q)clf:.p.import[`sklearn.tree][`:DecisionTreeClassifier][]
q).ml.xval.mcxval[xg;yg;.2;clf;5]
0.999375
q)xb:flip value flip([]n?100;n?100f)
q)yb:n?5
q).ml.xval.mcxval[xb;yb;.2;clf;5]
0.20675
```

!!! note
        This form of cross validation is also known as 'repeated random sub-sampling validation'. This has advantages over K-fold when observations are not wanted in equi-sized bins or where outliers could heavily bias a classifier. More information is available [here](https://en.wikipedia.org/wiki/Cross-validation_(statistics)#Repeated_random_sub-sampling_validation).


## `.ml.xval.tsroll`

_Score from a roll-forward cross validation_

Syntax: `.ml.xval.tsroll[x;y;n;algo]`

Where

-   `x` is a matrix of the data to be fit
-   `y` is the target vector
-   `n` is the number of validation splits of the data
-   `algo` is the model to be applied for validation

returns the average score from all n-fits to the validation set.

```q
q)n:10000
q)xg:flip value flip ([]n?100;asc n?100f)
q)yg:asc n?100f
q)reg:.p.import[`sklearn.linear_model][`:LinearRegression][]
q).ml.xval.tsroll[xg;yg;10;reg]
-11.99615
```
!!! note
        This works as shown in the following image:

        ![Figure 2](img/rollforward.png)

        Successive equi-sized bins are taken as validation and training sets for each step. This avoids testing a model on historical information which would be counter-productive in testing a model for time-series forecasting for example.
