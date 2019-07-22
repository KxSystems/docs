---
title: each, peach
description: each and peach are q keywords, wrappers for the iterators Each and Each Parallel.
author: Stephen Taylor
keywords: each, iterator, kdb+, map, q
---
# `each`, `peach`




Syntax: `v1 each x`, `each[v1;x]`, `v1 peach x`, `peach[v1;x]`  
Syntax: `(vv)each x`, `each[vv;x]`, `(vv)peach x`, `peach[vv;x]`

Where 

-   `v1` is a unary [applicable value](../basics/glossary.md#applicable-value)
-   `vv` is a [variadic](../basics/variadic.md) applicable value 

applies `v1` or `vv` as a unary to each item of `x` and returns a result of the same length.

That is, the projections `each[v1;]`, `each[vv;]`, `each[v1;]`, and `peach[vv;]` are [uniform](../basics/glossary.md#uniform-function) functions.

```q
q)count each ("the";"quick";" brown";"fox")
3 5 5 3
q)(+\)peach(2 3 4;(5 6;7 8);9 10 11 12)
2 5 9
(5 6;12 14)
9 19 30 42
```

`each` and `peach` perform the same computation and return the same result. 
`peach` will divide the work between available slave tasks. 

`each` is a wrapper for the [Each iterator](maps.md#each). 
`peach` is a wrapper for the [Each Parallel iterator](maps.md#each-parallel). 
It is good q style to use `each` and `peach` for unary values. 

<i class="far fa-hand-point-right"></i>
[Maps](maps.md) for uses of Each with binary and higher-rank values.

## Higher-rank values

`peach` applies only unary values. 
For a values of rank ≥2, use [Apply](apply.md) to project `v` as a unary value. 

For example, suppose `m` is a 4-column matrix and each row has values for the arguments of `v4`. Then `.[v4;]peach m` will apply `v4` to each list of arguments. 

Alternatively, suppose `t` is a table in which columns `b`, `c`, and `a` are arguments of `v3`. Then ``.[v3;]peach flip t `b`c`a`` will apply `v3` to the arguments in each row of `t`.