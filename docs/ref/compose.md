---
title: Compose – compose/curry functions together | Reference | kdb+ and q documentation
description: Compose is a q operator that composes (or curries) a unary value with another. The rank of the result is the rank of the second argument.
author: Stephen Taylor
keywords: adverb, compose, composition, function, kdb+, map, q, value
---
# `'` Compose




_Compose a unary value with another_

```txt
'[f;ff][x;y;z;…]
```

Where

-   `f` is a unary [value](../basics/glossary.md#applicable-value)
-   `ff` is a value rank ≥1

the derived function `'[f;ff]` has the rank of `ff` and returns `f ff[x;y;z;…]`.

```q
q)ff:{[w;x;y;z]w+x+y+z}
q)f:{2*x}
q)d:('[f;ff])               / Use noun syntax to assign a composition
q)d[1;2;3;4]                / f ff[1;2;3;4]
20
q)'[f;ff][1;2;3;4]
20
```

Extend Compose with [Over `/`](accumulators.md) or [`over`](accumulators.md#keywords-scan-and-over) to **compose a list of functions**.
Use

-   `'[;]` to resolve the overloads on `'`
-   noun syntax to pass the composition as an argument to `over`

```q
q)g:10*
q)dd:('[;]) over (g;f;ff)
q)dd[1;2;3;4]
200
q)(('[;])over (g;f;ff))[1;2;3;4]
200
q)'[;]/[(g;f;ff)][1;2;3;4]
200
```


## Implicit composition

_Compose one or more unary values with a higher-rank value_

Values can be composed by juxtaposition within parentheses.

The general form is a sequence of unaries `f`, `g`, `h`… terminating with a value `ff` of rank ≥2. The rank of `(f g h… ff)` is the rank of `ff`.

```q
q)x:-100 2 3 4 -100 6 7 8 9 -100
q)(x;0 (0|+)\x)
-100 2 3 4 -100 6 7  8  9  -100
0    2 5 9 0    6 13 21 30 0
```

Above, `(0|+)` composes the unary projection `0|` with Add. The composition becomes the argument to Scan, which derives the ambivalent function `(0|+)\`, which is then applied infix to 0 and `x` to return cumulative sums.

If we take `-100` to flag parts of `x`, the expression `max 0 (0|+)\x` returns the largest of the sums of the parts.

!!! tip "To compose a sequence of unary values, use [Apply or Apply At](apply.md#composition)."


----
:fontawesome-solid-graduation-cap:
[Q Phrasebook](https://code.kx.com/phrases/)