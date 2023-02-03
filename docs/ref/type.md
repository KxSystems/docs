---
title: type – datatype of an object | Reference | kdb+ and q documentation
description: type is a q keyword that returns as a short int the datatype of an object
author: Stephen Taylor
---
# `type`





_Type of an object_

```syntax
type x    type[x]
```

Where `x` is any object, returns its [type](../basics/datatypes.md).

The type is a short int: 

-    zero for a general list
-    negative for atoms of basic datatypes
-    positive for everything else

```q
q)type 5                        / integer atom
-7h
q)type 2 3 5                    / integer vector
7h
q)type (2 3 5;"hello")          / general list
0h
q)type ()                       / general list
0h
q)type each (2;3 5;"hello")     / int atom; int vector; string
-7 7 10h
q)type (+)                      / function
102h
q)type (0|+)                    / composition
105h
```

----

:fontawesome-solid-book:
[.Q.ty](dotq.md#ty-type)
<br>
:fontawesome-solid-book-open:
[Casting and encoding](../basics/by-topic.md#casting),
[Datatypes](../basics/datatypes.md)


