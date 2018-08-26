# `prds`

Syntax: `prds x` (atomic)

Returns the cumulative products of the items of `x`. The product of an atom is itself. Nulls are treated as 1s.
```q
q)prds 7                     / atom is returned unchanged
7
q)prds 2 3 5 7               / cumulative products of list
2 6 30 210
q)prds 2 3 0N 7              / 0N is treated as 1
2 6 6 42
q)prds (1 2 3;2 3 5)         / cumulative products of list of lists
1 2 3                        / same as (1 2 3;1 2 3 * 2 3 5)
2 6 15
q)prds "abc"                 / type error if list is not numeric
'type
```

<i class="far fa-hand-point-right"></i> [Mathematics](/basics/math), [`prd`](prd) 


