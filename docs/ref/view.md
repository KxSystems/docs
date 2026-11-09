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

Where `x` is the name of a view as a symbol, returns the expression defining `x` as a string.
The string is the source text of the definition, including any trailing comment.

```q
q)/ define dependency v
q)v::2+a*3
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

Returns a sorted list of the views defined in the default namespace.

```q
q)w::b*10
q)v::2+a*3
q)views[]
`s#`v`w
```

---

[`value`](value.md#view),
[Metadata](../basics/metadata.md)
<br>

_Q for Mortals_
[4.11 Views](/q4m3/4_Operators/#4114-views)
