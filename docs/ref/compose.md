---
keywords: adverb, compose, composition, function, kdb+, map, q, value
---

# `'` Compose



_Compose a unary value with another._

Syntax: `'[f;ff][x;y;z;…]` 

Where 

-   `f` is a unary [value](glossary.md#applicable-value)
-   `ff` is a value rank ≥1

the derived function `'[f;ff]` has the rank of `ff` and returns `f ff[x;y;z;…]`. 

```q
q)ff:{[w;x;y;z]w+x+y+z}
q)f:{2*x}
q)d:('[f;fff])              / Use noun syntax to assign a composition
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



