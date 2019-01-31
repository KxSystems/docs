---
keywords: adverb, compose, composition, iterable, function, kdb+, map, q
---

# `'` Compose



_Compose a unary iterable with another._

Syntax: `'[f;ff][x;y;z;…]` 

Where 

-   `f` is a unary [iterable](glossary.md/#iterable)
-   `ff` is an iterable rank ≥1

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

Extend Compose with [Over `/`](progressors.md) or [`over`](progressors.md#keywords-scan-and-over) to **compose a list of functions**.
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



