---
title: ss, ssr – string search and replacement | Reference | kdb+ and q documentation
description: ss and ssr are q keywords that perform string search and replacement.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `ss`, `ssr`

_String search and replace_

## `ss`

_String search_

```syntax
x ss y     ss[x;y]
```

Where

- `x` is a string
- `y` is a [pattern](../basics/regex.md) as a char atom or string (`ss` doesn't support `*` as a wildcard)

returns a long vector of the positions within `x` of substrings that match pattern `y`.

```q
q)"We the people of the United States" ss "the"
3 17

q)s:"toronto ontario"
q)s ss "ont"
3 8
q)s ss "[ir]o"
2 13
q)s ss "t?r"
0 10
```

Matches do not overlap: after a match, the search resumes at the end of the matched substring.

```q
q)"aaaa" ss "aa"
0 2
```

## `ssr`

_String search and replace_

```syntax
ssr[x;y;z]
```

Where

- `x` is a string
- `y` is a [pattern](../basics/regex.md) as a char atom or string (`ssr` doesn't support `*` as a wildcard)
- `z` is a string or a function

returns `x` with each substring matching `y` replaced by:

- `z` if `z` is a string
- `z[Y]` if `z` is a function, where `Y` is the matched substring

```q
q)s:"toronto ontario"
q)ssr[s;"ont";"x"]      / replace "ont" by "x"
"torxo xario"
q)ssr[s;"t?r";upper]    / replace matches by their uppercase
"TORonto onTARio"
```

----

[`like`](like.md)
<br>

[Wildcard patterns in q](../basics/regex.md)
<br>

[Strings](../basics/by-topic.md#strings)
