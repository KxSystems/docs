---
title: not
description: not is a q keyword that flags whether its argument is false.
author: Stephen Taylor
keywords: false, kdb+, logic, not, q, true
---
# `not`



_Is false_

Syntax: `not x` 

Returns `0b` where `x` **not** equal to zero, and `1b` otherwise.

Applies to all data types except symbol, and to items of lists, dictionary values and table columns.

`not` is an atomic function. 

```q
q)not -1 0 1 2
0100b
q)not "abc","c"$0
0001b
q)not `a`b!(-1 0 2;"abc","c"$0)
a| 010b
b| 0001b
```


<i class="far fa-hand-point-right"></i>
[`neg`](neg.md)  
Basics: [Logic](../basics/logic.md)