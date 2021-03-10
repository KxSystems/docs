---
author: Conor McCarthy
description: The toolkit contains an extensive list of commonly used metrics for the evaluating the performance of machine-learning algorithms. These cover the testing of both regression and classification results.
date: April 2019
keywords: confusion, correlation, accuracy, fscore, machine learning, ml, statistics, roc, auc, precision, logloss, cross entropy.
---
# :fontawesome-solid-share-alt: Metrics 


<div markdown="1" class="typewriter">
.ml   **Statistical analysis metrics**
  [accuracy](#mlaccuracy)      Accuracy of classification results
  [classReport](#mlclassreport)   Statistical information about classification results
  [confDict](#mlconfdict)      True/false positives and true/false negatives as dictionary
  [confMatrix](#mlconfmatrix)    Confusion matrix
  [corrMatrix](#mlcorrmatrix)    Table-like correlation matrix for a simple table
  [crossEntropy](#mlcrossentropy)  Categorical cross entropy
  [covMatrix](#mlcovMatrix)     Covariance matrix
  [describe](#mldescribe)      Descriptive information about a table
  [fBetaScore](#mlfbetascore)    Fbeta-score on classification results
  [logLoss](#mllogloss)       Logarithmic loss
  [mae](#mlmae)           Mean absolute error
  [mape](#mlmape)          Mean absolute percentage error
  [matthewCorr](#mlmatcorr)   Matthews correlation coefficient
  [mse](#mlmse)           Mean square error
  [percentile](#mlpercentile)    Percentile calculation for an array
  [precision](#mlprecision)     Precision of a binary classifier
  [r2Score](#mlr2score)       R2-score
  [rmse](#mlrmse)          Root mean square error
  [rmsle](#mlrmsle)         Root mean square logarithmic error
  [roc](#mlroc)           X- and Y-axis values for an ROC curve
  [rocAucScore](#mlrocaucscore)   Area under an ROC curve
  [sensitivity](#mlsensitivity)   Sensitivity of a binary classifier
  [smape](#mlsmape)         Symmetric mean absolute error
  [specificity](#mlspecificity)    Specificity of a binary classifier
  [sse](#mlsse)           Sum squared error
  [tScore](#mltscore)        One-sample t-test score
  [tScoreEqual](#mltscoreeq)   T-test for independent samples with unequal variances
</div>

:fontawesome-brands-github:
[KxSystems/ml/util/metrics.q](https://github.com/KxSystems/ml/blob/master/util/metrics.q)

The toolkit contains an extensive list of commonly used metrics for evaluating the performance of machine-learning algorithms. These cover the testing of both regression and classification results.


## `.ml.accuracy`

_Accuracy of classification results_

```syntax
.ml.accuracy[pred;true]
```

Where

-   `pred` is a vector/matrix of predicted labels
-   `true` is a vector/matrix of true labels

returns the accuracy of predictions made.

```q
q).ml.accuracy[1000?0b;1000?0b] / binary classifier
0.482
q).ml.accuracy[1000?10;1000?10] / non-binary classifier
0.108
q).ml.accuracy[10 2#20?10;10 2#20?10] / support for matrices of predictions and true labels
0.3 0.1
```


## `.ml.classReport`

_Statistical information about classification results_

```syntax
.ml.classReport[pred;true]
```

Where

* `pred` is a vector of predicted labels.
* `true` is a vector of true labels.

returns the accuracy, precision, f1 scores and the support (number of occurrences) of each class.

```q
q)n:1000
q)xr:n?5
q)yr:n?5
q).ml.classReport[xr;yr]
class     precision recall f1_score support
-------------------------------------------
0         0.2       0.23   0.22     179
1         0.22      0.22   0.22     193
2         0.21      0.21   0.21     192
3         0.19      0.19   0.19     218
4         0.21      0.17   0.19     218
avg/total 0.206     0.204  0.206    1000
q)xb:n?0b
q)yb:n?0b
q).ml.classReport[xb;yb]
class     precision recall f1_score support
-------------------------------------------
0         0.51      0.51   0.51     496
1         0.52      0.52   0.52     504
avg/total 0.515     0.515  0.515    1000
q)xc:n?`A`B`C
q)yc:n?`A`B`C
q).ml.classReport[xc;yc]
class     precision recall f1_score support
-------------------------------------------
A         0.34      0.33   0.33     336
B         0.33      0.36   0.35     331
C         0.32      0.3    0.31     333
avg/total 0.33      0.33   0.33     1000
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.classreport.
    That is still callable but will be deprecated after version 3.0.


## `.ml.confDict`

_True/false positives and true/false negatives_

```syntax
.ml.confDict[pred;true;posClass]
```

Where

-   `pred` is a vector of (binary or multi-class) predicted labels
-   `true` is a vector of (binary or multi-class) true labels
-   `posClass` is an atom denoting the positive class label

returns a dictionary giving the count of true positives (tp), true negatives (tn), false positives (fp) and false negatives (fn).

```q
q).ml.confDict[100?"AB";100?"AB";"A"]  / non-numeric inputs
tn| 25
fp| 25
fn| 21
tp| 29
q).ml.confDict[100?0b;100?0b;1b]  / boolean input
tn| 25
fp| 27
fn| 26
tp| 22
q).ml.confDict[100?5;100?5;4]    / supports multiclass by converting to boolean representation
tn| 60
fp| 18
fn| 19
tp| 3
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.confdict`.
    That is still callable but will be deprecated after version 3.0.


## `.ml.confMatrix`

_Confusion matrix_

```syntax
.ml.confMatrix[pred;true]
```

Where

-   `pred` is a vector of (binary or multi-class) predicted labels
-   `true` is a vector of (binary or multi-class) true labels

returns a confusion matrix.

```q 
q).ml.confMatrix[100?"AB";100?"AB"]  / non-numeric inputs
A| 22 30
B| 22 26
q).ml.confMatrix[100?0b;100?0b]      / boolean input
0| 20 26
1| 26 28
q).ml.confMatrix[100?5;100?5]        / supports multiclass by converting to boolean representation
0| 5 6 2 2 1
1| 1 6 5 4 3
2| 3 5 2 4 4
3| 6 5 9 2 8
4| 3 5 4 2 3
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.confmat`.
    That is still callable but will be deprecated after version 3.0.


## `.ml.corrMatrix`

_Calculate the correlation of a matrix or table_

```syntax
.ml.corrMatrix data
```

Where 

-  `data`  is a sample from a distribution as a matrix or simple table

returns the covariance of the data

```q
q)tab:([]A:asc 100?1f;B:desc 100?1000f;C:100?100)
q).ml.corrMatrix tab
 | A          B          C
-| --------------------------------
A| 1          -0.9945903 -0.2273659
B| -0.9945903 1          0.2287606
C| -0.2273659 0.2287606  1
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.corrmat`.
    That is still callable but will be deprecated after version 3.0.


## `.ml.crossEntropy`

_Categorical cross entropy_

```syntax
.ml.crossEntropy[pred;prob]
```

Where

-   `pred` is a vector of indices representing class labels
-   `prob` is a list of vectors representing the probability of belonging to each class

returns the categorical cross entropy for each class.

```q
q)p%:sum each p:1000 5#5000?1f
q)g:(first idesc@)each p / good labels
q)b:(first iasc@)each p  / bad labels
q).ml.crossEntropy[g;p]
1.07453
q).ml.crossEntropy[b;p]
3.187829
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.crossentropy`.
    That is still callable but will be deprecated after version 3.0.


## `.ml.covMatrix`

_Covariance of a matrix_

```syntax
.ml.covMatrix matrix
```

Where

-  `matrix`  is a sample from a distribution

returns the covariance matrix.

```q
q)show mat:(5?10;5?10;5?10)
3 6 0 8 4
1 7 4 7 6
6 9 9 8 7
q).ml.covMatrix[mat]
7.36 4   0.04
4    5.2 1.6
0.04 1.6 1.36
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.cvm`.
    That is still callable but will be deprecated after version 3.0.


## `.ml.f1Score`

_F-1 score for classification results_

```syntax
.ml.f1Score[pred;true;posClass]
```

Where

-   `pred` is a vector of predicted labels
-   `true` is a vector of true labels
-   `posClass` is the positive class

returns the F-1 score between predicted and true values.

```q
q)xr:1000?5
q)yr:1000?5
q).ml.f1Score[xr;yr;4]
0.1980676
q)xb:1000?0b
q)yb:1000?0b
q).ml.f1Score[xb;yb;0b]
0.4655532
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.f1score`.
    That is still callable but will be deprecated after version 3.0.


## `.ml.fBetaScore`

_F-beta score for classification results_

```syntax
.ml.fBetaScore[pred;true;posClass;beta]
```

Where

-   `pred` is a vector of predicted labels
-   `true` is a vector of true labels
-   `posClass` is the positive class
-   `beta` is the value of beta

returns the F-beta score between predicted and true labels.

```q
q)xr:1000?5
q)yr:1000?5
q).ml.fBetaScore[xr;yr;4;.5]
0.2254098
q)xb:1000?0b
q)yb:1000?0b
q).ml.fBetaScore[xb;yb;1b;.5]
0.5191595
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.fbscore`.
    That is still callable but will be deprecated after version 3.0.


## `.ml.logLoss`

_Logarithmic loss_

```syntax
.ml.logLoss[pred;prob]
```

Where

-   `pred` is a vector of class labels 0/1
-   `prob` is a list of vectors representing the probability of belonging to each class

returns the total logarithmic loss.

```q
q)v:1000?2
q)g:g,'1-g:1-(.5*v)+1000?.5 / good predictions
q)b:b,'1-b:1000?.5          / bad predictions
q).ml.logLoss[v;g]
0.3005881
q).ml.logLoss[v;b]
1.032062
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.logloss`.
    That is still callable but will be deprecated after version 3.0.


## `.ml.mae`

_Mean absolute error_

```syntax
.ml.mae[pred;true]
```

Where

-   `pred` is a vector of predicted values
-   `true` is a vector of true values

returns the mean absolute error between predicted and true values.

```q
q).ml.mae[100?0b;100?0b]
0.44
q).ml.mae[100?5;100?5]
1.73
```

## `.ml.mape`

_Mean absolute percentage error_

```syntax
.ml.mape[pred;true]
```

Where

-   `pred` is a vector of predicted values
-   `true` is a vector of true values

returns the mean absolute percentage error between predicted and true values. All values must be floats.

```q
q).ml.mape[100?5.0;100?5.0]
660.9362
```


## `.ml.matthewCorr`

_Matthews-correlation coefficient_

```syntax
.ml.matthewCorr[pred;true]
```

Where

-   `pred` is a vector of predicted labels
-   `true` is a vector of the true labels

returns the Matthews-correlation coefficient between predicted and true values.

```q
q).ml.matthewCorr[100?0b;100?0b]
0.1256775
q).ml.matthewCorr[100?5;100?5]
7.880334e-06
```


!!! warning "Deprecated"

    This function was previously defined as `.ml.matcorr`.
    That is still callable but will be deprecated after version 3.0.


## `.ml.mse`

_Mean square error_

```syntax
.ml.mse[pred;true]
```

Where

-   `pred` is a vector of predicted values
-   `true` is a vector of true values

returns the mean squared error between predicted values and the true values.

```q
q).ml.mse[asc 100?1f;asc 100?1f]
0.0004801384
q).ml.mse[asc 100?1f;desc 100?1f]
0.3202164
```

## `.ml.precision`

_Precision of a binary classifier_

```syntax
.ml.precision[pred;true;posClass]
```

Where

-   `pred` is a vector of (binary) predicted values
-   `true` is a vector of (binary) true values
-   `posClass` is the binary value defined to be 'true'

returns a measure of the precision.

```q
q).ml.precision[1000?0b;1000?0b;1b]
0.5020161
q).ml.precision[1000?"AB";1000?"AB";"B"]
0.499002
```


## `.ml.r2Score`

_R2-score for regression model validation_

```syntax
.ml.r2Score[pred;true]
```

Where

-   `pred` are (continuous) predicted values
-   `true` are (continuous) true values

returns the R2-score between the `true` and predicted values. Values close to 1 indicate good prediction, while negative values indicate poor predictors of the system behavior.

```q
q)xg:asc 1000?50f           / 'good values'
q)yg:asc 1000?50f
q).ml.r2Score[xg;yg]
0.9966209
q)xb:asc 1000?50f           / 'bad values'
q)yb:desc 1000?50f
q).ml.r2Score[xb;yb]
-2.981791
```


!!! warning "Deprecated"

    This function was previously defined as `.ml.r2score`.
    That is still callable but will be deprecated after version 3.0.


## `.ml.rmse`

_Root mean squared error for regression model validation_

```syntax
.ml.rmse[pred;true]
```

Where

-   `pred` is a vector of predicted values
-   `true` is a vector of true values

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

_Root mean squared logarithmic error_

```syntax
.ml.rmsle[pred;true]
```

Where

-   `pred` is a vector of predicted values
-   `true` is a vector of true values

returns the root mean squared logarithmic error between predicted and true values.

```q
q).ml.rmsle[100?0b;100?0b]
0.5187039
q).ml.rmsle[100?5;100?5]
0.8465022
```


## `.ml.roc`

_X and Y axis values for an ROC curve_

```syntax
.ml.roc[label;prob]
```

Where

-   `label` is the label associated with a prediction
-   `prob` is the probability that a prediction belongs to the positive class

returns the coordinates of the true-positive and false-positive values associated with the ROC curve.

```q
q)v:raze reverse 50?'til[20+1]xprev\:20#1b
q)p:asc count[v]?1f
q).ml.roc[v;p]
0           0           0           0           0           ..
0.001937984 0.003875969 0.005813953 0.007751938 0.009689922 ..
```


## `.ml.rocAucScore`

_Area under an ROC curve_

```syntax
.ml.rocAucScore[x;y]
```

Where

-   `label` is the label associated with a prediction
-   `prob` is the probability that a prediction belongs to the positive class

returns the area under the ROC curve.

```q
q)v:raze reverse 50?'til[20+1]xprev\:20#1b
q)p:asc count[v]?1f
q).ml.rocAucScore[v;p]
0.8696362
```

!!! warning "Deprecated"

    This function was previously defined as `.ml.rocaucscore`.
    That is still callable but will be deprecated after version 3.0.


## `.ml.sensitivity`

_Sensitivity of a binary classifier_

```syntax
.ml.sensitivity[pred;true;posClass]
```

Where

-   `pred` is a vector of (binary) predicted values
-   `true` is a vector of (binary) true values
-   `posClass` is the binary value defined to be 'true'

returns a measure of the sensitivity.

```q
q).ml.sensitivity[1000?0b;1000?0b;1b]
0.4876033
q).ml.sensitivity[1000?`class1`class2;1000?`class1`class2;`class1]
0.5326923
```


## `.ml.smape`

_Symmetric mean absolute percentage error_

```syntax
.ml.smape[pred;true]
```

Where

-   `pred` is a vector of predicted values
-   `true` is a vector of true values

returns the symmetric mean absolute percentage error between predicted and true values.

```q
q).ml.smape[100?0b;100?0b]
92f
q).ml.smape[100?5;100?5]
105.781
```


## `.ml.specificity`

_Specificity of a binary classifier_

```syntax
.ml.specificity[pred;true;posClass]
```

Where

-   `pred` is a vector of (binary) predicted values
-   `true` is a vector of (binary) true values
-   `posClass` is the binary value defined to be 'true'

returns a measure of the specificity.

```q
q).ml.specificity[1000?0b;1000?0b;1b]
0.5426829
q).ml.specificity[1000?100 200;1000?100 200;200]
0.4676409
```


## `.ml.sse`

_Sum squared error_

```syntax
.ml.sse[pred;true]
```

Where

-   `pred` is a vector of predicted values
-   `true` is a vector of true values

returns the sum squared error between predicted and true values.

```q
q).ml.sse[asc 100?1f;asc 100?1f]
0.4833875
q).ml.sse[asc 100?1f;desc 100?1f]
32.06403
```

## `.ml.tScore`

_One-sample t-test score_

```syntax
.ml.tScore[sample;mu]
```

Where

-   `sample` is a set of samples from a distribution
-   `mu` is the population mean

returns the one sample t-score for a distribution with less than 30 samples.

```q
q)x:25?100f
q)y:15
q).ml.tScore[x;y]
7.634824
```


!!! warning "Deprecated"

    This function was previously defined as `.ml.tscore`.
    That is still callable but will be deprecated after version 3.0.


## `.ml.tScoreEqual`

_T-test for independent samples with equal variances and equal sample size_

```syntax
.ml.tScoreEqual[sample1;sample2]
```

Where 

-   `sample1` and `sample2` are independent sample sets with equal variance and sample size

returns their t-test score.

```q
q)x:10+(-.5+avg each 0N 20#1000?1f)*sqrt 20*12 / ~N(10,1)
q)y:20+(-.5+avg each 0N 20#1000?1f)*sqrt 20*12 / ~N(20,1)
q)(avg;dev)@\:/:(x;y) / check dist
9.87473  1.010691
19.84484 0.9437789
q).ml.tScoreEqual[x;y]
50.46957
```


!!! warning "Deprecated"

    This function was previously defined as `.ml.tscoreeq`.
    That is still callable but will be deprecated after version 3.0.
