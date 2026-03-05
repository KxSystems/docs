---
title: desc, idesc, xdesc – descending sorts | Reference | kdb+ and q documentation
description: Descending sorts in q; desc returns a list sorted descending; idesc returns the grade for that sort. xdesc sorts a table descending by specified columns.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: asc, desc, descending, grade, idesc, kdb+, q, sort, xdesc
---
# `desc`, `idesc`, `xdesc`

_Sort and grade: descending_

## `desc`

_Descending sort_

```syntax
desc x    desc[x]
```

Where `x` is a

- **vector**, returns its items in descending order of value;
- **mixed list**, returns the items sorted descending by datatype, then descending within datatype;
- **nested list**, returns the items sorted descending lexicographically;
- **dictionary**, returns it sorted by the values;
- **table**, returns it sorted desceding lexicographically by the non-key columns.

!!! info "Q chooses from a variety of sorting algorithms depending on the datatype and data distribution."

!!! detail "Unlike `asc`, which sets the sorted (or parted) attribute, `desc` sets none, as there is no attribute that would indicate a descending sort."

```q
q)desc 2 1 3 4 2 1 2                       / vector
4 3 2 2 2 1 1

q)show l:desc (1;1b;"b";2009.01.01;"a";0)  / mixed list
2009.01.01
"b"
"a"
1
0
q)type each l
-14 -10 -10 -7 -7 -1h                      / datatypes are sorted by their type number

q)desc `a`b`c!2 1 3                        / dictionary
c| 3
a| 2
b| 1

q)desc([]a:4 4 1;b:`a`d`s)                 / table
a b
---
4 d
4 a
1 s

q)meta desc([]a:3 4 1;b:`a`d`s)
c| t f a
-| -----
a| j
b| s
```

```txt
domain: B G X H I J E F C S P M D Z N U V T
range:  B G X H I J E F C S P M D Z N U V T
```

## `idesc`

_Descending grade_

```syntax
idesc x    idesc[x]
```

Where `x` is a list or dictionary, returns the indices needed to sort it in descending order.

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
domain: B G X H I J E F C S P M D Z N U V T
range:  J J J J J J J J J J J J J J J J J J
```

## `xdesc`

_Sorts a table in descending order of specified columns._

```syntax
x xdesc y    xdesc[x;y]
```

Where `x` is a symbol vector of column names defined in `y`, which is passed by

- value, returns
- reference, updates

`y` sorted in descending order by `x`.

The sorted attribute is not set.
The sort is stable, i.e. it preserves order amongst equals.

```q
q)show t:0N?([]sym:raze 2#/:`a`b`c; date:6#2025.01.01+til 2; val:50+6?10f)
sym date       val
-----------------------
c   2025.01.01 51.95847
a   2025.01.02 53.40721
b   2025.01.01 50.54001
b   2025.01.02 55.49794
a   2025.01.01 53.83946
c   2025.01.02 55.61526
q)`date xdesc t
sym date       val
-----------------------
a   2025.01.02 53.40721
b   2025.01.02 55.49794
c   2025.01.02 55.61526
c   2025.01.01 51.95847
b   2025.01.01 50.54001
a   2025.01.01 53.83946
q)`sym`date xdesc t
sym date       val
-----------------------
c   2025.01.02 55.61526
c   2025.01.01 51.95847
b   2025.01.02 55.49794
b   2025.01.01 50.54001
a   2025.01.02 53.40721
a   2025.01.01 53.83946
q)`sym`date xdesc `t
`t
q)meta t                      / no attribute set
c   | t f a
----| -----
sym | s
date| d
val | f
```

**Duplicate column names**
`xdesc` signals `'dup` and the duplicate column name if it finds duplicate columns in the right argument. (Since V3.6 2019.02.19.)

[`.Q.id` (sanitize)](dotq.md#id-sanitize)

### Sorting data on disk

`xdesc` can sort data on disk directly, without loading the entire table into memory: see [`xasc`](asc.md#sorting-data-on-disk).

!!! warning "Duplicate keys in a dictionary or duplicate column names in a table will cause sorts and grades to return unpredictable results."

----

[`asc`, `iasc`, `xasc`](asc.md),
[`attr`](attr.md),
[Set Attribute](set-attribute.md)
<br>

[Dictionaries & tables](../basics/dictsandtables.md),
[Metadata](../basics/metadata.md),
[Sorting](../basics/by-topic.md#sort)
<br>

_Q for Mortals_
[§8.8 Attributes](/q4m3/8_Tables/#88-attributes)
