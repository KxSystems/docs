---
title: Machine learning | kdb+ and q documentation
description: Machine-learning capabilities are at the heart of future technology development at KX. Libraries are added here as they are released. Libraries are released under the Apache 2 license, and are free for all use cases, including 64-bit and commercial use.
---
# :fontawesome-solid-share: Machine learning


![Machine learning](img/ml.png)


**Machine-learning** capabilities are at the heart of future technology development at KX. 

Our libraries are released under the Apache 2 license, and are free for all use cases, including 64-bit and commercial use.

## Machine Learning Toolkit

:fontawesome-brands-github:
[KxSystems/ml](https://github.com/KxSystems/ml)

The Machine Learning Toolkit is at the core of our machine-learning functionality. This library contains functions that cover the following areas.

-  Accuracy [metrics](https://github.com/KxSystems/ml/tree/master/util) to test the performance of constructed machine-learning models.
-  [Pre-processing](https://github.com/KxSystems/ml/tree/master/util) data prior to the application of machine-learning algorithms.
-  An implementation of the [FRESH](https://github.com/KxSystems/ml/tree/master/fresh) algorithm for feature extraction and selection on structured time series data. 
-  [Utility](https://github.com/KxSystems/ml/tree/master/util) functions which are useful in many machine-learning applications but do not fall within the other sections of the toolkit.
-  [Cross-Validation](https://github.com/KxSystems/ml/tree/master/xval) functions, used to verify how robust and stable a machine-learning model is to changes in the data being interrogated and the volume of this data.
- [Clustering algorithms](https://github.com/KxSystems/ml/tree/master/clust) used to group data points and to identify patterns in their distributions. The algorithms make use of a [k-dimensional tree](https://github.com/KxSystems/ml/tree/master/clust) to store points and [scoring functions](https://github.com/KxSystems/ml/tree/master/clust) to analyze how well they performed.

### Example notebooks

:fontawesome-brands-github:
[KxSystems/mlnotebooks](https://github.com/KxSystems/mlnotebooks)

Example notebooks show FRESH and various aspects of toolkit functionality.


## Natural Language Processing 

:fontawesome-brands-github:
[KxSystems/nlp](https://github.com/KxSystems/nlp)

NLP manages the common functions associated with processing unstructured text. Functions for searching, clustering, keyword extraction and sentiment are included in the library.

:fontawesome-solid-hand-point-right:
[Demonstration notebook](https://github.com/KxSystems/mlnotebooks/blob/master/notebooks/08%20Natural%20Language%20Processing.ipynb)


## Automated Machine Learning

:fontawesome-brands-github:
[KxSystems/automl](https://github.com/KxSystems/automl)

AutoML is a framework to automate the process of machine learning using kdb+. This is build largely on the machine learning toolkit and handles the following aspects of a traditional machine-learning pipeline:

1.  Data preprocessing
2.  Feature engineering and feature selection
3.  Model selection
4.  Hyperparameter tuning
5.  Report generation and model persistence

:fontawesome-solid-hand-point-right:
[Demonstration notebook](https://github.com/KxSystems/mlnotebooks/blob/master/notebooks/10%20Automated%20Machine%20Learning.ipynb)


## embedPy

:fontawesome-brands-github:
[KxSystems/embedPy](https://github.com/KxSystems/embedpy)

EmbedPy loads Python into kdb+/q, allowing access to a rich ecosystem of libraries such as scikit-learn, tensorflow and pytorch.

-   Python variables and objects become q variables – and either language can act upon them. 
-   Python code and files can be embedded within q code.
-   Python functions can be called as q functions.

:fontawesome-solid-hand-point-right:
[Example notebooks using embedPy](https://github.com/KxSystems/mlnotebooks)


## JupyterQ

:fontawesome-brands-github:
[KxSystems/JupyterQ](https://github.com/KxSystems/jupyterq)

JupyterQ supports Jupyter notebooks for q, providing

-   Syntax highlighting, code completion and help
-   Multiline input (script-like execution)
-   Inline display of charts


## Technical papers

-   [NASA FDL: Analyzing social media data for disaster management](wp/disaster-management/index.md)<br>Conor McCarthy, 2019.10
-   [NASA FDL: Predicting floods with q and machine learning](wp/disaster-floods/index.md)<br>Diane O’Donoghue, 2019.10
-   [An introduction to neural networks with kdb+](wp/neural-networks/index.md)<br>James Neill, 2019.07
-   [NASA FDL: Exoplanets Challenge](wp/exoplanets/index.md)<br>Esperanza López Aguilera, 2018.12
-   [NASA FDL: Space Weather Challenge](wp/space-weather/index.md)<br>Deanna Morgan, 2018.11
-   [Using embedPy to apply LASSO regression](wp/embedpy-lasso/index.md)<br>Samantha Gallagher, 2018.10
-   [K-Nearest Neighbor classification and pattern recognition with q](wp/machine-learning/index.md)<br>Emanuele Melis, 2017.07


---

The KX machine-learning libraries are:

-   well **documented**, with understandable and useful examples
-   maintained and **supported** by KX on a best-efforts basis, at no cost to customers
-   released under the **Apache 2 license**
-   **free** for all use cases, including 64-bit and commercial use

Commercial support is available if required: please email sales@kx.com.

