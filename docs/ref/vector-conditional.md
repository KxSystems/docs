---
title: Vector Conditional – Reference – kdb+ and q documentation
description: Vector Conditional isd a q operator that replaces selected items of one list with corresponding items of another.
author: Stephen Taylor
keywords: condition, item, kdb+, q, vector
---
# `?` Vector Conditional 




_Replace selected items of one list with corresponding items of another_

Syntax: `?[x;y;z]`

Where

-   `x` is a boolean vector
-   `y` and `z` are lists of the same type
-   `x`, `y`, and `z` conform

returns a new list by replacing elements of `y` with the elements of `z` when `x` is false. 

All three arguments are evaluated.

```q
q)?[11001b;1 2 3 4 5;10 20 30 40 50]
1 2 30 40 5
```

If `x`, `y`, or `z` are atomic, they repeated.

```q
q)?[11001b;1;10 20 30 40 50]
1 1 30 40 1
q)?[11001b;1 2 3 4 5;99]
1 2 99 99 5
```

Since V2.7 2010.10.07 `?[x;y;z]` works for atoms too.


!!! tip "Vector Conditional can be used in [qSQL queries](../basics/qsql.md), which do not support [Cond](cond.md)."


!!! tip "For multiple cases – more than just true/false – see [Controlling evaluation](../basics/control.md#case)."

