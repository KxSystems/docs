---
title: ss, ssr – string search and replacement | Reference | KDB-X and q documentation
description: ss and ssr are q keywords that perform string search and replacement.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `ss`, `ssr`

_String search – and replace_




## `ss`

_String search_

```syntax
x ss y     ss[x;y]
```

Where

-   `x` is a string
-   `y` is a [pattern](regex.md) as a string (no asterisk)

returns an int vector of position/s within `x` of substrings that match pattern `y`.

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


## `ssr`

_String search and replace_

```syntax
ssr[x;y;z]
```

Where

-   `x` is a string
-   `y` is a [pattern](regex.md) as a string (no asterisk)
-   `z` is a string or a function

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


----

[`like`](like.md)
<br>

[Regular Expressions in q](regex.md)
<br>

[Strings](by-topic.md#strings)
<br>

[Using regular expressions](regex.md)


