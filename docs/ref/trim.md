---
title: trim, ltrim, rtrim – trim nulls from a list | Reference | kdb+ and q documentation
description: trim, ltrim, and rtrim are q keywords that remove leading or trailing spaces from a string.
author: Stephen Taylor
---
# `trim`, `ltrim`, `rtrim`

_Remove leading or trailing nulls from a list_


```txt
 trim x     trim[x]
ltrim x    ltrim[x]
rtrim x    rtrim[x]
```

Where `x` is a vector or non-null atom, returns `x` without leading (`ltrim`) or trailing (`rtrim`) nulls or without either (`trim`).

```q
q)trim "   IBM   "
"IBM"
q)trim 0N 0N 1 2 3 0N 0N  4 5 0N 0N
1 2 3 0N 0N 4 5

q)ltrim"   IBM   "
"IBM   "

q)rtrim"   IBM   "
"   IBM"

q)trim"a"
"a"
q)trim 42
42
```


----
:fontawesome-solid-book:
[Drop](drop.md)
<br>
:fontawesome-solid-book-open:
[Strings](../basics/strings.md)

