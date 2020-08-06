---
title: Partitioning databases | Knowledge Base | kdb+ and q documentation
description: File par.txt in the main database directory defines a top-level partitioning of a database into directories. 
keywords: database, kdb+, q, par.txt, partitioning
---
# Partitioning

## Partitioned databases

A partitioned table is a splayed table that is further decomposed by grouping records having common values along a column of special type. The allowable special column types have the property that the underlying value is an integer: date, month, year and long.

```txt
/db
    /2015.01.01
        /trade
        /quote
    /2015.01.02
        /trade
        /quote
    ...
```


:fontawesome-solid-street-view:
_Q for Mortals_ 
[§14.3 Partitioned Tables](/q4m3/14_Introduction_to_Kdb+/#143-partitioned-tables)


## Segmented databases

File `par.txt` defines a top-level partitioning of a database into directories. Each row of `par.txt` is a directory path. Each such directory would itself be partitioned in the usual way, typically by date. The directories should not be empty. The `par.txt` file should be created in the main database directory.

`par.txt` is used to unify partitions of a database, presenting them as a single database for querying.

This is particularly useful in combination with multithreading. Starting the kdb+ process with secondary threads (see [command line option `-s`](../basics/cmdline.md#-s-secondary-threads)), and where each partition in `par.txt` is on a separate local disk:

-   when the q process is started with secondary threads, the partitions in `par.txt` are allocated to secondary threads on a round-robin basis, i.e. if kdb+ is started with `n` secondary threads, then partition `p` is given to secondary thread `p mod n`. This gives maximum parallelization for queries over date ranges.

-   if also, the partitions in `par.txt` are on separate disks, this means that each thread gets its own disk or disks, and there should be no disk contention (i.e. not more than one thread issuing commands to any one disk). Ideally, there should be one disk per thread. Note that this works best where the disks have fully independent access paths CPU-disk controller-disk, but may be of little use with shared access due to disk contention, e.g. with SAN/RAID.

For example, `par.txt` might be:

```txt
/0/db
/1/db
/2/db
/3/db
```

with directories :

```bash
~$ ls /0/db
2009.06.01 2009.06.05 2009.06.11 ...

~$ ls /1/db
2009.06.02 2009.06.06 2009.06.12 ...

...
```


### Some considerations

-   The data should be partitioned correctly across the partitions – i.e. data for a particular date should reside in the partition for that date.<br>
:fontawesome-solid-book: [`.Q.par`](../ref/dotq.md#qpar-locate-partition)
-   The secondary/directory partitioning is for both read and write.
-   The directories pointed to in `par.txt` may only contain appropriate database subdirectories. Any other content (file or directory) will give an error.
-   The same subdirectory name may be in multiple `par.txt` partitions. For example, this would allow symbols to be split, as in A-M on `/0/db`, N-Z on `/1/db` (e.g. to work around the 2-billion row limit). Aggregations are handled correctly, as long as data is properly split (not duplicated). Note that in this case, the same day would appear on multiple partitions.

:fontawesome-solid-street-view:
_Q for Mortals_ 
[§14.4 Segmented Tables](/q4m3/14_Introduction_to_Kdb+/#144-segmented-tables)


## Table counts

For partitioned databases, q caches the count for a table, and this count cannot be updated from within a `reval` expression or from a secondary thread. 

!!! tip "To avoid `noupdate` errors on queries on partitioned tables, put `count table` in your startup script."

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
