---
hero: <i class="fa fa-share-alt"></i> Machine learning 
keywords: embedpy, interface, kdb+, python
title: embedPy - code.kx.com
---

# ![Python](../../interfaces/img/python.png) embedPy


<div class="fusion" markdown="1">
<i class="fab fa-superpowers"></i> [Fusion for kdb+](../../interfaces/fusion.md)
</div>

Allows the kdb+ interpreter to manipulate Python objects and call Python functions.


## Requirements

-   kdb+ ≥3.5 64-bit
-   Python ≥3.5


## Build and install

<i class="fa fa-download"></i> Download the code from <i class="fab fa-github"></i> [KxSystems/embedPy](https://github.com/kxsystems/embedpy) and follow installation instructions there.


## Back-incompatible changes

### V0.2-beta -> V1.0

-   Attribute access from embedPy object 
<pre><code class="language-q">
/ old
q)obj\`ATTRNAME
/ new
q)obj\`:ATTRNAME
</code></pre>

-   embedPy objects can be called directly without explicitly specifying the call return type, the default return type is an embedPy object


### V0.1-beta -> V0.2beta in V0.2-beta

V0.2-beta features a number of changes back-incompatible with the previous release, V0.1-beta. 

Most notably, the default _type_ used in many operations is now the embedPy type, rather than the foreign type. Differences between these types (and the associated APIs) are set out below. 



