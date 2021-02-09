---
title: xrank – group by value | Reference | kdb+ and q documentation
description: xrank is a q keyword that groups its argument by value.
author: Stephen Taylor
---
# `xrank`





_Group by value_

```txt
x xrank y     xrank[x;y]
```

Where

-   `x` is a long atom
-   `y` is of sortable type

returns for each item in `y` the bucket into which it falls, represented as a long from 0 to `x-1`.

If the total number of items is evenly divisible by `x`, then each bucket will have the same number of items; otherwise the first items of the result are longer.

`xrank` is right-uniform.

```q
q)4 xrank til 8          / equal size buckets
0 0 1 1 2 2 3 3
q)4 xrank til 9          / first bucket has extra
0 0 0 1 1 2 2 3 3
q)
q)3 xrank 1 37 5 4 0 3   / outlier 37 does not get its own bucket
0 2 2 1 0 1
q)3 xrank 1 7 5 4 0 3    / same as above
0 2 2 1 0 1
```

Example using stock data:

```q
q)show t:flip `val`name!((20?20);(20?(`MSFT`ORCL`CSCO)))
val name
--------
17  MSFT
1   CSCO
14  CSCO
13  ORCL
13  ORCL
9   ORCL
...

q)select Min:min val,Max:max val,Count:count i by bucket:4 xrank val from t
bucket| Min Max Count
------| -------------
0     | 0   7   5
1     | 9   12  5
2     | 13  15  5
3     | 15  17  5
```

!!! warning "Duplicate keys in a dictionary or duplicate column names in a table will cause sorts and grades to return unpredictable results."


----
:fontawesome-solid-book-open:
[Sorting](../basics/by-topic.md#sort)
