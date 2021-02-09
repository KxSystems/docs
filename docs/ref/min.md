---
title: min, mins, mmin – minima of a list | Reference | kdb+ and q documentation
description: min, mins and mmin are q keywords that return respectively the smallest item, the cumulative minimums, and the moving minimums of the argument.
author: Stephen Taylor
---
# `min`, `mins`, `mmin`

_Minimum/s_




## `min` 

_Minimum_

```txt
min x     min[x]
```

Where `x` is a non-symbol sortable list, returns its minimum. 
The minimum of an atom is itself. 

Nulls are ignored, except that if the argument has only nulls, the result is infinity.

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

`min` is an aggregate function, equivalent to `&/`.



## `mins` 

_Minimums_

```txt
mins x     mins[x]
```

Where `x` is a non-symbol sortable list, returns the running minimums of the prefixes.

Nulls are ignored, except that initial nulls are returned as infinity.

```q
q)mins 2 5 7 1 3
2 2 2 1 1
q)mins "genie"
"geeee"
q)mins 0N 5 0N 1 3         / initial nulls return infinity
0W 5 5 1 1
```

`mins` is a uniform function, equivalent to `&\`.


## `mmin`

_Moving minimums_

```txt
x mmin y     mmin[x;y]
```

Where `y` is a non-symbol sortable list and `x` is a 

-   positive int atom, returns the `x`-item moving minimums of `y`, with nulls treated as the minimum value; the first `x` items of the result are the minimums of the terms so far, and thereafter the result is the moving minimum
-   0 or a negative int, returns `y`

```q
q)3 mmin 0N -3 -2 1 -0W 0
0N 0N 0N -3 -0W -0W
q)3 mmin 0N -3 -2 1 0N -0W    / null is the minimum value
0N 0N 0N -3 0N 0N
```

`mmin` is a uniform function.

:fontawesome-solid-graduation-cap:
[Sliding windows](../kb/programming-idioms.md#how-do-i-apply-a-function-to-a-sequence-sliding-window)  


## :fontawesome-solid-sitemap: Implicit iteration

`min`, `mins`, and `mmin` apply to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).

```q
q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 21 3;4 5 6)

q)min d
4 5 3
q)min t
a| 3
b| 4
q)min k
a| 3
b| 4

q)mins t
a  b
----
10 4
10 4
3  4

q)2 mmin k
k  | a  b
---| ----
abc| 10 4
def| 10 4
ghi| 3  5
```


## Aggregating nulls

`avg`, `min`, `max` and `sum` are special: they ignore nulls, in order to be similar to SQL92.
But for nested `x` these functions preserve the nulls.

```q
q)min (1 2;0N 4)
0N 2
```


----
:fontawesome-solid-book:
[`max`, `maxs`, `mmax`](max.md)
<br>
:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)
