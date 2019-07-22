---
title: group
description: group is a q keyword that returns a dictionary in which the keys are the distinct items of its argument, and the values the indexes where the distinct items occur.
author: Stephen Taylor
keywords: group, kdb+, q, qsql, sql, sort
---
# `group`




Syntax: `group x`, `group[x]`

Returns a dictionary in which the keys are the distinct items of `x`, and the values the indexes where the distinct items occur. 

The order of the keys is the order in which they appear in `x`.

```q
q)group "mississippi"
m| ,0
i| 1 4 7 10
s| 2 3 5 6
p| 8 9
```

To count the number of occurrences of each distinct item:

```q
q)count each group "mississippi"
m| 1
i| 4
s| 4
p| 2
```

To get the index of the first occurrence of each distinct item:

```q
q)first each group "mississippi"
m| 0
i| 1
s| 2
p| 8
```


<i class="far fa-hand-point-right"></i> 
[`ungroup`](ungroup.md), 
[`xgroup`](xgroup.md)  
Basics: [Sorting](../basics/sort.md) 