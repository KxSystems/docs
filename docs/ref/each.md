---
title: each, peach | Reference | kdb+ and q documentation
description: each and peach are q keywords, wrappers for the map iterators Each and Each Parallel.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `each`, `peach`

_Iterate a unary_

```syntax
 v1 each x   each[v1;x]       v1 peach x   peach[v1;x]  
(vv)each x   each[vv;x]      (vv)peach x   peach[vv;x]
```

Where

- `v1` is a unary [applicable value](glossary.md#applicable-value)
- `vv` is a [variadic](variadic.md) applicable value

applies `v1` or `vv` as a unary to each item of `x` and returns a result of the same length.

That is, the projections `each[v1;]`, `each[vv;]`, `peach[v1;]`, and `peach[vv;]` are [uniform](glossary.md#uniform-function) functions.

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

!!! note "Changes since 4.1t 2024.01.04"

    peach workload distribution methodology changed to dynamically redistribute workload and allow nested invocation. The limitations on nesting have been removed, so peach (and multi-threaded primitives) can be used inside peach. To facilitate this, round-robin scheduling has been removed. Even though the initial work is still distributed in the same manner as before for compatibility, the workload is dynamically redistributed if a thread finishes its share before the others.

`each` is a wrapper for the [Each iterator](maps.md#each).
`peach` is a wrapper for the [Each Parallel iterator](maps.md#each-parallel).
It is good q style to use `each` and `peach` for unary values.

!!! warning "`each` is redundant with [atomic functions](atomic.md)."

[Maps](maps.md) for uses of Each with binary and higher-rank values
<br>

[`.Q.fc` parallel on cut](dotq.md#fc-parallel-on-cut)
<br>

[Parallel processing](../how_to/performance/performance.md#parallel-processing)
<br>

[Table counts in a partitioned database](../how_to/interact_with_databases/partition.md#table-counts)
<br>

_Q for Mortals_
[A.49 `peach`](../learn/q4m/A_Built-in_Functions.md#a49-peach)

## Higher-rank values

`peach` applies only unary values.
For a values of rank ≥2, use [Apply](apply.md) to project `v` as a unary value.

For example, suppose `m` is a 4-column matrix and each row has values for the arguments of `v4`. Then `.[v4;]peach m` will apply `v4` to each list of arguments.

Alternatively, suppose `t` is a table in which columns `b`, `c`, and `a` are arguments of `v3`. Then ``.[v3;]peach flip t `b`c`a`` will apply `v3` to the arguments in each row of `t`.

## Blocked within `peach`

```txt
hopen socket
websocket open
socket broadcast (25!x)
amending global variables
load master decryption key (-36!)
```

And any **system command** which might cause a change of global state.

Generally, do not use a **socket** within `peach`, unless it is encapsulated via [one-shot sync request](hopen.md#one-shot-request) or HTTP client request (TLS/SSL support added in 4.1t 2023.11.10). Erroneous socket usage is blocked and signals a `nosocket` error.

If you are careful to manage your **file handles/file access** so that there is no parallel use of the same handle (or file) across threads, then you can open and close files within `peach`.

**Streaming execute** ([`-11!`](internal.md#-11-streaming-execute)) should also be fine. However updates to global variables are not possible, so use cases might be quite restricted within `peach`.
