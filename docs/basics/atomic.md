---
title: Atomic functions and implicit iteration | Basics | kdb+ and q documentation
description: Many q functions iterate recursively through list or dictionary arguments down to items of some depth
author: Stephen Taylor
---
# :fontawesome-solid-sitemap: Atomic functions





_Many q functions iterate recursively through list or dictionary arguments down to items of some depth._

Where a function recurses to the atoms of an argument, it is _atomic_ in that domain: typically, _left-atomic_, _right-atomic_; or simply _atomic_ for all its arguments. 

A function that recurses to strings is _string-atomic_.


## Formal definition

Where `f` is a function, and `x` is a list of its arguments, `.[f;x]~.[f';x]`.

```q
q).[+;(2;(3 4;5))]
5 6
7
q).[+';(2;(3 4;5))]   / the iterator is unnecessary
5 6
7
```

:fontawesome-solid-book-open:
[Application, projection, and indexing](application.md)

By extension, for a unary function, `f` is atomic if `f[x]~f'[x]`.

```q
q)neg (5 2; 3; -8 0 2)
-5 -2
-3
8 0 -2
q)neg each (5 2; 3; -8 0 2)   / the iterator is unnecessary
-5 -2
-3
8 0 -2
```


## Informal definition

A unary is atomic if it applies to both atoms and lists, and in the case of a list, applies independently to every atom in the list. For example, the unary `neg` is atomic. A result of `neg` is just like its argument, except that each atom in an argument is replaced by its negation. 

```q
q)neg 3 4 5
-3 -4 -5
q)neg (5 2; 3; -8 0 2)
-5 -2
-3
8 0 -2
```

`neg` applies to a list by applying independently to every item. Accessing the `i`th item of a list `x` is denoted by `x[i]` , and therefore the rule for how `neg` applies to a list `x` is that the `i`th item of `neg x`, which is `(neg x)[i]`, is `neg` applied to the `i`th item.

`neg` can be defined recursively for lists in terms of its definition for atoms. To do so we need two language constructs. 

-   Any function `f` can be applied independently to the items of a list by modifying the function with the Each iterator, as in `f'`. 
-   The function `{0>type x}` has the value 1 when `x` is an atom, and 0 when `x` is a list. 

Using these constructs, `neg` can be defined as follows:

```q
neg:{$[0>type x; 0-x; neg'[x]]}
```

That is, if `x` is an atom then `neg x` is `0-x`, and otherwise `neg` is applied independently to every item of the list `x`. One can see from this definition that `neg` and `neg'` are identical. In general, this is the definition of atomic: a function `f` of any number of arguments is atomic if `f` is identical to `f'`.

A binary `f` is atomic if the following rules apply (these follow from the general definition that was given just above, or can be taken on their own merit):

-   `f[x;y]` is defined for atoms `x` and `y`
-   for an atom `x` and a list `y`, the result `f[x;y]` is a list whose ith item is `f[x;y[i]]`
-   for a list `x` and an atom `y`, the result `f[x;y]` is a list whose ith item is `f[x[i];y]`
-   for lists `x` and `y`, the result `f[x;y]` is a list whose ith item is
`f[x[i];y[i]]`

For example, the operator Add is atomic.

```q
q)2 + 3                      q)2 6 + 3 
5                            5 9
q)2 + 3 -8                   q)2 6 + 3 -8 
5 -6                         5 -2

q)(2; 3 4) + ((5 6; 7 8 9); (10; 11 12))
7 8 9 10 11
13  15 16
```

In the last example both arguments have count 2. The first item of the left argument, `2`, is added to the first item of the right argument, `(5 6; 7 8 9)`, while the second argument of the left argument, `3 4`, is added to the second argument of the right argument, `(10; 11 12)`. When adding the first items of the two lists, the atom `2` is added to every atom in `(5 6; 7 8 9)` to give `(7 8; 9 10 11)`, and when adding the second items, `3` is added to `10` to give `13`, and `4` is added to both atoms of `11 12` to give `15 16`.

Add can be defined recursively in terms of Add for atoms as follows:

```q
q)Add:{$[(0>type x) & 0>type y; x + y; Add'[x;y]]}
```


## Length and type

The arguments of an atomic function must be [conformable](conformable.md).

```q
q)1 2 3 + 4 5
'length
  [0]  1 2 3 + 4 5
             ^
```

Type errors can arise at depth. 

```q
q)1 2 3 + (4;"a";5)
'type
  [0]  1 2 3 + (4;"a";5)
             ^
```


## Rank

Atomic functions are not restricted to ranks 1 and 2. For example, the ternary `{x+y xexp z}` (“x plus y to the power z”) is atomic.


## Left- and right-atomic

A function can be atomic relative to some of its arguments but not all. For example, the Index At operator `@[x;y]` is an atomic function of its right argument but not its left, and is said to be _right-atomic_, or atomic in its second argument. That is, for every left argument `x` the projected unary function `x@` is atomic. This primitive function, like `x[y]`, selects items from `x` according to the atoms in `y`, and the result is structurally like `y`, except that every atom in `y` is replaced by the item of `x` that it selects. 

```q
q)2 4 -23 8 7 @ (0 4 ; 2)
2 7
-23
```

Index 0 selects 2; index 4 selects 7; and index 2 selects -23. 

<!-- 
!!! tip "Items of `x` do not have to be atoms"

    It is common in definitions of atomic functions to describe application to atom arguments and assume the reader understands how the description extends to list arguments.
-->


## String-atomic

Q does not have a string datatype. What we call _strings_ are char vectors.

Some functions that apply to strings recurse until they find either strings or char atoms. 
They are _string-atomic_.

```q
q)upper ("quick";("brown";"fox");"x")
"QUICK"
("BROWN";"FOX")
"X"
```

----
:fontawesome-solid-street-view:
_Q for Mortals_
[§6.6 Atomic Functions](/q4m3/6_Functions/#66-atomic-functions)
