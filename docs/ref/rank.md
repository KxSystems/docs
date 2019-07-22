---
title: rank
description: rank is a q keyword that returns the position of the items of its argument in the sorted list. 
author: Stephen Taylor
keywords: kdb+, q, sort
---
# `rank`







_Position in the sorted list_

Syntax: `rank x`, `rank[x]`

Where `x` is a list or dictionary, returns for each item in `x` the index of where it would occur in the sorted list or dictionary. 

This is the same as calling [`iasc`](asc.md#iasc) twice on the list.

```q
q)rank 2 7 3 2 5
0 4 2 1 3
q)iasc 2 7 3 2 5
0 3 2 4 1
q)iasc iasc 2 7 3 2 5            / same as rank
0 4 2 1 3
q)asc[2 7 3 2 5] rank 2 7 3 2 5  / identity
2 7 3 2 5
q)iasc idesc 2 7 3 2 5           / descending rank
3 0 2 4 1
```


<i class="far fa-hand-point-right"></i>
[`iasc`](asc.md#iasc)  
Basics: [Sorting](../basics/sort.md)
