---
title: asc, iasc, xasc
description: asc is a q keyword that returns a sortable argument in ascending order and with the s attribute set; iasc grades its items into ascending order; and xasc sorts a table by specified columns.
author: Stephen Taylor
keywords: asc, ascending, grade, iasc, kdb+, q, sort, table, xasc
---
# `asc`, `iasc`, `xasc`


_Sort and grade: ascending_



## `asc`

_Ascending sort_

Syntax: `asc x`, `asc[x]`

Where `x` is a:

-   **vector**, returns its items in ascending order of value, with the `` `s# `` attribute set, indicating the list is sorted
-   **mixed list**, returns the items sorted within datatype
-   **dictionary**, returns it sorted by the values and with the `` `s# `` attribute set
-   **table**, returns it sorted by the first non-key column and with the `` `s# `` attribute set

The function is uniform. 
The sort is stable: it preserves order between equals.

```q
q)asc 2 1 3 4 2 1 2
`s#1 1 2 2 2 3 4
```

In a mixed list the boolean is returned first, then the sorted integers, the sorted characters, and then the date.

```q
q)asc (1;1b;"b";2009.01.01;"a";0)
1b
0
1
"a"
"b"
2009.01.01
```

Note how the type numbers are used in a mixed list.

```q
q)asc(2f;3j;4i;5h)
5h
4i
3
2f
q){(asc;x iasc abs t)fby t:type each x}(2f;3j;4i;5h)  / kind of what asc does
5h
4i
3
2f
```

Sorting a table:

```q
q)t:([]a:3 4 1;b:`a`d`s)
q)asc t
a b
---
1 s
3 a
4 d

q)a:0 1
q)b:a
q)asc b
`s#0 1
q)a
`s#0 1
```



## `iasc`

_Ascending grade_

Syntax: `iasc x`, `iasc[x]`

Where `x` is a list or dictionary, returns the indexes needed to sort list `x` in ascending order. 

```q
q)L:2 1 3 4 2 1 2
q)iasc L
1 5 0 4 6 2 3
q)L iasc L
1 1 2 2 2 3 4
q)(asc L)~L iasc L
1b
q)iasc `a`c`b!1 2 3
`a`c`b
```



## `xasc`


_Sort a table in ascending order of specified columns._ 

<div markdown="1" style="float: right; margin: 0 0 0 1em; padding: 0;">
![xasc](../img/xasc.png) 
</div>

Syntax: `x xasc y`, `xasc[x;y]`

Where `x` is a symbol vector of column names defined in table `y`, which is passed by

-    value, returns
-    reference, updates

`y` sorted in ascending order by `x`. 
The sort is by the first column specified, then by the second column within the first, and so on.

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


### Sorting data on disk

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


!!! warning "Duplicate keys or column names"

    Duplicate keys in a dictionary or duplicate column names in a table will cause sorts and grades to return unpredictable results.


<i class="far fa-hand-point-right"></i>
[`desc`, `idesc`, `xdesc`](desc.md)  
Basics: [Dictionaries & tables](../basics/dictsandtables.md), 
[Sorting](../basics/sort.md)

