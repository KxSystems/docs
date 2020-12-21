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

The addition of Sklearn models can be completed through the modification of the `models.json` file found within `code/customization/models/modelConfig/`. The steps to do so are as follows.

1.  Within the json file, place the new model under the appropriate dictionary key depending on the problem type (i.e - `classification` or `regression`)

2.  Add the model display name as a dictionary key within the appropriate problem type and follow the same format as below. This is a sample of a subset of `regression` models 

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
  

    To understand the above structure, take for example the following embedPy code

    <pre><code class="language-q">q)seed:42
    q)mdl:.p.import[\`sklearn.ensemble][\`:AdaBoostRegressor][\`random_state pykw seed]
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


3.  If a grid or random search is to be performed on the model, a user must add the model's associated hyperparameters over which to perform to the json files `gsHyperParameters.json` or `rsHyperParameters.json` contained within `code/customization/hyperParameters/`. If not, then the model name must be added to `.automl.utils.excludeList` within `code/utils.q`. The following is an example of the hyperparameters which could be added for the Bayesian ridge regressor using grid search methods. Within `gsHyperParameters`, add the following key to the dictionary

    <pre><code class="language-q">"BayesianRidge":{
     "Parameters":{
       "n_iter":[100,200,300],
       "tol":[0.001,0.005,0.01]
     },
     "meta":{
      "typeConvert":["int","float"]
     }
    }</code></pre>

    * The hyperparameters to perform along with their associated values are contained within the `Parameters` key, and the type of each hyperparameter is contained under `typeConvert` within `meta`


### Keras Models

The addition of custom keras models is slightly more involved than that performed for scikit-learn models. The following steps show in their entirety the steps followed to add a custom regression model named `CustomReg` to the workflow.

1.  Open the file `code/customization/models/libSupport/keras.q`

2.  Follow the naming convention `models.[library].[module].{model/fit/predict}` to create functions which define the model to be used, fit the model to the training data and predict the value of the target. The `[library].[module]` part of the namespace are defined within the dictionaries found in `models.json`, which will be explained in detail below. Ensure the functions are defined in the root of the `.automl` namespace (this is already handled if within the `keras.q` file)
    
```q
    $vi keras.q
    \d .automl
    

    // @kind function
    // @category models
    // @fileoverview Fit a vanilla keras model to data
    // @param data  {dict} containing training and testing data according to keys
    //   `xtrn`ytrn`xtst`ytst
    // @param mdl   {<} model object being passed through the system (compiled/fitted)
    // @return      {<} a vanilla fitted keras model
    models.keras.customReg.fit:{[data;mdl]
      mdl[`:fit][models.i.npArray data`xtrain;data`ytrain;`batch_size pykw 16;
         `verbose pykw 0];
      mdl
    }


   // @kind function
   // @category models
   // @fileoverview Compile a keras model for binary problems
   // @param data  {dict} containing training and testing data according to keys
   //   `xtrn`ytrn`xtst`ytst
   // @param seed  {int} seed used for initialising the same model
   // @return      {<} the compiled keras models
   models.keras.customReg.model:{[data;seed]
     models.i.numpySeed[seed];
     if[models.i.tensorflowBackend;models.i.tensorflowSeed[seed]];
     mdl:models.i.kerasSeq[];
     layer1Keys:`input_dim`kernel_initializer`activation;
     layer1Vals:(count first data`xtrain;`normal;`relu);
     mdl[`:add]models.i.kerasDense[13;pykwargs layer1Keys!;layer1Vals];
     mdl[`:add]models.i.kerasDense[1;`kernel_initializer pykw `normal];
     mdl[`:compile][pykwargs `loss`optimizer!`mean_squared_error`adam];
     mdl
   }

   // @kind function
   // @category models
   // @fileoverview Predict test data values using a compiled model
   //  for binary problem types
   // @param data  {dict} containing training and testing data according to keys
   //   `xtrn`ytrn`xtst`ytst
   // @param mdl   {<} model object being passed through the system (compiled/fitted)
   // @return      {bool} the predicted values for a given model
   models.keras.customReg.predict:{[data;mdl]
     .5<raze mdl[`:predict][models.i.npArray data`xtest]`
   } 
```


To ensure the behavior of the system is consistent with the framework, it is vital to follow the above instructions, particularly ensuring that models take as arguments the defined parameters and return an appropriate result, in particular at the model-definition phase, where explicit return of the model is required. Seeding of these models is not guaranteed unless a user has defined calls to functions such as `numpy.random.seed` to ensure that this is the case.

For the fitting and prediction of Keras models through embedPy, it is important that the feature data is a NumPy array. Omission of this conversion can cause issues. As seen above within `keras.q` this is done through application of `` models.i.npArray`` to the data.

3.  Another function called `models.keras.fitScore` must be defined within `keras.q`. This function is used when applying cross validation during the `runModels` processing stage of the pipeline in which the model is fitted on the training data and the predictions made on the testing data is returned. The arguments and outputs to the model must be consistent with the below example.

```q
// @kind function
// @category models
// @fileoverview Fit model on training data and score using test data
// @param data  {dict} containing training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param seed  {int} seed used for initialising the same model
// @param mname {sym} name of the model being applied
// @return      {int;float;bool} the predicted values for a given model as applied to input data
models.keras.fitScore:{[data;seed;mname]
  if[mname~`multi;
    data[;1]:models.i.npArray@'flip@'value@'.ml.i.onehot1 each data[;1]];
  dataDict:`xtrain`ytrain`xtest`ytest!raze data;
  mdl:get[".automl.models.keras.",string[mname],".model"][dataDict;seed];
  mdl:get[".automl.models.keras.",string[mname],".fit"][dataDict;mdl];
  get[".automl.models.keras.",string[mname],".predict"][dataDict;mdl]
  }
```

4.  Go to `code/customization/models/modelConfig/` and include the model under the appropriate problem type `classification` or `regression` as described above

	<pre><code class="language-txt">"customReg":{
         "library":"keras",
         "module":"customReg",
         "seed":true,
         "type":"reg",
         "apply":true
        }
	</code></pre>


   The key of the dictionary is what will be used to display the name. The `library` and `module` key are used to define the structure of the naming convention of the model - `models.keras.customReg`. By default, all custom keras models are excluded from grid search procedures.
     
### PyTorch Models

The procedure which must be followed to add a custom PyTorch model to automl follows closely that outlined for the addition of keras models above. The following steps show in their entirety the steps followed to add a custom classification model named `ClassTorch` to the workflow.

1. Open the file to `models.json` in the folder `code/customization/models/modelConfig/` and add the defined model under the appropriate section. In this exampl,e the model being added is a multi-class classification model named `ClassTorch`.

	<pre><code class="language-txt">"ClassTorch":{
          "library":"torch",
          "module":"classifier",
          "seed":true,
          "type":"multi",
          "apply":true
        }</code></pre>
	
	**Note:**
	
	* In the schema above, the values of the `library` and `module` dictionary keys define the prefix of the naming convention of the `models.torch.classifier.{mdl/fit/predict}` functions which are retrieved from **pytorch.q**.
	* The key of the dictionary `ClassTorch` is used for display and model saving purposes.

3.  Within the folder `code/customization/models/libSupport/` there are two files associated with PyTorch models - **torch.q** and **torch.p**. These files should contain the following information
	* `torch.p` = Any Python code required to define the appropriate PyTorch models.
	* `torch.q` = The q functions which define the model, fit and predict functionality for any custom PyTorch models.


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

`torch.q` defined below contains q code which appropriately wraps a PyTorch model such that it can be run within the model pipeline. The following wraps the PyTorch functionality defined above into appropriately named q `model`, `fit` and `predict` functions along with the `fitScore` function used for cross validation.

```q
$vi torch.q
\d .automl

// @kind function
// @category models
// @fileoverview Fit model on training data and score using test data
// @param data  {dict} containing training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param seed  {int} seed used for initialising the same model
// @param mname {sym} name of the model being applied
// @return {int;float;bool} the predicted values for a given model as applied to input data
models.torch.fitScore:{[data;seed;mname]
  dataDict:`xtrain`ytrain`xtest`ytest!raze data;
  mdl:get[".automl.models.torch.",string[mname],".model"][dataDict;seed];
  mdl:get[".automl.models.torch.",string[mname],".fit"][dataDict;mdl];
  get[".automl.models.torch.",string[mname],".predict"][dataDict;mdl]
  }


// @kind function
// @category models
// @fileoverview Fit a vanilla torch model to data
// @param data {dict} containing training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param model {<} model object being passed through the system (compiled)
// @return {<} a vanilla fitted torch model
models.torch.classifier.fit:{[data;model]
  optimArg:enlist[`lr]!enlist 0.9;
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
// @param data  {dict} containing training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param seed  {int} seed used for initialising the same model
// @return {<} the compiled torch models
models.torch.classifier.model:{[data;seed]
  models.torch.torchModel[count first data`xtrain;200]
  }


// @kind function
// @category models
// @fileoverview Predict test data values using a compiled model
//  for binary problem types
// @param data {dict} containing training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param model {<} model object being passed through the system (fitted)
// @return {bool} the predicted values for a given model
models.torch.classifier.predict:{[data;model] 
  dataX:models.i.numpy[models.i.npArray[data`xtest]][`:float][];
  torchMax:last models.i.torch[`:max][model[dataX];1]`;
  (.p.wrap torchMax)[`:detach][][`:numpy][][`:squeeze][]`
  }


// load required python modules
models.i.torch      :.p.import[`torch           ]
models.i.npArray    :.p.import[`numpy           ]`:array;
models.i.Adam       :.p.import[`torch.optim     ]`:Adam
models.i.numpy      :.p.import[`torch           ]`:from_numpy
models.i.tensorData :.p.import[`torch.utils.data]`:TensorDataset
models.i.dataLoader :.p.import[`torch.utils.data]`:DataLoader
models.i.neuralNet  :.p.import[`torch.nn]

models.torch.torchFit:.p.get[`runmodel];
models.torch.torchModel:.p.get[`classifier];
```

### Theano Models

The procedure which must be followed to add a custom Theano model to automl follows closely that outlined for the addition of keras/PyTorch models above. The following steps show in their entirety the steps followed to add a custom classification model named `TheanoModel` to the workflow.

1. Open the file to `models.json` in the folder `code/customization/models/modelConfig/` and add the defined model under the appropriate section. In this example the Neural Network model being added is a binary-class classification model.

	<pre><code class="language-txt">"TheanoModel":{
          "library":"theano",
          "module":"NN",
          "seed":true,
          "type":"class",
          "apply":true
        }
	</code></pre>
	
	**Note:**
	
	* In the schema above, the values of the `library` and `module` dictionary keys define the prefix of the naming convention of the `models.theano.NN.{mdl/fit/predict}` functions which are retrieved from **theano.q**.
	* The key of the dictionary `TheanoModel` is used for display and model saving purposes.

3.  Within the folder `code/customization/models/libSupport/` there are two files associated with Theano models - **theano.q** and **theano.p**. These files should contain the following information
	* `theano.p` = Any Python code required to define the appropriate Theano models.
	* `theano.q` = The q functions which define the model, fit and predict functionality for any custom Theano models.

```python
$vi theano.p

import theano
from theano import tensor as T
import numpy as np


def init_weights(shape):
    """ Weight initialization """
    weights = np.asarray(np.random.randn(*shape) * 0.01, dtype=theano.config.floatX)
    return theano.shared(weights)

def backprop(cost, params, lr=0.01):
    """ Back-propagation """
    grads   = T.grad(cost=cost, wrt=params)
    updates = []
    for p, g in zip(params, grads):
        updates.append([p, p - g * lr])
    return updates

def forwardprop(X, w_1, w_2):
    """ Forward-propagation """
    h    = T.nnet.sigmoid(T.dot(X, w_1))  # The \sigma function
    yhat = T.nnet.softmax(T.dot(h, w_2))  # The \varphi function
    return yhat


def buildModel(train_X,train_y,seed):
  
   np.random.seed(seed)  
 
  # Symbols
   X = T.fmatrix()
   Y = T.fmatrix()

   # Layers sizes
   x_size = train_X.shape[1]             # Number of input nodes: 4 features and 1 bias
   h_size = 256                          # Number of hidden nodes
   y_size = train_y.shape[1]             # Number of outcomes (3 iris flowers)
   w_1 = init_weights((x_size, h_size))  # Weight initializations
   w_2 = init_weights((h_size, y_size))

   # Forward propagation
   yhat   = forwardprop(X, w_1, w_2)

   # Backward propagation
   cost    = T.mean(T.nnet.categorical_crossentropy(yhat, Y))
   params  = [w_1, w_2]
   updates = backprop(cost, params)

   # Train and predict
   train   = theano.function(inputs=[X, Y], outputs=cost, updates=updates, allow_input_downcast=True)
   pred_y  = T.argmax(yhat, axis=1)
   predict = theano.function(inputs=[X], outputs=pred_y, allow_input_downcast=True)
 
   return(train,predict)


def fitModel(train_X,train_y,model):
    for iter in range(5):
        for i in range(len(train_X)):
            model(train_X[i: i + 1], train_y[i: i + 1]) 


def predictModel(test_X,model):
  return model(test_X)
```

`theano.q` defined below contains q code which appropriately wraps a theano model such that it can be run within the model pipeline. The following wraps the theano functionality defined above into appropriately named q model, fit and predict functions along with the `fitScore` function used for cross validation.

```q
$vi theano.q
\d .automl

// @kind function
// @category models
// @fileoverview Fit model on training data and score using test data
// @param data  {dict} containing training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param seed  {int} seed used for initialising the same model
// @param mname {sym} name of the model being applied
// @return      {int;float;bool} the predicted values for a given model as applied to input data
models.theano.fitScore:{[data;seed;mname]
  dataDict:`xtrain`ytrain`xtest`ytest!raze data;
  mdl:get[".automl.models.theano.",string[mname],".model"][dataDict;seed];
  mdl:get[".automl.models.theano.",string[mname],".fit"][dataDict;mdl];
  get[".automl.models.theano.",string[mname],".predict"][dataDict;mdl]
  }


// @kind function
// @category models
// @fileoverview Compile a theano model for binary problems
// @param data  {dict} containing training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param seed  {int} seed used for initialising the same model
// @return      {<} the compiled theano models
models.theano.NN.model:{[data;seed]
  data[`ytrain]:models.i.npArray flip value .ml.i.onehot1 data[`ytrain];
  models.theano.buildModel[models.i.npArray data`xtrain;data`ytrain;seed]
  }

// @kind function
// @category models
// @fileoverview Fit a vanilla theano model to data
// @param data  {dict} containing training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param mdl   {<} model object being passed through the system (compiled/fitted)
// @return      {<} a vanilla fitted theano model
models.theano.NN.fit:{[data;mdl]
  data[`ytrain]:models.i.npArray flip value .ml.i.onehot1 data[`ytrain];
  mdls:.p.wrap each mdl`;
  trainMdl:first mdls;
  models.theano.trainModel[models.i.npArray data`xtrain;data`ytrain;trainMdl];
  last mdls
  }

// @kind function
// @category models
// @fileoverview Predict test data values using a compiled model
//  for binary problem types
// @param data  {dict} containing training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param mdl   {<} model object being passed through the system (compiled/fitted)
// @return      {bool} the predicted values for a given model
models.theano.NN.predict:{[data;mdl]
  models.theano.predictModel[models.i.npArray data`xtest;mdl]`
  }

 
// load required python modules and functions
models.i.npArray          :.p.import[`numpy]`:array;

models.theano.buildModel  :.p.get[`buildModel]
models.theano.trainModel  :.p.get`fitModel
models.theano.predictModel:.p.get[`predictModel]
```
