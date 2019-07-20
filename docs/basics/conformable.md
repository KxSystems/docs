---
title: Conformable data objects
description: Many q operators and keywords implicitly iterate through the items of their list arguments, provided that the arguments are conformable. This article describes what it means for data objects to conform. 
author: Stephen Taylor
keywords: argument, conform, conformable, kdb+, keyword, list, operator, q
---
# Conformable data objects




Many q operators and keywords implicitly iterate through the items of their list arguments, provided that the arguments are conformable. This article describes what it means for data objects to conform. 

The idea of conformable objects is tied to atomic functions such as Add, functions like Cast with behavior very much like atom functions, and functions derived from Each. 

For example, the primitive function Add can be applied to vectors of the same count, as in

```q
q)1 2 3+4 5 6 
5 7 9
```

but fails with a length error when applied to vectors that do not have the same count, such as:

```q
q)1 2 3 + 4 5 6 7
'length
  [0]  1 2 3 + 4 5 6 7
             ^
```

The vectors `1 2 3` and `4 5 6` are conformable, while `1 2 3` and
`4 5 6 7` are not.

Add applies to conformable vectors in an item-by-item fashion. For example, `1 2 3+4 5 6` equals `(1+4),(2+5),(3+6)`, or `5 7 9`. Similarly, Add of an atom and a list is obtained by adding the atom to each item of the list. For example, `1 2 3+5` equals `(1+5),(2+5),(3+5)`, or `6 7 8`.

If the argument lists of Add have additional structure below the first level then Add is applied item-by-item recursively, and for these lists to be conformable they must be conformable at every level; otherwise, a length error is signalled. For example, the arguments in the following expression are conformable at the top level – they are both lists of count 2 – but are not conformable at every level.

```q
q)(1 2 3;(4;5 6 7 8)) + (10;(11 12;13 14 15))
'length
  [0]  (1 2 3;(4;5 6 7 8)) + (10;(11 12;13 14 15))
                           ^
```

Add is applied to these arguments item-by-item, and therefore both `1 2 3+10` and `(4;5 6 7 8)+(11 12;13 14 15)` are evaluated, also item-by-item. When the latter is evaluated, `5 6 7 8+13 14 15` is evaluated in the process, and since `5 6 7 8` and `13 14 15` are not conformable, the evaluation fails.

!!! note "Type and length"

    All atoms in the arguments to Add must be numeric, or else Add will signal a type error. However, the types of the atoms in two lists have nothing to do with conformability, which is only concerned with the lengths of various pairs of sublists from the two arguments.

The following function tests for conformability; its result is 1 if its arguments conform at every level, and 0 otherwise.

```q
conform:{ $[ max 0>type each (x;y) ; 1
           count[x]=count[y] ; min x conform' y; 0]}
```

That is, atoms conform to everything, and two lists conform if they have equal counts and are item-by-item conformable.

Two objects `x` and `y` _conform at the top level_ if they are atoms or lists, and have the same count when both are lists. For example, if `f` is a binary then the arguments of `f'` (that is, `f`-Each) must conform at the top level. By extension, `x` and `y` _conform at the top two levels_ if they conform at the top level and when both are lists, the items `x[i]` and `y[i]` also conform at the top level for every index `i`; and so on.

These conformability concepts are not restricted to pairs of objects. For example, three objects `x`, `y`, and `z` conform if all pairs `x,y` and `y,z` and `x,z` are conformable.


