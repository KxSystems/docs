---
title: raze joins the items of a list, collapsing one level of nesting | Reference | kdb+ and q documentation
description: raze is a q keyword that returns the items of a list joined, collapsing one level of nesting.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `raze`

_Return the items of `x` joined, collapsing one level of nesting_

```syntax
raze x    raze[x]
```

To collapse all levels, use [Converge](accumulators.md#converge), that is, `raze/[x]`.

```q
q)raze (1 2;3 4 5)
1 2 3 4 5
q)b:(1 2;(3 4;5 6);7;8)
q)raze b                 / flatten one level
1
2
3 4
5 6
7
8
q)raze/[b]               / flatten all levels
1 2 3 4 5 6 7 8
q)raze 42                / atom returned as a list
,42
```

Where `x` is a dictionary, returns its values joined.

```q
q)d:`q`w`e!(1 2;3 4;5 6)
q)value d
1 2
3 4
5 6
q)raze d
1 2 3 4 5 6
```

!!! warning "Use only on items that can be joined"

    `raze` is equivalent to `,/` (Join Over) and requires items that can be joined.

    ```q
    q)d:`a`b!(1 2;3 5)
    q)10,d          / cannot join integer and dictionary
    'type
      [0]  10,d          / cannot join integer and dictionary
             ^
    q)raze (10;d)   / so raze signals an error too
    'type
      [0]  raze (10;d)   / so raze signals an error too
           ^
    ```

----

[Join](join.md)
