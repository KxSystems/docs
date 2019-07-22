---
title: get, set
description: get and set are q keywords that read or set value of a variable or a kdb+ data file.
author: Stephen Taylor
keywords: get, kdb+, q, set
---
# `get`, `set`

_Read or set value of a variable or a kdb+ data file_




## `get`

_Read or memory-map a kdb+ data file_

Syntax: `get x`, `get[x]`

Reads or memory maps kdb+ data file `x`. 
A type error is signalled if the file is not a kdb+ data file.

Used to map columns of databases in and out of memory when querying splayed databases, and can be used to read q log files etc.

```q
q)\l trade.q
q)`:NewTrade set trade                  / save trade data to file
`:NewTrade
q)t:get`:NewTrade                       / t is a copy of the table
q)`:SNewTrade/ set .Q.en[`:.;trade]     / save splayed table
`:SNewTrade/
q)s:get`:SNewTrade/                     / s has columns mapped on demand
```

!!! Note "`get` and `value`"

    `get` has several other uses. The function [`value`](value.md) is a synonym for `get`. By convention, it is used for other purposes. But the two are completely interchangeable.

    <pre><code class="language-q">
    q)value "2+3"
    5
    q)get "2+3"
    5
    </code></pre>

<!-- FIXME: describe other uses. -->




## `set`

_Assign a value to a variable or file_

Syntax: `x set y`, `set[x;y]`

Assigns the value of `y` to variable name or filename `x`

```q
q)`a set 1 2 3            / set name a
`a
q)a
1 2 3

q)a:`t
q)a set 1 2 3             / set name t (indirect assignment)
`t
q)t
1 2 3

q)a:"t"
q)a set 1 2 3             / fails, as name must be a symbol
:["type"]
```

If `x` is a filename, the values are written to file:

```q
q)`:work.dat set 1 2 3    / write values to file
`:work.dat
q)get `:work.dat
1 2 3
```

Write a table to a single file:

```q
q)\l sp.q
q)`:mytable.dat set sp
`:mytable.dat
q)get `:mytable.dat
s  p  qty
---------
s1 p1 300
s1 p2 200
s1 p3 400
..
```

To save a table splayed across a directory, `x` must be a path (i.e. ends with a `/`), and the table must be fully enumerated, with no primary keys:

```q
q)`:mydata/ set sp
`:mydata/
q)\ls mydata
,"p"
"qty"
,"s"
q)get `:mydata
s  p  qty
---------
s1 p1 300
s1 p2 200
s1 p3 400
..
```

!!! warning "Avoid Kx namespaces"

    Avoid setting variables in the Kx namespaces, as undesired and confusing behaviour can result.

    These are `.h`, `.j`, `.Q`, `.q`, `.z`, and any other namespaces with single-character names.


<i class="far fa-hand-point-right"></i>
[`value`](value.md)  
Basics: [File system](../basics/files.md)
