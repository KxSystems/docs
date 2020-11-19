---
title: except – exclude items from a list | Reference | kdb+ and q documentation
description: except is a q keyword that excludes items from a list.
author: Stephen Taylor
---
# `except`



_Exclude items from a list_

```txt
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


----

:fontawesome-solid-book:
[`in`](in.md),
[`within`](within.md)
<br>
:fontawesome-solid-book-open:
[Selection](../basics/by-topic.md#selection)



