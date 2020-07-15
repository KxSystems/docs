---
title: Find – Reference – kdb+ and q documentation
description: Find is a q operator that finds the first occurrence of an item in a list. 
author: Stephen Taylor
keywords: find, kdb+, q, query, search
---
# `?` Find

_Find the first occurrence of an item in a list._




Syntax: `x?y`, `?[x;y]`

where `x` is a list or a null, returns for 

1.  atom `y` the smallest index of `y`
-   list `y` the smallest index of each item of `y`

Where `y` or an item of it is not found in `x`, the smallest index is the smallest integer not found in `key x`, i.e. `count x`. Comparisons are exact and are not subject to to [comparison tolerance](../basics/precision.md). 

```q
q)w:10 -8 3 5 -1 2 3
q)w?-8
1
q)w[1]
-8
q)w?3              / the first occurrence of 3
2
q)w?17             / not found
7
q)w[7]
0N
q)"abcde"?"d"
3
```


## Type-specific

Find is type-specific relative to `x`. Where:

1.  `x` is a simple list and `y` a list whose atoms are all the same type as `x`, and whose first item is a list, the result corresponds to `x` item-by-item; i.e. Find is right-atomic.
<pre><code class="language-q">
q)rt:(10 5 -1;-8;3 17)
q)i:w?rt
q)i
0 3 4
7
2 7
q)w[i]
10 5 -1
0N
3 0N
</code></pre>
(If the first item of `y` is an atom, a `type` error is signalled.)

1.  `x` is a list of lists and `y` is a simple list, items of `x` are matched with the whole of `y`.
<pre><code class="language-q">
q)u:("abcde";10 2 -6;(2 3;`ab))
q)u?10 2 -6
1
q)u?"abcde"
0
</code></pre>

1.  `x` is a list of lists and `y` is a mixed list then items of `x` are matched with items of `y`.
<pre><code class="language-q">
q)u?(2 3;`ab)
3 3
</code></pre>

    In this case Find matches items of `x` with `2` `3` and `` `ab `` , not ``(2 3;`ab) ``.


## Rank-sensitive

`x?y` can’t deal with mixed-rank `x`. If rank `x` is _n_ then `x?y` looks for objects of rank _n_-1.
```q
2 3?2 3#til 6  / looks for rank 0 objects
(0 1 2;4 5)?2 3#til 6 / looks for rank 1 objects
```
A solution to find ``(2 3;`ab)`` is
```q
q)f:{where x~\:y}
q)f[u;(2 3;`ab)]
,2
```


## Searching tables

Where `x` is a table then `y` must be a compatible record (dictionary or list) or table. That is, each column of `x`, paired with the corresponding item of `y`, must be valid arguments of Find.
```q
q)\l sp.q
q)sp?(`s1;`p4;200)
3
q)sp?`s`p`qty!(`s2;`p5;450)
12
```






