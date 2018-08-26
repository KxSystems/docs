# `xasc`


_Sorts a table in ascending order of specified columns. 
The sort is by the first column specified, then by the second column within the first, and so on._

<div markdown="1" style="float: right; margin: 0 0 0 1em; padding: 0;">
![xasc](../img/xasc.png) 
</div>

Syntax: `x xasc y`, `xasc[x;y]`

Where `x` is a symbol vector of column names defined in table `y`, which is passed by

-    value, returns
-    reference, updates

`y` sorted in ascending order by `x`. 

The `` `s# `` attribute is set on the first column given (if possible).
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
q)`city xasc s                 / sort on city
s | name  status city
--| -------------------
s5| adams 30     athens
s1| smith 20     london
s4| clark 20     london
s2| jones 10     paris
s3| blake 30     paris
q)`city`name xasc s            / sort on city, and name within city
s | name  status city
--| -------------------
s5| adams 30     athens
s4| clark 20     london
s1| smith 20     london
s3| blake 30     paris
s2| jones 10     paris
q)`status`city`name xasc s     / sort on 3 columns, status first
s | name  status city
--| -------------------
s2| jones 10     paris
s4| clark 20     london
s1| smith 20     london
s5| adams 30     athens
s3| blake 30     paris
q)`status`city`name xasc `s    / table given by reference, updated in place
`s
q)s
s | name  status city
--| -------------------
s2| jones 10     paris
s4| clark 20     london
s1| smith 20     london
s5| adams 30     athens
s3| blake 30     paris
q)meta s                      / status column has sorted attribute
c     | t f a
------| -----
s     | s
name  | s
status| i   s
city  | s
```


## Sorting data on disk

`xasc` can sort data on disk directly, without loading the entire table into memory.

```q
q)t:([]b:`s`g`a`s`a;c:30 10 43 13 24;g:til 5)
q)`:dat/t/ set .Q.en[`:dat]t     / write splayed table
`:dat/t/
q)\ls dat/t                      / splayed columns
,"b"
,"c"
,"g"
q)`c xasc `:dat/t                / sort table on disk by column c
`:dat/t
q)t                              / in-memory table is unsorted
b c  g
------
s 30 0
g 10 1
a 43 2
s 13 3
a 24 4
q)\l dat/t                      / load table from disk
`t
q)t                             / table is sorted
b c  g
------
g 10 1
s 13 3
a 24 4
s 30 0
a 43 2
```


<i class="far fa-hand-point-right"></i>
[Dictionaries & tables](../basics/dictsandtables.md),
[Sorting](../basics/sort.md)
