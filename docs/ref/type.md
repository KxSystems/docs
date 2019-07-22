---
title: type
description: type is a q keyword that returns as a short int the datatype of its argument. 
author: Stephen Taylor
keywords: cast, datatype, kdb+, metadata, q, type
---
# `type`





_Datatype of an object_

Syntax: `type x`, `type[x]` 

Where `x` is any object, returns its [datatype](../basics/datatypes.md).

The datatype is a short int: negative for atoms, positive for vectors, `0h` for a general list.

```q
q)type 5                         / integer atom
-6h   
q)type 2 3 5                     / integer vector
6h   
q)type (2;3 5;"hello")           / mixed list
0h
q)type each (2;3 5;"hello")      / mixed list
-6 9 10h
q)type (+)                       / function atom
102h
```

<i class="far fa-hand-point-right"></i> 
[.Q.ty](dotq.md#qty-type)  
Basics: [Casting and encoding](../basics/casting.md),
[Datatypes](../basics/datatypes.md)


