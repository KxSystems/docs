---
author: Conor McCarthy
date: October 2018
keywords: machine learning, ml, feature extraction, feature selection, time series forecasting, utilities, interpolation, filling, statistics, kdb+, q
---

# <i class="fa fa-share-alt"></i> Machine-learning toolkit


<i class="fab fa-github"></i>
[KxSystems/ml](https://github.com/kxsystems/ml/)

The toolkit contains a number of libraries and scripts. 
These have been produced to provide kdb+ users with general-use functions and procedures to perform machine-learning tasks on a wide variety of datasets.

The toolkit contains:

-   [Utility functions](utils.md) relating to important aspects of machine learning including data preprocessing and statistical testing, and includes functions useful in many machine-learning applications. 

-   An [implementation of the FRESH](fresh.md) (FeatuRe Extraction and Scalable Hypothesis testing) algorithm in q. 
    This lets a q/kdb+ user perform feature-extraction and feature-significance tests on structured time-series data for forecasting, regression and classification. 

Over time the machine-learning functionality in this library will be extended to include

-   q-specific implementations of machine-learning algorithms
-   broader functionality


## Requirements

The following requirements cover all those needed to run the libraries in the current build of the toolkit.

-   [embedPy](../embedpy/)

A number of Python dependencies also exist for the running of embedPy functions within both the the machine-learning utilities and FRESH libraries. 
These can be installed as outlined at

<i class="fab fa-github"></i>
[KxSystems/ml](https://github.com/kxsystems/ml) 
using `pip`

```bash
pip install -r requirements.txt
```

or via `conda`;

```bash
conda install --file requirements.txt
```

!!! warning "Running notebooks"

    Running notebooks within the [Utilities](utils.md) and [FRESH](fresh.md) sections requires [JupyterQ](../jupyterq/) as well as embedPy.
    However this is not a requirement for the toolkit itself.


## Installation

Copy (a link to) the library into `$QHOME` to install and load all libraries using

```q
q)\l ml/ml.q
q).ml.loadfile`:init.q
```

