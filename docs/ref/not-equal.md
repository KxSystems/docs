---
title: Not Equal – Reference – kdb+ and q documentation
description: Not Equal is a q operator that flags whether its arguments have the same value.
author: Stephen Taylor
keywords: compare, equal, kdb+, q
---
# `<>` Not Equal



Syntax: `x <> y`

This atomic binary operator returns `1b` where (items of) `x` are less than `y`.

```q
q)(3;"a")<>(2 3 4;"abc")
101b
011b
```

:fontawesome-regular-hand-point-right: 
[Equal](equal.md)  
Basics: [Comparison](../basics/comparison.md)
