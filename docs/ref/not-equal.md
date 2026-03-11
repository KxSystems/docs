---
title: Not Equal | Reference | kdb+ and q documentation
description: Not Equal is a q operator that flags whether its arguments have the same value.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: compare, equal, kdb+, q
---
# `<>` Not Equal



```syntax
x<>y    <>[x;y]
```

This atomic binary operator returns `1b` where (items of) `x` are less than `y`.

```q
q)(3;"a")<>(2 3 4;"abc")
101b
011b
```

---
 
[Equal `=`](equal.md)
<br>
 
[Comparison](../basics/comparison.md)
<br>
 
_Q for Mortals_: [§4.3.1 Equality = and Inequality <>](/q4m3/4_Operators/#431-equality-and-disequality)
