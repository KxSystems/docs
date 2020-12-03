---
title: first, last – Reference – kdb+ and q documentation
description: first and last are q keywords that return respectively the first and last items from a list.
author: Stephen Taylor
keywords: each, enlist, first, last kdb+, q, select
---
# `first`, `last`



## `first`

_First item of a list_

```txt
first x    first[x]
```

Where `x` is a list or dictionary, returns its first item, else `x`.

Often used with [Each](maps.md#each) to get the first item of each item of a list, or of each key in a dictionary.

```q
q)first 1 2 3 4 5
1
q)first 42
42
q)RaggedArray:(1 2 3;4 5;6 7 8 9;0)
q)first each RaggedArray
1 4 6 0
q)RaggedDict:`a`b`c!(1 2;3 4 5;"hello")
q)first RaggedDict  / value of first key
1 2
q)first each RaggedDict
a| 1
b| 3
c| "h"
```

Returns the first row of a table.

```q
q)\l sp.q
q)first sp
s  | `s$`s1
p  | `p$`p1
qty| 300
```

`first` is the dual to [`enlist`](enlist.md).

```q
q)a:10
q)a~first enlist 10
1b
q)a~first first enlist enlist 10
1b
```

`first` is an aggregate function.



## `last`

_Last item of a list_

```txt
last x    last[x]
```

Where `x` is a list or dictionary, returns its last item; otherwise `x`.

```q
q)last til 10
9
q)last `a`b`c!1 2 3
3
q)last 42
42
```

----
:fontawesome-solid-book-open:
[Selection](../basics/by-topic.md#selection)
