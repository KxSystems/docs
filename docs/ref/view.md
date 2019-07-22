---
title: view, views
description: view and views are q keywords. view returns the expression defining a view. views lists views defined in the default namespace. 
author: Stephen Taylor
keywords: kdb+, metadata, q, view, views
---
# `view`, `views`





## `view`

_Expression defining a view_

Syntax: `view x`, `view[x]`

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

Syntax: `views[]`

Returns a sorted list of the views currently defined in the default namespace.

```q
q)w::b*10
q)v::2+a*3
q)views[]
`s#`v`w
```


<i class="far fa-hand-point-right"></i> 
Basics: [Metadata](../basics/metadata.md)  
Tutorials: [Views](../learn/views.md)
