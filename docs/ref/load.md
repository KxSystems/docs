---
title: load a table | Reference | kdb+ and q documentation
description: load is q keyword that loads binary data from a file or directory.
keywords: directory, file, kdb+, load, q, rload, splayed, table
---
# :fontawesome-solid-database: `load`, `rload`

_Load binary data from a file or directory_




## `load`

_Load binary data from a file_

```txt
load x     load[x]
```

Where `x` is 

-   a symbol atom or vector matching the name/s of datafile/s (with no extension) in the current directory, reads the datafile/s and assigns the value/s to global variable/s of the same name, which it returns
-   a filesymbol atom or vector for datafile/s (with no extension), reads the datafile/s and assigns the value/s to global variable/s of the same name, which it returns
-   a filesymbol for a directory, creates a global dictionary of the same name and within that dictionary recurses on any datafiles the directory contains

!!! tip "Signals a `type` error if the file is not a kdb+ data file"

    There are no text formats corresponding to [` save`](save.md). Instead, use [File Text](file-text.md).


```q
q)t:([]x: 1 2 3; y: 10 20 30)
q)save`t             / save to a binary file (same as `:t set t)
`:t
q)delete t from `.   / delete t
`.
q)t                  / not found
't

q)load`t             / load from a binary file (same as t:get `:t)
`t
q)t
x y
----
1 10
2 20
3 30
```

```q
q)\l sp.q
q)\mkdir -p cb
q)`:cb/p set p
`:cb/p
q)`:cb/s set s
`:cb/s
q)`:cb/sp set sp
`:cb/sp
q)load `cb
`cb
q)key cb
`p`s`sp
q)cb `s
s | name  status city
--| -------------------
s1| smith 20     london
s2| jones 10     paris
s3| blake 30     paris
s4| clark 20     london
s5| adams 30     athens
```

!!! warning "Operating systems may create hidden files, such as `.DS_Store`, that block `load`."


## `rload`

_Load a splayed table from a directory_

```txt
rload x     rload[x]
```

Where `x` is the table name as a symbol, the table is read from a directory of the same name. `rload` is the converse of [`rsave`](save.md#rsave). 

!!! tip "The usual, and more general, way of doing this is to use [`get`](get.md), which allows a table to be defined with a different name than the source directory."

```q
q)\l sp.q
q)rsave `sp           / save splayed table
`:sp/
q)delete sp from `.
`.
q)sp
'sp
q)rload `sp           / load splayed table
`sp
q)3#sp
s  p  qty
---------
s1 p1 300
s1 p2 200
s1 p3 400
q)sp:get `:sp/        / equivalent to rload `sp
```

----
:fontawesome-solid-book: 
[`save`, `rsave`](save.md)  
[`.Q.dsftg`](dotq.md#qdsftg-load-process-save) (load process save), 
[`.Q.fps`](dotq.md#qfps-streaming-algorithm) (streaming algorithm), 
[`.Q.fs`](dotq.md#qfs-streaming-algorithm) (streaming algorithm), 
[`.Q.fsn`](dotq.md#qfsn-streaming-algorithm) (streaming algorithm), 
[`.Q.v`](dotq.md#qv-value) (get splayed table)
<br>
:fontawesome-solid-book-open:
[File system](../basics/files.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§11.2 Save and Load on Tables](/q4m3/1_IO/#112-save-and-load-on-tables)

