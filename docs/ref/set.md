# `set`



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
[File system](../basics/files.md)

