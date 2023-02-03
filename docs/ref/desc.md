---
title: desc, idesc, xdesc – descending sorts | Reference | kdb+ and q documentation
description: Descending sorts in q; desc returns a list sorted descending; idesc returns the grade for that sort. xdesc sorts a table descending by specified columns.
author: Stephen Taylor
keywords: asc, desc, descending, grade, idesc, kdb+, q, sort, xdesc
---
# `desc`, `idesc`, `xdesc`

_Sort and grade: descending_




!!! info "Q chooses from a variety of algorithms, depending on the type and data distribution."

## `desc`

_Descending sort_

```syntax
desc x    desc[x]
```

Returns `x` sorted into descending order. 
The function is uniform.
The sort is stable: it preserves order between equals. 

Where `x` is a

-   **vector**, it is returned sorted
-   **mixed list**, the result is sorted within datatype
-   **dictionary**, returns it sorted by the values
-   **table**, returns it sorted by the first non-key column and with the sorted attribute set on that column

!!! detail "Unlike `asc`, which sets the parted attribute where there are other non-key columns, `desc` sets only the sorted attribute."

```q
q)desc 2 1 3 4 2 1 2                    / vector
4 3 2 2 2 1 1

q)desc (1;1b;"b";2009.01.01;"a";0)      / mixed list
2009.01.01
"b"
"a"
1
0

q)desc `a`b`c!2 1 3 					/ dictionary
c| 3
a| 2
b| 1

q)desc([]a:3 4 1;b:`a`d`s)              / table
a b
---
4 d
3 a
1 s
q)meta desc([]a:3 4 1;b:`a`d`s)
c| t f a
-| -----
a| j
b| s
```
```txt
domain: b g x h i j e f c s p m d z n u v t
range:  b g x h i j e f c s p m d z n u v t
```

## `idesc`

_Descending grade_

```syntax
idesc x    idesc[x]
```

Where `x` is a list or dictionary,  returns the indices needed to sort list it in descending order. 

```q
q)L:2 1 3 4 2 1 2
q)idesc L
3 2 0 4 6 1 5
q)L idesc L
4 3 2 2 2 1 1
q)(desc L)~L idesc L
1b
q)idesc `a`c`b!1 2 3
`b`c`a
```
```txt
domain: b g x h i j e f c s p m d z n u v t
range:  j j j j j j j j j j j j j j j j j j
```


## `xdesc`

_Sorts a table in descending order of specified columns. 
The sort is by the first column specified, then by the second column within the first, and so on._

```syntax
x xdesc y    xdesc[x;y]
```

Where `x` is a symbol vector of column names defined in `y`, which is passed by

-   value, returns
-   reference, updates 

`y` sorted in descending order by `x`. 

The sorted attribute is not set.
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


**Duplicate column names** `xdesc` signals `dup` if it finds duplicate columns in the right argument. (Since V3.6 2019.02.19.)

:fontawesome-regular-hand-point-right:
[`.Q.id` (sanitize)](dotq.md#id-sanitize) 


### Sorting data on disk

`xdesc` can sort data on disk directly, without loading the entire table into memory: see [`xasc`](asc.md#sorting-data-on-disk).

!!! warning "Duplicate keys in a dictionary or duplicate column names in a table will cause sorts and grades to return unpredictable results."

----

:fontawesome-solid-book:
[`asc`, `iasc`, `xasc`](asc.md),
[`attr`](attr.md),
[Set Attribute](set-attribute.md)
<br>
:fontawesome-solid-book-open:
[Dictionaries & tables](../basics/dictsandtables.md),
[Metadata](../basics/metadata.md),
[Sorting](../basics/by-topic.md#sort)
<br>
_Q for Mortals_
[§8.8 Attributes](/q4m3/8_Tables/#88-attributes)

