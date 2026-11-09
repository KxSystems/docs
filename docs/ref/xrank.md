---
title: xrank – assign items to buckets by rank | Reference | kdb+ and q documentation
description: xrank is a q keyword that assigns each item of a list to one of a given number of buckets, by rank.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `xrank`

_Assign items to buckets by rank_

```syntax
x xrank y     xrank[x;y]
```

Where

- `x` is a long atom
- `y` is a list of sortable type

returns for each item in `y` the bucket into which it falls, represented as a long from 0 to `x-1`.

If `x` evenly divides the number of items, each bucket has the same number of items. Otherwise, some buckets have one more item than others, and these larger buckets are spread throughout the result.

`xrank` is [right-uniform](../basics/glossary.md#right-uniform).

```q
q)4 xrank til 8          / equal size buckets
0 0 1 1 2 2 3 3
q)4 xrank til 9          / 1 bucket size differs
0 0 0 1 1 2 2 3 3
q)7 xrank til 9          / multiple bucket sizes differ
0 0 1 2 3 3 4 5 6
q)3 xrank 1 37 5 4 0 3   / outlier 37 does not get its own bucket
0 2 2 1 0 1
q)3 xrank 1 7 5 4 0 3    / same as above
0 2 2 1 0 1
```

Buckets are assigned by position in the sorted list, not by value, so equal items can fall into different buckets.

```q
q)2 xrank 5 5 5 5
0 0 1 1
```

Example using stock data:

```q
q)show t:([]val:17 1 14 13 13 9 2 6 8 11 16 4 15 0 7 12 10 3 5 15;name:20#`MSFT`CSCO`ORCL)
val name
--------
17  MSFT
1   CSCO
14  ORCL
13  MSFT
13  CSCO
9   ORCL
..

q)select Min:min val,Max:max val,Count:count i by bucket:4 xrank val from t
bucket| Min Max Count
------| -------------
0     | 0   4   5
1     | 5   9   5
2     | 10  13  5
3     | 14  17  5
```

!!! warning "Duplicate keys in a dictionary or duplicate column names in a table cause sorts and grades to return unpredictable results."

----

[Sorting](../basics/by-topic.md#sort)
