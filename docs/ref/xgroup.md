---
title: xgroup
description: xgroup is a q keyword that groups a table by values in selected columns.
author: Stephen Taylor
keywords: column, group, kdb+, q, xgroup
---
# `xgroup`




_Groups a table by values in selected columns_

Syntax: `x xgroup y`,`xgroup[x;y]`

Where 

-   `y` is a table passed by value 
-   `x` is a symbol atom or vector of column names in `y`

returns `y` grouped by `x`.
It is equivalent to doing a `select … by` on `y`, except that all the remaining columns are grouped without having to be listed explicitly.

```q
q)`a`b xgroup ([]a:0 0 1 1 2;b:`a`a`c`d`e;c:til 5)
a b| c  
---| ---
0 a| 0 1
1 c| ,2 
1 d| ,3 
2 e| ,4 

q)\l sp.q
q)meta sp                        / s and p are both columns of sp
c  | t f a
---| -----
s  | s s
p  | s p
qty| i

q)`p xgroup sp                   / group by column p
p | s               qty
--| -------------------------------
p1| `s$`s1`s2       300 300
p2| `s$`s1`s2`s3`s4 200 400 200 200
p3| `s$,`s1         ,400
p4| `s$`s1`s4       200 300
p5| `s$`s4`s1       100 400
p6| `s$,`s1         ,100

q)select s,qty by p from sp      / equivalent select statement
p | s               qty
--| -------------------------------
p1| `s$`s1`s2       300 300
p2| `s$`s1`s2`s3`s4 200 400 200 200
p3| `s$,`s1         ,400
p4| `s$`s1`s4       200 300
p5| `s$`s4`s1       100 400
p6| `s$,`s1         ,100

q)ungroup `p xgroup sp           / ungroup flattens the groups
p  s  qty
---------
p1 s1 300
p1 s2 300
p2 s1 200
p2 s2 400
p2 s3 200
p2 s4 200
p3 s1 400
..
```


!!! warning "Duplicate keys or column names"

    Duplicate keys in a dictionary or duplicate column names in a table will cause sorts and grades to return unpredictable results.


<i class="far fa-hand-point-right"></i>
[`group`](group.md)  
Basics: [Dictionaries & tables](../basics/dictsandtables.md)
