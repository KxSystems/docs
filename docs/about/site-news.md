## <i class="fas fa-code"></i> Fusion interfaces

2017.11.06

The [Fusion interfaces](/interfaces/fusion) are libraries for connecting kdb+ to other technologies. The libraries are

-   written for non-kdb+ programmers to use
-   well documented, with understandable and useful examples
-   maintained and supported by Kx on a best-efforts basis, at no cost to customers
-   released under the [Apache 2 license](https://www.apache.org/licenses/LICENSE-2.0)
-   free for all use cases, including 64-bit and commercial use



## <i class="fas fa-code"></i> Syntax highlighting

<small>2017.08.09</small>

Replaced standard [MkDocs](https://mkdocs.org) [Pygments](http://pygments.org/) syntax highlighting with [Prism](http://prismjs.com): 

- syntax highlighting for q
- a _Copy to Clipboard_ button on all code blocks


## <i class="fas fa-balance-scale"></i> Creative Commons license

<small>2017.08.05</small>

The site content is now licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>. 

<div style="text-align: center;"><a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a></div>


## <i class="fas fa-search"></i> Search box

<small>2017.08.03</small>

Type a Return at the end of your query and it gets sent to Google Search. (Sadly, as Google no longer offers ad-free results even from paid-for custom searches, the results may include ads.) 

For single-character queries such as `?`, `$` and `@` use the [Reference card](../ref/index.md). 

<i class="far fa-hand-point-right"></i> [Other search tips](thissite.md/#search-tips)


## <i class="far fa-comment"></i> Terminology

<small>2017.06.15</small>

<blockquote style="border: none;">
    <p style="display: inline-block;">
        And the words that are used for to get this ship confused<br>  
        Will not be understood as they are spoken<br>
        — <i>Bob Dylan</i> “When the ship comes in” 
    </p>
    <p style="display: inline-block; padding: 0 1em;">
        <a href="http://bobdylan.com/albums/the-times-they-are-a-changin/" title="The Times they Are A’Changin’"><img alt="Bob Dylan" src="http://code.kx.com/q/img/dylan.png" style="height: 70px"/></a>
    </p>
</blockquote>

We have revised the terms in which we talk about q, to align them with common usage. You will find _operators_ and _unary_ and _binary_ _functions_ applied _prefix_, _infix_ and _postfix_. Q’s _adverbs_ are now _unary operators_. You will no longer find references to _verbs_, _monads_ or _dyads_. 

We also now distinguish consistently between glyphs and what they denote. For example, `'` denotes Case, Compose, Each, and Signal.

Overloads such as these are distinguished in use by syntax and arguments. Every operator and keyword now has its syntax and arguments consistently and clearly described; also, where appropriate, its argument and range types. 


