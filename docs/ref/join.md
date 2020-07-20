---
title: Join – Reference – kdb+ and q documentation
description: Join is a q operator that joins atoms, lists, dictionaries or tables.
author: Stephen Taylor
keywords: atom, dictionary, join, kdb+, list, q
---
# `,` Join



Syntax: `x,y` `,[x;y]`

_Join atoms, lists, dictionaries or tables_

Where `x` and `y` are atoms, lists, dictionaries or tables returns `x` joined to `y`. 

```q
q)1 2 3,4
1 2 3 4
q)1 2,3 4
1 2 3 4
q)(0;1 2.5;01b),(`a;"abc")
(0;1.00 2.50;01b;`a;"abc")
```

The result is a vector if both arguments are vectors or atoms of the same type.

```q
q)1 2.4 5,-7.9 10               /float vectors
1.00 2.40 5.00 -7.90 10.00
q)1 2.4 5,-7.9                  /float vector and atomatom 
1.00 2.40 5.00 -7.90
q)1 2.4 5, -7.9 10e             /float and real vectors
(1.00;2.40;5.00;-7.90e;10.00e)
```

[Cast](cast.md) arguments to ensure vector results.

```q
q)v:1 2.34 -567.1 20e
q)v,(type v)$789                / cast an int to a real
1.00 2.34 -567.1 20.00 789e
q)v,(type v)$1b                 / cast a boolean to a real
1.00 2.34 -567.1 20 1e
q)v,(type v)$0xab
1.00 2.34 -567.1 20.00 171e
```

Tables can be joined row-wise. 

```q
q)t:([]a:1 2 3;b:`a`b`c)
q)s:([]a:10 11;b:`d`e)
q)show t,s
a  b
----
1  a
2  b
3  c
10 d
11 e
```

:fontawesome-solid-globe:
[SQL UNION ALL](https://www.w3schools.com/sql/sql_union.asp)

Tables of the same count can be joined column-wise with `,'` (Join Each).

```q
q)r:([]c:10 20 30;d:1.2 3.4 5.6)
q)show t,'r
q)show t,'r
a b c  d
----------
1 a 10 1.2
2 b 20 3.4
3 c 30 5.6
```

Join for keyed tables is strict; both the key and data columns must match in names and datatypes.

:fontawesome-solid-book: 
[`.Q.dd`](dotq.md#qdd-join-symbols) join symbols
<br>
:fontawesome-solid-book-open: 
[Joins](../basics/joins.md) 


