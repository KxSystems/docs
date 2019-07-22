---
title: til 
description: til is a q keyword that returns the natural numbers up to its argument.
author: Stephen Taylor
keywords: integers, kdb+, math, mathematics, natural numbers, q
---
# `til`



Syntax: `til x`, `til[x]` 

_First x natural numbers_ 

Where `x` is a non-negative integer, returns the first `x` integers. 
```q
q)til 0
`long$()
q)til 1b
,0
q)til 5
0 1 2 3 4
q)til 5f
'type
  [0]  til 5f
       ^
```

<i class="far fa-hand-point-right"></i> 
Basics: [Mathematics](../basics/math.md)
