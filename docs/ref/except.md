---
title: except
description: except is a q keyword that excludes items from a list.
author: Stephen Taylor
keywords: except, kdb+, q, select
---
## `except`



_Exclude items from a list_

Syntax: `x except y`, `except[x;y]`

Where 

-   `x` is a list 
-   `y` is a list or atom

returns all items of `x` that are not (items of) `y`.

```q
q)1 2 3 except 2
1 3
q)1 2 3 4 1 3 except 2 3
1 4 1
```



<i class="far fa-hand-point-right"></i> 
[`in`](in.md), 
[`within`](within.md)  
Basics: [Select](../basics/selection.md)



