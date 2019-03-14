---
title: Machine learning - code.kx.com
keywords: Python, Jupyter, natyural laguage processing, nlp, machine learning, ml, sentiment, Anaconda, Docker
---

# <i class="fa fa-share-alt"></i> Machine learning

![Machine learning](../img/ml.png)


**Machine-learning** capabilities are at the heart of future technology development at Kx. Libraries are added here as they are released. Libraries are released under the Apache 2 license, and are free for all use cases, including 64-bit and commercial use.

<i class="far fa-hand-point-right"></i> [How to set up](setup) kdb+ to create a machine-learning environment using either Anaconda, Docker or a manual build.

## Natural Language Processing 

[NLP](nlp) is the first module in our machine-learning suite, and manages the common functions associated with processing unstructured text. Functions for searching, clustering, keyword extraction and sentiment are included, the library is available [here](https://github.com/KxSystems/nlp).

<i class="far fa-hand-point-right"></i> [Demonstration notebook](https://github.com/KxSystems/mlnotebooks/blob/master/notebooks/ML07%20Natural%20Language%20Processing.ipynb)

## Machine Learning Toolkit

The [Machine Learning Toolkit](toolkit/) is at the core of q specific machine learning functionality. This library contains functions that cover the following areas.

-  Pre-processing data prior to the application of machine learning algoithms
-  Accuracy metrics to test the performance of the models built
-  Cross validation functions to test the stability of models being produced under various conditions 
-  An implementation of the [FRESH](toolkit/fresh) algorithm for feature extraction and selection on structured time series data. 

The library is available [here](https://github.com/KxSystems/ml)

<i class="far fa-hand-point-right"></i> [Example notebooks of FRESH and various toolkit functionality](https://github.com/KxSystems/ml/tree/master/fresh/notebooks) 

## embedPy

[EmbedPy](embedpy/) loads Python into kdb+, allowing access to a rich ecosystem of libraries such as scikit-learn, tensorflow and pytorch.

-   Python variables and objects become q variables – and either language can act upon them. 
-   Python code and files can be embedded within q code.
-   Python functions can be called as q functions.

<i class="far fa-hand-point-right"></i> [Example notebooks using embedPy](https://github.com/KxSystems/mlnotebooks)


## Anaconda

Users can now install kdb+ along with our supported Python and Machine Learning libraries, embedPy and jupyterq using the popular [Anaconda](https://anaconda.org/) package-management system `conda`.


## JupyterQ

[JupyterQ](jupyterq/) supports Jupyter notebooks for q, providing

-   Syntax highlighting, code completion and help
-   Multiline input (script-like execution)
-   Inline display of charts


All machine-learning libraries are:

-   well **documented**, with understandable and useful examples
-   maintained and **supported** by Kx on a best-efforts basis, at no cost to customers
-   released under the **Apache 2 license**
-   **free** for all use cases, including 64-bit and commercial use

Commercial support is available if required: please email sales@kx.com.

