---
title: prior – a wrapper for the Each Prior iterator | Reference | kdb+ and q documentation
description: prior is a q keyword that is a wrapper for the Each Prior iterator.
author: Stephen Taylor
date: March 2019
---
# `prior`



```txt
 v2 prior x      prior[v2;x]
(vv)prior x      prior[vv;x]
```

Where

-   `v2` is a binary [applicable value](../basics/glossary.md#applicable-value)
-   `vv` is a [variadic](../basics/variadic.md) applicable value

applies `v2` or `vv` to each item of `x` and the item preceding it, and returns a result of the same length.

That is, the projections  `prior[v2;]` and `prior[vv;]` are [uniform](../basics/glossary.md#uniform-function) functions.

```q
q)(+) prior til 10
0 1 3 5 7 9 11 13 15 17
q){x+y%10}prior til 10
0n 1 2.1 3.2 4.3 5.4 6.5 7.6 8.7 9.8
```

`prior` is a wrapper for the [Each Prior](maps.md#each-prior) iterator.

See the [iterator](maps.md#each-prior) for how the first item of the result is determined.

!!! tip "It is good q style to use `prior` rather than the iterator, except where iterators are composed and brevity helps."

----

:fontawesome-solid-book:
[Each Prior](maps.md#each-prior)