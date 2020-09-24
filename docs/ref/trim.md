---
title: trim, ltrim, rtrim | Reference | kdb+ and q documentation
description: trim, ltrim, and rtrim are q keywords that remove leading or trailing spaces from a string.
author: Stephen Taylor
---
# `trim`, `ltrim`, `rtrim`

_Remove leading or trailing nulls from a list_




## `trim`

_Trim leading and trailing nulls_

```txt
trim x     trim[x]
```

Returns vector `x` with any leading or trailing nulls removed.

```q
q)trim"   IBM   "
"IBM"
q)trim 0N 0N 1 2 3 0N 0N  4 5 0N 0N
1 2 3 0N 0N 4 5
```


## `ltrim`

_Trim leading nulls_

```txt
ltrim x     ltrim[x]
```

Left trim: returns vector `x` with any leading nulls removed.

```q
q)ltrim"   IBM   "
"IBM   "
```


## `rtrim`

_Trim trailing nulls_

```txt
rtrim x`, `rtrim[x]
```

Right trim: returns vector `x` with any trailing nulls removed.

```q
q)rtrim"   IBM   "
"   IBM"
```


----
:fontawesome-solid-book:
[`_` Drop](drop.md)
<br>
:fontawesome-solid-book-open:
[Strings](../basics/strings.md)

