---
title: Not Equal | Reference | KDB-X and q documentation
description: Not Equal is a q operator that flags whether its arguments have the same value.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: compare, equal, KDB-X, q
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
 
[Comparison](comparison.md)
<br>
 
_Q for Mortals_: [§4.3.1 Equality = and Inequality <>](../learn/q4m/4_Operators.md#431-equality-and-inequality)
