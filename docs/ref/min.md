---
title: min, mins, mmin
description: min, mins and mmin are q keywords that return respectively the smallest item, the cumulative minimums, and the moving minimums of the argument.
author: Stephen Taylor
keywords: kdb+, math, mathematics, minimum, moving, q, statistics
---
# `min`, `mins`, `mmin`

_Minimum/s_




## `min` 

_Minimum_

Syntax: `min x`, `min[x]`

Where `x` is a sortable list, returns its minimum. 
The minimum of an atom is itself. Applies to any datatype except symbol. Nulls are ignored, except that if the argument has only nulls, the result is infinity.

```q
q)min 2 5 7 1 3
1
q)min "genie"
"e"
q)min 0N 5 0N 1 3                  / nulls are ignored
1
q)min 0N 0N                        / infinity if all null
0W
q)select min price by sym from t   / use in a select statement
```

`min` is an aggregate function.



## `mins` 

_Minimums_

Syntax: `mins x`, `mins[x]`

Where `x` is a sortable list, returns the running minimums of the prefixes. The minimum of an atom is itself. Applies to any datatype except symbol. Nulls are ignored, except that initial nulls are returned as infinity.

```q
q)mins 2 5 7 1 3
2 2 2 1 1
q)mins "genie"
"geeee"
q)mins 0N 5 0N 1 3         / initial nulls return infinity
0W 5 5 1 1
```

`mins` is a uniform function.


## `mmin`

_Moving minimums_

Syntax: `x mmin y`, `mmin[x;y]`

Where

-   `x` is a positive int atom
-   `y` is a numeric list

returns the `x`-item moving minimums of `y`, with nulls treated as the minimum value. The first `x` items of the result are the minimums of the terms so far, and thereafter the result is the moving minimum.

```q
q)3 mmin 0N -3 -2 1 -0W 0
0N 0N 0N -3 -0W -0W
q)3 mmin 0N -3 -2 1 0N -0W    / null is the minimum value
0N 0N 0N -3 0N 0N
```

`mmin` is a uniform function.


<i class="far fa-hand-point-right"></i> 
Knowledge Base: 
[Sliding windows](../kb/programming-idioms.md#how-do-i-apply-a-function-to-a-sequence-sliding-window)  
Basics: 
[Mathematics](../basics/math.md)
