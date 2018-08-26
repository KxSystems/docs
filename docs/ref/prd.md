# `prd`


Syntax: `prd x`, `prd[x]` (aggregate)

Product: where `x` is

-   a simple numeric list, returns the product of the items of `x`
-   an atom, returns `x`
-   a list of numeric lists, returns their products

Nulls are treated as 1s.
```q
q)prd 7                    / product of atom (returned unchanged)
7
q)prd 2 3 5 7              / product of list
210
q)prd 2 3 0N 7             / 0N is treated as 1
42
q)prd (1 2 3 4;2 3 5 7)    / product of list of lists
2 6 15 28
q)prd "abc"
'type
```

<i class="far fa-hand-point-right"></i> [Mathematics](/basics/math), [`prds`](prds) 
