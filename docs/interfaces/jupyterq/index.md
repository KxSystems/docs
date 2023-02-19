---
title: JupyterQ | Machine Learning | kdb+ and q documentation
description: Jupyter kernel for kdb+ provides syntax highlighting, code completion, and code help for q; script-like execution of code (multiline input); inline display of charts; console stdout/stderr capture and display in notebooks; inline loading and saving of scripts 
---

# ![Jupyter](jupyter.png) Jupyter notebooks (JupyterQ)

:fontawesome-brands-superpowers: [Fusion for kdb+](../fusion.md)
{: .fusion}


JupyterQ provides a kdb+/q user with a kdb+/q kernel for the Jupyter project. This allows users to create Jupyter Notebooks and use JupyterHub both of which are very commonly used within the data science community.

[Jupyter](https://jupyter.org/) kernel for kdb+.

-   Syntax highlighting for q
-   Code completion for q keywords, `.z`, `.h`, `.Q`, `.j` namespace functions, and user-defined variables
-   Code help for q keywords and basic help (display and type information) for user-defined objects
-   Script-like execution of code (multiline input)
-   Inline display of charts created using embedPy, matplotlib, seaborn etc.
-   Console stdout/stderr capture and display in notebooks
-   Inline loading and saving of scripts into and from notebook cells


## Requirements 

-   kdb+ ≥ v3.5 64-bit
-   Anaconda Python 3.x
-   :fontawesome-brands-github: [embedPy](https://github.com/KxSystems/embedPy)


## Build and install

:fontawesome-solid-download: Download the code from :fontawesome-brands-github: [KxSystems/JupyterQ](https://github.com/kxsystems/jupyterq) and follow the instructions there.

JupyterQ can also be downloaded through Conda install as follows

```bash
conda install -c kx jupyterq
```

This download will install both kdb and embedPy if not previously installed within the Conda environment.


## Using notebooks

See the notebook `kdb+Notebooks.ipynb` for full interactive examples and explanation, also [viewable on GitHub](https://github.com/KxSystems/jupyterq/blob/master/kdb%2BNotebooks.ipynb).
