---
title: JupyterQ – Machine Learning – kdb+ and q documentation
description: Jupyter kernel for kdb+ provides syntax highlighting for q; code completion for q keywords, and namespace functions, and user-defined variables; code help for q keywords and basic help (display and type information) for user-defined objects; script-like execution of code (multiline input); inline display of charts created using embedPy, matplotlib, seaborn etc.; console stdout/stderr capture and display in notebooks; inline loading and saving of scripts into and from notebook cells
keywords: anaconda, jupyter, kdb+, kernel, notebook, python, q
---

# ![Jupyter](../../interfaces/img/jupyter.png) JupyterQ

:fontawesome-brands-superpowers: [Fusion for kdb+](../../interfaces/fusion.md)
{: .fusion}



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
-   [embedPy](https://github.com/KxSystems/embedPy)


## Build and install

:fontawesome-solid-download: Download the code from :fontawesome-brands-github: [KxSystems/JupyterQ](https://github.com/kxsystems/jupyterq) and follow the instructions there.

JupyterQ can also be downloaded through Conda install as follows

```bash
conda install -c kx jupyterq
```

This download will install both kdb and embedPy if not previously installed within the Conda environment.


## Using notebooks

See the notebook `kdb+Notebooks.ipynb` for full interactive examples and explanation, also [viewable on GitHub](https://github.com/KxSystems/jupyterq/blob/master/kdb%2BNotebooks.ipynb).
