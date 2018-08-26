# `rload`




_Load a splayed table_

Syntax: `rload x`, `rload[x]`

Where `x` is the table name as a symbol, the table is read from a directory of the same name. `rload` is the converse of [`rsave`](rsave.md). 

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
[`.Q.v`](dotq.md#qv-value) (get splayed table),
[File system](../basics/files.md)

