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
  .gridsearch         Grid search returning scores associated with ML-model params
  .gridsearchfit      Grid search returning score/params on test data set for optimal model
  .kfshuff            K-Fold cross validation, randomized indiced
  .kfsplit            K-Fold cross validation, sequential split indices
  .kfstrat            K-Fold cross validation, indices stratified based on target categories
  .mcsplit            Monte-Carlo cross validation with random split indices
  .tschain            Chain forward cross validation
  .tsroll             Roll forward cross validation
```


## `.ml.xval.gridsearch`

_Find optimal parameters for machine-learning model through cross validation_

Syntax: `.ml.xval.gridsearch[xv;x;y;mdl;mthd;pd]`

Where

-   `xv` is a projection outlining the form of cross validation to be completed for the gridsearch
-   `x` is a matrix
-   `y` is a target vector
-   `mdl` is the model being tested
-   `mthd` is a function indicating the behaviour to be applied during search (fit-score etc)
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

Syntax: `.ml.xval.gridsearchfit[xv;x;y;mdl;mthd;pd;pc]`

Where

-   `xv` is a projection outlining the form of cross validation to be completed for the gridsearch
-   `x` is a matrix
-   `y` is a target vector
-   `mdl` is the model being tested
-   `mthd` is a function indicating the behaviour to be applied during search (fit-score etc)
-   `pd` is a dictionary of hyperparameters to be searched
-   `pc` is the percentage of data comprising the testing set

returns the best score and parameter set based on the score on the testing set for the best model.

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

_K-Fold cross validation for randomized non-repeating indices_

Syntax: `.ml.xval.kfshuff[k;n;x;y;mdl;mthd]`

Where

-   `k` is the number of folds into which the data is split.
-   `n` is the number of repetitions of this cross validation procedure.
-   `x` is a matrix
-   `y` is the target vector
-   `mdl` is the model being applied
-   `mthd` is a function indicating the behaviour to be applied during search

returns scores for a model applied to each of the possible K-folds splits.

```q
q)n:200000
q)x:flip(n?100f;asc n?100f)
q)yr:asc n?100f / regression
q)lrm:.p.import[`sklearn.linear_model]`:LinearRegression
q).ml.xval.kfshuff[5;1;x;yr;lrm;.ml.xval.fitscore[]]
0.9999935 0.9999934 0.9999935 0.9999935 0.9999935
```

## `.ml.xval.kfsplit`

_Cross validation for ascending indices in split into K-folds_

Syntax: `.ml.xval.kfsplit[k;n;x;y;mdl;mthd]`

Where

-   `k` is the number of folds into which the data is split.
-   `n` is the number of repetitions of this cross validation procedure.
-   `x` is a matrix
-   `y` is the target vector
-   `mdl` is the model being applied
-   `mthd` is a function indicating the behaviour to be applied during search

returns scores for a model applied to each of the possible K-folds splits.

```q
q)n:200000
q)x:flip(n?100f;asc n?100f)
q)yr:asc n?100f 
q)lrm:.p.import[`sklearn.linear_model]`:LinearRegression
q).ml.xval.kfsplit[5;1;x;yr;lrm;.ml.xval.fitscore[]]
0.9997031 0.9999821 0.9999359 0.9996741 0.9988422
```


## `.ml.xval.kfstrat`

_Stratified K-Fold cross validation with approx equal distribution of classes per fold_

Syntax: `.ml.xval.kfstrat[k;n;x;y;mdl;mthd]`

Where

-   `k` is the number of folds into which the data is split.
-   `n` is the number of repetitions of this cross validation procedure.
-   `x` is a matrix
-   `y` is the target vector
-   `mdl` is the model being applied            
-   `mthd` is a function indicating the behaviour to be applied during search

returns the indices for each of the K-folds where the folds have approximately equal distribution of target classes.

```q
q)n:200000
q)x:flip(n?100f;asc n?100f)
q)yc:asc n?100f 
q)dcm:.p.import[`sklearn.tree]`:DecisionTreeClassifier
q).ml.xval.kfsplit[5;1;x;yc;dcm;.ml.xval.fitscore[]]
0.4973126 0.50425 0.497675 0.498725 0.5004125
```

!!!note
	This is used extensively in cases where the distribution of classes in the data is unbalanced.

## `.ml.xval.mcsplit`

_Scores for monte-carlo cross validated model_

Syntax: `.ml.xval.mcsplit[p;n;y;sz;algo;n]`

Where

-   `p` is a float between 0 and 1, which is the percentage of data within the validation set.
-   `n` is the number of repetitions of this cross validation procedure.
-   `x` is a matrix.
-   `y` is the target vector.
-   `mdl` is the model being applied.
-   `mthd` is a function indicating the behaviour to be applied during search.

returns the average score for all iterations of the monte-carlo cross validation.

```q
q)n:200000
q)x:flip(n?100f;asc n?100f)
q)yr:asc n?100f
q)lrm:.p.import[`sklearn.linear_model]`:LinearRegression
q).ml.xval.mcsplit[0.2;5;10;x;yr;lrm;.ml.xval.fitscore[]]
0.9999935 0.9999935 0.9999935 0.9999935 0.9999934
```

!!! note
        This form of cross validation is also known as 'repeated random sub-sampling validation'. This has advantages over K-fold when observations are not wanted in equi-sized bins or where outliers could heavily bias a classifier. More information is available [here](https://en.wikipedia.org/wiki/Cross-validation_(statistics)#Repeated_random_sub-sampling_validation).


## `.ml.xval.tschain`

_Scores from a chain-forward cross validation_

Syntax: `.ml.xval.tschain[k;n;x;y;mdl;mthd]`

Where

-   `k` is the number of folds into which the data is split.
-   `n` is the number of repetitions of this cross validation procedure.
-   `x` is a matrix
-   `y` is the target vector
-   `mdl` is the model being applied            
-   `mthd` is a function indicating the behaviour to be applied during search

returns the k-1 scores for the applied model over chained iterations.

```q
q)n:200000
q)x:flip(n?100f;asc n?100f)
q)yr:asc n?100f
q)lrm:.p.import[`sklearn.linear_model]`:LinearRegression
q).ml.xval.tschain[5;1;x;yr;lrm;.ml.xval.fitscore[]]
0.9973771 0.9992741 0.9996898 0.9997031
```

!!! note
        This works as shown in the following image:

        ![Figure 1](img/chainforward.png)

        The data is split into equi-sized bins with increasing amounts of the data incorporated in the testing set at each step. This avoids testing a model on historical information which would be counter-productive in testing a model for time-series forecasting. It also allows the robustness of the model to increasing data volumes to be probed.


## `.ml.xval.tsroll`

_Score from a roll-forward cross validation_

Syntax: `.ml.xval.tsroll[x;y;n;algo]`

Where

-   `k` is the number of folds into which the data is split.
-   `n` is the number of repetitions of this cross validation procedure.
-   `x` is a matrix
-   `y` is the target vector
-   `mdl` is the model being applied
-   `mthd` is a function indicating the behaviour to be applied during search

returns the scores for each (k-1) rolled fits to the validation set.

```q
q)n:200000
q)x:flip(n?100f;asc n?100f)
q)yr:asc n?100f
q)lrm:.p.import[`sklearn.linear_model]`:LinearRegression
q).ml.xval.tsroll[5;1;x;yr;lrm;.ml.xval.fitscore[]]
0.9973771 0.9995615 0.9999869 0.999965
```
!!! note
        This works as shown in the following image:

        ![Figure 2](img/rollforward.png)

        Successive equi-sized bins are taken as validation and training sets for each step. This avoids testing a model on historical information which would be counter-productive in testing a model for time-series forecasting for example.
