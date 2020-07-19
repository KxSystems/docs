---
title: pj – plus join | Reference | kdb+ and q documentation
description: pj is a q keyword that performs a plus join.
keywords: join, kdb+, pj,plus join, q
---
# `pj` 





_Plus join_

```txt
x pj y     pj[x;y]
```

Where

-   `x` and `y` are tables
-   `y` is keyed
-   the key column/s of `y` are columns of `x`

returns `x` and `y` joined on the key columns of `y`.

`pj` adds matching records in `y` to those in `x`, by adding common columns, other than the key columns. These common columns must be of appropriate types for addition.

For each record in `x`:

-   if there is a matching record in `y` it is added to the `x` record.
-   if there is no matching record in `y`, common columns are left unchanged, and new columns are zero.

```q
q)show x:([]a:1 2 3;b:`x`y`z;c:10 20 30)
a b c
------
1 x 10
2 y 20
3 z 30

q)show y:([a:1 3;b:`x`z]c:1 2;d:10 20)
a b| c d
---| ----
1 x| 1 10
3 z| 2 20

q)x pj y
a b c  d
---------
1 x 11 10
2 y 20 0
3 z 32 20
```

In the example above, `pj` is equivalent to `` x+0^y[`a`b#x] `` (compute the value of `y` on `a` and `b` columns of `x`, fill the result with zeros and add to `x`).

---
:fontawesome-solid-book-open:
[Joins](../basics/joins.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.9.6 Plus Join](/q4m3/9_Queries_q-sql/#996-plus-join-pj)

