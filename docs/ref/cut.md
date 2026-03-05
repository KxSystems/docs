---
title: Cut, cut – Reference – kdb+ and q documentation
description: Cut is a q operator that cuts a list or table into subarrays. cut is a q keyword that cuts a list or table into a matrix into a specified number of columns. 
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: cut, kdb+, keyword, operator, q
---
# `_` Cut, `cut`

## _ (cut operator)

_Cut a list or table into sub-arrays_

```syntax
x _ y     _[x;y]
```

Where

- `x` is a **non-decreasing list of integers** in the domain `til count y`
- `y` is a list or table

returns `y` cut at the indexes given in `x`. The result is a list with the same count as `x`. Refer to the examples for how exactly the cut is constructed:

```q
q)2 4 9 _ til 10           /first result item starts at index 2
2 3
4 5 6 7 8
,9
q)2 4 4 9 _ til 10         /cuts are empty for duplicate indexes
2 3
`long$()
4 5 6 7 8
,9
q)t:([]a:til 5;b:`a`b`c`d`e)
q)ts:0 3 _ t
q)ts 0
a b
---
0 a
1 b
2 c
q)ts 1
a b
---
3 d
4 e
```

!!! tip
    If you want all list items to be returned, be sure to start the left argument with 0:

    ```q
    q)0 4 5 _ til 7
    0 1 2 3
    ,4
    5 6
    ```

`_`(cut) is a [multithreaded primitive](../kb/mt-primitives.md).

!!! tip "Avoid confusion with underscores in names: separate the Cut operator with spaces."

## `cut` (keyword)

_Cut a list or table into a matrix of `x` columns_

```syntax
x cut y     cut[x;y]
```

Where

- `x` is an **integer atom**
- `y` is a list

returns `y` splits into a list of lists, all (except perhaps the last) of count `x`.

```q
q)4 cut til 10
0 1 2 3
4 5 6 7
8 9
```

Otherwise `cut` behaves as [`_` Cut](#_-cut-operator).

----

[Drop](drop.md)
