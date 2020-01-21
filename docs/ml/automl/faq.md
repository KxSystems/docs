---
title: Frequently-asked questions and hints/tips for the automated machine learning interface - Machine Learning – kdb+ and q documentation
description: Frequently-asked questions about the automated machine learning interface/framework
keywords: embedpy, machine learning, automation, distribution, cross validation, preprocessing, ml
---
# <i class="fab fa-python"></i> Frequently-asked questions

## Can this automated machine learning framework be configured for distributed execution?

Yes. As outlined within the documentation for the machine learning toolkit [here](https://code.kx.com/q/ml/toolkit/xval/) and [here](https://code.kx.com/q/ml/toolkit/fresh/#feature-extraction), procedures for the application of distributed multiprocess cross validation and the application of the FRESH algorithm have been implemented in kdb+. These are accessible by default within this framework as follows

```q
// Initialize your process with multiple slave processes and an associated port
$q -s -8 -p 4321
// load the automl framework
q)\l automl/automl.q
q).aml.loadfile`:init.q
```

The above will now allow the application of grid search and the FRESH algorithm to be distributed to multiple processes.

It should be noted that the framework to achieve this for user defined processes is generalizable. To do this within this automl framework a user must complete the followings two steps

1. Ensure that the user defined functions are placed within a q script which is accessible to your process
2. Load the relevant script into each of the open processes, this can be achieved using the following syntax
```q
if[0>system"s";.ml.mproc.init[abs system"s"]enlist"system[\"l myscript.q\"]"]
```

## Can I add my own models to be evaluated using this framework?

Yes, within supported limits. Within the current version of this framework it is possible for a user to add sklearn models and define Keras models to be evaluated. The steps to be taken to integrate models from each of these python libraries are outlined separately here.

### Sklearn Models

The addition of sklearn models can be completed through the addition modification of a number of files within the folder `code/models`. The steps to do so are as follows;

1 - Open the file relevant to the problem type being solved, namely classification/regression i.e. `classmodels.txt`/`regmodels.txt` respectively.

2 - Add a row to the defined tabular flat file, below is a sample of a number of rows from the regression file (table header added for convenience)
```q
Model name                | library   ; sub-module    ;  seeded? ; problem type
--------------------------|-----------;---------------;----------;-------------
AdaBoostRegressor         | sklearn   ;   ensemble    ;   seed   ; reg
RandomForestRegressor     | sklearn   ;   ensemble    ;   seed   ; reg
KNeighborsRegressor       | sklearn   ;   neighbors   ;    ::    ; reg
```
To understand the above structure take for example the following embedpy code
```q
q)seed:42
q)mdl:.p.import[`sklearn.ensemble][`:AdaBoostRegressor][`random_state pykw seed]
```

This defines a model from the `sklearn` library, from the submodule `ensemble`, named `AdaBoostRegressor` which can be seeded with a random state `seed` to ensure that runs of the model can be reproducible. If the model does not take a `random_state` input this is set to `::`.

The following would be the table modified to include a Bayesian ridge regressor which is not included by default.

```q
Model name                | library   ;  sub-module    ;  seeded?  ; problem type
--------------------------|-----------;----------------;-----------;-------------
AdaBoostRegressor         | sklearn   ;   ensemble     ;   seed    ; reg
RandomForestRegressor     | sklearn   ;   ensemble     ;   seed    ; reg
KNeighborsRegressor       | sklearn   ;   neighbors    ;    ::     ; reg
BayesianRidge             | sklearn   ;  linear_model  ;    ::     ; reg
```

3 - If a grid search is to be performed on the model a user must add the hyperparameters over which to perform this to the file `code/models/hyperparams.txt`, if not then the model name must be added to `.aml.i.excludelist` within `code/utils.q`. The following is an example of the hyperparameters which could be added for the Bayesian ridge regressor

```q
BayesianRidge  |n_iter=100 200 300;tol=0.001 0.005 0.01
```

### Keras Models

The addition of custom keras models is slightly more involved than that performed for scikit-learn models. The following steps show in their entirety the steps followed to add a custom regression model named `customreg` to the workflow.

1 - Open the file `code/models/kerasmdls.q`


2 - Follow the naming convention [model-name]{mdl/fit/predict} to create function which define the model to be used, fits the model and predicts the value of the target. Ensure that the functions are defined in the root of the `.aml` namespace (this is handled if within the `kerasmdls.q` file)

```q
$vi kerasmdls.q
\d .aml
// Custom regression model
/* d = mixed list containing ((xtrn;ytrn);(ytrn;ytst))
/* s = random seed used to ensure reinitialisation consistent
/* mtype   = type of model being evaluated
/. return = a compiled keras model
customregmdl:{[d;s;mtype]
  // seed the model appropriately
  nps[s];if[not 1~checkimport[];tfs[s]];
  m:seq[];
  // define the model
  layer1_nm :`input_dim`kernel_initializer`activation;
  layer1_val:(count first d[0]0;`normal;`relu);
  m[`:add]dns[13;pykwargs layer1_nm!layer1_val];
  m[`:add]dns[1;`kernel_initializer pykw `normal];
  m[`:compile][pykwargs `loss`optimizer!`mean_squared_error`adam];
  // ensure that the model is returned separate to compilation
  m
 }

// Custom fit function
/* m = model object from customregmdl
customregfit:{[d;m]m[`:fit][npa d[0]0;d[0]1;`batch_size pykw 16;`verbose pykw 0];m}

// Custom predict function
customregpredict:{[d;m]raze m[`:predict][npa d[1]0]`}
```

!!!Warning
	To ensure that the behaviour of the system is consistent with the framework, it is vital that a user follows the above instructions in particularly ensuring that their models take as input the defined parameters and output appropriately, in particular at the model definition phase where explicit return of the model is required. Seeding of these models is not guaranteed unless a user has defined calls to functions such as `numpy.random.seed` to ensure that this is the case.

!!!Note
	For the fitting and prediction of keras models through embedPy it is important that the feature data is a numpy array, omission of this conversion can cause issues. As seen above within `kerasmdls.q` this is done through application of ```npa:.p.import[`numpy]`:array``` to the data


3 - Update the list `.aml.i.keraslist` defined at the top of the `code/models/keramdls.q` file. At present grid search procedures are **not** completed on keras models. The name of the model here must coincide with the naming convention to be used for displays to console and that defined in the next step as the "display-name"

```q
\d .aml
i.keraslist:`regkeras`multikeras`binarykeras`customregkeras
```

4 - Open the file `code/models/regmodels.txt`. This can be changed to `classmodels.txt` depending on use case and add a row associated with the new model.

```q
display-name    | model-type ; model-name ; seeded? ; problem-type
----------------|------------;------------;---------;-------------
regkeras        | keras      ; reg        ; seed    ; reg
customregkeras  | keras      ; customreg  ; seed    ; reg
```

!!!Note
	1. display-name is used for display and saving purposes, this is the name that should be added to the `.aml.i.keraslist` in order to be excluded from grid-search
	2. model-name should coincide with the naming convention used in step 1 for [model-name]{fit/...}
