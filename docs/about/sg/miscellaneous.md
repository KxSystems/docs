---
title: Style Guide – Miscellaneous
hero: Site style guide
description: Miscellaneous rules for writing for code.kx.com
author: Stephen Taylor
keywords: kdb+, number, place, q, refactor, style
---

# <i class="fas fa-pen-nib"></i> Miscellaneous


## Refactor

Refactor your prose as you would your code:

-   prefer terser expressions where they do not obstruct readability
-   remove duplication, for example, moving repeated phrasing from list items to the list’s preamble 
-   find ways to simplify expressions 


## Mood 

Prefer the active mood. For example, prefer

> Prefer the active mood.

to

> The active mood is to be preferred. 

<i class="far fa-hand-point-right"></i> [_The Complete Plain Words_](https://en.wikipedia.org/wiki/The_Complete_Plain_Words)


## Numbers 

Use words for numbers of things, e.g. “there are three ways to achieve this”, up to a hundred. Use numbers to refer to numbers themselves, e.g. “and adds 2 to the total”.


## Place names

Use English place names. Thus _Copenhagen_ not _København_; _Milan_ not _Milano_, and _Zurich_ not _Zürich_.

Using place names correctly in a foreign language is a mark of competence.
Using them in English is showing off. 


## Only

_Only_ is a crucial qualifier in documentation. Place it beside what you intend to qualify.

The reader can usually resolve any ambiguity by eliminating unlikely interpretations. Not always. 
Placing _only_ in the right place relieves her of this work. 

_The function will **only return** 0 if an error occurs._
: If an error occurs, the function will do nothing but _return_ the result of 0. It won’t also _set_ 0 as the value of a variable, _write_ 0 to file… 

    Here _only_ qualifies _return_. 

_The function will return **only 0** if an error occurs._
: If an error occurs, the function returns nothing but a solitary _zero_. Otherwise it may return anything. (Including a zero.) 

    Here _only_ qualifies _0_. 

_The function will return 0 **only if** an error occurs._
: _If_ an error occurs the function will return a zero. Otherwise it will return something else. 

    Here _only_ qualifies _if_. 

