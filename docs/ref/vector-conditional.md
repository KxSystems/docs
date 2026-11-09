---
title: Vector Conditional operator | Reference | kdb+ and q documentation
description: Vector Conditional is a q operator that replaces selected items of one list with corresponding items of another.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: condition, item, kdb+, q, vector
---
# `?` Vector Conditional

_Replace selected items of one list with corresponding items of another_

```syntax
?[x;y;z]
```

Where

- `x` is a boolean vector or atom
- `y` and `z` are lists or atoms of the same type
- `x`, `y`, and `z` [conform](../basics/conformable.md)

returns a new list by replacing items of `y` with the corresponding items of `z` where `x` is false.

All three arguments are evaluated.

```q
q)?[11001b;1 2 3 4 5;10 20 30 40 50]
1 2 30 40 5
```

If `x`, `y`, or `z` are atoms, they are repeated. Since V2.7 2010.10.07 `?[x;y;z]` works for atoms too.

```q
q)?[11001b;1;10 20 30 40 50]
1 1 30 40 1
q)?[11001b;1 2 3 4 5;99]
1 2 99 99 5
q)?[0b;1;2]
2
```

`x` must be boolean. Other types signal a `'type` error.

```q
q)?[1 0 1;1 2 3;4 5 6]
'type
  [0]  ?[1 0 1;1 2 3;4 5 6]
       ^
```

You can use Vector Conditional in [qSQL queries](../basics/qsql.md), which do not support [Cond](cond.md).

!!! tip "For more than two cases, see [Controlling evaluation](../basics/control.md#case)."

----

[`?` Query](overloads.md#query),
[Cond](cond.md),
[`if`](if.md)
<br>

[Controlling evaluation](../basics/control.md)
<br>

_Q for Mortals_
[§10.1.3 Vector Conditional Evaluation](/q4m3/10_Execution_Control/#1013-vector-conditional-evaluation)
