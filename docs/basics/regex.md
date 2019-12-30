---
title: Regular expressions in q | Basics | q and kdb+ documentation
description: Syntax of regular expressions in q
author: Stephen Taylor
date: December 2019
---
# Regular expression syntax


Keywords [`like`](../ref/like.md), [`ss`, and `ssr`](../ref/ss.md) interpret their second arguments as a limited form of [Regular Expression](https://en.wikipedia.org/wiki/Regular_expression "Wikipedia") (regex).

In a q regex pattern certain characters have special meaning:

char | meaning
---- | -----------------------------------------------------------
`?`  | matches any character
`*`  | matches any sequence of characters
`[]` | embraces a list of alternatives, any of which matches


## Wildcard

A `?` in the pattern matches any character. 

```q
q)("brown";"drown";"frown";"grown") like "?rown"
1111b
q)"the brown duck drowned" ss "?rown"
4 15
```


## List of alternatives

A list of alternatives is embraced by square brackets. 

Syntax: `[^] + [char|range]{1,}`

where

-   `char` is a character atom
-   `range` has the form `0-9`, `a-z`, or `A-Z`

Beginning the list with a caret makes the list match any characters _except_ those listed. 

```q
q)"brown" like "[bf]rown"
1b
q)"brown" like "[^cf]rown"
1b
q)"br^wn" like "br[&^]wn"
1b
```

The list can include ranges of the form `0-9`, `a-z`, and `A-Z`.

```q
q)"brAwn" like "br[A-Z]wn"
1b
q)"br0wn" like "br[0-3]wn"
1b
q)"br0wn" like "br[3-6]wn"
0b
q)"br0wn" like "br[^3-6]wn"
1b
```

Within a list of alternatives `?` and `*` are not wildcards.

```q
q)"brown" like "br?*wn"
1b
q)"brown" like "br[?*]wn"
0b
```

The only way to match these characters and _only_ these characters is to embrace them as lists of alternatives.

```q
q)"br*wn" like "br[*]wn"
1b
q)"br?wn" like "br[?]wn"
1b
```

The only way to match a square bracket is with a wildcard.

```q
q)"[grown]" like "?grown?"
1b
```


## Arbitrary sequence

!!! warning "There are limits to matching patterns containing `*`"


### `ss`, `ssr`

A `*` in a pattern matches a sequence of any length. That includes empty strings.

```q
q)"brown" like "br?*wn"
1b
q)"brown" like "br*?wn"
1b
```

Empty strings are everywhere. 

```q
q)"A grown man in a gown" ss "rown"
,3
q)"A grown man in a gown" ss "own"
4 18
q)"A grown man in a gown" ss "n"
6 10 13 20
q)"A grown man in a gown" ss ""
'length
  [0]  "A grown man in a gown" ss ""
                               ^
```

With patterns containing `*`, keywords `ss` and `ssr` signal a `length` error.

```q
q)s:"Now is the time for all good men to come to the aid of the party."
q)s ss "t?e"
7 44 55
q)s ss "t*e"
'length
  [0]  s ss "t*e"
         ^
```


### `like`

Some patterns with `*` are too difficult to match. 
They produce a `nyi` error.

```q
q)s like "*the*"
1b
q)s like "*the*the*"
'nyi
  [0]  s like "*the*the*"
         ^
q)s like "*the*the"
'nyi
  [0]  s like "*the*the"
         ^
```


<i class="fas fa-graduation-cap"></i>
[Using regular expressions](../kb/regex.md)