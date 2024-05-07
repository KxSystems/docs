Documentation for kdb+ and q
============================



Version 2.0 of the documentation site at [code.kx.com/q](https://code.kx.com/q).



Platform
--------

This site is generated with the [MkDocs](https://mkdocs.org/) static-site generator, with the [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) theme. 

See [`install.md`](CONTRIBUTING/install.md) for how to compile the site. 


Not upwardly compatible
-----------------------

Version 2.0 substantially reorganizes the URL structure of the site. 
Most keywords and operators now have short URLs, e.g. code.kx.com/q/ref/aj and code.kx.com/q/ref/fill. 

This marks a break from [Version 1.0](https://github.com/kxsystems/docs-v1/). 
There is no Git continuity between the two repos. 

The terminology revision begun in Version 1.0 is complete: _adverbs_ are now _iterators_. The Reference material for them has been completely rewritten and the 2013 whitepaper “Efficient use of adverbs” re-issued as [“Iterators”](https://code.kx.com/q/wp/iterators/). The concept of _rank_ is extended from functions to all applicable values. _Variadic_ replaces _ambivalent_ for values (e.g. derived functions and matrixes) that may be applied as either unary or binary. 

The Cookbook articles are now in the [Knowledge Base](https://code.kx.com/q/kb/).


