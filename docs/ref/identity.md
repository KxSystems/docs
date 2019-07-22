---
title: Identity, Null
description: Identity is a q operator that returns its argument unchanged. Null is a generic null value.
author: Stephen Taylor
keywords: identity, kdb+, null, q
---
# Identity, Null



## `::` Identity

_Return an argument unchanged_

Syntax: `(::) x`, `::[x]`
  
Returns `x`.

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

Similarly, the identity can also be achieved via indexing.

```q
q)1 2 3 ::
1 2 3
```

and used in variants thereof for e.g. amends

```q
q)@[til 10;(::;2 3);2+]
2 3 6 7 6 7 8 9 10 11
```


## `::` Null

Q does not have a dedicated null type. Instead `::` is used to denote a generic null value. For example, functions that return no value, return `::`.

```q
q)enlist {1;}[]
::
```

We use `enlist` to force display of a null result: a pure `::` is not displayed.

When a unary function is called with no arguments, `::` is passed in.

```q
q)enlist {x}[]
::
```

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


<i class="far fa-hand-point-right"></i>
[`null`](null.md)