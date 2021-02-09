---
title: Database – tables in the filesystem | Documentation for q and kdb+
description: Kdb+ is what happens when q tables are persisted to the filesystem
author: Stephen Taylor
date: October 2020
---
# :fontawesome-solid-database: Database: tables in the filesystem



> Roughly speaking, kdb+ is what happens when q tables are persisted and then mapped back into memory for operations.<br>— Jeffry A. Borror, _Q for Mortals_

[Tables](../kb/faq.md) are first-class entities in q. Large q tables can be held in memory, but memory is finite and every process eventually terminates.

Sooner or later we need to persist tables in the filesystem. We will also need to perform operations on tables that are too large to hold in memory.

Roughly speaking, q tables and columns are represented in the filesystem as eponymous directories and binary files.

How you serialize a table depends on its size and how you need to use it.

serialization | representation | best where
--------------|----------------|-----------
object        | single binary file | small and most queries use most columns
splayed table | directory of column files | up to 100 million rows
partitioned table | table partitioned by e.g. date, with a splayed table for each date | more than 100 million records; or growing steadily
segmented database | partitioned tables distributed across disks | tables larger than disks; or you need to parallelize access


## Object

Q will [serialize and file](object.md) any object as a single binary file – the simplest way to persist a table.

A database with tables `trades` and `quotes`, and a sym list:

```treeview
db/
├── quotes
├── sym
└── trades
```

!!! tip "By specifying the extension (e.g. CSV, XLS) you can also export the table in another format."

If most queries on a table do not need all the columns for each query consider splaying it.


## Splayed table

A table is [splayed](https://en.wiktionary.org/wiki/splay "Wiktionary") by storing each of its columns as a single file. The table is represented by a directory.

```treeview
db/
├── quotes/
|   ├── time
|   ├── sym
|   └── price
└── trades/
    ├── time
    ├── sym
    ├── price
    └── vol
```

With a [splayed table](../kb/splayed-tables.md), a query deserializes into memory only files for the column/s it requires.

If the table either

-   grows
-   holds more than 100 million records
-   has columns that exceed the maximum size of a vector in memory

consider partitioning it.


## Partitioned table

The records of a [partitioned table](../kb/partition.md) are divided in its root directory between multiple partition directories. The table is partitioned by the values of a single column. Each partition contains records that have the same value in the partitioning column. With timeseries data, this is most commonly a date or time.

```tree
db/
├── 2020.10.03/
│   ├── quotes/
│   │   ├── price
│   │   ├── sym
│   │   └── time
│   └── trades/
│       ├── price
│       ├── sym
│       ├── time
│       └── vol
├── 2020.10.05/
│   ├── quotes/
│   │   ├── price
│   │   ├── sym
│   │   └── time
│   └── trades/
│       ├── price
│       ├── sym
│       ├── time
│       └── vol
└── sym
```

The partition directory is named for its partition value and contains a splayed table with just the records that have that value.

If either

-   your table exceeds the size of your storage
-   you need to parallelize access to it
-   you want to partition it by a datatype that is not integer-based, e.g. a symbol

consider segmenting it across multiple storage devices.


## Segmented database

The root directory of a [segmented database](segment.md) contains only two files:

-   `par.txt`: a text file listing the paths to the segments
-   the sym file for enumerated symbol columns

Segments are stored outside the root, usually on various volumes. Each segment contains a partitioned table.

```tree
DISK 0             DISK 1                     DISK 2
db/                db/                       db/
├── par.txt        ├── 2020.10.03/           ├── 2020.10.04/
└── sym            │   ├── quotes/           │   ├── quotes/
                   │   │   ├── .d            │   │   ├── .d
                   │   │   ├── price         │   │   ├── price
                   │   │   ├── sym           │   │   ├── sym
                   │   │   └── time          │   │   └── time
                   │   └── trades/           │   └── trades/
                   │       ├── .d            │       ├── .d
                   │       ├── price         │       ├── price
                   │       ├── sym           │       ├── sym
                   │       ├── time          │       ├── time
                   │       └── vol           │       └── vol
                   ├── 2020.10.05/           ├── 2020.10.06/
                   │   ├── quotes/           │   ├── quotes/
                   ..                        ..
```

Dividing the table between storage devices lets you

-   store very large tables
-   parallelize queries
-   optimize updates


## Queries on serialized tables

Deserialization and reserialization is implicit in qSQL queries.

```q
q)select city,pop,country.code from `:linked/cities
city     pop      code
----------------------
Tokyo    37435191 81
Delhi    29399141 91
Shanghai 26317104 86

q)`:linked/countries upsert (`Brazil;`$"South America";55)
`:linked/countries
q)get`:linked/countries
country| cont          code
-------| ------------------
China  | Asia          86
India  | Asia          91
Japan  | Asia          81
Brazil | South America 55
```


## Operations on serialized tables

Some operators and keywords work on some serialized tables.

For example, [`cols`](../ref/cols.md) works on tables in memory or mapped to memory, and on filesymbols for splayed tables but not tables serialized as an object.


----
:fontawesome-solid-hand-point-right:
[Serialize as an object](object.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§14. Introduction to kdb+](/q4m3/14_Introduction_to_Kdb%2B/)

