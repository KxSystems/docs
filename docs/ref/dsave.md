---
title: dsave saves a list of tables | Reference | kdb+ and q documentation
description: dsave is a q keyword that saves global tables to disk as splayed, enumerated, indexed kdb+ tables.
author: Stephen Taylor
keywords: enumerated, indexed, kdb+, q, splayed, table
---
# :fontawesome-solid-database: `dsave`

_Write global tables to disk as splayed, enumerated, indexed kdb+ tables._




```txt
x dsave y     dsave[x;y]
```

Where

-   `x` is the _save path_ as a file symbol atom or vector
-   `y` is one or more table names as a symbol atom or vector

save the table/s and returns the list of table names.
(Since V3.2 2014.05.07.)

The first column of each table saved has the [partitioned attribute](set-attribute.md) applied to it. If the save path is a list, the first item is the HDB root (where the sym file, if any, will be stored), while the remaining items are a path within the HDB (e.g. a partition).

!!! tip "Roughly the same functionality as the combination of [`.Q.en`](dotq.md#qen-enumerate-varchar-cols) and [`set`](get.md#set) or [`.Q.dpft`](dotq.md#qdpft-save-table), but in a simpler form."

```q
q)t:flip`sym`price`size!100?'(-10?`3;1.0;10)
q)q:flip`sym`bid`ask`bsize`asize!900?'(distinct t`sym;1.0;1.0;10;10)

q)meta t
c    | t f a
-----| -----
sym  | s    
price| f    
size | j    
q)meta q    
c    | t f a
-----| -----
sym  | s    
bid  | f    
ask  | f    
bsize| j    
asize| j    

q)type each flip t
sym  | 11
price| 9
size | 7
q)type each flip q
sym  | 11
bid  | 9
ask  | 9
bsize| 7
asize| 7

q)`:/tmp/db1 dsave`sym xasc'`t`q
`t`q
q)\l /tmp/db1

q)meta t
c    | t f a
-----| -----
sym  | s   p
price| f    
size | j    
q)meta q
c    | t f a
-----| -----
sym  | s   p
bid  | f    
ask  | f    
bsize| j    
asize| j    

q)type each flip t
sym  | 20
price| 9
size | 7
q)type each flip q
sym  | 20
bid  | 9
ask  | 9
bsize| 7
asize| 7
```

In the following, the left argument is a list, of which the second item is a partition name.

```q
q)t:flip`sym`price`size!100?'(-10?`3;1.0;10)
q)q:flip`sym`bid`ask`bsize`asize!900?'(distinct t`sym;1.0;1.0;10;10)

q)meta t
c    | t f a
-----| -----
sym  | s    
price| f    
size | j    
q)meta q
c    | t f a
-----| -----
sym  | s    
bid  | f    
ask  | f    
bsize| j    
asize| j    

q)type each flip t
sym  | 11
price| 9
size | 7
q)type each flip q
sym  | 11
bid  | 9
ask  | 9
bsize| 7
asize| 7

q)`:/tmp/db2`2015.01.01 dsave`sym xasc'`t`q
`t`q
q)\l /tmp/db2

q)meta t
c    | t f a
-----| -----
date | d    
sym  | s   p
price| f    
size | j    
q)meta q
c    | t f a
-----| -----
date | d    
sym  | s   p
bid  | f    
ask  | f    
bsize| j    
asize| j    
```

----
:fontawesome-solid-book: 
[`set`](get.md#set), 
[`.Q.en`](dotq.md#qen-enumerate-varchar-cols), 
[`.Q.dpft`](dotq.md#qdpft-save-table), 
[`.Q.hdpf`](dotq.md#qhdpf-save-tables) 
<br>
:fontawesome-solid-book-open:
[File system](../basics/files.md)


