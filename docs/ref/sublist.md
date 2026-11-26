---
title: Sublist of a list | Reference | kdb+ and q documentation
description: sublist is a q keyword that returns a sublist of a list.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `sublist`

_Select a sublist of a list_

```syntax
x sublist y    sublist[x;y]
```

Where

- `x` is an integer atom or pair
- `y` is a list

returns a sublist of `y`. The result contains no more items than are available in `y`.

## Head or tail

Where `x` is an integer atom, returns up to `x` items from the beginning of `y` if `x` is positive, or from the end if `x` is negative.

```q
q)p:2 3 5 7 11
q)3 sublist p                           / 3 from the front
2 3 5
q)10 sublist p                          / only available values
2 3 5 7 11
q)2 sublist `a`b`c!(1 2 3;"xyz";2 3 5)  / 2 keys from a dictionary
a| 1 2 3
b| x y z
q)t:([]s:3 0 3 3 0;p:1 2 1 3 4;qty:100 200 200 300 400)
q)-3 sublist t                          / last 3 rows of a table
s p qty
-------
3 1 200
3 3 300
0 4 400
```

Taking a sample from the beginning of a string with [Take](take.md) returns unexpected results if the string is shorter than the sample, because Take repeats items to fill the count.

```q
q)10#"take me"
"take metak"
```

Instead, compose [Pad](pad.md) with `sublist`.

```q
q){x$x sublist y}[10;]"take me"
"take me   "
```

## Slice

Where `x` is an integer pair, returns up to `x[1]` items from `y`, starting at item `x[0]`.

```q
q)1 2 sublist p  / 2 items starting from position 1
3 5
q)3 10 sublist p / only available values
7 11
```

----

[Take](take.md)
<br>

[Selection](../basics/by-topic.md#selection)

