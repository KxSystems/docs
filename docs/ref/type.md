---
title: type – datatype of an object | Reference | kdb+ and q documentation
description: type is a q keyword that returns the datatype of an object as a short.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `type`

_Type of an object_

```syntax
type x    type[x]
```

Where `x` is any object, returns its [type](../basics/datatypes.md).

The type is a short int:

- Zero for a general list
- Negative for atoms of basic datatypes
- Positive for everything else

```q
q)type 5                        / long atom
-7h
q)type 2 3 5                    / long vector
7h
q)type (2 3 5;"hello")          / general list
0h
q)type ()                       / general list
0h
q)type each (2;3 5;"hello")     / long atom; long vector; string
-7 7 10h
q)type (+)                      / function
102h
q)type (0|+)                    / composition
105h
```

----

[`key`](key.md#type-of-a-vector),
[`.Q.ty`](dotq.md#ty-type)
<br>

[Casting and encoding](../basics/by-topic.md#casting-and-encoding),
[Datatypes](../basics/datatypes.md)


