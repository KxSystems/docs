---
title: Partitioned tables | Knowledge Base | kdb+ and q documentation
description: File par.txt in the main database directory defines a top-level partitioning of a database into directories. 
author: Stephen Taylor
date: October 2020
---
# Partitioning tables across directories



A partitioned table is a [splayed table](splayed-tables.md) that is further decomposed by grouping records having common values along a column of special type. The allowable special column types have underlying integer values: date, month, year and long.

```txt
db
├── 2020.10.04
│   ├── quotes
│   │   ├── .d
│   │   ├── price
│   │   ├── sym
│   │   └── time
│   └── trades
│       ├── .d
│       ├── price
│       ├── sym
│       ├── time
│       └── vol
├── 2020.10.06
│   ├── quotes
..
└── sym
```

!!! tip "Partition data correctly: data for a particular date must reside in the partition for that date."

:fontawesome-solid-book: 
[`.Q.par`](../ref/dotq.md#qpar-locate-partition)


## Table counts

For partitioned databases, q caches the count for a table, and this count cannot be updated from within a reval expression or from a secondary thread.

!!! tip "To avoid `noupdate` errors on queries on partitioned tables, put `count table` in your startup script."


## Use case

Partition a table if either

-   it has over 100 million records
-   it has a column that cannot fit in memory
-   it grows
-   many queries can be limited to a range of values of one column


----
:fontawesome-solid-book:
[`count`](../ref/count.md), 
[maps](../ref/maps.md),
[`peach`](../ref/each.md#peach),
[`reval`](../ref/eval.md#reval),
[`select`](../ref/select.md)
<br>
:fontawesome-solid-book-open:
[Errors](../basics/errors.md),
[Parallel execution](../basics/peach.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§14.3 Partitioned Tables](/q4m3/14_Introduction_to_Kdb+/#143-partitioned-tables)
<br>
:fontawesome-solid-database:
[Segmented databases](../database/segment.md)