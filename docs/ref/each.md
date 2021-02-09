---
title: each, peach | Reference | kdb+ and q documentation
description: each and peach are q keywords, wrappers for the map iterators Each and Each Parallel.
author: Stephen Taylor
---
# `each`, `peach`


_Iterate a unary_

```txt
 v1 each x   each[v1;x]       v1 peach x   peach[v1;x]  
(vv)each x   each[vv;x]      (vv)peach x   peach[vv;x]
```

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
`peach` will divide the work between available secondary tasks. 

`each` is a wrapper for the [Each iterator](maps.md#each). 
`peach` is a wrapper for the [Each Parallel iterator](maps.md#each-parallel). 
It is good q style to use `each` and `peach` for unary values. 

!!! warning "`each` is redundant with [atomic functions](../basics/atomic.md). (Common qbie mistake.)"

:fontawesome-solid-book:
[Maps](maps.md) for uses of Each with binary and higher-rank values
<br>
:fontawesome-solid-book:
[`.Q.fc` parallel on cut](dotq.md#qfc-parallel-on-cut)
<br>
:fontawesome-solid-book-open:
[Parallel processing](../basics/peach.md)
<br>
:fontawesome-solid-graduation-cap:
[Table counts in a partitioned database](../kb/partition.md#table-counts)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[A.68 `peach`](/q4m3/A_Built-in_Functions/#a68-peach)


## Higher-rank values

`peach` applies only unary values. 
For a values of rank ≥2, use [Apply](apply.md) to project `v` as a unary value. 

For example, suppose `m` is a 4-column matrix and each row has values for the arguments of `v4`. Then `.[v4;]peach m` will apply `v4` to each list of arguments. 

Alternatively, suppose `t` is a table in which columns `b`, `c`, and `a` are arguments of `v3`. Then ``.[v3;]peach flip t `b`c`a`` will apply `v3` to the arguments in each row of `t`.



## :fontawesome-solid-exclamation-triangle: Blocked within `peach`

```txt
hopen socket
websocket open
socket broadcast (25!x)
amending global variables
load master decryption key (-36!)
```

And any **system command** which might cause a change of global state.

Generally, do not use a **socket** within `peach`, unless it is encapsulated via one-shot or HTTP client request.

If you are careful to manage your **file handles/file access** so that there is no parallel use of the same handle (or file) across threads, then you can open and close files within `peach`.

**Streaming execute** ([`-11!`](../basics/internal.md#-11-streaming-execute)) should also be fine. However updates to global variables are not possible, so use cases might be quite restricted within `peach`.