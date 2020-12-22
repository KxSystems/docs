---
title: Frequently-asked questions for the automated machine learning | Machine Learning | kdb+ and q documentation
description: Frequently-asked questions about the automated machine learning interface/framework
author: Diane O'Donoghue
date: December 2020
keywords: embedpy, machine learning, automation, distribution, cross validation, preprocessing, ml
---
# :fontawesome-solid-share-alt: Frequently-asked questions

## How can the automated machine learning framework be configured for distributed execution?

As outlined within the documentation for the [Machine-Learning Toolkit](../toolkit/index.md), procedures for the application of distributed multiprocessed cross validation, hyperparameter search and the application of the FRESH algorithm have been implemented in kdb+. These are accessible by default within this framework as follows

<pre><code class="language-q">
// Initialize your process with multiple secondary processes and an associated port
$q -s -8 -p 4321

// load the AutoML framework
q)\l automl/automl.q
q).automl.loadfile`:init.q
</code></pre>

The above will now automatically distribute cross validation, hyperparameter search and the FRESH algorithm to multiple processes.

The framework used to achieve this for user-defined processes is generalizable to other use cases. To do this within this AutoML framework, complete the following steps:

1. Ensure the user-defined functions are placed within a q script accessible to your process.
2. Load the relevant script into each of the open processes. This can be achieved as follows:

<pre><code class="language-q">
if[0>system"s";.ml.mproc.init[abs system"s"]enlist"system[\"l myscript.q\"]"]
</code></pre>

## How can my own models be evaluated using this framework?

Within the current version of this framework it is possible for a user to add Sklearn, Keras, PyTorch and Theano models to be evaluated.

### Sklearn Models

The addition of Sklearn models can be completed through the modification of the `models.json` file found within `code/customization/models/modelConfig/`. The steps to do so are as follows.

1.  Within the JSON file, place the new model under the appropriate dictionary key depending on the problem type (i.e - `classification` or `regression`)

2.  Add the model display name as a dictionary key within the appropriate problem type and follow the same format as below. This is a sample of a subset of `regression` models. 

    <pre><code class="language-json">"regression":{
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
      }</code></pre>

    To understand the above structure, take for example the following embedPy code:

    <pre><code class="language-q">q)seed:42
    q)model:.p.import[\`sklearn.ensemble][\`:AdaBoostRegressor][\`random_state pykw seed]
    
    </code></pre>

    This defines a model from Python’s `sklearn` library, with the associated submodule `ensemble`, named `AdaBoostRegressor` which can be seeded with a random state `seed`, to ensure that runs of the model can be reproducible. If the model does not take a `random_state`, the input to this is set to `::`.

    The following would be the table modified to include a Bayesian ridge regressor (not included by default).
    
    <pre><code class="language-json">"regression":{
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
    }</code></pre>


3.  If a hyperparameter search is to be performed on the model, a user must add the model's associated hyperparameters over which to perform the search to the JSON files `gsHyperParameters.json` or `rsHyperParameters.json` contained within `code/customization/hyperParameters/`. If a hypperparameter search is not required, then the model name must be added to `.automl.utils.excludeList` within `code/utils.q`. The following is an example of the hyperparameters which could be added for the Bayesian ridge regressor using grid search methods. Within `gsHyperParameters`, add the following key to the dictionary:

    <pre><code class="language-q">"BayesianRidge":{
     "Parameters":{
       "n_iter":[100,200,300],
       "tol":[0.001,0.005,0.01]
     },
     "meta":{
      "typeConvert":["int","float"]
     }
    }</code></pre>

    * The hyperparameters to perform the search over along with their associated values are contained within the `Parameters` key, and the type of each hyperparameter is contained under `typeConvert` within `meta`.


### Keras, Torch, Theano Models

The addition of custom Keras, Torch and Theano models are slightly more involved than that performed for scikit-learn models. The following steps demonstrate in their entirety the procedures taken to add a custom classification or regression model to the workflow. The examples displayed below will use a custom Torch model, but the same structure can also be followed to construct both Keras and Theano models.

1.   Within the folder `code/customization/models/libSupport/` there are two files associated with each model - **[keras/torch/theano].q** and **[keras/torch/theano].p**. These files should contain the following information
    * `.p` = Any Python code required to define the appropriate model.
    * `.q` = The q functions which define the model, fit and predict functionality for any custom model.

2.   If the model uses any python code it can be defined in the `.p` file. If no python code is needed, then this file can be left empty. An example of `torch.p` is defined below. 

    <pre><code class="language-python">$vi torch.p
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
        return model</code></pre>


3.   When constructing the `.q` file, the following naming convention is used `models.[library].[module].{model/fit/predict}` to create functions which define the model to be used, fit the model to the training data and predict the value of the target. The `[library].[module]` part of the namespace are defined within the dictionaries found in `models.json`, which will be explained in detail below. Any functions defined within the associated python script are also loaded in. Ensure the functions are defined in the root of the `.automl` namespace (this is already handled if within the `keras.q` file). Below is an example of `torch.q`.
    <pre><code class="language-q">$vi torch.q

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
      models.torch.torchFit[model;optimizer;criterion;dataLoader;nEpochs]
      }

    // @kind function
    // @category models
    // @fileoverview Compile a keras model for binary problems
    // @param data {dict} Training and testing data according to keys
    //   `xtrn`ytrn`xtst`ytst
    // @param seed  {int} Seed used for initialising the same model
    // @return {<} Compiled torch models
    models.torch.classifier.model:{[data;seed]
      models.torch.torchModel[count first data`xtrain;200]
      }

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
      (.p.wrap torchMax)[`:detach][][`:numpy][][`:squeeze][]`
      }

    // load required python modules
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
    </code></pre>

    To ensure the behavior of the system is consistent with the framework, it is vital to follow the above instructions, particularly ensuring that models take as arguments the defined parameters and return an appropriate result, in particular at the model-definition phase, where explicit return of the model is required. Seeding of these models is not guaranteed unless a user has defined calls to functions such as `numpy.random.seed` to ensure that this is the case.

    For the fitting and predicting these models through embedPy, it is important that the feature data is a NumPy array. Omission of this conversion can cause issues. As seen above within `keras.q` this is done through application of `` models.i.npArray`` to the data.


4.     Another function called `models.[library].fitScore` must be defined within the `.q` file. This function is used when applying cross validation during the `runModels` processing stage of the pipeline in which the model is fitted on the training data and the predictions made on the testing data is returned. The arguments and outputs to the model must be consistent with the below example.
    <pre><code class="language-q">// @kind function
    // @category models
    // @fileoverview Fit model on training data and score using test data
    // @param data  {dict} Training and testing data according to keys
    //   `xtrn`ytrn`xtst`ytst
    // @param seed  {int} Seed used for initialising the same model
    // @param mname {sym} Name of the model being applied
    // @return {int;float;bool} Predicted values for a model applied to data
    models.torch.fitScore:{[data;seed;mname]
        dataDict:\`xtrain\`ytrain\`xtest\`ytest!raze data;
        model:get[".automl.models.torch.",string[mname],".model"][dataDict;seed];
        model:get[".automl.models.torch.",string[mname],".fit"][dataDict;model];
        get[".automl.models.torch.",string[mname],".predict"][dataDict;model]
        }</code></pre>

5.  Go to `code/customization/models/modelConfig/` and include the model under the appropriate problem type `classification` or `regression` as described above. In this case, the model will be added within the classification section.

    <pre><code class="language-txt">"ClassTorch":{
          "library":"torch",
          "module":"classifier",
          "seed":true,
          "type":"multi",
          "apply":true
        }</code></pre>

    **Note:**

    * In the schema above, the values of the `library` and `module` dictionary keys define the prefix of the naming convention of the `models.torch.classifier.{model/fit/predict}` functions which are retrieved from **torch.q**.
    * The key of the dictionary `ClassTorch` is used for display and model saving purposes.

Implementations of [Keras](https://github.com/KxSystems/automl/tree/master/code/customization/models/libSupport/keras.q) models, [Torch](https://github.com/KxSystems/automl/tree/master/code/tests/files/torch) models and [Theano](https://github.com/KxSystems/automl/tree/master/code/tests/files/theano) models can be found on KxSystems Github.
