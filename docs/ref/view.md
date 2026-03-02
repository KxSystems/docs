---
title: view, views | Reference | kdb+ and q documentation
description: view and views are q keywords. view returns the expression defining a view. views lists views defined in the default namespace. 
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `view`, `views`





## `view`

_Expression defining a view_

```syntax
view x    view[x]
```

Where `x` is a view (by reference), returns the expression defining `x`.

```q
q)v::2+a*3                        / define dependency v
q)a:5
q)v
17
q)view `v                         / view the dependency expression
"2+a*3"
```



## `views`

_List views defined in the default namespace_

```syntax
views[]
```

Returns a sorted list of the views currently defined in the default namespace.

```q
q)w::b*10
q)v::2+a*3
q)views[]
`s#`v`w
```

---

[Metadata](metadata.md) 
<br>

_Q for Mortals_
[4.11 Views](../learn/q4m/4_Operators.md#411-views-advanced)
