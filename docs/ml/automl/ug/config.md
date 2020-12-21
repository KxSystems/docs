---
title: Automated machine learning user guide | Machine Learning | Documentation for kdb+ and q
description: Configuring AutoML
keywords: keywords: machine learning, automated, ml, automl, configuration, config
---

# :fontawesome-solid-share-alt: Configuring AutoML

:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl)

While AutoML provides a solid foundation for the generation of machine learning models, for many users there may be significant desire to modify or extend the frameworks capabilities to suit their specific use case. To facilitate this there are two principle ways a user can configure their system.

1. A number of JSON files are provided to allow users to add custom scoring functions, add or remove models, update hyperparameters and change general configuration of an autoML run.
2. When running within a q session users can update general configuration by passing a dictionary containing suitable key value pairs as input.

For the purpose of this outline each of the above options is outlined separately

## JSON configuration files

From an ease of use perspective one of the key additions of `v0.3.0` of the framework was to move all configuration definitions to JSON file format as opposed to the previous q style configuration.

There are at present five files adhering to this formatting style

??? Note "Relevant file paths"
	For ease of navigation within the code base the names in the below table are paths to the appropriate files relative to the `code/customization` directory of the repository.

Index | Folder name        | Relevant file                                       | File Description
------|--------------------|-----------------------------------------------------|-----------
1.    | scoring            | [scoringFunctions.json](#scoring-functions)         | Definitions of all the scoring functions which can be used in optimization and if the optimal model requires ascending/descending data.
2.    | configuration      | [default.json](#default-configuration)              | Default values for all the modifiable parameters outlined within [Advanced parameter modifications](advanced.md).
3.    | models/modelConfig | [models.json](#mdoels)                              | Definition of all models supported for classification and regression tasks.
4.    | hyperParameters    | [gsHyperparameters.json](#grid-search-parameters)   | Definition of hyperparameter sets used by each model when using an exhaustive search method.
5.    | hyperParameters    | [rsHyperparameters.json](#random-search-parameters) | Definition of hyperparameter sets used by each model when using a random/pseudo-random search method.

For ease of user understanding regarding how to modify these files generally, the following provides a guide for a representative subset of supported changes to each file.

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

This structure provides a mapping between a function `.ml.accuracy` and the expected ordering of results in order to find the best model, in this case descending as the best model is the one returning the largest result. Alternatively for the function `.ml.mse` the best model is found when the mean squared error is minimized hence using the ordering function `asc`.

Users are unlikely to need to change the currently defined functions however in order to use a custom model optimization function this function must be defined within this file. 

### Default Configuration

The default configuration JSON file, `default.json` file is used in two situations

1. As the source for the default parameters used when executing `.automl.fit` and using default parameters.
2. As the reference file for generation of custom configuration files, these custom files can be used in two settings.
	1. For running the entirety of the command line interface logic including instructions for data retrieval.
	2. In order to allow the default configuration file to be left untouched but users to use custom configurations for domain specific problems in a multi user environment.

The following are the major sections of the JSON file, each of these will be outlined separately at a high level below.

Section Name      | Description
------------------|------------
problemDetails    | Required when using the command line interface to run the entirety of the [`.automl.fit`](functions.md#automlfit) function, this defines the information about the problem being solved which is required to generate a full run.
retrievalMethods  | Required when using the command line interface to run the entirety of the [`.automl.fit`](functions.md#automlfit) function, this defines instructions for the retrieving the target vector and feature data using various methods.
problemParameters | This defines all default parameters to be used when a configuration file of this type is loaded, problem type specific parameters and parameters which are generally applicable are separated to avoid confusion.

#### problemDetails

The following represents the structure of a representative subset of the `problemDetails` section of the default configuration file.

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

In the above JSON configuration each entry represents the following. 

Entry name            | Entry description                                         | Options
----------------------|-----------------------------------------------------------|-----------------------
featureExtractionType | What method is to be used for generating features?        | "normal"/"fresh"/"nlp"
problemType           | What form of problem is being solved?                     | "class"/"reg"
modelName             | What unique name is to be associated with the model?      | Any [optional]
dataRetrievalMethod   | How are the feature data and target data to be retrieved? | "ipc"/"csv"/"binary"

??? Note "Usage"

	Each of entries above apart from `modelName` can only be envoked when running the entirety of the AutoML framework via command line. These entries are ignored when running from q directly, or updating the default configuration on command line.

#### retrievalMethods

The following provides the structure of the `retrievalMethods` section of the default configuration file.

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

The above denotes the presently supported methods for retrieving both feature and target datasets used when running AutoML from command line. The following outlines expected inputs in each case.

__*ipc:*__

Retrieve feature and target data via localhost IPC.

Input         | Type   | Description | Example
--------------|--------|-------------|---------
 port         | long   | The localhost port from which to retrieve the dataset | 5000
 select       | string | The select/q statement to be executed on the port to retrieve appropriate data | "select from tab where x<100"
 targetColumn | string | In the case that the feature and target datasets are both from the same port and retrieved using the same select statement, retrieve the data once and select the appropriate target column. | "target"

__*csv:*__

Retrieve feature and target data from a CSV file.

Input         | Type   | Description | Example
--------------|--------|-------------|---------
 schema       | string | Define the schema which is to be used for retrieval of the CSV data from disk, this should follow the q mapping between types and letters defined [here](https://code.kx.com/q/ref/tok/). | "SPJJFFI"
 separator    | char   | The field separator is the item within each line of a CSV that splits the data into its constituent fields. | ","/"/\t"
 directory    | string | The directory relative to the directory that AutoML was loaded containing the appropriate CSV file. | "testDirectory/test1"
 fileName     | string | The name of the CSV file to be loaded | "testFile.csv"
 targetColumn | string | In the case that the feature and target datasets are both from the same port and retrieved using the same select statement, retrieve the data once and select the appropriate target column. | "target"

__*binary:*__

Retieve feature and target data from a kdb+ binary file.

Input         | Type   | Description | Example
--------------|--------|-------------|---------
 directory    | string | The directory relative to the directory that AutoML was loaded containing the appropriate kdb+ binary file. | "testDirectory/test1"
 fileName     | string | The name of the kdb+ binary file to be loaded | "testFile.csv"
 targetColumn | string | In the case that the feature and target datasets are both from the same port and retrieved using the same select statement, retrieve the data once and select the appropriate target column. | "target"

#### problemParameters

The `problemParameters` section of the default.json file contains the definitions of all the default parameters used within AutoML, which are configurable as outlined in the [Advanced parameter modifications](advanced.md) section. This outlines all configurable parameters across the supported use cases and is broken into 4 sections,

Section  | Description                                                                          | Example
---------|--------------------------------------------------------------------------------------|---------
 general | Parameters configurable for each use case                                            | 'seed'/'testingSize'
 normal  | Parameters configurable for the application of 'normal' feature extraction/use cases | 'trainTestSplit'/'functions'
 fresh   | Parameters configurable for the application of 'fresh' feature extraction/use cases  | 'aggregationColumns'
 nlp     | Parameters configurable for the application of 'nlp' feature extraction/use cases    | 'w2v'

In each case the JSON configuration defined takes the following form, where value is the input supplied to AutoML and the type defines how this value is to be represented within kdb+.

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

The `models.json` file defines information surrounding the machine learning models which are to be applied when running AutoML. Any model which is to be added to the framework must be defined in this file. The JSON file contains two sections

1. classification
2. regression

Users who wish to add custom models, in accordance with the instructions outlined within the [FAQ](#../faq.md) section for `pytorch`/`sklearn`/`keras`/`theano` must define their models within this section. The following provides an example definition of a `sklearn`, `keras` and `torch` model

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

The following table outlines the expected inputs for each of the models defined above

 Input      | Description
------------|-------------
 Model-Name | In the examples above 'LinearSVC', 'BinaryKeras' and 'Torch' are the names which will be associated with the models when printing to standard out, in the case of Keras/Torch, this has no physical representation however when using sklearn this defines the model name to be retrieved. for example the model defined here is `sklearn.svm.LinearSVC`.
 library    | Is the library from which the model is generated `sklearn`/`keras`/`torch`/`theano` this defines the logic used for model retrieval.
 module     | In the case of `sklearn` this defines the module from which the model is retrieved, for `keras`/`theano`/`torch` however this defines the name of the model being retrieved i.e. in the case of `BinaryKeras` above the model to be retrieved must be defined as `.automl.keras.binary.x` where `x` defines `fit`/`predict`/`model` definitions within the library.
 seed       | Is the model to be seeded for reproducibility or not? Models such as simple linear regressors are deterministic and as such do not need to be seeded
 type       | Is the model `binary/`multi` class in the case of a classification problem, otherwise define it as `reg` for a regression model
 apply      | Is this model to be applied or not in a given run? If set to false this model definition will be ignored.

### Grid search parameters

This defines the hyperparameters which are used when running the AutoML such that model optimization is completed using an exhaustive grid search. The following provides a number of examples of the definition of elements of this JSON file.

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

The following table outlines the expected behaviour of each of the sections of the above JSON

 Input               | Description
---------------------|-------------
 Model-Name          | The model name defined within 'models.json' to which the defined hyperparameters are to be applied
 Parameters          | The hyperparameters to be applied when running the model optimization, this should be an exhaustive list of parameters to be searched
 meta -> typeConvert | The type conversion of each of the parameters to be searched. For example in the case of the `AdaBoostRegressor` model, the parameter `n_estimators` must be cast to an integer, while the `learning_rate` is a floating point value.

### Random search parameters

This defines the hyperparameter search space when applying a random/sobol sequence based search during optimization. The following provides a number of examples of the definition of elements of this JSON file.

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

The following table outlines the expected behaviour of each of the sections of the above JSON

 Input               | Description
---------------------|-------------
 Model-Name          | The model name defined within 'models.json' to which the defined hyperparameters are to be applied
 Parameters          | The specific hyperparameters/range of over which hyperparameters to be applied are defined.
 meta -> randomType  | This defines the type of randomization which is to be used within the random search. This can be one of `boolean`, `uniform`, `loguniform` or `symbol`, the definitions outlining expected behaviour for each are provided [here](../../../../toolkit/xval#random-search-hyperparameter-dictionary).
 meta -> typeConvert | The type conversion of each of the parameters to be searched. For example in the case of the `Lass` model, the parameter `alpha` must be cast to an float, while the `normalize` parameter is a boolean value.

## In process configuration

For many users configuring AutoML will not require modification of the above JSON files, instead they will modify the system behaviour on explicit invocation of the function `.automl.fit` as outlined [here](functions.md#automlfit). When calling this function the final parameter `params` can be configured to take as input any of the supported parameters outlined [above](#problemParameters). The following provides an example of a sample dictionary which would be used to change the random seed used to a value of 75, set the testing size to 25 percent of the total dataset and the cross validation function used to be `.ml.xv.kfsplit`.

```q
q)paramKeys:`seed`testingSize`crossValidationFunction
q)paramVals:(75;0.25;.ml.xv.kfshuff)
q)paramDict:paramKeys!paramVals
q).automl.fit[([]100?1f;100?1f);100?1f;`normal;`reg;paramDict]
```

A full breakdown of supported options is provided [here](advanced.md), while a description of the use of the function `.automl.fit` can be found [here](functions.md#automlfit).
