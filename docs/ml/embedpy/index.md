---
title: embedPy
description: embedPy allows the kdb+ interpreter to manipulate Python objects and call Python functions.
keywords: embedpy, interface, kdb+, python
---
# <i class="fab fa-python"></i> embedPy



<div class="fusion" markdown="1">
<i class="fab fa-superpowers"></i> [Fusion for kdb+](../../interfaces/fusion.md)
</div>



## Requirements

-   kdb+ ≥3.5 64-bit
-   Python ≥ 3.5 (macOS/Linux) ≥ 3.6.0 Windows


## Build and install

<i class="fas fa-download"></i>
Download the code from
<i class="fab fa-github"></i>
[KxSystems/embedPy](https://github.com/kxsystems/embedpy) and follow installation instructions there.

EmbedPy can also be downloaded through a Conda install as follows

```bash
conda install -c kx embedpy
```

This download will install kdb+ if not previously installed within the Conda environment.


## Back-incompatible changes

### V0.2-beta -> V1.0

-   Attribute access from embedPy object
    <pre><code class="language-q">
    q)obj\`ATTRNAME     / old
    q)obj\`:ATTRNAME    / new
    </code></pre>

-   embedPy objects can be called directly without explicitly specifying the call return type, the default return type is an embedPy object


### V0.1-beta -> V0.2beta in V0.2-beta

V0.2-beta features a number of changes back-incompatible with the previous release, V0.1-beta.

Most notably, the default _type_ used in many operations is now the embedPy type, rather than the foreign type.

