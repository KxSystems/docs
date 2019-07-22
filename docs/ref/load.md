---
title: load
description: load is q keyword that loads binary data from a file or directory.
keywords: directory, file, kdb+, load, q, rload, splayed, table
---
# `load`, `rload`

_Load binary data from a file or directory_




## `load`

_Load binary data from a file_

Syntax: `load x`, `load[x]`

Loads binary data from the filesystem and returns the name of the table loaded.

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

If `x` is a directory, a dictionary of that name is created and all data files are loaded into that dictionary, keyed by file name.

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


## `rload`

_Load a splayed table from a directory_

Syntax: `rload x`, `rload[x]`

Where `x` is the table name as a symbol, the table is read from a directory of the same name. `rload` is the converse of [`rsave`](save.md#rsave). 

The usual, and more general, way of doing this is to use [`get`](get.md), which allows a table to be defined with a different name than the source directory.

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


<i class="far fa-hand-point-right"></i> 
[`save`, `rsave`](save.md)  
[`.Q.dsftg`](dotq.md#qdsftg-load-process-save) (load process save), 
[`.Q.fps`](dotq.md#qfps-streaming-algorithm) (streaming algorithm), 
[`.Q.fs`](dotq.md#qfs-streaming-algorithm) (streaming algorithm), 
[`.Q.fsn`](dotq.md#qfsn-streaming-algorithm) (streaming algorithm), 
[`.Q.v`](dotq.md#qv-value) (get splayed table)   
Basics: [File system](../basics/files.md)


