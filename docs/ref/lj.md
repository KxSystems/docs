---
title: lj – left join keyword | Reference | kdb+ and q documentation
description: lj is a q keyword that performs a left join.
keywords: join, kdb+, left, left join, lj, ljf, q
---
# `lj`, `ljf` 

_Left join_




<pre markdown="1" class="language-txt">
x lj  y     lj [x;y]
x ljf y     ljf[x;y]
</pre>

Where 

-   `x` is a table
-   `y` is 
    -   a keyed table whose key column/s are columns of `x`, returns `x` and `y` joined on the key columns of `y`
    -   or the general empty list `()`, returns `x`

For each record in `x`, the result has one record with the columns of `y` joined to columns of `y`:

-   if there is a matching record in `y`, it is joined to the `x` record; common columns are replaced from `y`.
-   if there is no matching record in `y`, common columns are left unchanged, and new columns are null

```q
q)show x:([]a:1 2 3;b:`I`J`K;c:10 20 30)
a b c
------
1 I 10
2 J 20
3 K 30

q)show y:([a:1 3;b:`I`K]c:1 2;d:10 20)
a b| c d
---| ----
1 I| 1 10
3 K| 2 20

q)x lj y
a b c  d
---------
1 I 1  10
2 J 20
3 K 2  20
```

The `y` columns joined to `x` are given by:

```q
q)y[select a,b from x]
c d
----
1 10
2 20
```


## Changes in V4.0

`lj` checks that `y` is a keyed table. (Since V4.0 2020.03.17.)

```q
q)show x:([]a:1 2 3;b:10 20 30)
a b
----
1 10
2 20
3 30
q)show y:([]a:1 3;b:100 300)
a b
-----
1 100
3 300
q)show r:([]a:1 2 3;b:100 20 300)
a b
-----
1 100
2 20
3 300

q)(1!r)~(1!x)lj 1!y
1b
q)r~t1 lj 1!t2
1b

q)t1 lj t2
'type
  [0]  t1 lj t2
          ^
```


??? detail "Changes in V3.0"

    Since V3.0, the `lj` operator is a cover for `,\:` (Join Each Left) that allows the left argument to be a keyed table. `,\:` was introduced in V2.7 2011.01.24.

    Prior to V3.0, `lj` had similar behavior, with one difference - when there are nulls in the right argument, `lj` in V3.0 uses the right-argument null, while the earlier version left the corresponding value in the left argument unchanged:

    <pre><code class="language-q">
    q)show x:([]a:1 2;b:`x`y;c:10 20)
    a b c
    ------
    1 x 10
    2 y 20
    q)show y:([a:1 2]b:``z;c:1 0N)
    a| b c
    -| ---
    1|   1
    2| z
    q)x lj y        / kdb+ 3.0
    a b c
    -----
    1   1
    2 z
    q)x lj y        / kdb+ 2.8 
    a b c
    ------
    1 x 1
    2 z 20
    </code></pre>

    Since 2014.05.03, the earlier version is available in all V3.x versions as `ljf`.


----
:fontawesome-solid-book-open: 
[Joins](../basics/joins.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.9.2 Ad Hoc Left Join](/q4m3/9_Queries_q-sql/#992-ad-hoc-left-join-lj)

