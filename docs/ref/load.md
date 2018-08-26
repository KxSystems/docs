# `load`



_Load binary data from the filesystem_

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

<i class="far fa-hand-point-right"></i> 
[`.Q.dsftg`](dotq.md#qdsftg-load-process-save) (load process save), 
[`.Q.fps`](dotq.md#qfps-streaming-algorithm) (streaming algorithm), 
[`.Q.fs`](dotq.md#qfs-streaming-algorithm) (streaming algorithm), 
[`.Q.fsn`](dotq.md#qfsn-streaming-algorithm) (streaming algorithm), 
[File system](../basics/files.md)
