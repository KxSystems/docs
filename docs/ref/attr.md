---
title: attr
description: attr is a q keyword that reurns the attributes of its arguments
author: Stephen Taylor
keywords: attr, attribute, data, kdb+, q
---
# `attr`




_Attributes of an object_

Syntax: `attr x`, `attr[x]`

Returns the attributes of `x`. It can be applied to all data types. The possible attributes are:

code | attribute
:---:|---------------------
s    | sorted
u    | unique (hash table)
p    | partitioned (grouped)
g    | true index (dynamic attribute): enables constant time update and access for real-time tables


The result is a symbol atom and is one of `` `s`u`p`g` `` with `` ` `` meaning no attributes are set on the argument.

```q
q)attr 1 3 4
`
q)attr asc 1 3 4
`s
```


<i class="far fa-hand-point-right"></i>
[Set Attribute](set-attribute.md)  
Basics: [Metadata](../basics/metadata.md)