---
title: Equal | Reference | kdb+ and q documentation
description: Equal is a q operator that flags where its arguments are equal.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: equal, kdb+, q
---
# `=` Equal



```syntax
x=y    =[x;y]
```

Returns `1b` where (atoms of) `x` and `y` are equal.

```q
q)(3;"a")=(2 3 4;"abc")
010b
100b
```

Equal is an atomic function.

---
 
[Not Equal `<>`](not-equal.md)
<br>
 
[Comparison](comparison.md)
<br>
 
_Q for Mortals_: [§4.3.1 Equality = and Inequality <>](../learn/q4m/4_Operators.md#431-equality-and-inequality)
