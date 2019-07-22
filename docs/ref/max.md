---
title: max, maxs, mmax
description: max, maxs, and mmax are q keywords that return respectively the largest item from a list or dictionary, the cumulative maximums, and the moving maximums.
author: Stephen Taylor
keywords: kdb+, math, mathematics, maximum, maximums, moving, q, statistics
---
# `max`, `maxs`, `mmax`





## `max` 

_Maximum_

Syntax: `max x`, `max[x]`

Where `x` is a sortable list, returns the maximum of its items. 
The maximum of an atom is itself. Applies to any datatype except symbol. Nulls are ignored, except that if the items of `x` are all nulls, the result is negative infinity.

```q
q)max 2 5 7 1 3
7
q)max "genie"
"n"
q)max 0N 5 0N 1 3                  / nulls are ignored
5
q)max 0N 0N                        / negative infinity if all null
-0W
q)select max price by sym from t   / use in a select statement
```

`max` is an aggregate function.



## `maxs`

_Maximums_

Syntax: `maxs x` `maxs[x]`

Where `x` is a sortable list, returns the running maximums of its prefixes. 
The maximum of an atom is itself. Applies to any datatype except symbol. Nulls are ignored, except that initial nulls are returned as negative infinity.

```q
q)maxs 2 5 7 1 3
2 5 7 7 7
q)maxs "genie"
"ggnnn"
q)maxs 0N 5 0N 1 3         / initial nulls return negative infinity
-0W 5 5 5 5
```

`maxs` is a uniform function. 


## `mmax`

_Moving maximums_

Syntax: `x mmax y`, `mmax[x;y]`

Where

-   `x` is a positive int atom
-   `y` is a numeric list

returns the `x`-item moving maximums of `y`, with nulls after the first replaced by the preceding maximum. The first `x` items of the result are the maximums of the items so far, and thereafter the result is the moving maximum.

```q
q)3 mmax 2 7 1 3 5 2 8
2 7 7 7 5 5 8
q)3 mmax 0N -3 -2 0N 1 0  / initial null returns negative infinity
-0W -3 -2 -2 1 1          / remaining nulls replaced by preceding max
```

`mmax` is a uniform function. 


<i class="far fa-hand-point-right"></i> 
[Greater Than](greater-than.md)  
Knowledge Base: 
[Sliding windows](../kb/programming-idioms.md#how-do-i-apply-a-function-to-a-sequence-sliding-window)  
Basics: 
[Comparison](../basics/comparison.md), 
[Mathematics](../basics/math.md)
