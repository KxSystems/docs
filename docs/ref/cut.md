---
title: Cut, cut – Reference – kdb+ and q documentation
description: Cut is a q operator that cuts a list or table into subarrays. cut is a q keyword that cuts a list or table into a matrix into a specified number of columns. 
author: Stephen Taylor
keywords: cut, kdb+, keyword, operator, q
---
# `_` Cut, `cut`





## Cut (operator)

_Cut a list or table into sub-arrays_

```txt
x _ y     _[x;y]
```

Where 

-   `x` is a **non-decreasing list of integers** in the domain `til count y` 
-   `y` is a list or table

returns `y` cut at the indexes given in `x`. The result is a list with the same count as `x`.

```q
q)2 4 9 _ til 10           /first result item starts at index 2
2 3
4 5 6 7 8
,9
q)
q)2 4 4 9 _ til 10         /cuts are empty for duplicate indexes
2 3
`long$()
4 5 6 7 8
,9
q)2 5 7 _ til 12
2 3 4
5 6
7 8 9 10 11
q)\l sp.q
q)count sp
12
q){}show each 2 5 7_sp / `show` returns the generic null ::
s  p  qty
---------
s1 p3 400
s1 p4 200
s4 p5 100
s  p  qty
---------
s1 p6 100
s2 p1 300
s  p  qty
---------
s2 p2 400
s3 p2 200
s4 p2 200
s4 p4 300
s1 p5 400
```

!!! tip "Avoid confusion with underscores in names: separate the Cut operator with spaces."


## `cut` (keyword)

_Cut a list or table into a matrix of `x` columns_

```txt
x cut y     cut[x;y]
```

Where 

-   `x` is an **integer atom**
-   `y` is a list

returns `y` splits into a list of lists, all (except perhaps the last) of count `x`.

```q
q)4 cut til 10
0 1 2 3
4 5 6 7
8 9
```

Otherwise `cut` behaves as `_` Cut.


----

:fontawesome-solid-book:
[Drop](drop.md)