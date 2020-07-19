---
title: ij, ijf – inner join | Reference | kdb+ and q documentation
description: ij and ijf are q keywords that perform inner joins.
author: Stephen Taylor
keywords: ij, ijf, inner join, join, kdb+, q
---
# `ij`, `ijf`






_Inner join_


<pre markdown="1" class="language-txt">
x ij  y     ij [x;y]
x ijf y     ijf[x;y]
</pre>
Where

-   `x` and `y` are tables
-   `y` is keyed, and its key columns are columns of `x`

returns two tables joined on the key columns of the second table.
The result has one combined record for each row in `x` that matches a row in `y`.

```q
q)t
sym  price
---------------
IBM  0.7029677
FDP  0.08378167
FDP  0.06046216
FDP  0.658985
IBM  0.2608152
MSFT 0.5433888

q)s
sym | ex  MC
----| --------
IBM | N   1000
MSFT| CME 250

q)t ij s
sym  price     ex  MC
-----------------------
IBM  0.7029677 N   1000
IBM  0.2608152 N   1000
MSFT 0.5433888 CME 250
```

Common columns are replaced from `y`.

```q
q)([] k:1 2 3 4; v:10 20 30 40) ij ([k:2 3 4 5]; v:200 300 400 500;s:`a`b`c`d)
k v   s
-------
2 200 a
3 300 b
4 400 c
```

??? detail "Changes in V3.0"

    Since V3.0, `ij` has changed behavior (similarly to `lj`): when there are nulls in `y`, `ij` uses the `y` null, where the earlier version left the corresponding value in `x` unchanged:

    <pre><code class="language-q">
    q)show x:([]a:1 2;b:`x`y;c:10 20)
    a b c
    \------
    1 x 10
    2 y 20
    q)show y:([a:1 2]b:``z;c:1 0N)
    a| b c
    \-| ---
    1|   1
    2| z
    q)x ij y        /V3.0
    a b c
    \-----
    1   1
    2 z
    q)x ij y        /V2.8
    a b c
    \------
    1 x 1
    2 z 20
    </code></pre>

    Since 2016.02.17, the earlier version is available in all V3.4 and later versions as `ijf`.

---
:fontawesome-solid-book-open:
[Joins](../basics/joins.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.9.4 Ad Hoc Inner Join](/q4m3/9_Queries_q-sql/#994-ad-hoc-inner-join-ij)

