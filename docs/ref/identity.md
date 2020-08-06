---
title: Identity, Null – Reference – kdb+ and q documentation
description: Identity is a q operator that returns its argument unchanged. Null is a generic null value.
author: Stephen Taylor
keywords: identity, kdb+, null, q
---
# Identity, Null



When the generic null is applied to another value, it is the Identity function.

Indexing with the generic null has the same effect.


## `::` Identity

_Return a value unchanged_


### Applying null to a value

```txt
(::) x     ::[x]
```
  
Where `x` is any value, returns `x`.

```q
q)(::)1
1
```

This can be used in statements applying multiple functions to the same data, if one of the operations desired is "do nothing".

```q
q)(::;avg)@\:1 2 3
1 2 3
2f
```


### Applying a value to null

```txt
x ::      x[::]
```
  
Identity can also be achieved via indexing.

```q
q)1 2 3 ::
1 2 3
```

and used in variants thereof for e.g. amends

```q
q)@[til 10;(::;2 3);2+]
2 3 6 7 6 7 8 9 10 11
```

When prefix notation is used, `x` does not have to be an applicable value.

```q
q)q:3[::]       / not an applicable value
'type
  [0]  q:3[::]
         ^
q)q:3 ::
q)q~3
1b
```


## `::` Null

Q does not have a dedicated null type. Instead `::` is used to denote a generic null value. For example, functions that ‘return no value’, actually return `::`.

```q
q)enlist {1;}[]
::
```

!!! tip "We use `enlist` above to force display of a null result – a pure `::` is not displayed."

When a unary function is called with no arguments, `::` is passed in.

```q
q)enlist {x}[]
::
```

!!! tip "Use `::` to prevent a mixed list changing type."

Since `::` has a type for which no vector variant exists, it is useful to prevent a mixed list from being coerced into a vector when all items happen to be of the same type. (This is important when you need to preserve the ability to add non-conforming items later.)

```q
q)x:(1;2;3)
q)x,:`a
'type
```

but

```q
q)x:(::;1;2)
q)x,:`a  / ok
```

----
:fontawesome-solid-book:
[`null`](null.md)