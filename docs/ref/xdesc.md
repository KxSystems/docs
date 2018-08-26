# `xdesc`



_Sorts a table in descending order of specified columns. 
The sort is by the first column specified, then by the second column within the first, and so on._

Syntax: `x xdesc y`, `xdesc[x;y]`

Where `x` is a symbol vector of column names defined in `y`, which is passed by

- value, returns
- reference, updates 

`y` sorted in descending order by `x`. 

The `` `s# `` attribute is not set.
The sort is stable, i.e. it preserves order amongst equals.
```q
q)\l sp.q
q)s
s | name  status city
--| -------------------
s1| smith 20     london
s2| jones 10     paris
s3| blake 30     paris
s4| clark 20     london
s5| adams 30     athens
q)`city xdesc s                 / sort descending by city
s | name  status city
--| -------------------
s2| jones 10     paris
s3| blake 30     paris
s1| smith 20     london
s4| clark 20     london
s5| adams 30     athens
q)meta `city xdesc s            / `s# attribute not set
c     | t f a
------| -----
s     | s
name  | s
status| i
city  | s
```


<i class="far fa-hand-point-right"></i>
[Dictionaries & tables](../basics/dictsandtables.md)