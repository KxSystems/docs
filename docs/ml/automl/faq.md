---
title: Frequently-asked questions for the automated machine learning | Machine Learning | kdb+ and q documentation
description: Frequently-asked questions about the automated machine learning interface/framework
keywords: embedpy, machine learning, automation, distribution, cross validation, preprocessing, ml
---
# :fontawesome-solid-share-alt: Frequently-asked questions



## How can the automated machine-learning framework be configured for distributed execution?

As outlined within the documentation for the [Machine-Learning Toolkit](../toolkit/index.md), procedures for the application of distributed multiprocessed cross-validation, grid-search and the application of the FRESH algorithm have been implemented in kdb+. These are accessible by default within this framework as follows

```q
// Initialize your process with multiple secondary processes and an associated port
$q -s -8 -p 4321
// load the AutoML framework
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

1.  Open the file relevant to the problem type being solved, namely classification/regression i.e. `classmodels.txt`/`regmodels.txt` respectively from `code/models/models/`.

2.  Add a row to the defined tabular flat file using the same format as shown below. This is a sample of a number of rows from the regression file (table header added for convenience)

    <pre><code class="language-q">Model name                | library   ; sub-module    ;  seeded? ; problem type
    --------------------------|-----------;---------------;----------;-------------
    AdaBoostRegressor         | sklearn   ;   ensemble    ;   seed   ; reg
    RandomForestRegressor     | sklearn   ;   ensemble    ;   seed   ; reg
    KNeighborsRegressor       | sklearn   ;   neighbors   ;    ::    ; reg
    </code></pre>

    To understand the above structure take for example the following embedPy code

    <pre><code class="language-q">q)seed:42
    q)mdl:.p.import[\`sklearn.ensemble][\`:AdaBoostRegressor][\`random_state pykw seed]
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

3.  If a grid search is to be performed on the model, a user must add the model associated hyperparameters over which to perform this to the file `code/models/hyperparameters/grid_hyperparameters.txt`, if not then the model name must be added to `.automl.i.excludelist` within `code/utils.q`. The following is an example of the hyperparameters which could be added for the Bayesian ridge regressor

    <pre><code class="language-q">BayesianRidge  |n_iter=100 200 300;tol=0.001 0.005 0.01</code></pre>


### Keras Models

The addition of custom keras models is slightly more involved than that performed for scikit-learn models. The following steps show in their entirety the steps followed to add a custom regression model named `customreg` to the workflow.

1.  Open the file `code/models/lib_support/keras.q`

2.  Follow the naming convention `[model-name]{mdl/fit/predict}` to create functions which define the model to be used, fit the model to the training data and predict the value of the target. Ensure the functions are defined in the root of the `.automl` namespace (this is already handled if within the `kerasmdls.q` file)
    <pre><code class="language-q">$vi keras.q
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
      layer1_nm :\`input_dim\`kernel_initializer\`activation;
      layer1_val:(count first d[0]0;\`normal;\`relu);
      m[\`:add]dns[13;pykwargs layer1_nm!layer1_val];
      m[\`:add]dns[1;\`kernel_initializer pykw \`normal];
      m[\`:compile][pykwargs \`loss\`optimizer!\`mean_squared_error\`adam];
      // ensure that the model is returned separate to compilation
      m
     }

    // Custom fit function
    /* m = model object from customregmdl
    customregfit:{[d;m]m[\`:fit][npa d[0]0;d[0]1;\`batch_size pykw 16;\`verbose pykw 0];m}

    // Custom predict function
    customregpredict:{[d;m]raze m[\`:predict][npa d[1]0]`\$}
    </code></pre>

    * To ensure the behavior of the system is consistent with the framework, it is vital to follow the above instructions, particularly ensuring that models take as arguments the defined parameters and return an appropriate result, in particular at the model-definition phase, where explicit return of the model is required. Seeding of these models is not guaranteed unless a user has defined calls to functions such as `numpy.random.seed` to ensure that this is the case.
    * For the fitting and prediction of Keras models through embedPy, it is important that the feature data is a NumPy array. Omission of this conversion can cause issues. As seen above within `kerasmdls.q` this is done through application of `` `npa:.p.import[`numpy]`:array`` to the data.


3.  Update the list `.automl.i.keraslist` defined at the top of the `code/models/keramdls.q` file. The name of the model here must coincide with the naming convention to be used for displays to console and that defined in the next step as the `display-name`. At present grid search procedures are _not_ completed on Keras models.

    <pre><code class="language-q">\d .automl
    i.keraslist:\`regkeras\`multikeras\`binarykeras\`customregkeras</code></pre>

4.  Go to `code/models/models/` and open `regmodels.txt` or `classmodels.txt` depending on use case. Add a row associated with the new model.

	<pre><code class="language-txt">display-name    | model-type ; model-name ; seeded? ; problem-type
	----------------|------------;------------;---------;-------------
	regkeras        | keras      ; reg        ; seed    ; reg
	customregkeras  | keras      ; customreg  ; seed    ; reg
	</code></pre>


    `display-name` is used for display and saving purposes. This is the name that should be added to the `.automl.i.keraslist` in order to be excluded from grid-search.

    `model-name` should observe the naming convention used in step 1 for `[model-name]{fit/...}`.
    
### PyTorch Models

The procedure which must be followed to add a custom PyTorch model to automl follows closely that outlined for the addition of keras models above. The following steps show in their entirety the steps followed to add a custom classification model named `Pytorch` to the workflow.

1. Open the file to `classmodels.txt`/`regmodels.txt` in the folder `code/models/models/` depending on the problem type being tackled i.e. classification/regression respectively. In this example the model being added is a multi-class classification model.

2. Add a row to the definition in the flat file using the schema defined below as a guide

	<pre><code class="language-txt">display-name    | model-type ; model-name ; seeded? ; problem-type
	----------------|------------;------------;---------;-------------
	multikeras      | keras      ; multi      ; seed    ; multi
	Pytorch         | torch      ; classtorch ; seed    ; multi
	</code></pre>
	
	**Note:**
	
	* In the schema above, `classtorch`, in the 'model-name' column defines the prefix defining the `[model-name]{mdl/fit/predict}` functions which are retrieved from **pytorch.q**.
	* The 'display-name' column is used for display and model saving purposes. This is also the name that should be added to the `.automl.i.torchlist` as outlined in step 3 below. This list ensures that the PyTorch models are excluded from grid-search, functionality which is currently not supported.

3.  Within the folder `code/models/lib_support/` there are two files associated with PyTorch models - **torch.q** and **torch.p**. These files should contain the following information
	* `torch.p` = Any Python code required to define the appropriate PyTorch models.
	* `torch.q` = The q functions which define the model, fit and predict functionality for any custom PyTorch models. In addition to this the file contains a modifiable list `.automl.i.torchlist` which should be modified to include the `display-name` of the custom function as outlined in 2 above.


```python
$vi torch.p
class classifier(nn.Module):

    def __init__(self,input_dim, hidden_dim, dropout = 0.4):
        super().__init__()

        self.fc1 = nn.Linear(input_dim, hidden_dim)
        self.fc2 = nn.Linear(hidden_dim, hidden_dim)
        self.fc3 = nn.Linear(hidden_dim, 1)
        self.dropout = nn.Dropout(p = dropout)


    def forward(self,x):
        x = self.dropout(F.relu(self.fc1(x)))
        x = self.dropout(F.relu(self.fc2(x)))
        x = self.fc3(x)

        return x 

def runmodel(model,optimizer,criterion,dataloader,n_epoch):
    for epoch in range(n_epoch):
        train_loss=0
        for idx, data in enumerate(dataloader, 0):
            inputs, labels = data
            model.train()
            optimizer.zero_grad()
            outputs = model(inputs)
            loss = criterion(outputs,labels.view(-1,1))
            loss.backward()
            optimizer.step()
            train_loss += loss.item()/len(dataloader)
    return model
```

`torch.q` defined below contains q code which appropriately wraps a PyTorch model such that it can be run within the model pipeline. The following wraps the PyTorch functionality defined above into appropriately named q `model`, `fit` and `predict` functions.

```q
$vi torch.q
\d .automl

npa    :.p.import[`numpy]`:array
torch  :.p.import`torch
optim  :.p.import`torch.optim
dloader:.p.import[`torch.utils.data]`:DataLoader
.p.set[`nn;nn:.p.import`torch.nn]
.p.set[`F;.p.import`torch.nn.functional]

classtorchmdl:{[d;s;mtype]
  classifier:.p.get`classifier;
  classifier[count first d[0]0;200]
  }

classtorchpredict:{[d;m]
  d_x:torch[`:from_numpy][npa d[1]0][`:float][];
  {(.p.wrap x)[`:detach][][`:numpy][][`:squeeze][]`}last torch[`:max][m d_x;1]`
  }

classtorchfit:{[d;m]
  optimizer:optim[`:Adam][m[`:parameters][];pykwargs enlist[`lr]!enlist .9];
  criterion:nn[`:BCEWithLogitsLoss][];
  data_x:torch[`:from_numpy][npa d[0]0][`:float][];
  data_y:torch[`:from_numpy][npa d[0]1][`:float][];
  tt_xy:torch[`:utils.data][`:TensorDataset][data_x;data_y];
  mdl:.p.get`runmodel;
  pyinputs:pykwargs`batch_size`shuffle`num_workers!(count first d[0]0;1b;0);
  mdl[m;optimizer;criterion;dloader[tt_xy;pyinputs];10|`int$count[d[0]0]%1000]
  }

i.torchlist:`Pytorch
i.nnlist:i.keraslist,i.torchlist
```
