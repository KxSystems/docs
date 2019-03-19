---
author: Conor McCarthy
date: March 2019
keywords: confusion, correlation, accuracy, fscore, machine learning, ml, utilities,statistics, array, kdb+, q
---

# <i class="fa fa-share-alt"></i> .ml namespace 


The `.ml` namespace contains statistical functions used commonly in machine learning along with a number of functions used for array creation and manipulation.

<i class="fab fa-github"></i>
[KxSystems/ml](https://github.com/kxsystems/ml/)

The following functions are those contained at present within the `.ml` namespace

```txt
.ml – Statistical analysis and vector creation
  .accuracy      Accuracy of classification results
  .arange        Evenly-spaced values within a range
  .confdict      True/false positives and true/false negatives as dictionary
  .confmat       Confusion matrix
  .corrmat       Table-like correlation matrix for a simple table
  .crossentropy  Categorical cross entropy
  .cvm           Covariance matrix
  .describe      Descriptive information about a table
  .eye           Identity matrix
  .f1score       F1-score on classification results
  .fbscore       Fbeta-score on classification results
  .kfshuff       K-fold non repeating indices
  .kfxval        Basic K-Fold cross-validation
  .linspace      List of evenly-spaced values
  .logloss       Logarithmic loss
  .mae           Mean absolute error
  .mape          Mean absolute percentage error
  .matcorr       Matthews correlation coefficient
  .mse           Mean square error
  .percentile    Percentile calculation for an array
  .precision     Precision of a binary classifier
  .r2score       R2-score
  .range         Range of values
  .rmse          Root mean square error
  .rmsle         Root mean square logarithmic error
  .roc           X- and Y-axis values for an ROC curve
  .rocaucscore   Area under an ROC curve
  .sensitivity   Sensitivity of a binary classifier
  .shape         Shape of a matrix
  .smape         Symmetric mean absolute error
  .specificity   Specificity of a binary classifier
  .sse           Sum squared error
  .tscore        One-sample t-test score
  .tscoreeq      T-test for independent samples with unequal variances
```

## `.ml.accuracy`

_Accuracy of classification results_

Syntax: `.ml.accuracy[x;y]`

Where

-   `x` is a vector/matrix of predicted labels
-   `y` is a vector/matrix of true labels

returns the accuracy of predictions made.

```q
q).ml.accuracy[1000?0b;1000?0b] / binary classifier
0.482
q).ml.accuracy[1000?10;1000?10] / non-binary classifier
0.108
q).ml.accuracy[10 2#20?10;10 2#20?10] / support for matrices of predictions and true labels
0.3 0.1
```


## `.ml.arange`

_Evenly-spaced values_

Syntax: `.ml.arange[x;y;z]`

Where `x`, `y`, and `z` are numeric atoms, returns a vector of evenly-spaced values between `x` (inclusive) and `y` (non-inclusive) in steps of length `z`.

```q
q).ml.arange[1;10;1]
1 2 3 4 5 6 7 8 9
q).ml.arange[6.25;10.5;0.05]
6.25 6.3 6.35 6.4 6.45 6.5 6.55 6.6 6.65 6.7 6.75 6.8 6.85 6.9 6.95 7 7.05 7...
```


## `.ml.confdict`

_True/false positives and true/false negatives_

Syntax: `.ml.confdict[x;y]`

Where

-   `x` is a vector of (binary) predicted labels
-   `y` is a vector of (binary) true labels

returns a dictionary giving the count of true positives (tp), true negatives (tn), false positives (fp) and false negatives (fn).

```q
q).ml.confdict[100?"AB";100?"AB"]
tp| 25
fn| 25
fp| 21
tn| 29
```


## `.ml.confmat`

_Confusion matrix_

Syntax: `.ml.confmat[x;y]`

Where

-   `x` is a vector of predicted labels
-   `y` is a vector of the true labels

returns a dictionary representing a confusion matrix with counts.

```q
q).ml.confmat[100?0b;100?0b] / binary classifier
0| 26 27
1| 22 25
q).ml.confmat[100?5;100?5]   / non-binary classifier
0| 5 3 4 5 2
1| 6 5 3 5 6
2| 5 6 5 2 4
3| 5 3 5 2 1
4| 3 4 6 2 3
```


## `.ml.corrmat`

_Table-like correlation matrix for a simple table_

Syntax: `.ml.corrmat[x]`

Where `x` is a table of numeric values, returns a table representing a correlation matrix.

```q
q)tab:([]A:asc 100?1f;B:desc 100?1000f;C:100?100)
q).ml.corrmat tab
 | A          B          C
-| --------------------------------
A| 1          -0.9945903 -0.2273659
B| -0.9945903 1          0.2287606
C| -0.2273659 0.2287606  1
```


## `.ml.crossentropy`

_Categorical cross entropy_

Syntax: `.ml.crossentropy[x;y]`

Where

-   `x` is a vector of indices representing class labels
-   `y` is a list of vectors representing the probability of belonging to each class

returns the categorical cross entropy for each class.

```q
q)p%:sum each p:1000 5#5000?1f
q)g:(first idesc@)each p / good labels
q)b:(first iasc@)each p  / bad labels
q).ml.crossentropy[g;p]
1.07453
q).ml.crossentropy[b;p]
3.187829
```

## `.ml.cvm`

_Covariance of a matrix_

Syntax: `.ml.cvm[x]`

Where

-  `x` is a matrix

Returns the covariance matrix

```q
q)show mat:(5?10;5?10;5?10)
3 6 0 8 4
1 7 4 7 6
6 9 9 8 7
q).ml.cvm[mat]
7.36 4   0.04
4    5.2 1.6
0.04 1.6 1.36
```


## `.ml.describe`

_Descriptive information_

Syntax: `.ml.describe[x]`

Where `x` is a simple table, returns a tabular description of aggregate information (count, standard deviation, quartiles etc) for each numeric column.

```q
q)n:1000
q)tab:([]sym:n?`4;x:n?10000f;x1:1+til n;x2:reverse til n;x3:n?100f)
q).ml.describe tab
     | x        x1       x2       x3
-----| ------------------------------------
count| 1000     1000     1000     1000
mean | 4953.491 500.5    499.5    49.77201
std  | 2890.066 288.8194 288.8194 28.91279
min  | 7.908894 1        0        0.1122762
q1   | 2491.828 250.75   249.75   24.38531
q2   | 5000.222 500.5    499.5    49.96016
q3   | 7453.287 750.25   749.25   74.98685
max  | 9994.308 1000     999      99.98165
```


## `.ml.eye`

_Identity matrix_

Syntax: `.ml.eye[x]`

Where

-  `x` is an integer atom

returns an identity matrix of height/width `x`.

```q
q).ml.eye 5
1 0 0 0 0
0 1 0 0 0
0 0 1 0 0
0 0 0 1 0
0 0 0 0 1
```


## `.ml.f1score`

_F-1 score for classification results_

Syntax: `.ml.f1score[x;y;z]`

Where

-   `x` is a vector of predicted labels
-   `y` is a vector of true labels
-   `z` is the positive class

returns the F-1 score between predicted and true values.

```q
q)xr:1000?5
q)yr:1000?5
q).ml.f1score[xr;yr;4]
0.1980676
q)xb:1000?0b
q)yb:1000?0b
q).ml.f1score[xb;yb;0b]
0.4655532
```


## `.ml.fbscore`

_F-beta score for classification results_

Syntax: `.ml.fbscore[x;y;z;b]`

Where

-   `x` is a vector of predicted labels
-   `y` is a vector of true labels
-   `z` is the positive class
-   `b` is the value of beta

returns the F-beta score between predicted and true labels.

```q
q)xr:1000?5
q)yr:1000?5
q).ml.fbscore[xr;yr;4;.5]
0.2254098
q)xb:1000?0b
q)yb:1000?0b
q).ml.fbscore[xb;yb;1b;.5]
0.5191595
```


## `.ml.kfoldx`

_K-Fold cross validation_

Syntax: `.ml.kfoldx[x;y;i;fn]`

Where

-   `x` is the data matrix
-   `y` is the target vector
-   `i` are the indices for the K-fold validation using `.ml.kfsplit`
-   `fn` is the model which is being passed to the function for cross validation

returns the cross validated score for an applied machine-learning algorithm.
```q
n:10000
q)xg:(n?100f;asc n?100f)        / 'good values' for linear regressor
q)yg:asc n?100f
q)reg:.p.import[`sklearn.linear_model][`:LinearRegression][]
q)reg1:.p.import[`sklearn.linear_model][`:SGDRegressor][]
q)reg2:.p.import[`sklearn.linear_model][`:ElasticNet][]
q)reg3:.p.import[`sklearn.neighbors][`:KNeighborsRegressor][]
q)folds:10                      / number of folds for data
q)i:.ml.kfshuff[yg;folds]
q).ml.kfoldx[xg;yg;i]each(reg;reg1;reg2;reg3)
0.9998536 -1.24663e+24 0.9998393 0.9999997
q)yb:n?100f                     / 'bad values' for linear regression
q)xb:(n?100f;n?100f)
q).ml.kfoldx[xb;yb;i]each(reg;reg1;reg2;reg3)
-0.009119423 -7.726559e+21 -0.009119348 -0.2275681
```
!!! note
        This is an aliased version of the function `.ml.xval.kfoldx` which is contained in the `.ml.xval` namespace.


## `.ml.kfshuff`

_Randomized non repeating indices for K-fold cross validation_

Syntax: `.ml.kfshuff[x;y]`

Where

-   `x` is the target vector
-   `y` is the number of 'folds' which the data is to be split into

returns randomized non repeating indices associated with each of K folds.

```q
q)yg:asc 1000?100f
q).ml.kfshuff[yg;5]
647 755 790 152 948 434 583 536 156 637 699 159 315 698 41  345 565 680 775 6..
118 402 34  601 833 877 762 703 129 294 593 634 192 939 545 98  641 266 910 4..
795 69  664 393 519 722 616 55  132 802 448 140 361 194 977 97  247 74  733 6..
633 430 346 267 102 201 123 295 487 418 606 108 154 899 398 932 994 643 944 5..
919 354 119 478 954 567 497 848 665 471 406 541 307 82  984 198 134 622 550 9..
```
!!! note
        This is an aliased version of the function `.ml.xval.kfshuff` which is contained in the `.ml.xval` namespace.


## `.ml.linspace`

_Array of evenly-spaced values_

Syntax: `.ml.linspace[x;y;z]`

Where

-   `x` and `y` are numeric atoms
-   `z` is an int atom

returns a vector of `z` evenly-spaced values between `x` (inclusive) and `y` (inclusive).

```q
q).ml.linspace[10;20;9]
10 11.25 12.5 13.75 15 16.25 17.5 18.75 20
q).ml.linspace[0.5;15.25;12]
0.5 1.840909 3.181818 4.522727 5.863636 7.204545 8.545455 9.886364 11.22727 1..
```


## `.ml.logloss`

_Logarithmic loss_

Syntax: `.ml.logloss[x;y]`

Where

-   `x` is a vector of class labels 0/1
-   `y` is a list of vectors representing the probability of belonging to each class

returns the total logarithmic loss.

```q
q)v:1000?2
q)g:g,'1-g:1-(.5*v)+1000?.5 / good predictions
q)b:b,'1-b:1000?.5          / bad predictions
q).ml.logloss[v;g]
0.3005881
q).ml.logloss[v;b]
1.032062
```


## `.ml.mae`

_Mean absolute error_

Syntax: `.ml.mae[x;y]`

Where

-   `x` is a vector of predicted values
-   `y` is a vector of true values

returns the mean absolute error between predicted and true values.

```q
q).ml.mae[100?0b;100?0b]
45f
q).ml.mae[100?5;100?5]
173f
```


## `.ml.mape`

_Mean absolute percentage error_

Syntax: `.ml.mape[x;y]`

Where

-   `x` is a vector of predicted values
-   `y` is a vector of true values

returns the mean absolute percentage error between predicted and true values. All values must be floats.

```q
q)mape[100?5.0;100?5.0]
660.9362
```


## `.ml.matcorr`

_Matthews-correlation coefficient_

Syntax: `.ml.matcorr[x;y]`

Where

-   `x` is a vector of predicted labels
-   `y` is a vector of the true labels

returns the Matthews-correlation coefficient between predicted and true values.

```q
q).ml.matcorr[100?0b;100?0b]
0.1256775
q).ml.matcorr[100?5;100?5]
7.880334e-06
```


## `.ml.mse`

_Mean square error_

Syntax: `.ml.mse[x;y]`

Where

-   `x` is a vector of predicted values
-   `y` is a vector of true values

returns the mean squared error between predicted values and the true values.

```q
q).ml.mse[asc 100?1f;asc 100?1f]
0.0004801384
q).ml.mse[asc 100?1f;desc 100?1f]
0.3202164
```
```


## `.ml.percentile`

_Percentile calculation for an array_

Syntax: `.ml.percentile[x;y]`

Where

-  `x` is a numerical array
-  `y` is the percentile of interest

returns the value below which `y` percent of the of the observations within the array are found.

```q
q).ml.percentile[10000?1f;0.2]
0.2030272
q).ml.percentile[10000?1f;0.6]
0.5916521
```


## `.ml.precision`

_Precision of a binary classifier_

Syntax: `.ml.precision[x;y;z]`

Where

-   `x` is a vector of (binary) predicted values
-   `y` is a vector of (binary) true values
-   `z` is the binary value defined to be 'true'

returns a measure of the precision.

```q
q).ml.precision[1000?0b;1000?0b;1b]
0.5020161
q).ml.precision[1000?"AB";1000?"AB";"B"]
0.499002
```


## `.ml.r2score`

_R2-score for regression model validation_

Syntax: `.ml.r2score[x;y]`

Where

-   `x` are predicted continuous values
-   `y` are true continuous values

returns the R2-score between the true and predicted values. Values close to 1 indicate good prediction, while negative values indicate poor predictors of the system behaviour.

```q
q)xg:asc 1000?50f           / 'good values'
q)yg:asc 1000?50f
q).ml.r2score[xg;yg]
0.9966209
q)xb:asc 1000?50f           / 'bad values'
q)yb:desc 1000?50f
-2.981791
```


## `.ml.range`

_Range of values_

Syntax: `.ml.range[x]`

Where `x` is a vector of numeric values, returns the range of its values.

```q
q).ml.range 1000?100000f
99742.37
q)show mat:(2 2#4?1f)
0.7717648 0.6112608
0.8042972 0.1703396
q).ml.range mat
0.06763422 0.2393768
```


## `.ml.rmse`

_Root mean squared error for regression model validation_

Syntax: `.ml.rmse[x;y]`

Where

-   `x` is a vector of predicted values
-   `y` is a vector of true values

returns the root mean squared error for a regression model between predicted and true values.

```q
q)n:10000
q)xg:asc n?100f
q)yg:asc n?100f
q).ml.rmse[xg;yg]
0.5321886
q)xb:n?100f
q).ml.rmse[xb;yg]
41.03232
```

## `.ml.rmsle`

_Root mean squared log error_

Syntax: `.ml.rmsle[x;y]`

Where

-   `x` is a vector of predicted values
-   `y` is a vector of true values

returns the root mean squared log error between predicted and true values.

```q
q).ml.rmsle[100?0b;100?0b]
0.5187039
q).ml.rmsle[100?5;100?5]
0.8465022
```


## `.ml.roc`

_X- and Y-axis values for an ROC curve_

Syntax: `.ml.roc[x;y]`

Where

-   `x` is the label associated with a prediction
-   `y` is the probability that a prediction belongs to the positive class

returns the coordinates of the true-positive and false-positive values associated with the ROC curve.

```q
q)v:raze reverse 50?'til[20+1]xprev\:20#1b
q)p:asc count[v]?1f
q).ml.roc[v;p]
0           0           0           0           0           0          0     ..
0.001937984 0.003875969 0.005813953 0.007751938 0.009689922 0.01162791 0.0135..
```


## `.ml.rocaucscore`

_Area under an ROC curve_

Syntax: `.ml.rocaucscore[x;y]`

Where

-   `x` is the label associated with a prediction
-   `y` is the probability that a prediction belongs to the positive class

returns the area under the ROC curve.

```q
q)v:raze reverse 50?'til[20+1]xprev\:20#1b
q)p:asc count[v]?1f
q).ml.rocaucscore[v;p]
0.8696362
```


## `.ml.sensitivity`

_Sensitivity of a binary classifier_

Syntax: `.ml.sensitivity[x;y;z]`

Where

-   `x` is a vector of (binary) predicted values
-   `y` is a vector of (binary) true values
-   `z` is the binary value defined to be 'true'

returns a measure of the sensitivity.

```q
q).ml.sensitivity[1000?0b;1000?0b;1b]
0.4876033
q).ml.sensitivity[1000?`class1`class2;1000?`class1`class2;`class1]
0.5326923
```


## `.ml.shape`

_Shape of a matrix_

Syntax: `.ml.shape[x]`

Where `x` is an object, returns its shape as a list of dimensions.

```q
q).ml.shape 10
`long$()
q).ml.shape enlist 10
,1
q).ml.shape til 10
,10
q).ml.shape enlist til 10
1 10
q).ml.shape 2 5#til 10
2 5
q).ml.shape 2 3 4#til 24
2 3 4
q).ml.shape ([]c1:til 10;c2:0)
10 2
```

!!! warning "Behavior of `.ml.shape` is undefined for ragged/jagged arrays."


## `.ml.smape`

_Symmetric mean absolute percentage error_

Syntax: `.ml.smape[x;y]`

Where

-   `x` is a vector of predicted values
-   `y` is a vector of true values

returns the symmetric-mean absolute percentage between predicted and true values.

```q
q)smape[100?0b;100?0b]
92f
q)smape[100?5;100?5]
105.781
```


## `.ml.specificity`

_Specificity of a binary classifier_

Syntax: `.ml.specificity[x;y;z]`

Where

-   `x` is a vector of (binary) predicted values
-   `y` is a vector of (binary) true values
-   `z` is the binary value defined to be 'true'

returns a measure of the specificity.

```q
q).ml.specificity[1000?0b;1000?0b;1b]
0.5426829
q).ml.specificity[1000?100 200;1000?100 200;200]
0.4676409
```


## `.ml.sse`

_Sum squared error_

Syntax: `.ml.mse[x;y]`

Where

-   `x` is a vector of predicted values
-   `y` is a vector of true values

returns the sum squared error between predicted and true values.

```q
q).ml.sse[asc 100?1f;asc 100?1f]
0.4833875
q).ml.sse[asc 100?1f;desc 100?1f]
32.06403
```


## `.ml.tscore`

_One-sample t-test score_

Syntax: `.ml.tscore[x;y]`

Where

-   `x` is a set of samples from a distribution
-   `y` is the population mean

returns the one sample t-score for a distribution with less than 30 samples.

```q
q)x:25?100f
q)y:15
q).ml.tscore[x;y]
7.634824
```

!!! note "Above 30 samples a one-sample t-score is not statistically significant."


## `.ml.tscoreeq`

_T-test for independent samples with equal variances and equal sample size_

Syntax: `.ml.tscoreeq[x;y]`

Where `x` and `y` are independent sample sets with equal variance and sample size, returns their t-test score.

```q
q)x:10+(-.5+avg each 0N 20#1000?1f)*sqrt 20*12 / ~N(10,1)
q)y:20+(-.5+avg each 0N 20#1000?1f)*sqrt 20*12 / ~N(20,1)
q)(avg;dev)@\:/:(x;y) / check dist
9.87473  1.010691
19.84484 0.9437789
q).ml.tscoreeq[x;y]
50.46957
```
