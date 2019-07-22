---
author: Conor McCarthy
description: The toolkit contains an extensive list of commonly used metrics for the evaluating the performance of machine-learning algorithms. These cover the testing of both regression and classification results.
date: April 2019
keywords: confusion, correlation, accuracy, fscore, machine learning, ml, statistics, roc, auc, precision, logloss, cross entropy.
---
# <i class="fa fa-share-alt"></i> Metrics 


The toolkit contains an extensive list of commonly used metrics for the evaluating the performance of machine-learning algorithms. These cover the testing of both regression and classification results.

<i class="fab fa-github"></i>
[KxSystems/ml/util/metrics.q](https://github.com/KxSystems/ml/blob/master/util/metrics.q)

The following functions are those at present that are contained within the `metrics.q` file of the Machine Learning Toolkit.

```txt
Statistical analysis metrics
  .ml.accuracy      Accuracy of classification results
  .ml.classreport   Statistical information about classification results
  .ml.confdict      True/false positives and true/false negatives as dictionary
  .ml.confmat       Confusion matrix
  .ml.corrmat       Table-like correlation matrix for a simple table
  .ml.crossentropy  Categorical cross entropy
  .ml.crm           Correlation matrix
  .ml.cvm           Covariance matrix
  .ml.describe      Descriptive information about a table
  .ml.f1score       F1-score on classification results
  .ml.fbscore       Fbeta-score on classification results
  .ml.logloss       Logarithmic loss
  .ml.mae           Mean absolute error
  .ml.mape          Mean absolute percentage error
  .ml.matcorr       Matthews correlation coefficient
  .ml.mse           Mean square error
  .ml.percentile    Percentile calculation for an array
  .ml.precision     Precision of a binary classifier
  .ml.r2score       R2-score
  .ml.range         Range of values
  .ml.rmse          Root mean square error
  .ml.rmsle         Root mean square logarithmic error
  .ml.roc           X- and Y-axis values for an ROC curve
  .ml.rocaucscore   Area under an ROC curve
  .ml.sensitivity   Sensitivity of a binary classifier
  .ml.smape         Symmetric mean absolute error
  .ml.specificity   Specificity of a binary classifier
  .ml.sse           Sum squared error
  .ml.tscore        One-sample t-test score
  .ml.tscoreeq      T-test for independent samples with unequal variances
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


## `.ml.classreport`

_Statistical information about classification results_

Syntax: `.ml.classreport[x;y]`

Where

* `x` is a vector of predicted labels.
* `y` is a vector of true labels.

returns the accuracy, precision, f1 scores and the support (number of occurrences) of each class.

```q
q)n:1000
q)xr:n?5
q)yr:n?5
q).ml.classreport[xr;yr]
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
q).ml.classreport[xb;yb]
class     precision recall f1_score support
-------------------------------------------
0         0.51      0.51   0.51     496
1         0.52      0.52   0.52     504
avg/total 0.515     0.515  0.515    1000
q)xc:n?`A`B`C
q)yc:n?`A`B`C
q).ml.classreport[xc;yc]
class     precision recall f1_score support
-------------------------------------------
A         0.34      0.33   0.33     336
B         0.33      0.36   0.35     331
C         0.32      0.3    0.31     333
avg/total 0.33      0.33   0.33     1000
```


## `.ml.confdict`

_True/false positives and true/false negatives_

Syntax: `.ml.confdict[x;y;z]`

Where

-   `x` is a vector of (binary) predicted labels
-   `y` is a vector of (binary) true labels
-   `z` is an atom denoting the positive class label

returns a dictionary giving the count of true positives (tp), true negatives (tn), false positives (fp) and false negatives (fn).

```q
q).ml.confdict[100?"AB";100?"AB";"A"]   / non-numeric inputs
tn| 25
fp| 25
fn| 21
tp| 29
q).ml.confdict[100?0b;100?0b;1b]        / boolean input
tn| 25
fp| 27
fn| 26
tp| 22
q).ml.confdict[100?5;100?5;4]           / supports multiclass by converting to boolean representation
tn| 60
fp| 18
fn| 19
tp| 3
```


## `.ml.corrmat`

_Table-like correlation matrix for a simple table_

Syntax: `.ml.corrmat[x]`

Where 

-  `x` is a table of numeric values

returns a table representing a correlation matrix.

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

returns the covariance matrix.

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

Where 

-  `x` is a simple table

returns a tabular description of aggregate information (count, standard deviation, quartiles etc) for each numeric column.

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
0.44
q).ml.mae[100?5;100?5]
1.73
```


## `.ml.mape`

_Mean absolute percentage error_

Syntax: `.ml.mape[x;y]`

Where

-   `x` is a vector of predicted values
-   `y` is a vector of true values

returns the mean absolute percentage error between predicted and true values. All values must be floats.

```q
q).ml.mape[100?5.0;100?5.0]
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
q).ml.r2score[xb;yb]
-2.981791
```


## `.ml.range`

_Range of values_

Syntax: `.ml.range[x]`

Where 

-  `x` is a vector of numeric values

returns the range of its values.

```q
q).ml.range 1000?100000f
99742.37
q)show mat:(2 2#4?1f)
0.04492896 0.1786355
0.9694828  0.8964098
q).ml.range mat
0.9245539 0.7177742
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


## `.ml.smape`

_Symmetric mean absolute percentage error_

Syntax: `.ml.smape[x;y]`

Where

-   `x` is a vector of predicted values
-   `y` is a vector of true values

returns the symmetric-mean absolute percentage between predicted and true values.

```q
q).ml.smape[100?0b;100?0b]
92f
q).ml.smape[100?5;100?5]
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

!!! tip "One-sample t-score"

    Above 30 samples a one-sample t-score is not statistically significant.


## `.ml.tscoreeq`

_T-test for independent samples with equal variances and equal sample size_

Syntax: `.ml.tscoreeq[x;y]`

Where 

- `x` & `y` are independent sample sets with equal variance and sample size

returns their t-test score.

```q
q)x:10+(-.5+avg each 0N 20#1000?1f)*sqrt 20*12 / ~N(10,1)
q)y:20+(-.5+avg each 0N 20#1000?1f)*sqrt 20*12 / ~N(20,1)
q)(avg;dev)@\:/:(x;y) / check dist
9.87473  1.010691
19.84484 0.9437789
q).ml.tscoreeq[x;y]
50.46957
```
