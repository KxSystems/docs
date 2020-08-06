---
title: get, set – Reference – kdb+ and q documentation
description: get and set are q keywords that read or set value of a variable or a kdb+ data file.
author: Stephen Taylor
keywords: get, kdb+, q, set
---
# :fontawesome-solid-database: `get`, `set`

_Read or set the value of a variable or a kdb+ data file_




## `get`

_Read or memory-map a variable or kdb+ data file_

```txt
get x     get[x]
```

Where `x` is

-   the name of a global variable as a symbol atom
-   a [file or folder](../basics/glossary.md#file-symbol) named as a symbol atom or vector

returns its value.

Signals a `type` error if the file is not a kdb+ data file.

Used to map columns of databases in and out of memory when querying splayed databases, and can be used to read q log files, etc.

```q
q)a:42
q)get `a
42

q)\l trade.q
q)`:NewTrade set trade                  / save trade data to file
`:NewTrade
q)t:get`:NewTrade                       / t is a copy of the table
q)`:SNewTrade/ set .Q.en[`:.;trade]     / save splayed table
`:SNewTrade/
q)s:get`:SNewTrade/                     / s has columns mapped on demand
```

??? note "`value` is a synonym for `get`"

    By convention, [`value`](value.md) is used for other purposes. But the two are completely interchangeable.

    <pre><code class="language-q">
    q)value "2+3"
    5
    q)get "2+3"
    5
    </code></pre>

    <!-- FIXME: describe other uses. -->




## `set`

_Assign a value to a variable or file_

```txt
x set y     set[x;y]
```

Where `x` is 

-   a global variable named as a symbol atom
-   a [file or folder](../basics/glossary.md#file-symbol) named as a symbol atom 

assigns the value of `y` to `x`.

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


If `x` is a file symbol, the values are written to file.

```q
q)`:work.dat set 1 2 3    / write values to file
`:work.dat
q)get `:work.dat
1 2 3
```


### Table to file

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


### Table to directory

To save a table `y` splayed across a directory `x`

-   `x` must be a path that ends with a `/`
-   `y` must have no primary keys
-   columns of `y` must be vectors or [compound lists](../basics/glossary.md#compound-list)
-   symbol columns in `y` must be fully enumerated

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


### Format 

`set` saves the data in a binary format akin to tag+value, retaining the structure of the data in addition to its value.

```q
q)`:data/foo set 10 20 30
`:data/foo
q)read0 `:data/foo
"\376 \007\000\000\000\000\000\003\000\000\000\000\000\000\000"
"\000\000\000\000\000\000\000\024\000\000\000\000\000\000\000\036\000..
```

??? warning "Avoid setting variables in the Kx namespaces, as undesired and confusing behavior can result."

    These are `.h`, `.j`, `.Q`, `.q`, `.z`, and any other namespaces with single-character names.

----
:fontawesome-solid-book:
[`eval`](eval.md),
[`value`](value.md)
<br>
:fontawesome-solid-book-open:
[File system](../basics/files.md)
