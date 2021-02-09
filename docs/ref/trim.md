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


## Implicit iteration

`trim`, `ltrim`, and `rtrim` are [string-atomic](../basics/atomic.md#string-atomic) and apply to dictionaries and tables.

```q
q)trim(("fox";("jumps ";"over   "));("a";"dog "))
"fox" ("jumps";"over")
"a"   "dog"

q)ltrim`a`b!(("fox";("jumps ";"over   "));("a";"dog "))
a| "fox" ("jumps ";"over   ")
b| "a"   "dog "

q)rtrim ([]a:("fox";("jumps ";"over   "));b:("a";"dog "))
a                b
----------------------
"fox"            "a"
("jumps";"over") "dog"
```

----
:fontawesome-solid-book:
[Drop](drop.md)
<br>
:fontawesome-solid-book-open:
[Strings](../basics/by-topic.md#strings)

