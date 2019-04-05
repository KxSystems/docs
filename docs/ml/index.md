---
title: Machine learning - code.kx.com
keywords: Python, Jupyter, natyural laguage processing, nlp, machine learning, ml, sentiment, Anaconda, Docker
---

# <i class="fas fa-share-alt"></i> Machine learning

![Machine learning](../img/ml.png)


**Machine-learning** capabilities are at the heart of future technology development at Kx. Libraries are added here as they are released. Libraries are released under the Apache 2 license, and are free for all use cases, including 64-bit and commercial use.

<i class="far fa-hand-point-right"></i> [How to set up](setup) kdb+ to create a machine-learning environment using either Anaconda, Docker or a manual build.

## Natural Language Processing 

[NLP](nlp) was the first module within the machine-learning suite, it manages the common functions associated with processing unstructured text. Functions for searching, clustering, keyword extraction and sentiment are included, the library is available [here](https://github.com/KxSystems/nlp).

<i class="far fa-hand-point-right"></i> [Demonstration notebook](https://github.com/KxSystems/mlnotebooks/blob/master/notebooks/ML07%20Natural%20Language%20Processing.ipynb)

## Machine Learning Toolkit

The [Machine Learning Toolkit](toolkit/) is at the core of q centered machine learning functionality. This library contains functions that cover the following areas.

-  Accuracy [metrics](toolkit/utilities/metric.md) to test the performance of constructed machine learning models.
-  [Pre-processing](toolkit/utilities/preproc.md) data prior to the application of machine learning algorithms.
-  An implementation of the [FRESH](toolkit/fresh.md) algorithm for feature extraction and selection on structured time series data. 
-  [Utility](toolkit/utilities/util.md) functions which are useful in many machine learning applications but do not fall within the other sections of the toolkit.

The library is available [here](https://github.com/KxSystems/ml).

<i class="far fa-hand-point-right"></i> [Example notebooks showing FRESH and various aspects of toolkit functionality](https://github.com/KxSystems/ml/tree/master/fresh/notebooks) 

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
