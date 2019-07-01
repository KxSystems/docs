---
author: Conor McCarthy
date: March 2019
keywords: time-series, cross validation, grid search, roll-forward, chain-forward, grid search fit, data splitting, stratified splitting, kdb+, q
---

# <i class="fa fa-share-alt"></i> Cross Validation Procedures 


The `.ml.xval` namespace contains a number of cross validation and grid search algorithms. These algorithms test how robust/stable a model is to changes in the volume of data or the specific subsets of data used for validation.

<i class="fab fa-github"></i>
[KxSystems/ml/xval/](https://github.com/kxsystems/ml/tree/master/xval)

The following functions are contained in the `.ml.xval` namespace

```txt
.ml.xval - Cross validation functions
  .gridsearch         Grid search returning scores based on ML-model params
  .gridsearchfit      Grid search returning score/params for best model
  .kfshuff            K-Fold cross validation with randomized indices
  .kfsplit            K-Fold cross validation with sequential indices
  .kfstrat            K-Fold cross validation with stratified indices
  .mcsplit            Monte Carlo cross validation with random split indices
  .pcsplit            Percentage split cross validation
  .tschain            Chain-forward cross validation
  .tsroll             Roll-forward cross validation
```

!!!notes
	* Within the following examples `.ml.xval.fitscore` is used extensively to fit models and return the score achieved on validation/test data. This function can be replaced by a user-defined alternative for tailored applications, for example a function to fit on training data and predict outputs for new data.
	* As of toolkit version 0.1.3, the distribution of cross validation functions is invoked at console initialization. If a process is started with `$q -s -4 -p 4321`, then the cross validation library will automatically make 4 worker processes available to execute jobs.

## `.ml.xval.gridsearch`

_Find optimal parameters for a machine-learning model through an exhaustive parameter gridsearch_

Syntax: `.ml.xval.gridsearch[x;y;f;p;d]`

Where

-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking parameters and data as input and returning a score
-   `p` is a dictionary of hyperparameters to be searched
-   `d` is a dictionary of cross validation parameters (cross validation function, number of folds, number of repetitions)

returns a dictionary, with a vector of scores associated with each of the splits, for each of the hyperparameter sets.

!!!note
	The default values of parameter d are `` `xval`n`k`test`shuffle!(.ml.xval.pcsplit;1;0.2;0.2;0b)`` modifications to these allows different cross validation procedures to be used
```q
q)m:10000
q)x:(m;10)#(m*10)?1f
// regression based target
q)yr:x[;0]+m?.05
// classification based target
q)yc:(raze flip(0N;4)#m#`a`b`c`d)rank x[;0]
q)k:5
q)n:1
// regression model
q)ar:{.p.import[`sklearn.linear_model]`:LinearRegression}
// classification model
q)ac:{.p.import[`sklearn.tree]`:DecisionTreeClassifier}
// regression using default cross validation params
q)pr:`fit_intercept`normalize!(01b;01b)
q).ml.xval.gridsearch[x;yr;.ml.xval.fitscore ar;pr][]
fit_intercept normalize|          
-----------------------| ---------
0             0        | 0.9972705
0             1        | 0.9972705
1             0        | 0.9975118
1             1        | 0.9975118
// regression using updated cross validation params
q)dr:`xval`k!(.ml.xval.kfsplit;4)
q).ml.xval.gridsearch[x;yr;.ml.xval.fitscore ar;pr;dr]
fit_intercept normalize|                                                  
-----------------------| ----------------------------------------
0             0        | 0.9972705 0.9972844 0.9971721 0.9973347
0             1        | 0.9972705 0.9972844 0.9971721 0.9973347
1             0        | 0.9975118 0.9974799 0.9974753 0.9975939
1             1        | 0.9975118 0.9974799 0.9974753 0.9975939
// classification using default cross validation params
q)pc:enlist[`max_depth]!enlist(::;1;2;3;4;5)
q).ml.xval.gridsearch[x;yc;.ml.xval.fitscore ac;pc][]
max_depth|      
---------| -----
::       | 1    
1        | 0.484
2        | 0.741
3        | 1    
4        | 1    
5        | 1  
// classification with updated cross validation params
q)dc:`xval`k!(.ml.xval.kfstrat;4)
q).ml.xval.gridsearch[x;yc;.ml.xval.fitscore ac;pc;dc]
max_depth|                                   
---------| ----------------------------
::       | 1      1      0.9985 0.9995
1        | 0.5    0.5    0.5    0.4995   
2        | 1      0.9995 0.999  1          
3        | 0.9995 1      1      0.9995 
4        | 0.999  0.999  1      1     
5        | 0.9995 0.9995 0.9995 0.9995
```


## `.ml.xval.gridsearchfit`

_Find optimal parameters for a machine-learning model through an exhaustive parameter gridsearch, and evaluate optimal model on held-out data_

Syntax: `.ml.xval.gridsearchfit[x;y;f;p;d]`

Where

-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking parameters and data as input and returning a score
-   `p` is a dictionary of hyperparameters to be searched
-   `d` is a dictionary of cross validation parameters (cross validation function, number of folds, number of repetitions, whether to shuffle for test set)

returns the optimal parameter set and the scored achieved by the optimal model on a held-out testing set.


```q
q)m:10000
q)x:(m;10)#(m*10)?1f
// regression based target
q)yr:x[;0]+m?.05
// classification based target
q)yc:(raze flip(0N;4)#m#`a`b`c`d)rank x[;0]
q)k:5
q)n:1
// regression model
q)ar:{.p.import[`sklearn.linear_model]`:LinearRegression}
// classification model
q)ac:{.p.import[`sklearn.tree]`:DecisionTreeClassifier}
// regression using default cross validation params
q)pr:`fit_intercept`normalize!(01b;01b)
q).ml.xval.gridsearchfit[x;yr;.ml.xval.fitscore ar;pr][]
`fit_intercept`normalize!10b
0.9975627
// regression using updated cross validation params
q)dr:`xval`k!(.ml.xval.kfshuff;4)
q).ml.xval.gridsearchfit[x;yr;.ml.xval.fitscore ar;pr;dr]
`fit_intercept`normalize!11b
0.9975627
// classification using default cross validation params
q)pc:enlist[`max_depth]!enlist(::;1;2;3;4;5)
q).ml.xval.gridsearchfit[x;yc;.ml.xval.fitscore ac;pc][]
(,`max_depth)!,::
1f
// classification using updated cross validation params
q)dc:`xval`k!(.ml.xval.tsroll;4)
q).ml.xval.gridsearchfit[x;yc;.ml.xval.fitscore ac;pc;dc]
(,`max_depth)!,::
1f
```


## `.ml.xval.kfshuff`

_K-Fold cross validation for randomized non-repeating indices_

Syntax: `.ml.xval.kfshuff[k;n;x;y;f]`

Where

-   `k` is the number of folds into which the data is split
-   `n` is the number of repetitions of this cross validation procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking data as input

returns output of `f` applied to each of the cross validation splits

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yr:x[;0]+m?.05
q)k:5
q)n:1
q)ar:{.p.import[`sklearn.linear_model]`:LinearRegression}
q)mdlfn:.ml.xval.fitscore[ar][]
q).ml.xval.kfshuff[k;n;x;yr;mdlfn]
0.9999935 0.9999934 0.9999935 0.9999935 0.9999935
```

## `.ml.xval.kfsplit`

_K-Fold cross validation for ascending indices split into K-folds_

Syntax: `.ml.xval.kfsplit[k;n;x;y;f]`

Where

-   `k` is the number of folds into which the data is split
-   `n` is the number of repetitions of this cross validation procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking data as input

returns output of `f` applied to each of the cross validation splits

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yr:x[;0]+m?.05
q)k:5
q)n:1
q)ar:{.p.import[`sklearn.linear_model]`:LinearRegression}
q)mdlfn:.ml.xval.fitscore[ar][]
q).ml.xval.kfsplit[k;n;x;yr;mdlfn]
0.9953383 0.9995422 0.9985156 0.9995144 0.9952133
```


## `.ml.xval.kfstrat`

_Stratified K-Fold cross validation with an approximately equal distribution of classes per fold_

Syntax: `.ml.xval.kfstrat[k;n;x;y;f]`

Where

-   `k` is the number of folds into which the data is split
-   `n` is the number of repetitions of this cross validation procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking data as input

returns output of `f` applied to each of the cross validation splits

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yc:(raze flip(0N;4)#m#`a`b`c`d)rank x[;0]
q)k:5
q)n:1
q)ac:{.p.import[`sklearn.tree]`:DecisionTreeClassifier}
q)mdlfn:.ml.xval.fitscore[ac][]
q).ml.xval.kfsplit[k;n;x;yc;mdlfn]
0.9995 0.9995 0.9995 1 1
```

!!!note
	This is used extensively in cases where the distribution of classes in the data is unbalanced.

## `.ml.xval.mcsplit`

_Monte Carlo cross validation using randomized non-repeating indices_

Syntax: `.ml.xval.mcsplit[p;n;x;y;f]`

Where

-   `p` is a float between 0 and 1 representing the percentage of data within the validation set
-   `n` is the number of repetitions of this cross validation procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking data as input

returns output of `f` applied to each of the cross validation splits

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yr:x[;0]+m?.05
q)p:0.2
q)n:5
q)ar:{.p.import[`sklearn.linear_model]`:LinearRegression}
q)mdlfn:.ml.xval.fitscore[ar][]
q).ml.xval.mcsplit[p;n;x;yr;mdlfn]
0.9999905 0.9999906 0.9999905 0.9999905 0.9999905
```

!!! note
        This form of cross validation is also known as 'repeated random sub-sampling validation'. This has advantages over K-fold when observations are not wanted in equi-sized bins or where outliers could heavily bias a classifier. More information is available [here](https://en.wikipedia.org/wiki/Cross-validation_(statistics)#Repeated_random_sub-sampling_validation).

## `.ml.xval.pcsplit`

_Percentage split cross validation procedure_

Syntax: `.ml.xval.pcsplit[p;n;x;y;f]`

Where

-   `p` is a float between 0 and 1 representing the percentage of data within the validation set
-   `n` is the number of repetitions of this cross validation procedure
-   `x` is a matrix of features
-   `y` is a vector of targets
-   `f` is a function taking data as input

returns output of `f` applied to each of the cross validation splits

```q
q)m:10000
q)x:(m;10)#(m*10)?1f
q)yr:x[;0]+m?.05
q)p:0.2
q)n:4
q)ar:{.p.import[`sklearn.linear_model]`:LinearRegression}
q)mdlfn:.ml.xval.fitscore[ar][]
q).ml.xval.pcsplit[p;n;x;yr]
0.9975171 0.9975171 0.9975171 0.9975171
```


## `.ml.xval.tschain`

_Chain-forward cross validation procedure_

Syntax: `.ml.xval.tschain[k;n;x;y;f]`

Where

-   `k` is the number of folds into which the data is split
-   `n` is the number of repetitions of this cross validation procedure
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
q)mdlfn:.ml.xval.fitscore[ar][]
q).ml.xval.tschain[k;n;x;yr;mdlfn]
0.9973771 0.9992741 0.9996898 0.9997031
```

!!! note
        This works as shown in the following image:

        ![Figure 1](img/chainforward.png)

        The data is split into equi-sized bins with increasing amounts of the data incorporated in the testing set at each step. This avoids testing a model on historical information which would be counter-productive in testing a model for time-series forecasting. It also allows the robustness of the model to increasing data volumes to be probed.


## `.ml.xval.tsroll`

_Roll-forward cross validation procedure_

Syntax: `.ml.xval.tsroll[k;n;x;y;f]`

Where

-   `k` is the number of folds into which the data is split
-   `n` is the number of repetitions of this cross validation procedure
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
q)mdlfn:.ml.xval.fitscore[ac][]
q).ml.xval.tsroll[k;n;x;yc;mdlfn]
0.9973771 0.9995615 0.9999869 0.999965
```
!!! note
        This works as shown in the following image:

        ![Figure 2](img/rollforward.png)

        Successive equi-sized bins are taken as validation and training sets for each step. This avoids testing a model on historical information which would be counter-productive in testing a model for time-series forecasting for example.
