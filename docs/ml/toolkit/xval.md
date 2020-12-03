---
author: Conor McCarthy
title: Cross validation procedures - Machine Learning – Machine Learning – kdb+ and q documentation
description: The .ml.xv, .ml.gs and .ml.rs namespaces contain functions related to cross-validation and grid search algorithms. These algorithms test how robust or stable a model is to changes in the volume of data or the specific subsets of data used for validation.
date: March 2019
keywords: time-series, cross validation, grid search, random search, Sobol sequences, sobol-random search, roll-forward, chain-forward, grid search fit, data splitting, stratified splitting, kdb+, q
---
# :fontawesome-solid-share-alt: Cross validation procedures 



<div markdown="1" class="typewriter">
.ml.gs   **Grid-search functions**
  [kfshuff](#mlgskfshuff)      K-Fold cross validation with randomized indices
  [kfsplit](#mlgskfsplit)      K-Fold cross validation with sequential indices
  [kfstrat](#mlgskfstrat)      K-Fold cross validation with stratified indices
  [mcsplit](#mlgsmcsplit)      Monte-Carlo cross validation with random split indices
  [pcsplit](#mlgspcsplit)      Percentage-split cross validation
  [tschain](#mlgstschain)      Chain-forward cross validation
  [tsrolls](#mlgstsrolls)      Roll-forward cross validation

.ml.rs   **Random-search functions**
  [kfshuff](#mlrskfshuff)      K-Fold cross validation with randomized indices
  [kfsplit](#mlrskfsplit)      K-Fold cross validation with sequential indices
  [kfstrat](#mlrskfstrat)      K-Fold cross validation with stratified indices
  [mcsplit](#mlrsmcsplit)      Monte-Carlo cross validation with random split indices
  [pcsplit](#mlrspcsplit)      Percentage-split cross validation
  [tschain](#mlrstschain)      Chain-forward cross validation
  [tsrolls](#mlrstsrolls)      Roll-forward cross validation

.ml.xv   **Cross-validation functions**
  [kfshuff](#mlxvkfshuff)      K-Fold cross validation with randomized indices
  [kfsplit](#mlxvkfsplit)      K-Fold cross validation with sequential indices
  [kfstrat](#mlxvkfstrat)      K-Fold cross validation with stratified indices
  [mcsplit](#mlxvmcsplit)      Monte-Carlo cross validation with random split indices
  [pcsplit](#mlxvpcsplit)      Percentage-split cross validation
  [tschain](#mlxvtschain)      Chain-forward cross validation
  [tsrolls](#mlxvtsrolls)      Roll-forward cross validation
</div>

:fontawesome-brands-github:
[KxSystems/ml/xval](https://github.com/kxsystems/ml/tree/master/xval/)

The `.ml.xv`, `.ml.gs` and `.ml.rs` namespaces contain functions related to cross validation, grid search, random/sobol-random search algorithms respectively. These algorithms are used in machine learning to test how robust or stable a model is to changes in the volume of data or to the specific subsets of data used for model generation.

Within the following examples, `.ml.xv.fitscore` is used extensively to fit models and return the score achieved on validation/test data. This function can be replaced by a user-defined alternative for tailored applications, e.g. a function to fit on training data and predict outputs for new data.

As of toolkit version 0.1.3, the distribution of cross-validation functions is invoked at console initialization. If a process is started with `$q -s -4 -p 4321` and `xval.q` is loaded into the process, then the cross-validation library will automatically make 4 worker processes available to execute jobs.

!!! tip "Interactive notebook implementations"

  	Interactive notebook implementations of a large number of the functions outlined here are available within :fontawesome-brands-github: [KxSystems/mlnotebooks](https://github.com/KxSystems/mlnotebooks)
    

## Grid Search

The most common method of perfoming hyperparameter optimization in machine learning is through the use of a grid search. Grid search is an exhaustive searching method across all possible combinations of a hyperparameters provided by a user.

#### Grid Search Hyperparameter Dictionary

When applying the grid search functionality provided within the toolkit, a user must provide a dictionary mapping the names of all the hyperparameters to be searched with the possible values to be considered for the hyperparameter. The following example shows a set of valid hyperparameter dictionaries for an `sklearn` AdaBoostRegressor and `DecisionTreeClassifier`

```q
/ grid search hyperparameter dictionary for an AdaBoostRegressor
q)p:`n_estimators`learning_rate!(10 20 50 100;0.1 0.5 0.9)
/ grid search hyperparameter dictionary for a DecisionTreeClassifier
q)p:enlist[`max_depth]!enlist(::;1;2;3;4;5)
```


### `.ml.gs.kfshuff`

_Cross-validated parameter grid search applied to data with shuffled split indices_

Syntax: `.ml.gs.kfshuff[k;n;x;y;f;p;h]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function that takes parameters and data as input and returns a score
-   `p` is a dictionary of hyperparameters to be searched - see section [Grid Search Hyperparameter Dictionary](#grid-search-hyperparameter-dictionary)
-   `h` is a float value denoting the size of the holdout set used in a fitted grid search, where the best model is fit to the holdout set. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the `k` folds for all values of `h` and additionally returns the best hyperparameters and score on the holdout set for `0 < h <= 1`.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yr:x[;0]+m?.05
// algo
q)rf:{.p.import[`sklearn.linear_model]`:LinearRegression}
// params
q)pr:`fit_intercept`normalize!(01b;01b)
// 4 fold cross-validation no holdout
q).ml.gs.kfshuff[4;1;x;yr;.ml.xv.fitscore rf;pr;0]
fit_intercept normalize|
-----------------------| ---------------------------------------
0             0        | 0.997356  0.9973086 0.9971782 0.9973688
0             1        | 0.9974428 0.9972132 0.9972411 0.9973183
1             0        | 0.9975179 0.997513  0.9975894 0.99757
1             1        | 0.99761   0.9974926 0.997565  0.997517
// 5 fold cross-validated grid search fitted on 20% holdout set
q).ml.gs.kfshuff[5;1;x;yr;.ml.xv.fitscore rf;pr;.2]
(+`fit_intercept`normalize!(0011b;0101b))!(0.9972156 0.9974328 0.9972923 0.99..
`fit_intercept`normalize!11b
0.9975171
```


### `.ml.gs.kfsplit`

_Cross-validated parameter grid search applied to data with ascending split indices_

Syntax: `.ml.gs.kfsplit[k;n;x;y;f;p;h]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function that takes parameters and data as input and returns a score
-   `p` is a dictionary of hyperparameters to be searched - see section [Grid Search Hyperparameter Dictionary](#grid-search-hyperparameter-dictionary)
-   `h` is a float value denoting the size of the holdout set used in a fitted grid search, where the best model is fit to the holdout set. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the `k` folds for all values of `h` and additionally returns the best hyperparameters and score on the holdout set for `0 < h <= 1`.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yc:(raze flip(0N;4)#m#`a`b`c`d)rank x[;0]
// algos
q)cf:{.p.import[`sklearn.tree]`:DecisionTreeClassifier}
// params
q)pc:enlist[`max_depth]!enlist(::;1;2;3;4;5)
// 5 fold cross-validation no holdout
q).ml.gs.kfsplit[5;1;x;yc;.ml.xv.fitscore cf;pc;0]
max_depth|
---------| ---------------------------------
::       | 1     0.999  1      1      0.9995
1        | 0.484 0.4925 0.4855 0.4895 0.4895
2        | 1     0.742  1      0.7385 0.738
3        | 1     0.999  1      1      0.9995
4        | 1     0.999  1      1      0.9995
5        | 1     0.999  1      1      0.9995
// 5 fold cross-validated grid search fitted on 20% holdout set
q).ml.gs.kfsplit[5;1;x;yc;.ml.xv.fitscore cf;pc;.2]
(+(,`max_depth)!,(::;1;2;3;4;5))!(0.99875 1 0.999375 0.999375 1;0.500625 0.48..
(,`max_depth)!,::
1f
// 10 fold cross-validated grid search fitted on 10% holdout 
// with initial data shuffle
q).ml.gs.kfsplit[10;1;x;yc;.ml.xv.fitscore cf;pc;-.1]
(+(,`max_depth)!,(::;1;2;3;4;5))!(1 1 1 1 1 1 1 1 0.9988889 0.9977778;0.48555..
(,`max_depth)!,::
0.998
```


### `.ml.gs.kfstrat`

_Cross-validated parameter grid search applied to data with an equi-distributions of targets per fold_

Syntax: `.ml.gs.kfstrat[k;n;x;y;f;p;h]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function that takes parameters and data as input and returns a score
-   `p` is a dictionary of hyperparameters to be searched - see section [Grid Search Hyperparameter Dictionary](#grid-search-hyperparameter-dictionary)
-   `h` is a float value denoting the size of the holdout set used in a fitted grid search, where the best model is fit to the holdout set. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the `k` folds for all values of `h` and additionally returns the best hyperparameters and score on the holdout set for `0 < h <= 1`.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yc:(raze flip(0N;4)#m#`a`b`c`d)rank x[;0]
// algos
q)cf:{.p.import[`sklearn.tree]`:DecisionTreeClassifier}
// params
q)pc:enlist[`max_depth]!enlist(::;1;2;3;4;5)
// 5 fold cross-validation no holdout
q).ml.gs.kfstrat[5;1;x;yc;.ml.xv.fitscore cf;pc;0]
max_depth|
---------| -------------------------------
::       | 1      0.9995 1   0.9985 1
1        | 0.4995 0.5    0.5 0.5    0.5
2        | 1      1      1   0.9995 1
3        | 1      1      1   1      0.9995
4        | 1      1      1   0.9995 1
5        | 1      0.9995 1   0.999  0.999
// 4 fold cross-validated grid search fitted on 20% holdout set
q).ml.gs.kfstrat[4;1;x;yc;.ml.xv.fitscore cf;pc;.2]
(+(,`max_depth)!,(::;1;2;3;4;5))!(1 0.9995 1 1;0.5052474 0.505 0.5052474 0.50..
(,`max_depth)!,3
1f
```


### `.ml.gs.mcsplit`

_Cross-validated parameter grid search applied to randomly shuffled data and validated on a percentage holdout set_

Syntax: `.ml.gs.mcsplit[pc;n;x;y;f;p;h]`

Where

-   `pc` is a float between 0 and 1 denoting the percentage of data in the holdout validation set
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function that takes parameters and data as input and returns a score
-   `p` is a dictionary of hyperparameters to be searched - see section [Grid Search Hyperparameter Dictionary](#grid-search-hyperparameter-dictionary)
-   `h` is a float value denoting the size of the holdout set used in a fitted grid search, where the best model is fit to the holdout set. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the `k` folds for all values of `h` and additionally returns the best hyperparameters and score on the holdout set for `0 < h <= 1`.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yr:x[;0]+m?.05
// algo
q)rf:{.p.import[`sklearn.linear_model]`:LinearRegression}
// params
q)pr:`fit_intercept`normalize!(01b;01b)
// 20% validation set with 5 repetitions, no fit on holdout
q).ml.gs.mcsplit[0.2;5;x;yr;.ml.xv.fitscore rf;pr;0]
fit_intercept normalize|
-----------------------| -------------------------------------------------
0             0        | 0.9972352 0.9972425 0.9971611 0.9971591 0.997231
0             1        | 0.9972606 0.9972371 0.9972327 0.9971915 0.9972252
1             0        | 0.997512  0.9974875 0.9975111 0.9974552 0.9974987
1             1        | 0.9975357 0.9975999 0.9975074 0.9974429 0.9975411
// 10% validation set with 3 repetitions, fit on 20% holdout set
q).ml.gs.mcsplit[0.1;3;x;yr;.ml.xv.fitscore rf;pr;.2]
(+`fit_intercept`normalize!(0011b;0101b))!(0.9973292 0.997217 0.9973233;0.997..
`fit_intercept`normalize!10b
0.997549
```


### `.ml.gs.pcsplit`

_Cross-validated parameter grid search applied to percentage split dataset_

Syntax: `.ml.gs.pcsplit[pc;n;x;y;f;p;h]`

Where

-   `pc` is a float between 0 and 1 denoting the percentage of data in the holdout validation set
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function that takes parameters and data as input and returns a score
-   `p` is a dictionary of hyperparameters to be searched - see section [Grid Search Hyperparameter Dictionary](#grid-search-hyperparameter-dictionary)
-   `h` is a float value denoting the size of the holdout set used in a fitted grid search, where the best model is fit to the holdout set. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the `k` folds for all values of `h` and additionally returns the best hyperparameters and score on the holdout set for `0 < h <= 1`.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yr:x[;0]+m?.05
// algo
q)rf:{.p.import[`sklearn.linear_model]`:LinearRegression}
// params
q)pr:`fit_intercept`normalize!(01b;01b)
// 20% validation set with 1 repetition, no fit on holdout
q).ml.gs.pcsplit[0.2;1;x;yr;.ml.xv.fitscore rf;pr;0]
fit_intercept normalize|
-----------------------| ---------
0             0        | 0.9971796
0             1        | 0.9971796
1             0        | 0.9974919
1             1        | 0.9974919
// 10% validation set with 3 repetitions, fit on 20% holdout set
q).ml.gs.pcsplit[0.1;3;x;yr;.ml.xv.fitscore rf;pr;.2]
(+`fit_intercept`normalize!(0011b;0101b))!(0.9972762 0.9972762 0.9972762;0.99..
`fit_intercept`normalize!10b
0.9974919
```

This form of cross validation is also known as _repeated random sub-sampling validation_. This has advantages over K-fold when observations are not wanted in equi-sized bins or where outliers could heavily bias a classifier. 

:fontawesome-brands-wikipedia-w:
[Repeated random sub-sampling validation](https://en.wikipedia.org/wiki/Cross-validation_(statistics)#Repeated_random_sub-sampling_validation)


### `.ml.gs.tschain`

_Cross-validated parameter grid search applied to chain forward time-series sets_

Syntax: `.ml.gs.tschain[k;n;x;y;f;p;h]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function that takes parameters and data as input and returns a score
-   `p` is a dictionary of hyperparameters to be searched - see section [Grid Search Hyperparameter Dictionary](#grid-search-hyperparameter-dictionary)
-   `h` is a float value denoting the size of the holdout set used in a fitted grid search, where the best model is fit to the holdout set. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the `k` folds for all values of `h` and additionally returns the best hyperparameters and score on the holdout set for `0 < h <= 1`.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yc:(raze flip(0N;4)#m#`a`b`c`d)rank x[;0]
// algos
q)cf:{.p.import[`sklearn.tree]`:DecisionTreeClassifier}
// params
q)pc:enlist[`max_depth]!enlist(::;1;2;3;4;5)
// 5 fold cross-validation no holdout
q).ml.gs.tschain[5;1;x;yc;.ml.xv.fitscore cf;pc;0]
max_depth|
---------| --------------------------
::       | 0.999  1     0.9995 1
1        | 0.4985 0.492 0.476  0.4885
2        | 0.758  0.745 0.7345 0.743
3        | 0.999  1     0.9995 1
4        | 0.999  1     0.9995 1
5        | 0.999  1     0.9995 1
// 4 fold cross-validated grid search fitted on 20% holdout set
q).ml.gs.tschain[4;1;x;yc;.ml.xv.fitscore cf;pc;.2]
(+(,`max_depth)!,(::;1;2;3;4;5))!(0.999 1 0.9995;0.4985 0.492 0.476;0.758 0.7..
(,`max_depth)!,::
1f
```

This works as shown in the following image:

![Figure 1](img/chainforward.png)

The data is split into equi-sized bins with increasing amounts of the data incorporated into the testing set at each step. This avoids testing a model on historical information which would be counter-productive for time-series forecasting. It also allows users to test the robustness of the model when passed increasing volumes of data.


### `.ml.gs.tsrolls`

_Cross-validated parameter grid search applied to roll forward time-series sets_

Syntax: `.ml.gs.tsrolls[k;n;x;y;f;p;h]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function that takes parameters and data as input and returns a score
-   `p` is a dictionary of hyperparameters to be searched - see section [Grid Search Hyperparameter Dictionary](#grid-search-hyperparameter-dictionary)
-   `h` is a float value denoting the size of the holdout set used in a fitted grid search, where the best model is fit to the holdout set. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the `k` folds for all values of `h` and additionally returns the best hyperparameters and score on the holdout set for `0 < h <= 1`.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yc:(raze flip(0N;4)#m#`a`b`c`d)rank x[;0]
// algos
q)cf:{.p.import[`sklearn.tree]`:DecisionTreeClassifier}
// params
q)pc:enlist[`max_depth]!enlist(::;1;2;3;4;5)
// 6-fold cross validation no holdout
q).ml.gs.tsrolls[6;1;x;yc;.ml.xv.fitscore cf;pc;0]
max_depth|
---------| -------------------------------------------------
::       | 0.9994001 0.9994001 1         0.9994001 0.9988002
1        | 0.4985003 0.5056989 0.5162065 0.4943011 0.4997001
2        | 0.7438512 0.7492501 1         0.7582484 0.7378524
3        | 0.9994001 0.9994001 1         0.9994001 0.9988002
4        | 0.9994001 0.9994001 1         0.9994001 0.9988002
5        | 0.9994001 0.9994001 1         0.9994001 0.9988002     
// 5 fold cross-validated grid search fitted on 20% holdout set
q).ml.gs.tsrolls[4;1;x;yc;.ml.xv.fitscore cf;pc;.2]
(+(,`max_depth)!,(::;1;2;3;4;5))!(1 0.999 0.999;0.486 0.4825 0.5005;0.7315 0...
(,`max_depth)!,::
0.999
```

This works as shown in the following image:

![Figure 2](img/rollforward.png)

Successive equi-sized bins are taken as training and validation sets at each step. This avoids testing a model on historical information which would be counter-productive for time-series forecasting.

## Random Search

Random and quasi-random search methods replace the need exhaustive searching across a hyperparameter space used by [grid-search](#grid-search) by selecting combinations of hyperparameters randomly. This random selection can take place across a discrete space as would be the case if choosing randomly from a list of possible values or over a continuous space bounded based on user input. 

Such methods commonly outperform grid search both with respect to finding the optimal parameters in particular in cases where a small number of parameters disproportionately affect the performance of the machine learning algorithm. This library contains two different implementations following the ethos of random search namely

1. Random search
	
	The completely random selection of hyperparameters across a defined continuous or discreet search space. 

2. Quasi-random sobol sequence search
	
	The selection of hyperparameters across a user defined continuous or discreet space using a quasi-random selection method based on Sobol sequences. This method ensures that the hyperparameters searched encompass a more even representation of the hyperparameter space than is the case in purely random or grid search methods. More information can be found [here](https://en.wikipedia.org/wiki/Sobol_sequence)



#### Random Search Hyperparameter Dictionary

The random and sobol searching methods follow the same syntax as grid search, with the exception of the `p` parameter. In order to perfom these two searching methods extra information is needed, where the parameter dictionary must have the format:

-   `typ` is the type of random search to perform as a symbol - `random` or `sobol`
-   `random_state` is the seed to apply during cross validation. If a null character, `(::)`, is passed the default seed, `42`, will be applied.
-   `n` is the number of hyperparameter sets to produce. 
	
	* **Note**: for sobol this number must equal $2^n$, e.g. $4$, $8$, $16$, etc.

-   `p` is a dictionary of hyperparameters to be searched which must have the following forms:

	* **Numerical:**
		
		```
		enlist[`hyperparam_name]!enlist(space_type;lower_bound;upper_bound;hp_type)
		``` 
		
		where `space_type` is `uniform` or `loguniform`, `lower_upper` and `upper_bound` are the limits of the hyperparameter space and `hp_typ` is the type to cast the hyperparameters to.

	* **Symbol:**

		```
		enlist[`hyperparam_name]!enlist(`symbol;symbols_to_search)
		``` 
		
		where `symbol` is given as the type followed by the list of possible symbol values.

	* **Boolean:**
		
		```
		enlist[`hyperparam_name]!enlist`boolean
		```
		
A practical example is provided below.
        
```q
// Example random dictionary for a Decision Tree Classifier
q)typ:`random
q)random_state:283
q)n:10
q)p:`max_depth`criterion!((`uniform;1;30;"j");(`symbol;`gini`entropy))
q)pr:`typ`random_state`n`p!(typ;random_state;n;p)
// Example sobol dictionary for an SGD Classifier
q)typ:`sobol
q)random_state:93
q)n:512  // must equal 2^n
q)prms:`average`l1_ratio`alpha!(`boolean;(`uniform;0;1;"f");(`loguniform;-5;2;"f"))
q)ps:`typ`random_state`n`p!(typ;random_state;n;p)
```
        
### `.ml.rs.kfshuff`

_Cross-validated parameter random search applied to data with shuffled split indices_

Syntax: `.ml.rs.kfshuff[k;n;x;y;f;p;h]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function that takes parameters and data as input and returns a score
-   `p` is a dictionary of hyperparameters to be searched - see section [Random Search Hyperparameter Dictionary](#random-search-hyperparameter-dictionary)
-   `h` is a float value denoting the size of the holdout set used in a fitted random or sobol search, where the best model is fit to the holdout set. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the `k` folds for all values of `h` and additionally returns the best hyperparameters and score on the holdout set for `0 < h <= 1`.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yc:(raze flip(0N;4)#m#`a`b`c`d)rank x[;0]
// algos
q)cf:{.p.import[`sklearn.tree]`:DecisionTreeClassifier}
// params
q)typ:`random
q)random_state:82
q)n:5
q)p:enlist[`max_depth]!enlist(`uniform;1;20;"j")
// random hyperparameter dictionary
q)pr:`typ`random_state`n`p!(typ;random_state;n;p)
// 6-fold cross validation no holdout
q).ml.rs.kfshuff[6;1;x;yc;.ml.xv.fitscore cf;pr;0]
max_depth|
---------| ---------------------------------------------------
9        | 0.9994001 1 0.9993998 1         1         1
12       | 1         1 1         1         0.9994001 0.9981993
19       | 0.9994001 1 0.9993998 1         1         0.9993998
5        | 0.9994001 1 0.9993998 0.9994001 1         1
7        | 1         1 0.9987995 1         1         1
// 5 fold cross-validated random search fitted on 20% holdout set
q).ml.rs.kfshuff[5;1;x;yc;.ml.xv.fitscore cf;pr;.2]
(+(,`max_depth)!,9 12 19 5 7)!(1 1 0.999375 1 0.99875;1 1 0.999375 0.999375 0..
(,`max_depth)!,5
1f
```


### `.ml.rs.kfsplit`

_Cross-validated parameter random search applied to data with ascending split indices_

Syntax: `.ml.rs.kfsplit[k;n;x;y;f;p;h]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function that takes parameters and data as input and returns a score
-   `p` is a dictionary of hyperparameters to be searched - see section [Random Search Hyperparameter Dictionary](#random-search-hyperparameter-dictionary)
-   `h` is a float value denoting the size of the holdout set used in a fitted random or sobol search, where the best model is fit to the holdout set. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the `k` folds for all values of `h` and additionally returns the best hyperparameters and score on the holdout set for `0 < h <= 1`.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yc:(raze flip(0N;4)#m#`a`b`c`d)rank x[;0]
// algos
q)cf:{.p.import[`sklearn.linear_model]`:SGDClassifier}
// params
q)typ:`sobol
q)random_state:374
q)n:8  // must equal 2^n
q)p:`average`l1_ratio`alpha!(`boolean;(`uniform;0;1;"f");(`loguniform;-5;2;"f"))
// sobol hyperparameter dictionary
q)ps:`typ`random_state`n`p!(typ;random_state;n;p)
// 4-fold cross validation no holdout
q).ml.rs.kfsplit[4;1;x;yc;.ml.xv.fitscore cf;ps;0]
average l1_ratio alpha        |
------------------------------| ---------------------------
1       0.5      0.03162278   | 0.5072 0.5148 0.512  0.4884
0       0.75     0.0005623413 | 0.7612 0.6736 0.7232 0.678
0       0.25     1.778279     | 0.506  0.5128 0.5072 0.5392
1       0.375    0.004216965  | 0.64   0.6408 0.6576 0.624
0       0.875    13.33521     | 0.2608 0.2916 0.2604 0.2544
1       0.625    7.498942e-005| 0.898  0.9032 0.9108 0.9116
1       0.125    0.2371374    | 0.5044 0.5148 0.5116 0.4888
0       0.1875   0.001539927  | 0.646  0.6788 0.6476 0.6268
// 5 fold cross-validated sobol search fitted on 20% holdout set
q).ml.rs.kfsplit[5;1;x;yc;.ml.xv.fitscore cf;ps;.2]
(+`average`l1_ratio`alpha!(10010110b;0.5 0.75 0.25 0.375 0.875 0.625 0.125 0...
`average`l1_ratio`alpha!(1b;0.625;7.498942e-005)
0.9105
// 10 fold cross-validated sobol search fitted on 10% holdout 
// with initial data shuffle
q).ml.rs.kfsplit[10;1;x;yc;.ml.xv.fitscore cf;ps;-.1]
(+`average`l1_ratio`alpha!(10010110b;0.5 0.75 0.25 0.375 0.875 0.625 0.125 0...
`average`l1_ratio`alpha!(1b;0.625;7.498942e-005)
0.894
```


### `.ml.rs.kfstrat`

_Cross-validated parameter random search applied to data with an equi-distributions of targets per fold_

Syntax: `.ml.rs.kfstrat[k;n;x;y;f;p;h]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function that takes parameters and data as input and returns a score
-   `p` is a dictionary of hyperparameters to be searched - see section [Random Search Hyperparameter Dictionary](#random-search-hyperparameter-dictionary)
-   `h` is a float value denoting the size of the holdout set used in a fitted random or sobol search, where the best model is fit to the holdout set. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the `k` folds for all values of `h` and additionally returns the best hyperparameters and score on the holdout set for `0 < h <= 1`.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yc:(raze flip(0N;4)#m#`a`b`c`d)rank x[;0]
// algos
q)cf:{.p.import[`sklearn.ensemble]`:AdaBoostClassifier}
// params
q)typ:`random
q)random_state:363
q)n:6
q)p:`n_estimators`learning_rate!((`uniform;1;2;"j");(`loguniform;-3;0;"f"));
// random hyperparameter dictionary
q)pr:`typ`random_state`n`p!(typ;random_state;n;p)
// 3-fold cross validation no holdout
q).ml.rs.kfstrat[3;1;x;yc;.ml.xv.fitscore cf;pr;0]
n_estimators learning_rate|
--------------------------| -----------------------------
1            0.1590291    | 0.5       0.4996999 0.4996999
1            0.007257519  | 0.5       0.4996999 0.5
1            0.2363748    | 0.5       0.4996999 0.5
1            0.9187224    | 0.5       0.4996999 0.4996999
1            0.01076973   | 0.4994005 0.4996999 0.5
1            0.6294208    | 0.5       0.4993998 0.4996999
// 4 fold cross-validated random search fitted on 20% holdout set
q).ml.rs.kfstrat[4;1;x;yc;.ml.xv.fitscore cf;pr;.2]
(+`n_estimators`learning_rate!(1 1 1 1 1 1;0.1590291 0.007257519 0.2363748 0...
`n_estimators`learning_rate!(1;0.007257519)
0.491
```


### `.ml.rs.mcsplit`

_Cross-validated parameter random search applied to randomly shuffled data and validated on a percentage holdout set_

Syntax: `.ml.rs.mcsplit[pc;n;x;y;f;p;h]`

Where

-   `pc` is a float between 0 and 1 denoting the percentage of data in the holdout validation set
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function that takes parameters and data as input and returns a score
-   `p` is a dictionary of hyperparameters to be searched - see section [Random Search Hyperparameter Dictionary](#random-search-hyperparameter-dictionary)
-   `h` is a float value denoting the size of the holdout set used in a fitted random or sobol search, where the best model is fit to the holdout set. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the `k` folds for all values of `h` and additionally returns the best hyperparameters and score on the holdout set for `0 < h <= 1`.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yr:x[;0]+m?.05
// algos
q)dt:{.p.import[`sklearn.tree]`:DecisionTreeRegressor}
// params
q)typ:`sobol
q)random_state:73
q)n:8  // must equal 2^n
q)p:enlist[`max_depth]!enlist(`uniform;1;20;"j")
// sobol hyperparameter dictionary
q)ps:`typ`random_state`n`p!(typ;random_state;n;p)
// 20% validation set with 5 repetitions, no fit on holdout
q).ml.rs.mcsplit[0.2;5;x;yr;.ml.xv.fitscore dt;ps;0]
max_depth|
---------| -------------------------------------------------
11       | 0.9960566 0.9958836 0.9958455 0.9959367 0.9961012
15       | 0.9952471 0.9953858 0.9950434 0.9951379 0.9951459
6        | 0.9971643 0.9972604 0.9973471 0.9971362 0.9972258
8        | 0.9969521 0.9970162 0.9970413 0.9969478 0.9969298
18       | 0.99497   0.9946913 0.9949457 0.9947844 0.9952239
13       | 0.9953671 0.9951547 0.9955295 0.9954282 0.9952482
3        | 0.9812511 0.9810006 0.9819113 0.9826636 0.9819451
5        | 0.9966442 0.996488  0.9964846 0.9965193 0.9965324
// 10% validation set with 3 repetitions, fit on 20% holdout set
q).ml.rs.mcsplit[0.1;3;x;yr;.ml.xv.fitscore dt;ps;.2]
(+(,`max_depth)!,11 15 6 8 18 13 3 5)!(0.9963612 0.9960823 0.9959418;0.995198..
(,`max_depth)!,6
0.9970801
```


### `.ml.rs.pcsplit`

_Cross-validated parameter random search applied to percentage split dataset_

Syntax: `.ml.rs.pcsplit[pc;n;x;y;f;p;h]`

Where

-   `pc` is a float between 0 and 1 denoting the percentage of data in the holdout validation set
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function that takes parameters and data as input and returns a score
-   `p` is a dictionary of hyperparameters to be searched - see section [Random Search Hyperparameter Dictionary](#random-search-hyperparameter-dictionary)
-   `h` is a float value denoting the size of the holdout set used in a fitted random or sobol search, where the best model is fit to the holdout set. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the `k` folds for all values of `h` and additionally returns the best hyperparameters and score on the holdout set for `0 < h <= 1`.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yr:x[;0]+m?.05
// algos
q)dt:{.p.import[`sklearn.tree]`:DecisionTreeRegressor}
// params
q)typ:`random
q)random_state:92
q)n:6
q)p:enlist[`max_depth]!enlist(`uniform;1;20;"j")
// random hyperparameter dictionary
q)pr:`typ`random_state`n`p!(typ;random_state;n;p)
// 20% validation set with 1 repetition, no fit on holdout
q).ml.rs.pcsplit[.2;1;x;yr;.ml.xv.fitscore dt;pr;0]
max_depth|
---------| ---------
7        | 0.9972803
1        | 0.7437862
19       | 0.9949442
17       | 0.9950088
16       | 0.9950008
11       | 0.9959856
// 10% validation set with 3 repetitions, fit on 20% holdout set
q).ml.rs.pcsplit[.1;3;x;yr;.ml.xv.fitscore dt;pr;.2]
(+(,`max_depth)!,7 1 19 17 16 11)!(0.9971323 0.9971323 0.9971323;0.7563344 0...
(,`max_depth)!,7
0.9972803
```

This form of cross validation is also known as _repeated random sub-sampling validation_. This has advantages over K-fold when observations are not wanted in equi-sized bins or where outliers could heavily bias a classifier. 

:fontawesome-brands-wikipedia-w:
[Repeated random sub-sampling validation](https://en.wikipedia.org/wiki/Cross-validation_(statistics)#Repeated_random_sub-sampling_validation)


### `.ml.rs.tschain`

_Cross-validated parameter random search applied to chain forward time-series sets_

Syntax: `.ml.rs.tschain[k;n;x;y;f;p;h]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function that takes parameters and data as input and returns a score
-   `p` is a dictionary of hyperparameters to be searched - see section [Random Search Hyperparameter Dictionary](#random-search-hyperparameter-dictionary)
-   `h` is a float value denoting the size of the holdout set used in a fitted random or sobol search, where the best model is fit to the holdout set. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the `k` folds for all values of `h` and additionally returns the best hyperparameters and score on the holdout set for `0 < h <= 1`.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yc:(raze flip(0N;4)#m#`a`b`c`d)rank x[;0]
// algos
q)cf:{.p.import[`sklearn.ensemble]`:AdaBoostClassifier}
// params
q)typ:`sobol
q)random_state:15
q)n:8  // must equal 2^n
q)p:`n_estimators`learning_rate!((`uniform;1;5;"j");(`loguniform;-3;0;"f"));
// random hyperparameter dictionary
q)ps:`typ`random_state`n`p!(typ;random_state;n;p)
// 3-fold cross validation no holdout
q).ml.rs.tschain[3;1;x;yc;.ml.xv.fitscore cf;ps;0]
n_estimators learning_rate|
--------------------------| -------------------
3            0.03162278   | 1         0.9991002
4            0.005623413  | 0.7491749 0.9991002
2            0.1778279    | 0.7344734 0.7474505
3            0.01333521   | 1         0.9991002
5            0.4216965    | 1         0.9991002
4            0.002371374  | 0.7491749 0.7420516
2            0.07498942   | 0.7344734 0.7474505
2            0.008659643  | 0.7344734 0.7474505
// 4 fold cross-validated random search fitted on 20% holdout set
q).ml.rs.tschain[4;1;x;yc;.ml.xv.fitscore cf;ps;.2]
(+`n_estimators`learning_rate!(3 4 2 3 5 4 2 2;0.03162278 0.005623413 0.17782..
`n_estimators`learning_rate!(3;0.03162278)
0.4775
```

This works as shown in the following image:

![Figure 1](img/chainforward.png)

The data is split into equi-sized bins with increasing amounts of the data incorporated into the testing set at each step. This avoids testing a model on historical information which would be counter-productive for time-series forecasting. It also allows users to test the robustness of the model when passed increasing volumes of data.


### `.ml.rs.tsrolls`

_Cross-validated parameter random search applied to roll forward time-series sets_

Syntax: `.ml.rs.tsrolls[k;n;x;y;f;p;h]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function that takes parameters and data as input and returns a score
-   `p` is a dictionary of hyperparameters to be searched - see section [Random Search Hyperparameter Dictionary](#random-search-hyperparameter-dictionary)
-   `h` is a float value denoting the size of the holdout set used in a fitted random or sobol search, where the best model is fit to the holdout set. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the `k` folds for all values of `h` and additionally returns the best hyperparameters and score on the holdout set for `0 < h <= 1`.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yc:(raze flip(0N;4)#m#`a`b`c`d)rank x[;0]
// algos
q)cf:{.p.import[`sklearn.ensemble]`:AdaBoostClassifier}
// params
q)typ:`random
q)random_state:116
q)n:7
q)p:`n_estimators`learning_rate!((`uniform;1;20;"j");(`loguniform;-3;1;"f"));
// random hyperparameter dictionary
q)pr:`typ`random_state`n`p!(typ;random_state;n;p)
// 5-fold cross validation no holdout
q).ml.rs.tsrolls[5;1;x;yc;.ml.xv.fitscore cf;pr;0]
n_estimators learning_rate|
--------------------------| -------------------------
16           0.002382789  | 0.998 0.51   0.5005 1
11           0.1853371    | 0.998 0.9995 0.9995 1
12           7.029101     | 0.998 0.757  0.7465 1
6            8.910367     | 0.998 0.51   0.7465 1
7            0.04554741   | 0.998 0.51   0.5005 1
10           0.02318011   | 0.998 0.51   0.5005 1
2            5.920482     | 0.74  0.7595 0.7465 0.735
// 6 fold cross-validated random search fitted on 20% holdout set
q).ml.rs.tsrolls[6;1;x;yc;.ml.xv.fitscore cf;pr;.2]
(+`n_estimators`learning_rate!(16 11 12 6 7 10 2;0.002382789 0.1853371 7.0291..
`n_estimators`learning_rate!(11;0.1853371)
1f
```

This works as shown in the following image:

![Figure 2](img/rollforward.png)

Successive equi-sized bins are taken as training and validation sets at each step. This avoids testing a model on historical information which would be counter-productive for time-series forecasting.


## Cross Validation

Cross-validation is a technique used to gain a statistical understanding of how well a machine learning model generalizes to independent datasets. This is used to limit overfitting and selection bias, especially when dealing with small datasets.

### `.ml.xv.kfshuff`

_K-Fold cross validation for randomized non-repeating indices_

Syntax: `.ml.xv.kfshuff[k;n;x;y;f]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function which takes data as input

returns output of `f` applied to each of the cross-validation splits.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yr:x[;0]+m?.05
q)k:5
q)n:1
q)ar:{.p.import[`sklearn.linear_model]`:LinearRegression}
q)mdlfn:.ml.xv.fitscore[ar][]
q).ml.xv.kfshuff[k;n;x;yr;mdlfn]
0.9999935 0.9999934 0.9999935 0.9999935 0.9999935
```


### `.ml.xv.kfsplit`

_K-Fold cross-validation for ascending indices split into K-folds_

Syntax: `.ml.xv.kfsplit[k;n;x;y;f]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function which takes data as input

returns output of `f` applied to each of the cross-validation splits.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yr:x[;0]+m?.05
q)k:5
q)n:1
q)ar:{.p.import[`sklearn.linear_model]`:LinearRegression}
q)mdlfn:.ml.xv.fitscore[ar][]
q).ml.xv.kfsplit[k;n;x;yr;mdlfn]
0.9953383 0.9995422 0.9985156 0.9995144 0.9952133
```


### `.ml.xv.kfstrat`

_Stratified K-Fold cross-validation with an approximately equal distribution of classes per fold_

Syntax: `.ml.xv.kfstrat[k;n;x;y;f]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function which takes data as input

returns output of `f` applied to each of the cross-validation splits.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yc:(raze flip(0N;4)#m#`a`b`c`d)rank x[;0]
q)k:5
q)n:1
q)ac:{.p.import[`sklearn.tree]`:DecisionTreeClassifier}
q)mdlfn:.ml.xv.fitscore[ac][]
q).ml.xv.kfsplit[k;n;x;yc;mdlfn]
0.9995 0.9995 0.9995 1 1
```

This is used extensively where the distribution of classes in the data is unbalanced.


### `.ml.xv.mcsplit`

_Monte-Carlo cross validation using randomized non-repeating indices_

Syntax: `.ml.xv.mcsplit[p;n;x;y;f]`

Where

-   `p` is a float between 0 and 1 representing the percentage of data within the validation set
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function which takes data as input

returns output of `f` applied to each of the cross-validation splits.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yr:x[;0]+m?.05
q)p:0.2
q)n:5
q)ar:{.p.import[`sklearn.linear_model]`:LinearRegression}
q)mdlfn:.ml.xv.fitscore[ar][]
q).ml.xv.mcsplit[p;n;x;yr;mdlfn]
0.9999905 0.9999906 0.9999905 0.9999905 0.9999905
```

This form of cross validation is also known as _repeated random sub-sampling validation_. This has advantages over k-fold when equi-sized bins of observations are not wanted or where outliers could heavily bias the classifier. 

:fontawesome-brands-wikipedia-w:
[Repeated random sub-sampling validation](https://en.wikipedia.org/wiki/Cross-validation_(statistics)#Repeated_random_sub-sampling_validation "Wikipedia")


### `.ml.xv.pcsplit`

_Percentage split cross-validation procedure_

Syntax: `.ml.xv.pcsplit[p;n;x;y;f]`

Where

-   `p` is a float between 0 and 1 representing the percentage of data within the validation set
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function which takes data as input

returns output of `f` applied to each of the cross-validation splits.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yr:x[;0]+m?.05
q)p:0.2
q)n:4
q)ar:{.p.import[`sklearn.linear_model]`:LinearRegression}
q)mdlfn:.ml.xv.fitscore[ar][]
q).ml.xv.pcsplit[p;n;x;yr;mdlfn]
0.9975171 0.9975171 0.9975171 0.9975171
```


### `.ml.xv.tschain`

_Chain-forward cross-validation procedure_

Syntax: `.ml.xv.tschain[k;n;x;y;f]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function which takes data as input

returns output of `f` applied to each of the chained iterations.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yr:x[;0]+m?.05
q)k:5
q)n:1
q)ar:{.p.import[`sklearn.linear_model]`:LinearRegression}
q)mdlfn:.ml.xv.fitscore[ar][]
q).ml.xv.tschain[k;n;x;yr;mdlfn]
0.9973771 0.9992741 0.9996898 0.9997031
```

This works as shown in the following image.

![Figure 1](img/chainforward.png)

The data is split into equi-sized bins with increasing amounts of the data incorporated in the testing set at each step. This avoids testing a model on historical information which would be counter-productive for time-series forecasting. It also allows users to test the robustness of the model with data of increasing volumes.


### `.ml.xv.tsrolls`

_Roll-forward cross-validation procedure_

Syntax: `.ml.xv.tsrolls[k;n;x;y;f]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function which takes data as input

returns output of `f` applied to each of the chained iterations.

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yc:(raze flip(0N;4)#m#`a`b`c`d)rank x[;0]
q)k:5
q)n:1
q)ac:{.p.import[`sklearn.tree]`:DecisionTreeClassifier}
q)mdlfn:.ml.xv.fitscore[ac][]
q).ml.xv.tsrolls[k;n;x;yc;mdlfn]
0.9973771 0.9995615 0.9999869 0.999965
```

This works as shown in the following image.

![Figure 2](img/rollforward.png)

Successive equi-sized bins are taken as validation and training sets for each step. This avoids testing a model on historical information which would be counter-productive for time-series forecasting.


