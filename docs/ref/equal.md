---
title: Equal | Reference | kdb+ and q documentation
description: Equal is a q operator that flags where its arguments are equal.
author: Stephen Taylor
keywords: equal, kdb+, q
---
# `=` Equal



Syntax: `x = y`, `=[x;y]`

Returns `1b` where (items of) `x` and `y` are equal.

```q
q)(3;"a")=(2 3 4;"abc")
010b
100b
```

Equal is an atomic function.

:fontawesome-solid-book: 
[Not Equal `<>`](not-equal.md)
<br>
:fontawesome-solid-book-open: 
[Comparison](../basics/comparison.md)
<br>
:fontawesome-solid-street-view: 
_Q for Mortals_: [§4.3.1 Equality = and Disequality <>](/q4m3/4_Operators/#431-equality-and-disequality)
