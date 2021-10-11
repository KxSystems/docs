---
title: delete query | Reference | kdb+ and q documentation
description: delete is a qSQL template that removes rows or columns from a table, entries from a dictionary, or objects from a namespace.
author: Stephen Taylor
keywords: delete, functional kdb+, q, query, qsql, sql
---
# `delete`

_Delete rows or columns from a table, entries from a dictionary, or objects from a namespace_

```syntax
delete    from x
delete    from x where pw
delete ps from x
```

!!! info "`delete` is a [qSQL query template](../basics/qsql.md) and varies from regular q syntax"

For the Delete operator `!`, see
:fontawesome-solid-book-open:
[Functional SQL](../basics/funsql.md#delete)


## Table rows

```syntax
delete    from x
delete    from x where pw
```
Where

-   `x` is a table
-   `pw` is a condition

deletes from `x` rows matching `pw`, or all rows if `where pw` not specified.

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

!!! warning "Attributes may or may not be dropped: reapply or remove as needed"


## Table columns

```syntax
delete    from x
delete ps from x
```
Where

-   `x` is a table
-   `ps` a list of column names

deletes from `x` columns `ps` or all columns if `ps` not specified.

```q
q)show delete n from table
a
-
a
b
c
```


## Dictionary entries

```syntax
delete    from x
delete ps from x
```
Where

-   `x` is a dictionary
-   `ps` a list of keys to it

deletes from `x` entries for `ps`.

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
    [qSQL](../basics/qsql.md#cond)


## Namespace objects

```syntax
delete    from x
delete ps from x
```
Where

-   `x` is a namespace
-   `ps` a symbol atom or vector of name/s defined in it

deletes the named objects from the namespace.

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


[![DevOps Borat on delete](../img/borat_delete.jpg)](https://twitter.com/devops_borat)
