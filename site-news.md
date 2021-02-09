Site news
=========


## Navigation

<small>2020.11.15</small>

We revised site navigation to group content more clearly, with new sections:

section      | content
-------------|---------
Language     | combines what was previously Reference and Basics; now holds all content describing the q programming language.
Database     | kdb+ is what happens when q tables get persisted to, and loaded from, the filesystem.
Developing   | Tools for developers; advanced programming techniques; tips for DevOps with kdb+.
Architecture | The typical kdb+ application has multiple kdb+ processes collaborating with other processes. Here is how to put them together.

Most articles and their URLs remain the same. 
White papers now appear with their LHS nav showing related articles. 



## Kx wiki (1993-2016) 

<small>2019.10.05</small>

The old wiki has now been taken off life support at /oldwiki. 
_Requiescat in pacem_. 

If this causes you a problem, please contact the [Librarian](mailto:librarian@kx.com).


## V1

<small>2019.04.15</small>

Version 1 – with URLs beginning `/q` – has been removed. 
Most URLs beginning `code.kx.com/q` now return 404s. 
URLs beginning `code.kx.com/wiki` do the same.
We apologise for the undoubted inconvenience. 

We have taken this drastic step after a failed campaign to dissuade Google Search from returning wiki and V1 pages in its top results. 
It appeared that its own history of referrals to the old material outweighed sitemaps and X-Robots metatags.

We expect Google Search to catch up soon.


## V2

<small>2019.03.07</small>

Version 2 of this site has

-   extensive revision of the Reference, including 
-   a completely new description of the _iterators_ (formerly _adverbs_), completing the terminology review that started in 2016
-   simplified URLs for Reference articles
-   a new version, [Iterators](../wp/iterators/index.md) of the 2013 white paper “Efficient use of adverbs”
-   HTTP requests redirected to HTTPS 
-   An updated version of :fontawesome-brands-github: [`help.q`](https://github.com/kxsystems/help)

The Kx wiki, frozen in 2016, has been retired to code.kx.com/oldwiki.


## Kx@25

<small>2018.05.18</small>

Announcements to mark our 25th birthday:

-   [Kdb+ on Google Cloud Platform](../cloud/gcpm/index.md)
-   [Version 3.6](../releases/ChangesIn3.6.md)
-   [Anaconda](../ml/index.md)
-   [Natural Language Processing toolkit](../ml/nlp/index.md)
-   [Docker and Notebooks](../ml/setup.md#docker-command)
-   [JupyterQ FAQ](../ml/jupyterq/index.md#frequently-asked-questions)



## New development tools

<small>2018.03.01</small>

Listed on [GitHub](../github.md#development-tools): three new development tools  by legendary developer [Leslie Goldsmith](https://github.com/LeslieGoldsmith).

:fontawesome-regular-hand-point-right: [Kx blog](https://kx.com/blog/kdb-utilities-essential-utility-identifying-performance-problems/)


## Jupyter kernel for kdb+

<small>2018.01.30</small>

In beta on [GitHub](https://github.com/KxSystems/jupyterq): a Jupyter kernel for kdb+ 


##  Socket sharding on Linux

<small>2018.01.25</small>

New white paper [Socket sharding with kdb+ on Linux](../wp/socket-sharding/index.md)


## Machine learning

<small>2018.01.24</small>

New section on [Machine Learning](../ml/index.md) opens with the [embedPy](../ml/embedpy/index.md) library.


## Custom search engine

<small>2018.01.14</small>

We have replaced the native MkDocs client-side search engine with a custom search engine written in q. 

The large majority of visits to this site are from laptops and desktops, so the new search engine displays results as a page, rather than a popup list. 

The engine is still being developed. 
Please send your comments, suggestions and requests to librarian@kx.com. 


## Fusion interfaces

<small>2017.11.06</small>

The [Fusion interfaces](../interfaces/fusion.md) are libraries for connecting kdb+ to other technologies. The libraries are

-   written for non-kdb+ programmers to use
-   well documented, with understandable and useful examples
-   maintained and supported by Kx on a best-efforts basis, at no cost to customers
-   released under the [Apache 2 license](https://www.apache.org/licenses/LICENSE-2.0)
-   free for all use cases, including 64-bit and commercial use



## Syntax highlighting

<small>2017.08.09</small>

Replaced standard [MkDocs](https://www.mkdocs.org) [Pygments](http://pygments.org/) syntax highlighting with [Prism](https://prismjs.com): 

-   syntax highlighting for q
-   a _Copy to Clipboard_ button on all code blocks


## Creative Commons license

<small>2017.08.05</small>

The site content is now licensed under a <a rel="license" href="https://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>. 

<div style="text-align: center;"><a rel="license" href="https://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://licensebuttons.net/l/by/4.0/88x31.png" /></a></div>


## Terminology

<small>2017.06.15</small>

<blockquote style="border: none;">
    <p style="display: inline-block;">
        And the words that are used for to get this ship confused<br>  
        Will not be understood as they are spoken<br>
        — <i>Bob Dylan</i> “When the ship comes in” 
    </p>
    <p style="display: inline-block; padding: 0 1em;">
        <a href="https://www.bobdylan.com/albums/the-times-they-are-a-changin/" title="The Times they Are A’Changin’"><img alt="Bob Dylan" src="//code.kx.com/q/img/dylan.png" style="height: 70px"/></a>
    </p>
</blockquote>

We have revised the terms in which we talk about q, to align them with common usage. You will find _operators_ and _unary_ and _binary_ _functions_ applied _prefix_, _infix_ and _postfix_. Q’s _adverbs_ still need their distinctive name, but you will no longer find references to _verbs_, _monads_ or _dyads_. 

We also now distinguish consistently between glyphs and what they denote. In some cases we’ve coined new names to distinguish what was previously conflated. So, for example, `/` denotes Over, Converge, Do, and While. 

Overloads such as these are distinguished in use by syntax and arguments. Every operator, function and adverb now has its syntax and arguments consistently and clearly described. 


