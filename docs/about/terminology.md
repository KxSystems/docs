---
title: Terminology | q and kdb+documentation
description: In 2018-2019 the vocabulary used to describe the q language changed. Here is how and why.
author: Stephen Taylor
date: October 2019
---
# :fontawesome-solid-pen-nib: Terminology

[![Bob Dylan](../img/faces/bobdylan.jpg)](https://prruk.org/how-prophetic-was-bob-dylan-when-he-said-the-times-were-a-changing/)
{: .small-face}

And the words that are used for to get this ship confused<br>
Will not be understood as they are spoken<br>
— _Bob Dylan_ “When the ship comes in”
{: style="opacity:.5"}

In 2018 and 2019 the vocabulary used to describe the q language changed. Why?

The q language inherited from its ancestor languages (APL, J, A+, k) syntactic terms that made the language seem more difficult to learn than it really is.

So we changed them.


## Inheritance

[Iverson](https://en.wikipedia.org/wiki/Kenneth_E._Iverson) wrote his seminal book _A Programming Language_ at Harvard with [Fred Brooks](https://en.wikipedia.org/wiki/Fred_Brooks) as a textbook for the world’s first computer-science courses. He adopted [Heaviside](https://en.wikipedia.org/wiki/Oliver_Heaviside)’s term for higher-order functions: _operator_. It did not catch on. The term retains this usage in the APL language, but in other languages denotes simple functions such as addition and subtraction. Similarly Iverson’s _monadic_ and _dyadic_ are better known as _unary_ and _binary_.

In 1990 Iverson and [Hui](https://en.wikipedia.org/wiki/Roger_Hui) published a reboot of APL, the J programming language. Always alert to the power of metaphor, they referred to the syntactic elements of J as _nouns_, _verbs_, and _adverbs_, with the latter two denoting respectively functions and higher-order functions. Canadian schools used to teach more formal grammar than other English-speaking countries. Perhaps this made the metaphor seem more useful than it now is.

In 2017 an informal poll in London of senior q programmers found none able to give a correct definition of _adverb_ in either English or q. Iverson & Hui’s metaphor no longer had explanatory value.

Worse, discussions with the language implementors repeatedly foundered on conflicting understandings of terms such as _verb_ and _ambivalent_.

The terms we had inherited for describing q were obstacles in the path of people learning the language. We set out to remove the obstacles.


## Revision

In revising, our first principle was to use familiar programming-language terms for familiar concepts. So `+` and `&` would be _operators_. Primitive functions with reserved words as names became _keywords_. We had no role for _verb_. Functions defined in the functional notation would be _lambdas_, anonymous or not. Operators, keywords, and lambdas would all be _functions_. _Monadic_, _dyadic_, and _triadic_ yielded to _unary_, _binary_, and _ternary_.

Removing _verb_ drained the noun-verb-adverb metaphor of whatever explanatory power it once had. Many candidates were considered as replacements. _Iterator_ was finally adopted at a conference of senior technical staff in January 2019.

The isomorphism between functions, lists and dictionaries is a foundational insight of q. It underlies the syntax of Apply and Index. Defining

-   the application of functions
-   the indexing of arrays
-   the syntax and semantics of iterators

requires a portmanteau term for the valence of a function or the dimensions of an array. We follow the usage of J in denoting this as _rank_, despite the `rank` keyword having a quite different meaning.


## Changes

The following tabulates the changes in terminology.
The new terms are used consistently on this site.

Training materials must adopt them to ensure consistency with reference articles.

old         | new
------------|---------
adverb      | iterator
ambivalent  | variadic
char vector | string
dimensions  | rank
dyadic      | binary
monadic     | unary
niladic     | nullary
triadic     | ternary
valence     | rank
verb        | operator
verb        | keyword



## Recommendations

Consistency helps the reader. Variations in terminology that do not mark a distinction add to the reader’s cognitive load.

This site uses the following terms consistently. If you are writing about q, we recommend you adopt them too.

deprecated       | preferred
-----------------|-----------------
array            | list
element          | item, list item
indices          | indexes
input, parameter | argument
matrices         | matrixes
output           | result

----
:fontawesome-solid-book-open:
[Glossary](../basics/glossary.md)



