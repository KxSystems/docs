---
title: delete query | Reference | kdb+ and q documentation
description: delete is a qSQL template that removes rows or columns from a table, entries from a dictionary, or objects from a namespace.
author: Stephen Taylor
keywords: delete, functional kdb+, q, query, qsql, sql
---
# `delete`

_Delete rows or columns from a table, entries from a dictionary, or objects from a namespace_

!!! info "`update` is a qSQL query template and varies from regular q syntax."

For the Delete operator `!`, see 
:fontawesome-solid-book-open:
[Functional SQL](../basics/funsql.md)


## Syntax

<div markdown="1" class="typewriter">
delete    from _t<sub>exp</sub>_ [where _p<sub>w</sub>_]
delete _p<sub>s</sub>_ from _t<sub>exp</sub>_ 
</div>

:fontawesome-solid-book-open:
[qSQL syntax](../basics/qsql.md)




### Table rows

Where 

-   `t` is a table
-   `{cond}` is a condition

deletes from `t` rows matching `{cond}`.

```q
q)show table: ([] a: `a`b`c; n: 1 2 3)
a n
---
a 1
b 2
c 3
q)show delete from table where a = `c
a n
---
a 1
b 2
```


### Table columns

Where

-   `t` is a table
-   `cols` a list of column names

deletes from `t` columns `cols`.

```q
q)show delete n from table
a
-
a
b
c
```


### Dictionary entries

Where

-   `x` is a dictionary
-   `keys` a list of keys to it

deletes from `x` entries for `keys`.

```q
q)show d:`a`b`c!til 3
a| 0
b| 1
c| 2
q)delete b from `d
`d
q)d
a| 0
c| 2
```


!!! warning "Cond is not supported inside q-SQL expressions"

    Enclose in a lambda or use [Vector Conditional](vector-conditional.md) instead.

    :fontawesome-regular-hand-point-right:
    [q-SQL](../basics/qsql.md#cond)


### Namespace objects

Where

-   `x` is a namespace
-   `keys` a symbol atom or vector of name/s defined in it

deletes from `x` the named objects.

```q
q)a:1
q)\v
,`a
q)delete a from `.
`.
q)\v
`symbol$()
```


:fontawesome-regular-hand-point-right:
[qSQL](../basics/qsql.md)


## `!` Delete operator

:fontawesome-regular-hand-point-right:
[Functional Delete](../basics/funsql.md#delete)


[![DevOps Borat on delete](../img/borat_delete.jpg)](https://twitter.com/devops_borat)
