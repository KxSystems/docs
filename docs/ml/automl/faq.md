---
title: Frequently-asked questions for the automated machine learning | Machine Learning | kdb+ and q documentation
description: Frequently-asked questions about the automated machine learning interface/framework
author: Diane O’Donoghue
date: December 2020
keywords: embedpy, machine learning, automation, distribution, cross validation, preprocessing, ml
---
# :fontawesome-solid-share-alt: Frequently-asked questions

## How can the automated machine-learning framework be configured for distributed execution?

As seen in the [Machine-Learning Toolkit](../toolkit/index.md), procedures for the application of distributed multiprocessed cross validation, hyperparameter search, and the application of the FRESH algorithm have been implemented in kdb+. These are accessible by default within this framework as follows

Initialize your process with multiple secondary processes and an associated port.

```bash
$q -s -8 -p 4321
```
```q
q)// load the AutoML framework
q)\l automl/automl.q
q).automl.loadfile`:init.q
```

The above will now automatically distribute cross validation, hyperparameter search and the FRESH algorithm to multiple processes.

The framework used to achieve this for user-defined processes is generalizable to other use cases. To do this within this AutoML framework, complete the following steps:

1. Ensure the user-defined functions are placed within a q script accessible to your process.
2. Load the relevant script into each of the open processes. This can be achieved as follows:

```q
if[0>system"s";.ml.mproc.init[abs system"s"]enlist"system[\"l myscript.q\"]"]
```


## How can my own models be evaluated in the framework?

Within the framework you can add Sklearn, Keras, PyTorch and Theano models to be evaluated.


### Sklearn models

Sklearn models can be included by modifying the [`models.json`](ug/config.md#json-configuration-files) file:

**Step 1**
Place the new model under the appropriate dictionary key depending on the problem type (i.e - `classification` or `regression`)

**Step 2**
Add the model display name as a dictionary key within the appropriate problem type and follow the format below (an extract from `regression` models).

```json
"regression":{
  "AdaBoostRegressor":{
    "library":"sklearn",
    "module":"ensemble",
    "seed":true,
    "type":"reg",
    "apply":true
  },
  "RandomForestRegressor":{
    "library":"sklearn",
    "module":"ensemble",
    "seed":true,
    "type":"reg",
    "apply":true
   }
  }
```

To understand the above, take for example the following embedPy code:

```q
seed:42
model:.p.import[\`sklearn.ensemble][\`:AdaBoostRegressor][\`random_state pykw seed]
```

This defines a model from Python’s `sklearn` library, with the associated submodule `ensemble`, named `AdaBoostRegressor`, which can be seeded with a random state `seed` to ensure runs of the model are reproducible. If the model does not take a `random_state`, the value is set to `::`.

The following changes to the JSON file would include a Bayesian ridge regressor (not included by default).

```json
"regression":{
  "AdaBoostRegressor":{
    "library":"sklearn",
    "module":"ensemble",
    "seed":true,
    "type":"reg",
    "apply":true
  },
  "RandomForestRegressor":{
    "library":"sklearn",
    "module":"ensemble",
    "seed":true,
    "type":"reg",
    "apply":true
   },
    "BayesianRidge":{
     "library":"sklearn",
     "module":"linear_model",
     "seed":true,
     "type":"multi",
     "apply":true
 }
}
```

**Step 3**
To perform a hyperparameter search on the model, add the associated hyperparameters over which to perform the search to the [JSON](ug/config.md#json-configuration-files) files `gsHyperParameters.json` or `rsHyperParameters.json`.

If a hyperparameter search is not required, then add the model name to `.automl.utils.excludeList` within `code/utils.q`. The following is an example of the hyperparameters which could be added for the Bayesian ridge regressor using gridsearch methods. Within `gsHyperParameters.json`, add the following to the dictionary:

```json
"BayesianRidge":{
 "Parameters":{
   "n_iter":[100,200,300],
   "tol":[0.001,0.005,0.01]
 },
 "meta":{
  "typeConvert":["int","float"]
 }
}
```

:fontawesome-solid-hand-point-right:
[Structure of the JSON file](ug/config.md#grid-search-parameters)


### Keras, Torch, and Theano models

The addition of custom Keras, Torch and Theano models is slightly more involved than the procedure for scikit-learn models. The following steps demonstrate the entire procedure add a custom classification or regression model to the workflow. The examples below use a custom Torch model; follow the same structure to construct both Keras and Theano models.

**Step 1**
In folder `code/customization/models/libSupport/` are a pair of files for each model, with extensions

```txt
.p  Python code
.q  q functions for model, fit and prediction
```

**Step 2**
Define in the `.p` file any Python code used in the model. If none needed, the file can be left empty. Example `torch.p`:

```python
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

** Step 3**
When constructing the `.q` file, follow this naming convention for model, fit and prediction functions:

```txt
models.[library].[module].{model/fit/predict}
```

where `library` and `module` are defined within `models.json` and 

-   `library` is one of `keras`, `theano`, or `torch`
-   `module`  is an arbitrary name for the model

Any functions required by the Python script should also be loaded in. Ensure you define the functions in the `.automl` namespace. (This is already handled if within the `keras.q` file.) 
An example of `torch.q`:

```q
\d .automl

// @kind function
// @category models
// @fileoverview Fit a vanilla torch model to data
// @param data {dict} Training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param model {<} Model object being passed through the system (compiled)
// @return {<} Vanilla fitted torch model
models.torch.classifier.fit:{[data;model]
  optimArg:enlist[`lr]!enlist .9;
  optimizer:models.i.Adam[model[`:parameters][];pykwargs optimArg];
  criterion:models.i.neuralNet[`:BCEWithLogitsLoss][];
  dataX:models.i.numpy[models.i.npArray[data`xtrain]][`:float][];
  dataY:models.i.numpy[models.i.npArray[data`ytrain]][`:float][];
  tensorXY:models.i.tensorData[dataX;dataY];
  modelArgs:`batch_size`shuffle`num_workers!(count first data`xtrain;1b;0);
  dataLoader:models.i.dataLoader[tensorXY;pykwargs modelArgs];
  nEpochs:10|`int$(count[data`xtrain]%1000);
  models.torch.torchFit[model;optimizer;criterion;dataLoader;nEpochs] }

// @kind function
// @category models
// @fileoverview Compile a keras model for binary problems
// @param data {dict} Training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param seed  {int} Seed used for initializing the same model
// @return {<} Compiled torch models
models.torch.classifier.model:{[data;seed]
  models.torch.torchModel[count first data`xtrain;200] }

// @kind function
// @category models
// @fileoverview Predict test data values using a compiled model
//  for binary problem types
// @param data {dict} Training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param model {<} Model object being passed through the system (fitted)
// @return {bool} Predicted values for a given model
models.torch.classifier.predict:{[data;model]
  dataX:models.i.numpy[models.i.npArray[data`xtest]][`:float][];
  torchMax:last models.i.torch[`:max][model dataX;1]`;
  (.p.wrap torchMax)[`:detach][][`:numpy][][`:squeeze][]` }

// load required Python modules
models.i.torch      :.p.import[`torch           ]
models.i.npArray    :.p.import[`numpy           ]`:array
models.i.Adam       :.p.import[`torch.optim     ]`:Adam
models.i.numpy      :.p.import[`torch           ]`:from_numpy
models.i.tensorData :.p.import[`torch.utils.data]`:TensorDataset
models.i.dataLoader :.p.import[`torch.utils.data]`:DataLoader
models.i.neuralNet  :.p.import[`torch.nn]
// load in functions from torch.p
models.torch.torchFit:.p.get[`runmodel]
models.torch.torchModel:.p.get[`classifier]
```

For the fitting and predicting these models through embedPy, it is important that the feature data is a NumPy array. Omission of this conversion can cause issues. As seen above within `keras.q` this is done through applying `models.i.npArray` to the data.

??? Warning "Consistency and reproducibility"

    To ensure the behavior of the system is consistent with the framework, it is vital to follow the above instructions, particularly ensuring that models take the defined parameters as arguments and return an appropriate result. This is particularly important when defining the model, as an explicit result is required from the model.

    Seeding of these models is not guaranteed unless you define calls to functions such as `numpy.random.seed` to ensure it.

**Step 4**
Define a function `.automl.models.[library].fitScore` in the `.q` file. It is used applying cross validation during the `runModels` processing stage of the pipeline. In this phase, the model is fitted to the training data and the predictions made on the testing data returned. Arguments and results must be consistent with this example.

```q
// @kind function
// @category models
// @fileoverview Fit model on training data and score using test data
// @param data  {dict} Training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param seed  {int} Seed used for initializing the same model
// @param mname {sym} Name of the model being applied
// @return {int;float;bool} Predicted values for a model applied to data
models.torch.fitScore:{[data;seed;mname]
  dataDict:\`xtrain\`ytrain\`xtest\`ytest!raze data;
  model:get[".automl.models.torch.",string[mname],".model"][dataDict;seed];
  model:get[".automl.models.torch.",string[mname],".fit"][dataDict;model];
  get[".automl.models.torch.",string[mname],".predict"][dataDict;model] }
```

**Step 5**
Go to [models.json](ug/config.md#json-configuration-files) and include the model under the problem type `classification` or `regression`. 

Example for the classification section:

```json
"ClassTorch":{
  "library":"torch",
  "module":"classifier",
  "seed":true,
  "type":"multi",
  "apply":true
}
```

In the schema above, the values of the `library` and `module` dictionary keys define the prefix of the naming convention of the `models.torch.classifier.{model/fit/predict}` functions retrieved from `torch.q`.

The key of the dictionary `ClassTorch` is used for display and model saving.

---

:fontawesome-brands-github:
Model implementations at KxSystems/automl:
[Keras](https://github.com/KxSystems/automl/tree/master/code/customization/models/libSupport/keras.q),
[Torch](https://github.com/KxSystems/automl/tree/master/code/tests/files/torch),
[Theano](https://github.com/KxSystems/automl/tree/master/code/tests/files/theano)
