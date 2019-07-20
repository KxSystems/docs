---
title: Style Guide – Characters and encoding
hero: Site style guide
description: Rules for the ncoding vof Markdown source files, choices of characters, how to use quotation marks, how to write acronyms and abbreviations.
author: Stephen Taylor
keywords: acronym, abbreviation, ampersand, apostrophe, dash, ellipse, encoding, hyphen, latex, ligature, math, quotation, quote, unicode
---
# <i class="fas fa-pen-nib"></i> Characters and encoding 


## Encoding

For Markdown source files use only UTF-8 encoding with no BOM (byte-order mark).

Prefer **actual Unicode characters** – which a modern text editor will display correctly – to both character entities and HTML character entities, which degrade the readability of the source. (HTML character entities are more readable than character entities, but different browsers support different subsets of them.) Thus, use `π` rather than `&#928;` or `&pi;`. 

-   <i class="fab fa-windows"></i> Windows allows many characters to be typed as ASCII codes from the numeric keyboard, eg Alt+0215 for ×. (See the [W3C list of HTML character entity references](http://www.w3.org/TR/html401/sgml/entities.html#h-24.2) for codes.) 
-   <i class="fab fa-apple"></i> Mac OS X provides a graphical palette of Unicode characters. 

If a character proves particularly difficult to source (for example, the romaji O-micron), try using its character entity, displaying the result in a browser, then copying and pasting the character from the browser back into the source. (It is a good idea in such cases to leave the character entity embedded as a comment.)

Use **real ellipses** (…) because three periods can be broken across lines or pages. 

-   <i class="fab fa-windows"></i> In Windows Alt+0133 on the numeric keypad 
-   <i class="fab fa-apple"></i> On Mac, Opt+;

[Ligatures](https://en.wikipedia.org/wiki/Glyph) are typesetters’ tools for setting two letters together. Reserve _æ_ for languages, such as Danish and Norwegian, in which it is a distinct character, not for words such as _mediaeval_.


## Math

Set a LaTeX equation on its own line, starting and ending with `$$`.

Embrace a LaTeX expression in single dollar signs, e.g. `$n-1$`. 

Escape dollar signs in plain text, e.g. `this costs \$4.99 or less`.


## Quotation and quote marks

quotation mark              | character | usage
----------------------------|-----------| -----
single typewriter quote     | `'`       | only in code
double typewriter quote     | `"`       | only in code
typographers’ double quotes | `“”`      | reported speech or verbatim quotation, titles of published articles
single typographer’s quote  | `’`       | as apostrophe; to remove emphasis

_Removing emphasis_ is the opposite of emphasis. The words de-emphasised are not to be understood as carrying their literal sense. 

> At the conference he said, “Today I’d like to talk to you about the ‘vision thing’ you’ve heard so much about.”

Do not use apostrophes to form plurals. 

The possessive of a word ending in _s_ is formed with a trailing apostrophe. 
For example:

> Many MPs say that, unlike most MPs’ expenses, this MP’s expenses are questionable.

> People in their 60s know “St James’ Infirmary Blues” was not 1967’s biggest hit, not even one of the 1960s’ biggest hits. 


## Acronyms, abbreviations and truncations

Set **acronyms** (pronounceable or not) in upper case without periods, e.g. _IBM_ not _I.B.M._, _HTTP_ not _http_. 

**Abbreviations** are formed by omitting characters from the middle of a word, **truncations** by omitting characters from the end. Suffix a truncation with a period; not so with abbreviations. For example

-   Dr Kenneth E. Iverson
-   Mr & Mrs J. Smith 
-   M. le President 


## Comma

Use the [serial or ‘Oxford’ comma](https://en.wikipedia.org/wiki/Serial_comma) where necessary to avoid ambiguity. 

The **Oxford comma** cannot safely be used without thought. 

-   It can resolve ambiguity in a list.
-   It can introduce ambiguity into a list.
-   Some lists have ambiguities that its use or omission do not resolve; such ambiguity may be resolved only by rephrasing.

<i class="far fa-hand-point-right"></i> _Wikipedia:_ [Serial comma](https://en.wikipedia.org/wiki/Serial_comma)

Commas can have semantic force outside lists, e.g. _Let’s eat, Grandma!_



## Hyphens and dashes

Hyphenate **adjectival phrases**, e.g. _real-time systems do things in real time_. 

Use **spaced endashes** for parenthetical remarks – such as this one – but never hyphens or unspaced emdashes. (The longer emdash—like this—is the more common style in American typography.)


## Ampersands

Use sparingly, not simply as a synonym for _and_, but to mark an association closer than conjunction.

Thus, _Kernigan & Ritchie_ and _Proctor & Gamble_, but _authentication and access control_.

**Exception** Where an ampersand is part of a label on a UI control, reproduce it faithfully.
