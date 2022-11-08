---
title: Automated Machine Learning | Machine Learning | Documentation for q and kdb+
description: The kdb+/q automated machine-learning platform helps find models to predict a target of interest, and handles preprocessing data, export of models, images and reports.
author: Deanna Morgan
date: December 2020
keywords: machine learning, ml, ai, automated, automl, preprocessing, processing, postprocessing, feature extraction, feature selection, statistics, interpretability, kdb+, q
---
# :fontawesome-solid-share-alt: Automated Machine Learning in kdb+/q

:fontawesome-brands-github:
[KxSystems/automl](https://github.com/kxsystems/automl/)

The automated machine-learning platform described here is built largely on the tools available within the [Machine Learning Toolkit](../toolkit/index.md). The purpose of this platform is to help automate the process of applying machine-learning techniques to real-world problems. In the absence of expert machine-learning engineers this handles the following processes within a traditional workflow.

1. Data preprocessing
2. Feature extraction and selection
3. Model selection
4. Model optimization
5. Report generation and model persistence

Each of these steps is described in detail throughout this documentation. 
This allows users to understand the processes by which decisions are being made and the transformations which their data undergo during the production of the output models.

At present the machine-learning frameworks supported for this are based on:

1. One-to-one feature to target non-timeseries
2. [FRESH](../toolkit/fresh.md)-based feature extraction and model production
3. [NLP](../nlp/index.md)-based feature creation and word2vec transformation 

Over time, the functionality available and the problems which can be solved using this library will be extended to include:

-   Timeseries use cases and architectures 
-   Broader workflow flexibility
-   More detailed outputs describing the steps taken

!!! note

    This should not necessarily be seen as a replacement to commercially available automated machine learning platforms. The work outlined here is intended to allow kdb+ users to explore the use of machine learning on their data and highlight automation techniques which can be deployed through kdb+ for various workflows. 

    This platform is currently in beta and feedback on the interface is requested. Please write to ai@kx.com. 


## Requirements

The following requirements cover all those needed to run the libraries in the current build of the toolkit.

-   [embedPy](../embedpy/index.md)
-   [ML-Toolkit](../toolkit/index.md)

A number of Python dependencies also exist for the running of embedPy functions within both the machine learning utilities and FRESH libraries. These can be installed as outlined at:

:fontawesome-brands-github:
[KxSystems/ml](https://github.com/kxsystems/automl)
using Pip

```bash
pip install -r requirements.txt
```

or Conda

```bash
conda install --file requirements.txt
```
The requirements needed in order to use the NLP functionality can be found on [Github](https://github.com/kxsystems/automl#optional-requirements-for-advanced-modules).


## Installation and loading

Install and load all libraries.

```q
q)\l automl/automl.q
q).automl.loadfile`:init.q
```

This can be achieved with one command. Assuming the `automl` repository is located in `QHOME`, execute the following from a q session:

```q
q)\l automl/init.q
```
