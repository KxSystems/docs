# `type`




_Datatype of an object_

Syntax: `type x`, `type[x]` 

Where `x` is any object, returns its [datatype](../basics/datatypes.md) of `x`.

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
Basics [Datatypes](../basics/datatypes.md), 
[Casting and encoding](/basics/casting)  
[.Q.ty](dotq.md#qty-type)


