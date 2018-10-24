---
author: Samantha Gallagher
date: October 2018
keywords: categorical, clean, csv, data, embedpy, engineering, feature, kdb+, learning, log, machine, matrix, model, numerical, polynomial, python, q, split, standardize, transform
title: Machine learning – using embedPy to apply LASSO regression
---

# Cleaning and pre-processing data in kdb+




## Load data

As the data are stored in CSVs, the standard kdb+ method of
loading a CSV is used. The raw dataset has column names beginning
with numbers, which kdb+ will not allow in queries, so the
columns are renamed on loading.

```q
ct:"IISIISSSSSSSSSSSSIIIISSSSSISSSSSSSISIII"      / column types
ct,:"SSSSIIIIIIIIIISISISSISIISSSIIIIIISSSIIISSF"
train:(ct;enlist csv) 0:`: train.csv
old:`1stFlrSF`2ndFlrSF`3SsnPorch                  / old column names
new:`firFlrSF`secFlrSF`threeSsnPorch              / new column names
train:@[cols train; where cols[train] in old; :; new] xcol train
```


## Log-transform the sale price

The sale price is log-transformed to obtain a simpler relationship of
data to the sale price.

```q
update SalePrice:log SalePrice from `train
y:train.SalePrice
```


## Clean data

Cleaning the data involves several steps. First, ensure that there are
no duplicated data, and then remove outliers as [suggested by the dataset’s
author](https://www.tandfonline.com/doi/abs/10.1080/10691898.2011.11889627).

```q
q)count[train]~count exec distinct Id from train
1b
q)delete Id from `train
q)delete from `train where GrLivArea > 4000
```

Next, null data points within the features are assumed to mean that it
does not have that feature. Any `` `NA`` values are filled with `` `No`` or ``
`None``, depending on category.

```q
updateNulls:{[t]
  noneC:`Alley`MasVnrType;
  noC:`BsmtQual`BsmtCond`BsmtExposure`BsmtFinType1`BsmtFinType2`Fence`FireplaceQu;
  noC,:`GarageType`GarageFinish`GarageQual`GarageCond`MiscFeature`PoolQC;
  a:raze{y!{(?;(=;enlist`NA;y);enlist x;y)}[x;]each y}'[`None`No;(noneC;noC)];
  ![t;();0b;a]}

train:updateNulls train
```

Convert some numerical features into categorical features, such as
mapping months and sub-classes. This is done for one-hot encoding later.

```q
monthDict:(1+til 12)!`Jan`Feb`Mar`Apr`May`Jun`Jul`Aug`Sep`Oct`Nov`Dec
@[`train;`MoSold;monthDict]
subclDict:raze {enlist[x]!enlist[`$"SC",string[x]]}
  each 20 30 40 45 50 60 70 75 80 85 90 120 160 180 190
@[`train;`MSSubClass;subclDict]
```

Convert some categorical features into numerical features, such as
assigning grading to each house quality, encoding as ordered numbers.
These fields were selected for numerical conversion as their categorical
values are easily mapped intuitively, while other fields are less so.

```q
@[`train;;`None`Grvl`Pave!til 3] each `Alley`Street
quals: `BsmtCond`BsmtQual`ExterCond`ExterQual`FireplaceQu
quals,:`GarageCond`GarageQual`HeatingQC`KitchenQual
@[`train;;`No`Po`Fa`TA`Gd`Ex!til 6] each quals
@[`train;`BsmtExposure;`No`Mn`Av`Gd!til 4]
@[`train;;`No`Unf`LwQ`Rec`BLQ`ALQ`GLQ!til 7] each `BsmtFinType1`BsmtFinType2
@[`train;`Functional;`Sal`Sev`Maj2`Maj1`Mod`Min2`Min1`Typ!1+til 8]
@[`train;`LandSlope;`Sev`Mod`Gtl!1+til 3]
@[`train;`LotShape;`IR3`IR2`IR1`Reg!1+til 4]
@[`train;`PavedDrive;`N`P`Y!til 3]
@[`train;`PoolQC;`No`Fa`TA`Gd`Ex!til 5]
@[`train;`Utilities;`ELO`NoSeWa`NoSewr`AllPub!1+til 4]
```


## Feature engineering

To increase the model’s accuracy, some features are simplified and
combined based on similarities. This is done in three steps demonstrated
below.

### Simplification of existing features

Some numerical features’ scopes are reduced, and several categorical
features are mapped to become simple numerical features.

```q
ftrs:`OverallQual`OverallCond`GarageCond`GarageQual`FireplaceQu`KitchenQual
ftrs,:`HeatingQC`BsmtFinType1`BsmtFinType2`BsmtCond`BsmtQual`ExterCond`ExterQual
rng:(1+til 10)!1 1 1 2 2 2 3 3 3 3
{![`train;();0b;enlist[`$"Simpl",string[x]]!enlist (rng;x)]} each ftrs
rng:(1+til 8)!1 1 2 2 3 3 3 4
{![`train;();0b;enlist[`$"Simpl",string[x]]!enlist (rng;x)]} each `PoolQC`Functional
```


### Combination of existing features

Some of the features are very similar and can be combined into one. For
example, `Fireplaces` and `FireplaceQual` can become one overall feature
of `FireplaceScore`.

```q
gradeFuncPrd:{[t;c1;c2;cNew]![t;();0b;enlist[`$string[cNew]]!enlist (*;c1;c2)]}

combineFeat1:`OverallQual`GarageQual`ExterQual`KitchenAbvGr,
  `Fireplaces`GarageArea`PoolArea`SimplOverallQual`SimplExterQual,
  `PoolArea`GarageArea`Fireplaces`KitchenAbvGr

combineFeat2:`OverallCond`GarageCond`ExterCond`KitchenQual,
  `FireplaceQu`GarageQual`PoolQC`SimplOverallCond`SimplExterCond,
  `SimplPoolQC`SimplGarageQual`SimplFireplaceQu`SimplKitchenQual

combineFeat3:`OverallGrade`GarageGrade`ExterGrade`KitchenScore,
  `FireplaceScore`GarageScore`PoolScore`SimplOverallGrade`SimplExterGrade,
  `SimplPoolScore`SimplGarageScore`SimplFireplaceScore`SimplKitchenScore;

train:train{gradeFuncPrd[x;]. y}/flip(combineFeat1; combineFeat2; combineFeat3)

update TotalBath:BsmtFullBath+FullBath+0.5*BsmtHalfBath+HalfBath,
  AllSF:GrLivArea+TotalBsmtSF,
  AllFlrsSF:firFlrSF+secFlrSF,
  AllPorchSF:OpenPorchSF+EnclosedPorch+threeSsnPorch+ScreenPorch,
  HasMasVnr:((`BrkCmn`BrkFace`CBlock`Stone`None)!((4#1),0))[MasVnrType],
  BoughtOffPlan:((`Abnorml`Alloca`AdjLand`Family`Normal`Partial)!((5#0),1))[SaleCondition]
  from `train
```

Use correlation (`cor`) to find the features that have a positive
relationship with the sale price. These will be the most important
features relative to the sale price, as they become more prominent with
an increasing sale price.

```q
q)corr:desc raze {enlist[x]!enlist train.SalePrice cor ?[train;();();x]} 
  each exec c from meta[train] where not t="s"

q)10#`SalePrice _ corr  / Top 10 most relevant features
OverallQual     | 0.8192401
AllSF           | 0.8172716
AllFlrsSF       | 0.729421
GrLivArea       | 0.7188441
SimplOverallQual| 0.7079335
ExterQual       | 0.6809463
GarageCars      | 0.6804076
TotalBath       | 0.6729288
KitchenQual     | 0.6671735
GarageScore     | 0.6568215
```


### Polynomials on the top ten existing features

Create new polynomial features from the top ten most relevant features.
These mathematically derived features will improve the model by
increasing flexibility. Polynomial regression is used as it describes
the relationship between the data and sale price most accurately.

```q
polynom:{[t;c]
  a:raze(!).'(
    {`$string[x] ,/:("_2";"_3";"_sq")}; 
    {((^;2;x);(^;3;x);(sqrt;x))}
  )@\:/:c;
  ![t;();0b;a]}

train:polynom[train;key 10#`SalePrice _ corr]
```


## Handling categorical and numerical features separately

Split the dataset into numerical features (minus the sale price) and
categorical features.

```q
.feat.categorical:?[train;();0b;]{x!x} 
  exec c from meta[train] where t="s"

.feat.numerical:?[train;();0b;]{x!x} 
  (exec c from meta[train] where not t="s") except `SalePrice
```


### Numerical features

Fill nulls with the median value of the column:

```q
![`.feat.numerical;();0b;{x\!{(^;(med;x);x)}each x}cols .feat.numerical]
```

Outliers in the numerical features are assumed to have a skewness of
&gt;0.5. These are log-transformed to reduce their impact:

```q
skew:.p.import[`scipy.stats;`:skew] / import Python skew function
skewness:{skew[x]`}each flip .feat.numerical
@[`.feat.numerical;where abs[skewness]>0.5;{log[1+x]}]
```


### Categorical features

Create dummy features via one-hot encoding, then join with numerical
results for complete dataset.

```q
oneHot:{[pvt;t;clm]
  t:?[t;();0b;{x!x}enlist[clm]];
  prePvt:![t;();0b;`name`true!(($;enlist`;((/:;,);string[clm],"_";($:;clm)));1)];
  pvtCol:asc exec distinct name from prePvt;
  pvtTab:0^?[prePvt;();{x!x}enlist[clm];(#;`pvtCol;(!;`name;`true))];
  pvtRes:![t lj pvtTab;();0b;enlist clm];$[()~pvt;pvtRes;pvt,'pvtRes]}

train:.feat.numerical,'()oneHot[;.feat.categorical;]/cols .feat.categorical
```


## Modeling

### Splitting data

Partition the dataset into training sets and test sets by extracting
random rows. The training set will be used to fit the model, and the
test set will be used to provide an unbiased evaluation of the final
model.

```q
trainIdx:-1019?exec i from train // training indices
X_train:train[trainIdx]
yTrain:y[trainIdx]
X_test:train[(exec i from train) except trainIdx]
yTest:y[(exec i from train) except trainIdx]
```


### Standardize numerical features

Standardization is done after the partitioning of training and test sets
to apply the standard scalar independently across both. This is done to
produce more standardized coefficients from the numerical features.

```q
stdSc:{(x-avg x) % dev x}
@[`X_train;;stdSc] each cols .feat.numerical
@[`X_test;;stdSc] each cols .feat.numerical
```


## Transform kdb+ tables into Python-readable matrices

```q
xTrain:flip value flip X_train
xTest:flip value flip X_test
```


