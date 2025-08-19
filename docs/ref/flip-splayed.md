---
title: Flip Splayed or Partitioned – Reference – kdb+ and q documentation
description: Flip Splayed or Partitioned is a q operator that returns the flip of a splayed orpartitioned table.
author: Stephen Taylor
keywords: flip, flip splayed, kdb+, partitioned, q, splayed, table
---
# `!` Flip Splayed or Partitioned




```syntax
x!y    ![x;y]
```

This operation is used internally by kdb+ to represent the flip of a memory-mapped splayed table. When loading a database with [`\l`](../basics/syscmds.md#l-load-file-or-directory), the tables in the database are added to the root namespace in this representation.

Where `x` is a symbol list containing the names of the table columns and `y` is

-   an **hsym symbol atom** denoting the path to a **splayed** table
-   a **non-hsym symbol atom** denoting the name of a **partitioned** table

returns an object that must be [flipped](flip.md) in order to use it as a table. After flipping, queries will use the memory-mapped on-disk table. Certain operations (including the extra-argument overloads of [`select`](select.md)) will throw a `par` or `nyi` error when used on a partitioned table.

```q
q)`:db/t/ set ([]a:1 2)
`:db/t/
q)\l db
q).Q.s1 t
"+(,`a)!`:./t/"
q)t
a
-
1
2
```

It is possible to manually create this representation:

```q
q)enlist[`a]!`:./t/
(,`a)!`:./t/
q)flip enlist[`a]!`:./t/
a
-
1
2
```

The equivalent for a partitioned table:

```q
q)`:db/2001.01.01/t/ set ([]a:1 2)
`:db/2001.01.01/t/
q)`:db/2001.01.02/t/ set ([]a:3 4)
`:db/2001.01.02/t/
q)\l db
q).Q.s1 t
"+(,`a)!`t"
q)enlist[`a]!`t
(,`a)!`t
q)flip enlist[`a]!`t
date       a
------------
2001.01.01 1
2001.01.01 2
2001.01.02 3
2001.01.02 4
q)select[1] from flip enlist[`a]!`t
'nyi
  [0]  select[1] from flip enlist[`a]!`t
                      ^
```

If the specified table does not exist on disk, the expression remains unresolved and any attempt to query it fails:

```q
q)flip enlist[`a]!`:./s/
+(,`a)!`:./s/
q)select from flip enlist[`a]!`:./s/
'./s/a. OS reports: No such file or directory
  [0]  select from flip enlist[`a]!`:./s/
q)flip enlist[`a]!`s
+(,`a)!`s
q)select from flip enlist[`a]!`s
's
  [0]  select from flip enlist[`a]!`s
       ^
```

---
:fontawesome-solid-book-open:
[Dictionaries & tables](../basics/dictsandtables.md)