---
title: trim, ltrim, rtrim
description: trim, ltrim, and rtrim are q keywords that remove leading or trailing spaces from a string.
author: Stephen Taylor
keywords: kdb+, ltrim, q, rtrim, string, trim
---
# `trim`, `ltrim`, `rtrim`

_Remove leading or trailing spaces from a string_




## `trim`

_Trim leading and trailing spaces_

Syntax: `trim x`, `trim[x]`

Returns string `x` with any leading or trailing spaces removed.

```q
q)trim"   IBM   "
"IBM"
```


## `ltrim`

_Trim leading spaces_

Syntax: `ltrim x`, `ltrim[x]`

Left trim: returns string `x` with any leading space/s removed.

```q
q)ltrim"   IBM   "
"IBM   "
```


## `rtrim`

_Trim trailing spaces_

Syntax: `rtrim x`, `rtrim[x]`

Right trim: returns string `x` with any trailing space/s removed. 

```q
q)rtrim"   IBM   "
"   IBM"
```



<i class="far fa-hand-point-right"></i> 
[`_` Drop](drop.md)  
Basics: [Strings](../basics/strings.md)

