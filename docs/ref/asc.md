---
title: asc, iasc, xasc – ascending sort | Reference | kdb+ and q documentation
description: Ascending sorts in q; asc returns a sortable argument in ascending order; iasc grades its items into ascending order; xasc sorts a table by columns.
author: Stephen Taylor
---
# `asc`, `iasc`, `xasc`


_Sort and grade: ascending_




!!! info "Q chooses from a variety of algorithms, depending on the type and data distribution."

## `asc`

_Ascending sort_

```syntax
asc x     asc[x]
```

Where `x` is a:

-   **vector**, returns its items in ascending order of value, with the [sorted attribute](set-attribute.md) set, indicating the list is sorted; where the argument vector is found to be in ascending order already, it is assigned the sorted attribute
-   **mixed list**, returns the items sorted within datatype and with the sorted attribute set
-   **dictionary**, returns it sorted by the values
-   **table**, returns it sorted by the first non-key column and with 
	+ the sorted attribute set on that column if there is only one non-key column; otherwise
	+ the parted attribute set

The function is uniform. 
The sort is stable: it preserves order between equals.


### Vector

```q
q)asc 2 1 3 4 2 1 2
`s#1 1 2 2 2 3 4

q)a:0 1
q)b:a
q)asc b  / result has sorted attribute
`s#0 1
q)b      / argument was already in ascending order
`s#0 1
q)a      / b was a shallow copy of a
`s#0 1
```

### Mixed list

In the example below, the boolean is returned first, then the sorted integers, the sorted characters, and then the date.

```q
q)asc (1;1b;"b";2009.01.01;"a";0)
1b
0
1
"a"
"b"
2009.01.01
```

Note how the type numbers are used.

```q
q)asc(2f;3;4i;5h)
5h
4i
3
2f
q){(asc;x iasc abs t)fby t:type each x}(2f;3;4i;5h)  / compare asc
5h
4i
3
2f
```


### Dictionary

```q
q)asc `a`b`c!2 1 3
b| 1
a| 2
c| 3
```


### Table

```q
q)/ simple table
q)asc ([]a:3 4 1;b:`a`d`s)
a b
---
1 s
3 a
4 d
q)meta asc ([]a:3 4 1;b:`a`d`s)  		/ sets parted attribute
c| t f a
-| -----
a| j   p
b| s
q)meta asc([]a:3 4 1)            		/ sets sorted attribute
c| t f a
-| -----
a| j   s

q)/ keyed table
q)meta asc ([c1:`a`b] c2:2 1; c3:01b)	/ sets parted attribute
c | t f a
--| -----
c1| s
c2| j   p
c3| b 
q)meta asc ([c1:`a`b] c2:2 1)    		/ sets sorted attribute
c | t f a
--| -----
c1| s 
c2| j   s

```

```txt
domain: b g x h i j e f c s p m d z n u v t
range:  b g x h i j e f c s p m d z n u v t
```

## `iasc`

_Ascending grade_

```syntax
iasc x    iasc[x]
```

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

Reverse a sort with `iasc iasc`:

```q
q)x:100?100
q)b:100?.Q.a
q)c:b iasc x
q)b~c iasc iasc x
1b
```

```txt
domain: b g x h i j e f c s p m d z n u v t
range:  j j j j j j j j j j j j j j j j j j
```

## `xasc`


_Sort a table in ascending order of specified columns._ 

![xasc](../img/xasc.png) 
{: style="float: right; margin: 0 0 0 1em; padding: 0;"}

```syntax
x xasc y     xasc[x;y]
```

Where `x` is a symbol vector of column names defined in table `y`, which is passed by

-    value, returns
-    reference, updates

`y` sorted in ascending order by `x`. 
The sort is by the first column specified, then by the second column within the first, and so on.

The sorted attribute is set on the first column given (if possible).
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


**Duplicate column names** `xasc` signals `dup` if it finds duplicate columns in the right argument. (Since V3.6 2019.02.19.)

:fontawesome-regular-hand-point-right:
[`.Q.id` (sanitize)](dotq.md#qid-sanitize) 


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
q)\l dat/t                       / load table from disk
`t 
q)t                              / table is sorted
b c  g
------
g 10 1
s 13 3
a 24 4
s 30 0
a 43 2
```


!!! warning "Duplicate keys in a dictionary or duplicate column names in a table cause sorts and grades to return unpredictable results."


----
:fontawesome-solid-book:
[`attr`](attr.md),
[`desc`, `idesc`, `xdesc`](desc.md),
[Set Attribute](set-attribute.md)
<br>
:fontawesome-solid-book-open:
[Dictionaries & tables](../basics/dictsandtables.md), 
[Metadata](../basics/metadata.md),
[Sorting](../basics/by-topic.md#sort)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§8.8 Attributes](/q4m3/8_Tables#88-attributes)