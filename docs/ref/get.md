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

_Assign a value to a variable; persist an object as a file or directory_

```txt
x set y                    set[x;y]
dir set t                  set[dir;t]                     / splayed table
(fil;lbs;alg;lvl) set y    set[(fil;lbs;alg;lvl);y]       / object as compressed file
(dir;lbs;alg;lvl) set t    set[(dir;lbs;alg;lvl);t]       / compressed splayed table
(dir;dic) set t            set[(dir;dic);t]               / compressed splayed table
```

Where 

-   `x` is a global variable named as a symbol atom, or a filesymbol
-   `y` is a kdb+ object
-   `t` is a table
-   `dir` is a filesymbol for a directory in the filesystem
-   `fil` is a filesymbol for a file in the filesystem
-   `lbs`, `alg`, and `lvl` are logical block size, compression algorithm, and lvl as for [`-19!`](../basics/internal.md#-19-compress-file)
-   `dic` is a dictionary of compression specifications, as described below

`x set y`

: Where `x` is a valid q name as a symbol atom, that name is assigned `y` as its value.

: Where `x` is a filesymbol, `y` is serialized as that file. 

`dir set t`

: Table `t` is [splayed](../kb/splayed-tables.md) as directory `dir`.

`(fil;lbs;alg;lvl) set y`

: Object `y` is serialized compressed as file `fil`.

`(dir;lbs;alg;lvl) set t`

: Table `t` is serialized compressed as directory `dir`.

`(dir;dic) set t`

: Table `t` is serialized as directory `dir` with columns compressed as described by `dic`.

```
q)`a set 42                         / set global variable
`a
q)a
42

q)`:a set 42                        / serialize object to file
`:a

q)t:([]tim:100?23:59;qty:100?1000)  / splay table
q)`:tbl/ set t
`:tbl/

q)(`:ztbl;17;2;6) set t             / serialize compressed
`:ztbl

q)(`:ztbl/;17;2;6) set t            / splay table compressed
`:ztbl/
```

See [_Compression_](#compression) for how to specify compression by column.


### Splayed table

To splay a table `t` to directory `dir`

-   `dir` must be a filesymbol that ends with a `/`
-   `t` must have no primary keys
-   columns of `t` must be vectors or [compound lists](../basics/glossary.md#compound-list)
-   symbol columns in `t` must be fully enumerated

:fontawesome-solid-database:
[Splayed tables](../kb/splayed-tables.md)


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


### Compression

For 

```q
(fil;lbs;alg;lvl) set y
(dir;lbs;alg;lvl) set t
```

the left-argument list corresponds to the last four items of the right argument of [`-19!`](../basics/internal.md#-19-compress-file).

Splay table `t` to directory `ztbl/` with gzip compression:

```q
q)(`:ztbl/;17;2;6) set t
`:ztbl/
```

For `(dir;dic) set t` the keys of `dic` are either column names of `t` or the null symbol `` `  ``. The value of each entry is a 3-list of ints: `lbs`, `alg`, and `lvl`. 

Compression for unspecified columns is specified either by an entry for the null symbol (as below) or by [`.z.zd`](dotz.md#zzd-zip-defaults).

```q
q)m1:1000000
q)t:([]a:m1?10;b:m1?10;c:m1?10;d:m1?10)

q)/specify compression for cols a, b and defaults for others
q)show dic:``a`b!(17 2 9;17 2 6;17 2 6)
 | 17 2 9
a| 17 2 6
b| 17 2 6
q)(`:ztbl/;dic) set t               / splay table compressed
`:ztbl/
```


----
:fontawesome-solid-book:
[`eval`](eval.md),
[`value`](value.md)
<br>
:fontawesome-solid-book-open:
[File system](../basics/files.md)
<br>
:fontawesome-solid-database:
[File compression](../kb/file-compression.md)
