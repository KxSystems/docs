---
title: rank – position of the items of its argument in the sorted list | Reference | kdb+ and q documentation
description: rank is a q keyword that returns the position of the items of its argument in the sorted list. 
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `rank`

_Position in the sorted list_

```syntax
rank x    rank[x]
```

Where `x` is a list, dictionary, or table, returns, for each item in `x`, its position in the sorted list, dictionary, or table.

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
q)rank `a`b`c`d`e!2 7 3 2 5      / dictionary: ranks the values
0 4 2 1 3
```

Equal items get different ranks, in order of their position in `x`.

----

[`iasc`](asc.md#iasc),
[`xrank`](xrank.md)
<br>

[Sorting](../basics/by-topic.md#sort)
