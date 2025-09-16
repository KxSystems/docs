---
title: Join atoms, lists, dictionaries or tables | Reference | kdb+ and q documentation
description: Join is a q operator that joins atoms, lists, dictionaries or tables.
author: Stephen Taylor
---
# `,` `,:` Join and Append
## `,` Join

_Join atoms, lists, dictionaries or tables_


```syntax
x,y    ,[x;y]
```

Where `x` and `y` are atoms, lists, dictionaries or tables returns `x` joined to `y`. 

```q
q)1 2 3,4
1 2 3 4
q)1 2,3 4
1 2 3 4
q)(0;1 2.5;01b),(`a;"abc")
(0;1.00 2.50;01b;`a;"abc")
```

The result is a vector if both arguments are vectors or atoms of the same type; otherwise a mixed list.

```q
q)1 2.4 5,-7.9 10               /float vectors
1.00 2.40 5.00 -7.90 10.00
q)1 2.4 5,-7.9                  /float vector and atom
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

The result is a general list if the two arugments are [enumeration](enumerate.md) atoms of different domains, or one is an enumeration and the other is a regular symbol:

```q
q)sym:`a`b
q)sym2:`c`d
q)(`sym$`b),`sym2$`b
`sym$`b
`sym2$`b
q)(`sym$`b),`b
`sym$`b
`b
q)`b,(`sym$`b)
`b
`sym$`b
```

On the other hand, if either or both arguments are lists and not of the same enumeration domain, any enumerations are de-enumerated:

```q
q)(`sym$`a`b),`sym2$`b`c
`a`b`b`c
q)(`sym$`a),`c`d
`a`c`d
q)(`sym$`a`b),`c
`a`b`c
q)`a,`sym2$`b`c
`a`b`c
q)`a`b,`sym2$`c
`a`b`c
```

`,`(join) is a [multithreaded primitive](../kb/mt-primitives.md).


### Dictionaries

When both arguments are dictionaries, Join has upsert semantics.

```q
q)(`a`b`c!1 2 3),`c`d!4 5
a| 1
b| 2
c| 4
d| 5
```


### Tables

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

:fontawesome-solid-book:
[`uj`](uj.md) union join
<br>
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

## `,:` Append

```syntax
x,:y   ,:[x;y]
```

Where

* `x` is a variable containing a list or dictionary
* `y` is an atom or a list if `x` contains a list
* `y` is a dictionary if `x` contains a dictionary

Appends the item(s) of `y` to the variable `x`. This is the [assign through operator](assign.md#assign-through-operator) form of `,`, but it has major differences.

If `x` contains a simple list, `y` must be an atom or simple list of the same type. If `x` contains a dictionary whose values are a simple list, `y` must be a dictionary with values of the same type.

```q
q)s:1 2 3
q)s,:4
q)s
1 2 3 4
q)s,:5f
'type
  [0]  s,:5f
        ^
q)s:([a:1;b:2])
q)s,:([a:3;c:4])
q)s
a| 3
b| 2
c| 4
q)s,:([d:5f])
'type
  [0]  s,:([d:5f])
        ^
```

If `x` contains a general list, any item(s) can be appended. However, if the rank (defined as the recursive depth of the first element) of `x` is one higher than that of `y`, `y` is implicitly enlisted. This gives a different result from `x:x,y`.

```q
q)s:(::;3;4)
q)s,:5f
q)s
::
3
4
5f
q)s:enlist 1 2 3    / rank 2
q)s,4 5 6           / rank 1
1 2 3
4
5
6
q)s,:4 5 6
q)s
1 2 3
4 5 6
```

If `x` contains an enumeration, append will enumerate `y` against `x`'s domain, which may fail if the appended symbols are not in that domain:

```q
q)sym:`a`b
q)e:`sym$`a`b
q)e,:`b
q)e
`sym$`a`b`b
q)e,:`c
'cast
  [0]  e,:`c
        ^

```

Conversely, if `x` contains unenumerated symbols, any enumerations are de-enumerated as part of the append:

```q
q)s:`a`c
q)s,:`sym$`b
q)s
`a`c`b
```

----

:fontawesome-solid-book: 
[`.Q.dd`](dotq.md#dd-join-symbols) join symbols
<br>
:fontawesome-solid-book-open: 
[Joins](../basics/joins.md) 


