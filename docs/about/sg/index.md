---
title: Style guide for code.kx.com
hero: Site style guide
description: Typographical, spelling, markup and lexical conventions for the q and kdb+ documentation site
author: Stephen Taylor
keywords: convention, kdb+, q, style, spelling, typography
---

# <i class="fas fa-pen-nib"></i> Style guide


Here are typographical, spelling and lexical conventions for the content of this site.


## Scope

They apply to 

-   Markdown source files for code.kx.com, hosted at <i class="fab fa-github"></i> [KxSystems/docs](https://github.com/kxsystems/docs)
-   Technical Whitepapers prepared as PDFs for code.kx.com 

## Purpose

The conventions have two objects.

The first is essential to the working of the site’s custom search engine. 
The site’s build script compiles an index. 
To do this it parses the Markdown source files. 
It is less tolerant than the MkDocs site generator. 
For example, MkDocs recognizes `~~~` as a code fence, and the language suffix is optional. 
Our indexing script does not. 
It recognizes only backtick code fences, and requires language suffixes to them. 

The second object of these conventions is to remove ambiguity. In practice, they rarely do, because in most instances of potential ambiguity the author’s intent can be deduced by an intelligent reader. 

They nonetheless sometimes have important work to do. 
For example:

> For unary values the keyword `over` is preferred over the iterator Over, e.g. for unary `f`, write `f over` rather than `f/`.

!!! important "The value of consistency"
    
    Consistent observation of the conventions relieves the reader of the cognitive load of resolving ambiguities, and raises the value of the documentation. 


## Summary

Here are the most important – or most commonly neglected – rules.

-   Use **American spelling**, e.g. _customize_ not _customise_
-   Use the **revised terminology** to describe the grammar of q
-   Use **sentence case** for headings, with minimal punctuation and no final periods, e.g. _Coding conventions for interfaces_, not _Coding Conventions for Interfaces._
-   Use **bold type** for keywords to assist a visual search. 
-   Use **italic type** for
    -   emphasis 
    -   to refer to a section by its heading, e.g. see _Machine learning_
    -   to denote a word rather than its meaning, e.g. “It can be difficult to search for words like _like_ and _and_.”
    -   titles of books, journals, films and record albums (with sentence case), e.g. _Q For Mortals_
-   Use **double typographer’s quotes** around 
    -   reported speech, e.g. “Go away,” he said.
    -   titles of articles, essays, and scholarly papers
-   Use **single typographer’s quotes** 
    -   to denote possession (but never plurals), e.g. 1983’s hit “Oobop Shebam” was her best work in the 1980s, and perhaps the 1980s’ favorite song.
    -   to remove emphasis, i.e., when a word or phrase is not meant literally 
-   Use **typewriter quotes** only in code elements, e.g. `ssr'[x;y;z]`
-   Use **spaced endashes** for parenthetical phrases – such as this – not spaced hyphens and not emdashes, spaced or unspaced. 
-   Use **numbered lists** (or headings) only when there are multiple references to the numbers; otherwise use bulleted lists. 
-   In Markdown use backtick **code fences** to delimit code blocks, and label them with the corresponding language.
-   Use [Grammarly](https://www.grammarly.com/) to proof your text before submitting it for review. 


## References

-   [**Grammarly**](https://www.grammarly.com) checks spelling and grammar
-   **Markdown** original definition at [Daring Fireball](https://daringfireball.net/projects/markdown/) 
-   [**MkDocs**](https://mkdocs.org): static site generator
-   [**Material for MkDocs**](https://squidfunk.github.io/mkdocs-material/): Material theme for code.kx.com
-   [**PyMdown**](https://squidfunk.github.io/mkdocs-material/extensions/pymdown/): Markdown extension for the Material theme
-   [**Prism.js**](http://prismjs.com/): code syntax highlighting
-   [**FontAwesome**](http://fontawesome.io/icons/) icons


