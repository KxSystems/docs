---
title: except – exclude items from a list | Reference | kdb+ and q documentation
description: except is a q keyword that excludes items from a list.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `except`



_Exclude items from a list_

```syntax
x except y    except[x;y]
```

Where

-   `x` is a list
-   `y` is a list or atom

returns a list of all items of `x` that are not (items of) `y`.

```q
q)1 2 3 except 2
1 3
q)1 2 3 4 1 3 except 2 3
1 4 1
```

`except` uses [`in`](in.md) to identify items of `x` in `y`, which in turn uses [`find`](find.md).

----


[Find](find.md),
[`in`](in.md),
[`within`](within.md)
<br>

[Selection](../basics/by-topic.md#selection)



