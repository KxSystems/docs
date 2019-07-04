---
author: Conor McCarthy
date: March 2019
keywords: time-series, cross validation, grid search, roll-forward, chain-forward, grid search fit, data splitting, stratified splitting, kdb+, q
---

# <i class="fa fa-share-alt"></i> Cross Validation Procedures 


The `.ml.xv` and `.ml.gs` namespaces contain a number of functions related to cross-validation and grid-search algorithms. These algorithms test how robust/stable a model is to changes in the volume of data or the specific subsets of data used for validation.

<i class="fab fa-github"></i>
[KxSystems/ml/xval/](https://github.com/kxsystems/ml/tree/master/xval)

The following functions are those contained in the `.ml.gs` and `.ml.xv` namespaces

```txt
.ml.gs - Grid search functions
  .kfshuff            K-Fold cross-validation with randomized indices
  .kfsplit            K-Fold cross-validation with sequential indices
  .kfstrat            K-Fold cross-validation with stratified indices
  .mcsplit            Monte-Carlo cross-validation with random split indices
  .pcsplit            Percentage split cross-validation
  .tschain            Chain-forward cross-validation
  .tsrolls            Roll-forward cross-validation
.ml.xv - Cross validation functions
  .kfshuff            K-Fold cross-validation with randomized indices
  .kfsplit            K-Fold cross-validation with sequential indices
  .kfstrat            K-Fold cross-validation with stratified indices
  .mcsplit            Monte-Carlo cross-validation with random split indices
  .pcsplit            Percentage split cross-validation
  .tschain            Chain-forward cross-validation
  .tsrolls            Roll-forward cross-validation
```

!!!notes
	* Within the following examples `.ml.xv.fitscore` is used extensively to fit models and return the score achieved on validation/test data. This function can be replaced by a user-defined alternative for tailored applications, for example a function to fit on training data and predict outputs for new data.
	* As of toolkit version 0.1.3, the distribution of cross-validation functions is invoked at console initialization. If a process is started with `$q -s -4 -p 4321` and load `xval.q` into the process, then the cross-validation library will automatically make 4 worker processes available to execute jobs.

## `.ml.gs.kfshuff`

_Cross-validated parameter grid-search applied to data with shuffled split indices_

Syntax: `.ml.gs.kfshuff[k;n;x;y;f;p;h]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking parameters and data as input and returning a score
-   `p` is a dictionary of hyperparameters to be searched
-   `h` is a float value denoting the size of the holdout set used in a fitted gridsearch where the best set model is fit to holdout data. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the k folds if `h = 0` and the hyperparameters and score on holdout set for `0 < h <=1`

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
// 5 fold cross-validated grid-search fitted on 20% holdout set
q).ml.gs.kfshuff[5;1;x;yr;.ml.xv.fitscore rf;pr;0.2]
`fit_intercept`normalize!11b
0.9975171
// 10 fold cross-validated grid-search fitted on 10% holdout with initial data shuffle
q).ml.gs.kfshuff[10;1;x;yr;.ml.xv.fitscore rf;pr;-0.1]
`fit_intercept`normalize!10b
0.9975167
```

## `.ml.gs.kfsplit`

_Cross-validated parameter grid-search applied to data with ascending split indices_

Syntax: `.ml.gs.kfsplit[k;n;x;y;f;p;h]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking parameters and data as input and returning a score
-   `p` is a dictionary of hyperparameters to be searched
-   `h` is a float value denoting the size of the holdout set used in a fitted gridsearch where the best set model is fit to holdout data. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the k folds if `h = 0` and the hyperparameters and score on holdout set for `0 < h <=1`

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
---------| ----------------------------------
::       | 1      0.9995 0.9995 0.9995 1     
1        | 0.485  0.4835 0.495  0.4925 0.483 
2        | 0.7375 0.7325 0.7445 0.7435 0.7305
3        | 1      0.9995 0.9995 0.9995 1     
4        | 1      0.9995 0.9995 0.9995 1     
5        | 1      0.9995 0.9995 0.9995 1     
// 5 fold cross-validated grid-search fitted on 20% holdout set
q).ml.gs.kfsplit[5;1;x;yc;.ml.xv.fitscore cf;pc;0.2]
(,`max_depth)!,::
1f
```

## `.ml.gs.kfstrat`

_Cross-validated parameter grid-search applied to data with an equi-distributions of targets per fold_

Syntax: `.ml.gs.kfstrat[k;n;x;y;f;p;h]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking parameters and data as input and returning a score
-   `p` is a dictionary of hyperparameters to be searched
-   `h` is a float value denoting the size of the holdout set used in a fitted gridsearch where the best set model is fit to holdout data. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the k folds if `h = 0` and the hyperparameters and score on holdout set for `0 < h <=1`

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
::       | 1      1      0.999  1   1     
1        | 0.5    0.5    0.5    0.5 0.4995
2        | 0.9995 1      0.9995 1   1     
3        | 1      0.9995 1      1   1     
4        | 0.999  1      1      1   1     
5        | 0.9995 1      0.9995 1   1     
// 4 fold cross-validated grid-search fitted on 20% holdout set
q).ml.gs.kfstrat[4;1;x;yc;.ml.xv.fitscore cf;pc;0.2]
(,`max_depth)!,3
1f
q).ml.gs.kfstrat[10;1;x;yc;.ml.xv.fitscore cf;pc;-0.1]
(,`max_depth)!,4
1f
```


## `.ml.gs.mcsplit`

_Cross-validated parameter grid-search applied to randomly shuffled data and validated on a percentage holdout set_

Syntax: `.ml.gs.mcsplit[pc;n;x;y;f;p;h]`

Where

-   `pc` is a float between 0 and 1 denoting the percentage of data in the holdout validation set
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking parameters and data as input and returning a score
-   `p` is a dictionary of hyperparameters to be searched
-   `h` is a float value denoting the size of the holdout set used in a fitted gridsearch where the best set model is fit to holdout data. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the k folds if `h = 0` and the hyperparameters and score on holdout set for `0 < h <=1`

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
0             0        | 0.9973058 0.9973047 0.9972594 0.9971545 0.9972227
0             1        | 0.9972814 0.997329  0.9974201 0.9972685 0.997304 
1             0        | 0.997535  0.9975769 0.9976013 0.9975085 0.9974381
1             1        | 0.9975952 0.9974163 0.9975122 0.9974753 0.99747  
// 10% validation set with 3 repetitions, fit on 20% holdout set
q).ml.gs.mcsplit[0.1;3;x;yr;.ml.xv.fitscore rf;pr;0.2]
`fit_intercept`normalize!10b
0.9976824
```


## `.ml.gs.pcsplit`

_Cross-validated parameter grid-search applied to percentage split dataset_

Syntax: `.ml.gs.pcsplit[pc;n;x;y;f;p;h]`

Where

-   `pc` is a float between 0 and 1 denoting the percentage of data in the holdout validation set
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking parameters and data as input and returning a score
-   `p` is a dictionary of hyperparameters to be searched
-   `h` is a float value denoting the size of the holdout set used in a fitted gridsearch where the best set model is fit to holdout data. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the k folds if `h = 0` and the hyperparameters and score on holdout set for `0 < h <=1`

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
0             0        | 0.9972134
0             1        | 0.9972134
1             0        | 0.997443 
1             1        | 0.997443 
// 10% validation set with 3 repetitions, fit on 20% holdout set
q).ml.gs.pcsplit[0.1;3;x;yr;.ml.xv.fitscore rf;pr;0.2]
`fit_intercept`normalize!10b
0.997443
```

!!! note
        This form of cross-validation is also known as 'repeated random sub-sampling validation'. This has advantages over K-fold when observations are not wanted in equi-sized bins or where outliers could heavily bias a classifier. More information is available [here](https://en.wikipedia.org/wiki/Cross-validation_(statistics)#Repeated_random_sub-sampling_validation).

## `.ml.gs.tschain`

_Cross-validated parameter grid-search applied to chain forward time-series sets_

Syntax: `.ml.gs.tschain[k;n;x;y;f;p;h]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking parameters and data as input and returning a score
-   `p` is a dictionary of hyperparameters to be searched
-   `h` is a float value denoting the size of the holdout set used in a fitted gridsearch where the best set model is fit to holdout data. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the k folds if `h = 0` and the hyperparameters and score on holdout set for `0 < h <=1`

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
---------| ---------------------------
::       | 0.9995 0.9995 0.9995 1     
1        | 0.502  0.5005 0.4995 0.474 
2        | 0.7535 0.764  0.741  0.7305
3        | 0.9995 0.9995 0.9995 1     
4        | 0.9995 0.9995 0.9995 1     
5        | 0.9995 0.9995 0.9995 1     
// 4 fold cross-validated grid-search fitted on 20% holdout set
q).ml.gs.tschain[4;1;x;yc;.ml.xv.fitscore cf;pc;0.2]
(,`max_depth)!,::
1f
```

!!! note
        This works as shown in the following image:

        ![Figure 1](img/chainforward.png)

        The data is split into equi-sized bins with increasing amounts of the data incorporated in the testing set at each step. This avoids testing a model on historical information which would be counter-productive in testing a model for time-series forecasting. It also allows the robustness of the model to increasing data volumes to be probed.


## `.ml.gs.tsroll`

_Cross-validated parameter grid-search applied to roll forward time-series sets_

Syntax: `.ml.gs.tsroll[k;n;x;y;f;p;h]`

Where

-   `k` is the integer number of folds
-   `n` is the integer number of repetitions of the procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking parameters and data as input and returning a score
-   `p` is a dictionary of hyperparameters to be searched
-   `h` is a float value denoting the size of the holdout set used in a fitted gridsearch where the best set model is fit to holdout data. If 0 the function will return scores for each fold for the given hyperparameters. If negative the data will be shuffled prior to designation of the holdout set.

returns the scores for hyperparameter sets on each of the k folds if `h = 0` and the hyperparameters and score on holdout set for `0 < h <=1`

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yc:(raze flip(0N;4)#m#`a`b`c`d)rank x[;0]
// algos
q)cf:{.p.import[`sklearn.tree]`:DecisionTreeClassifier}
// params
q)pc:enlist[`max_depth]!enlist(::;1;2;3;4;5)
// 6 fold cross-validation no holdout
q).ml.gs.tsrolls[6;1;x;yc;.ml.xv.fitscore cf;pc;0]
max_depth|                                                  
---------| -------------------------------------------------
::       | 0.9988002 1         0.9993998 1         0.9994001
1        | 0.4961008 0.4961008 0.4879952 0.5164967 0.4919016
2        | 0.7492501 0.7420516 0.7545018 0.7654469 0.7456509
3        | 0.9988002 1         0.9993998 1         0.9994001
4        | 0.9988002 1         0.9993998 1         0.9994001
5        | 0.9988002 1         0.9993998 1         0.9994001
// 5 fold cross-validated grid-search fitted on 20% holdout set
q).ml.gs.tsrolls[4;1;x;yc;.ml.xv.fitscore cf;pc;0.2]
(,`max_depth)!,::
0.9995
```

!!! note
        This works as shown in the following image:

        ![Figure 2](img/rollforward.png)

        Successive equi-sized bins are taken as validation and training sets for each step. This avoids testing a model on historical information which would be counter-productive in testing a model for time-series forecasting for example.

## `.ml.xv.kfshuff`

_K-Fold cross-validation for randomized non-repeating indices_

Syntax: `.ml.xv.kfshuff[k;n;x;y;f]`

Where

-   `k` is the number of folds into which the data is split
-   `n` is the number of repetitions of this cross-validation procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking data as input

returns output of `f` applied to each of the cross-validation splits

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

## `.ml.xv.kfsplit`

_K-Fold cross-validation for ascending indices split into K-folds_

Syntax: `.ml.xv.kfsplit[k;n;x;y;f]`

Where

-   `k` is the number of folds into which the data is split
-   `n` is the number of repetitions of this cross-validation procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking data as input

returns output of `f` applied to each of the cross-validation splits

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


## `.ml.xv.kfstrat`

_Stratified K-Fold cross-validation with an approximately equal distribution of classes per fold_

Syntax: `.ml.xv.kfstrat[k;n;x;y;f]`

Where

-   `k` is the number of folds into which the data is split
-   `n` is the number of repetitions of this cross-validation procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking data as input

returns output of `f` applied to each of the cross-validation splits

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

!!!note
	This is used extensively in cases where the distribution of classes in the data is unbalanced.

## `.ml.xv.mcsplit`

_Monte Carlo cross-validation using randomized non-repeating indices_

Syntax: `.ml.xv.mcsplit[p;n;x;y;f]`

Where

-   `p` is a float between 0 and 1 representing the percentage of data within the validation set
-   `n` is the number of repetitions of this cross-validation procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking data as input

returns output of `f` applied to each of the cross-validation splits

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

!!! note
        This form of cross-validation is also known as 'repeated random sub-sampling validation'. This has advantages over K-fold when observations are not wanted in equi-sized bins or where outliers could heavily bias a classifier. More information is available [here](https://en.wikipedia.org/wiki/Cross-validation_(statistics)#Repeated_random_sub-sampling_validation).

## `.ml.xv.pcsplit`

_Percentage split cross-validation procedure_

Syntax: `.ml.xv.pcsplit[p;n;x;y;f]`

Where

-   `p` is a float between 0 and 1 representing the percentage of data within the validation set
-   `n` is the number of repetitions of this cross-validation procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking data as input

returns output of `f` applied to each of the cross-validation splits

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


## `.ml.xv.tschain`

_Chain-forward cross-validation procedure_

Syntax: `.ml.xv.tschain[k;n;x;y;f]`

Where

-   `k` is the number of folds into which the data is split
-   `n` is the number of repetitions of this cross-validation procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking data as input

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

!!! note
        This works as shown in the following image:

        ![Figure 1](img/chainforward.png)

        The data is split into equi-sized bins with increasing amounts of the data incorporated in the testing set at each step. This avoids testing a model on historical information which would be counter-productive in testing a model for time-series forecasting. It also allows the robustness of the model to increasing data volumes to be probed.


## `.ml.xv.tsrolls`

_Roll-forward cross-validation procedure_

Syntax: `.ml.xv.tsrolls[k;n;x;y;f]`

Where

-   `k` is the number of folds into which the data is split
-   `n` is the number of repetitions of this cross-validation procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking data as input

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
!!! note
        This works as shown in the following image:

        ![Figure 2](img/rollforward.png)

        Successive equi-sized bins are taken as validation and training sets for each step. This avoids testing a model on historical information which would be counter-productive in testing a model for time-series forecasting for example.
