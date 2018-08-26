# `rsave`




_Save a table spayed to a directory_

Syntax: `rsave x`, `rsave[x]`

Where `x` is a table name as a symbol, saves the table, splayed to a directory of the same name.
The table must be fully enumerated and not keyed.

The usual and more general way of doing this is to use [`set`](set.md), which allows the target directory to be given.

```q
q)\l sp.q
q)rsave `sp           / save splayed table
`:sp/
q)\ls sp
,"p"
"qty"
,"s"
q)`:sp/ set sp        / equivalent to rsave `sp
`:sp/
```

<i class="far fa-hand-point-right"></i> 
[`set`](set.md),
[`.Q.dpft`](dotq.md#qchk-fill-hdb) (save table),
[File system](../basics/files.md)
