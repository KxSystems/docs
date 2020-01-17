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

