---
title: attr – attributes of an object | Reference | KDB-X and q documentation
description: attr is a q keyword that returns the attributes of an object 
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `attr`

_Attribute of an object_

```syntax
attr x     attr[x]
```

Where `x` is any object, returns its attribute as a symbol atom.

The possible attributes are:

code | attribute
:---:|---------------------
```s``    | sorted
```u``    | unique
```p``    | parted
```g``    | grouped

A null symbol result `` ` `` means no attributes are set on `x`.

```q
q)attr 1 3 4
`
q)attr asc 1 3 4
`s
```

For more information on each of the attributes, please refer to the documentation pages in the footer.

----

[Set Attribute](set-attribute.md)
<br>

[Metadata](metadata.md)
<br>
_Q for Mortals_
[§8.9 Attributes](../learn/q4m/8_Tables.md#89-attributes)
