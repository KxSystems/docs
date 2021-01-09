---
title: Automated machine learning user guide | Machine Learning | Documentation for kdb+ and q
description: Configuring AutoML
author: Conor McCarthy
date: December 2020
keywords: keywords: machine learning, automated, ml, automl, configuration, config
---

# :fontawesome-solid-share-alt: Configuring AutoML

:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl)

While AutoML provides a solid foundation for generating machine-learning models, you may wish to modify or extend the capabilities of the framework to suit a specific use-case. There are two ways:

1.  JSON files that allow you to add custom scoring functions, add or remove models, update hyperparameters and change general configuration of an autoML run
2.  Within a q session you can update general configuration by passing a dictionary containing suitable key-value pairs as input.


## JSON configuration files

For ease of use, `v0.3.0` of the framework moves all configuration definitions to JSON file format insead of the earlier q configuration.

There are at present five files in this format.

Names in the table below are paths relative to the `code/customization` directory of the repository.

folder             | file                                                | file description
-------------------|-----------------------------------------------------|-----------
scoring            | [scoringFunctions.json](#scoring-functions)         | Definitions of all the scoring functions which can be used in optimization and if the optimal model requires ascending/descending data.
configuration      | [default.json](#default-configuration)              | Default values for all the modifiable parameters outlined within [Advanced parameter modifications](advanced.md) and all information needed when running AutoML from command line only.
models/modelConfig | [models.json](#mdoels)                              | Definition of all models supported for classification and regression tasks.
hyperParameters    | [gsHyperparameters.json](#grid-search-parameters)   | Definition of hyperparameter sets used by each model when using an exhaustive search method.
hyperParameters    | [rsHyperparameters.json](#random-search-parameters) | Definition of hyperparameter sets used by each model when using a random/pseudo-random search method.

The following is a guide to a representative subset of supported changes to each file.


### Scoring functions

The scoring functions JSON file, `scoringFunctions.json` contains a set of scoring functions defined as follows

```json
".ml.accuracy":{
  "orderFunc":"desc"
  },
".ml.mse":{
  "orderFunc":"asc"
  },
```

ABOVE, a mapping between function `.ml.accuracy` and the expected ordering of results that finds the best model: in this case _descending_, as the best model is the one returning the largest result. For function `.ml.mse` the best model is found when the mean squared error is minimized; hence the ordering function is `asc`.

You are unlikely to need to change the currently-defined functions.
However to use a custom model optimization function, it must be defined in this file. 


### Default configuration

The default configuration JSON file `default.json` is used in two contexts:

1. As the source of default parameters for `.automl.fit`
2. As the reference file for generating custom configuration files, which can be used in two settings:
	1. For running the entirety of the command-line interface logic, including instructions for data retrieval.
	2. To leave the default configuration file untouched and use custom configurations for domain-specific problems in a multi-user environment.

Major sections of the JSON file:

section           | description
------------------|------------
problemDetails    | Required when using the command-line interface to run the entirety of the [`.automl.fit`](functions.md#automlfit) function: information about the problem being solved required to generate a full run.
retrievalMethods  | Required when using the command-line interface to run the entirety of the [`.automl.fit`](functions.md#automlfit) function: instructions for retrieving the target vector and feature data using various methods.
problemParameters | Defines default parameters to be used when a configuration file of this type is loaded. Problem type-specific parameters and parameters  generally applicable are separated to avoid confusion.


#### `problemDetails`

Example:

```json
"problemDetails":{
  "featureExtractionType":"",
  "problemType"          :"",
  "modelName"            :"",
  "dataRetrievalMethod"  :{
    "featureData":"",
    "targetData" :""
  }
```

Parameters:

key                   | value                                          | options
----------------------|-----------------------------------------------------------|-----------------------
featureExtractionType | method for generating features        | normal \| fresh \| nlp
problemType           | form of problem                     | class \| reg
modelName             | unique name for model (optional)      | 
dataRetrievalMethod   | how to retrieve feature and target data | ipc \| csv \| binary

!!! warning "Command line only"

    The parameters above (apart from `modelName`) can be invoked only when running the entirety of the AutoML framework from the command line. These entries are ignored when running from q directly, or updating the default configuration on the command line.


#### `retrievalMethods`

Structure:

```json
"ipc":{
  "featureData":{
    "port"  :"",
    "select":""
  },
  "targetData":{
    "port"  :"",
    "select":"",
    "targetColumn":""
  }
},
"csv":{
  "featureData":{
    "schema"   :"",
    "separator":"",
    "directory":"",
    "fileName" :""
  },
  "targetData":{
    "schema"      :"",
    "separator"   :"",
    "directory"   :"",
    "fileName"    :"",
    "targetColumn":""
  }
},
"binary":{
  "featureData":{
    "directory":"",
    "fileName" :""
  },
  "targetData":{
    "directory"   :"",
    "fileName"    :"",
    "targetColumn":""
  }
}
```

`ipc`: Retrieve feature and target data via localhost IPC

key           | type   | value       | example
--------------|--------|-------------|---------
port         | long   | localhost port from which to retrieve the dataset | 5000
select       | string | q expression to evaluate on the port to retrieve  data | `select from tab where x<100`
targetColumn | string | when feature and target datasets are from the same port and `select` expression, retrieve the data once and select this target column | `target`

`csv`: Retrieve feature and target data from a CSV file

key          | type   | value       | example/s
-------------|--------|-------------|---------
schema       | string | schema for CSV data from disk, as per [Tok](https://code.kx.com/q/ref/tok/) | `"SPJJFFI"`
separator    | char   | CSV field separator | `","` \| `"/\t"`
directory    | string | filepath to the CSV’s parent directory, relative to the directory from which AutoML was loaded | <span class="nowrap">`"testDirectory/test1"`</span>
fileName     | string | name of the CSV | `"testFile.csv"`
targetColumn | string | when feature and target datasets are from the same port and `select` expression, retrieve the data once and select this target column | `target`

`binary`: Retrieve feature and target data from a kdb+ binary file

key          | type   | value       | example
-------------|--------|-------------|---------
directory    | string | filepath to the binary’s parent directory, relative to the directory from which AutoML was loaded | <span class="nowrap">`"testDirectory/test1"`</span>
fileName     | string | name of the kdb+ binary file | `"testFile.csv"`
targetColumn | string | when feature and target datasets are from the same port and `select` expression, retrieve the data once and select this target column | `target`


#### `problemParameters`

The `problemParameters` section defines default parameters for AutoML, as in the [Advanced parameter modifications](advanced.md) section. 

section  | parameters                                                              | examples
---------|-------------------------------------------------------------------------|---------
 general | applicable for all use cases                                            | seed<br>testingSize
 normal  | configurable for the application of normal feature extraction/use cases | trainTestSplit<br>functions
 fresh   | configurable for the application of FRESH feature extraction/use cases  | aggregationColumns
 nlp     | configurable for the application of NLP feature extraction/use cases    | w2v

The JSON configurations are defined in the following form, where `value` is the input supplied to AutoML and `type` how it is represented in q.

```json
"aggregationColumns":{
  "value":"{first cols x}",
  "type" :"lambda"
},
"trainTestSplit":{
  "value":".automl.utils.ttsNonShuff",
  "type" :"symbol"
},
"targetLimit":{
  "value":10000,
  "type" :"long"
}
```

### Models

The `models.json` file specifies the machine-learning models applied when running AutoML. Any model added to the framework must be specified, as per the [FAQ](../faq.md#keras-torch-theano-models), in this file, which has two sections:

1.  classification
2.  regression

Example:

```json
"LinearSVC":{
  "library":"sklearn",
  "module":"svm",
  "seed":true,
  "type":"binary",
  "apply":true
},
"BinaryKeras":{
  "library":"keras",
  "module":"binary",
  "seed":true,
  "type":"binary",
  "apply":true
},
"Torch":{
  "library":"torch",
  "module":"NN",
  "seed":true,
  "type":"binary",
  "apply":true
}
```

The following table outlines the expected inputs for each of the models defined above:

Model name 

: In the example above `LinearSVC`, `BinaryKeras` and `Torch` are the names associated with the models when printing to standard out. In the case of Keras/Torch, this has no physical representation, however when using sklearn this defines the model name to be retrieved. For example, the model defined here is `sklearn.svm.LinearSVC`.

`library` 

: Is the library from which the model is generated `sklearn`, or `keras`, or `torch`, or `theano`? Defines the logic used for model retrieval.

`module` 

: For `sklearn` this defines the module from which the model is retrieved. For `keras`, `theano`, and `torch` however this defines the name of the model being retrieved i.e. in the case of `BinaryKeras` above the model to be retrieved must be defined as `.automl.keras.binary.x` where `x` defines `fit`, `predict`, or `model` definitions within the library.

`seed` 

: Is the model to be seeded for reproducibility or not? Models such as simple linear regressors are deterministic and as such do not need to be seeded

`type` 

: Set to `binary` or `multi` for a classification problem; otherwise `reg` for a regression model.

`apply`

: Is this model to be applied or not in a given run? If set to `false` the model will be omitted.


### Grid search parameters

This defines the hyperparameters used when running the AutoML such that model optimization is completed using an exhaustive grid search. 
Some examples:

```json
"AdaBoostRegressor":{
  "Parameters":{
    "n_estimators":[10,20,30,50,100,250],
    "learning_rate":[0.1,0.25,0.5,0.75,0.9,1.0]
  },
  "meta":{
    "typeConvert":["int","float"]
  }
},
"RandomForestRegressor":{
  "Parameters":{
    "n_estimators":[10,20,50,100,250],
    "criterion":["mse","mae"],
    "min_samples_leaf":[1,2,3,4]
  },
  "meta":{
   "typeConvert":["int","symbol","int"]
  }
}
```

Model name 

: Name defined within `models.json` to which the defined hyperparameters are to be applied

`Parameters` 

: Hyperparameters to be applied when running the model optimization: should be an exhaustive list of parameters to be searched

`meta` -> `typeConvert` 

: Type conversion of each of the parameters to be searched. For example, for the `AdaBoostRegressor` model, the parameter `n_estimators` must be cast to an integer, while the `learning_rate` is a float.


### Random search parameters

This defines the hyperparameter search space when applying a random or sobol-sequence-based search during optimization. 

Examples:

```json
"KNeighborsRegressor":{
  "Parameters":{
    "n_neighbors":[2,100],
    "weights":["uniform","distance"]
  },
  "meta":{
    "randomType":["uniform","symbol"],
    "typeConvert":["long","symbol"]
  }
},
"Lasso":{
  "Parameters":{
    "alpha":[0.1,1.0],
    "normalize":[0,1],
    "max_iter":[100,1000],
    "tol":[0.0001,0.1]
  },
  "meta":{
    "randomType":["uniform","boolean","uniform","uniform"],
    "typeConvert":["float","boolean","long","float"]
  }
}
```


Model name 

: Name defined within `models.json` to which the defined hyperparameters are to be applied

`Parameters` 

: Specific hyperparameters or range over which hyperparameters to be applied are defined.

`meta` -> `randomType`  

: Defines the type of randomization to be used within the random search. This can be one of `boolean`, `uniform`, `loguniform` or `symbol`, as [defined](../../../../toolkit/xval#random-search-hyperparameter-dictionary) for the Machine Learning Toolkit.

`meta` -> `typeConvert` 

: Type conversion of each of the parameters to be searched. For example in the case of the `Lass` model, the parameter `alpha` must be cast to a float, while the `normalize` parameter is a boolean value.


## In-process configuration

Instead of modifying the above JSON files, you may prefer to modify the system behavior on explicit invocation of the function [`.automl.fit`](functions.md#automlfit). 
When calling this function the final argument `params` can be configured to take as input any of the parameters in [`problemParameters`](#problemparameters). 

Example: a dictionary to set the random seed to a value of 75, testing size to 25 percent of the total dataset, and the cross validation function to `.ml.xv.kfsplit`.

```q
q)paramKeys:`seed`testingSize`crossValidationFunction
q)paramVals:(75;0.25;.ml.xv.kfshuff)
q)paramDict:paramKeys!paramVals
q).automl.fit[([]100?1f;100?1f);100?1f;`normal;`reg;paramDict]
```

---
:fontawesome-solid-hand-point-right:
[Advanced options](advanced.md)
<br>
:fontawesome-solid-hand-point-right:
[`.automl.fit`](functions.md#automlfit)
