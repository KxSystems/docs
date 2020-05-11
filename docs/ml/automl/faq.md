---
title: Frequently-asked questions for the automated machine learning | Machine Learning | kdb+ and q documentation
description: Frequently-asked questions about the automated machine learning interface/framework
keywords: embedpy, machine learning, automation, distribution, cross validation, preprocessing, ml
---
# :fontawesome-solid-share-alt: Frequently-asked questions



## How can the automated machine-learning framework be configured for distributed execution?

As outlined within the documentation for the [Machine-Learning Toolkit](../toolkit/index.md), procedures for the application of distributed multiprocessed cross-validation, grid-search and the application of the FRESH algorithm have been implemented in kdb+. These are accessible by default within this framework as follows

```q
// Initialize your process with multiple slave processes and an associated port
$q -s -8 -p 4321
// load the automl framework
q)\l automl/automl.q
q).automl.loadfile`:init.q
```

The above will now automatically distribute grid-search, cross-validation and the FRESH algorithm to multiple processes.

The framework to achieve this for user-defined processes is generalizable. To do this within this AutoML framework, complete the following steps.

1. Ensure the user-defined functions are placed within a q script accessible to your process.
2. Load the relevant script into each of the open processes. This can be achieved as follows:

```q
if[0>system"s";.ml.mproc.init[abs system"s"]enlist"system[\"l myscript.q\"]"]
```


## How can my own models be evaluated using this framework?

Within the current version of this framework it is possible for a user to add Sklearn models and define Keras models to be evaluated.


### Sklearn Models

The addition of Sklearn models can be completed through the modification of a number of files within the folder `code/models`. The steps to do so are as follows.

1.  Open the file relevant to the problem type being solved, namely classification/regression i.e. `classmodels.txt`/`regmodels.txt` respectively.

2.  Add a row to the defined tabular flat file using the same format as shown below. This is a sample of a number of rows from the regression file (table header added for convenience)

    <pre><code class="language-q">Model name                | library   ; sub-module    ;  seeded? ; problem type
    --------------------------|-----------;---------------;----------;-------------
    AdaBoostRegressor         | sklearn   ;   ensemble    ;   seed   ; reg
    RandomForestRegressor     | sklearn   ;   ensemble    ;   seed   ; reg
    KNeighborsRegressor       | sklearn   ;   neighbors   ;    ::    ; reg
    </code></pre>

    To understand the above structure take for example the following embedPy code

    <pre><code class="language-q">q)seed:42
    q)mdl:.p.import[`sklearn.ensemble][`:AdaBoostRegressor][`random_state pykw seed]
    </code></pre>

    This defines a model from Python’s `sklearn` library, with the associated submodule `ensemble`, named `AdaBoostRegressor` which can be seeded with a random state `seed`, to ensure that runs of the model can be reproducible. If the model does not take a `random_state`, the input to this is set to `::`.

    The following would be the table modified to include a Bayesian ridge regressor (not included by default).

    <pre><code class="language-txt">Model name                | library   ;  sub-module    ;  seeded?  ; problem type
    --------------------------|-----------;----------------;-----------;-------------
    AdaBoostRegressor         | sklearn   ;   ensemble     ;   seed    ; reg
    RandomForestRegressor     | sklearn   ;   ensemble     ;   seed    ; reg
    KNeighborsRegressor       | sklearn   ;   neighbors    ;    ::     ; reg
    BayesianRidge             | sklearn   ;  linear_model  ;    ::     ; reg
    </code></pre>

3.  If a grid search is to be performed on the model, a user must add the model associated hyperparameters over which to perform this to the file `code/models/hyperparams.txt`, if not then the model name must be added to `.automl.i.excludelist` within `code/utils.q`. The following is an example of the hyperparameters which could be added for the Bayesian ridge regressor

    <pre><code class="language-q">BayesianRidge  |n_iter=100 200 300;tol=0.001 0.005 0.01</code></pre>


### Keras models

The addition of custom keras models is slightly more involved than that performed for scikit-learn models. The following steps show in their entirety the steps followed to add a custom regression model named `customreg` to the workflow.

1.  Open the file `code/models/kerasmdls.q`

2.  Follow the naming convention `[model-name]{mdl/fit/predict}` to create functions which define the model to be used, fit the model to the training data and predict the value of the target. Ensure the functions are defined in the root of the `.automl` namespace (this is already handled if within the `kerasmdls.q` file)

    <pre><code class="language-q">$vi kerasmdls.q
    \d .automl
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
    </code></pre>

    To ensure the behavior of the system is consistent with the framework, it is vital to follows the above instructions, particularly ensuring that models take as arguments the defined parameters and returning an appropriate result, in particular at the model-definition phase, where explicit return of the model is required. Seeding of these models is not guaranteed unless a user has defined calls to functions such as `numpy.random.seed` to ensure that this is the case.

    For the fitting and prediction of Keras models through embedPy, it is important that the feature data is a NumPy array. Omission of this conversion can cause issues. As seen above within `kerasmdls.q` this is done through application of `` `npa:.p.import[`numpy]`:array`` to the data.


3.  Update the list `.automl.i.keraslist` defined at the top of the `code/models/keramdls.q` file. The name of the model here must coincide with the naming convention to be used for displays to console and that defined in the next step as the `display-name`. At present grid search procedures are _not_ completed on Keras models.

    <pre><code class="language-q">\d .automl
    i.keraslist:`regkeras`multikeras`binarykeras`customregkeras</code></pre>

4.  Open the file `code/models/regmodels.txt` or `classmodels.txt` depending on use case and add a row associated with the new model.

    <pre><code class="language-txt">display-name    | model-type ; model-name ; seeded? ; problem-type
    ----------------|------------;------------;---------;-------------
    regkeras        | keras      ; reg        ; seed    ; reg
    customregkeras  | keras      ; customreg  ; seed    ; reg
    </code></pre>

    `display-name` is used for display and saving purposes. This is the name that should be added to the `.automl.i.keraslist` in order to be excluded from grid-search.

    `model-name` should observe the naming convention used in step 1 for `[model-name]{fit/...}`.
