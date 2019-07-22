---
title: ss, ssr
description: ss and ssr are q keywords that perform string search and replacement.
author: Stephen Taylor
keywords: kdb+, match, pattern, q, regex, regular expression, replace, search, ss, ssr, string
---
# `ss`, `ssr`

_String search – and replace_




## `ss`

_String search_

Syntax: `x ss y`, `ss[x;y]` 

Where 

-   `x` is a string
-   `y` is a string of plain text, or a [pattern](../kb/regex.md)

returns position/s of substring `y` within string `x`.

```q
q)"We the people of the United States" ss "the"
3 17
```

It also supports some of the pattern-matching capabilities of `like`.

```q
q)s:"toronto ontario"
q)s ss "ont"
3 8
q)s ss "[ir]o"
2 13
q)s ss "t?r"
0 10
```



## `ssr`

_String search and replace_ 

Syntax: `ssr[x;y;z]`

Where

- `x` is a string
- `y` is a pattern
- `z` is a string or a function

returns `x` with each substring matching `y` replaced by:

-   `z` if `z` is a string 
-   `z[Y]` where `z` is a function and `Y` is the matched substring

```q
q)s:"toronto ontario"
q)ssr[s;"ont";"x"]      / replace "ont" by "x"
"torxo xario"
q)ssr[s;"t?r";upper]    / replace matches by their uppercase
"TORonto onTARio"
```


<i class="far fa-hand-point-right"></i> 
[`like`](like.md)  
Basics: [Strings](../basics/strings.md)  
Knowledge Base: [Regular expressions](../kb/regex.md), 


