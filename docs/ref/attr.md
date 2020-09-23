---
title: attr – attributes of an object | Reference | kdb+ and q documentation
description: attr is a q keyword that reurns the attributes of an object 
author: Stephen Taylor
---
# `attr`




_Attributes of an object_

```txt
attr x     attr[x]
```

Where `x` is any object, returns its attributes as a symbol vector.

The possible attributes are:

code | attribute
:---:|---------------------
s    | sorted
u    | unique (hash table)
p    | partitioned (grouped)
g    | true index (dynamic attribute): enables constant time update and access for real-time tables

A null symbol result `` ` `` means no attributes are set on `x`.

```q
q)attr 1 3 4
`
q)attr asc 1 3 4
`s
q)attr ({x+y})
`
```


----

:fontawesome-solid-book:
[Set Attribute](set-attribute.md)
<br>
:fontawesome-solid-book-open:
[Metadata](../basics/metadata.md)