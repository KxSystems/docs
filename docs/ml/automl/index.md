---
title: Automated Machine Learning with kdb+/q documentation
description: The kdb+/q automated machine learning platform provides an architecture through which users can apply machine learning techniques to datasets in order to find the best models to predict a target of interest. This platform handles all parts of the machine learning workflow from the preprocessing of data to the export of models, descriptive images and reports outlining the success of the project. 
author: Conor McCarthy
date: October 2019
keywords: machine learning, ml, ai, automated, preprocessing, postprocessing, feature extraction, feature selection, statistics, interpretability, kdb+, q
---
# <i class="fas fa-share-alt"></i> Automated Machine-learning in kdb+/q



<i class="fab fa-github"></i>
[KxSystems/ml](https://github.com/kxsystems/automl/)

The automated machine learning platform described here, is built largely on the tools available within the [machine learning toolkit](../toolkit/ml/toolkit). The purpose of this platform is to provide users with the ability to automate the process of applying machine learning techniques to real-world problems. In the absence of expert machine learning engineers this handles the following processes within a traditional workflow.

1. Data preprocessing
2. Feature engineering and feature selection
3. Model selection
4. Hyperparameter Tuning 
5. Report generation and model persistence

Each of these steps is outlined in depth within the documentation on this website. This allows users to understand the processes by which decisions are being made and the transformations which their data undergo during the production of the output models.

At present the machine learning frameworks supported for this are based on:

1. One-to-one feature to target non time-series
2. [FRESH](../toolkit/ml/fresh) based feature extraction and model production


Over time the functionality available and the problems which can be solved using this library will be extended to include;

-   Time-series use-cases and architectures
-   Natural Language Processing frameworks
-   Broader workflow flexibility
-   More detailed outputs describing the steps taken

!!!Note
	This should not be seen necessarily as a replacement to commercially available automated machine learning platforms. The work outlined here is intended to allow kdb users to explore the use of machine learning on their data and highlight automation techniques which can be deployed through kdb+ for various workflows. This platform is currently in beta and feedback on the interface is readily encouraged.

## Requirements

The following requirements cover all those needed to run the libraries in the current build of the toolkit.

-   [embedPy](../embedpy/index.md)
-   [ML-Toolkit](../toolkit/index.md)

A number of Python dependencies also exist for the running of embedPy functions within both the machine-learning utilities and FRESH libraries.
These can be installed as outlined at

<i class="fab fa-github"></i>
[KxSystems/ml](https://github.com/kxsystems/automl)
using Pip

```bash
pip install -r requirements.txt
```

or Conda

```bash
conda install --file requirements.txt
```


## Installation and loading

Install and load all libraries.

```q
q)\l automl/automl.q
q).automl.loadfile`:init.q
```

This can be achieved by one command.
Copy a link to the library into `$QHOME`.
Then:

```q
q)\l automl/init.q
```

