---
title: Partitioning
description: File par.txt defines a top-level partitioning of a database into directories. Each row of par.txt is a directory path. Each such directory would itself be partitioned in the usual way, typically by date. The directories should not be empty. The par.txt file should be created in the main database directory.
keywords: database, kdb+, q, par.txt, partitioning
---
# Partitioning




File `par.txt` defines a top-level partitioning of a database into directories. Each row of `par.txt` is a directory path. Each such directory would itself be partitioned in the usual way, typically by date. The directories should not be empty. The `par.txt` file should be created in the main database directory.

`par.txt` is used to unify partitions of a database, presenting them as a single database for querying.

This is particularly useful in combination with multithreading. Starting the kdb+ process with slave threads (see [command line option `-s`](../basics/cmdline.md#-s-slaves)), and where each partition in `par.txt` is on a separate local disk:

-   when the q process is started with slave threads, the partitions in `par.txt` are allocated to slaves on a round-robin basis, i.e. if kdb+ is started with `n` slaves, then partition `p` is given to slave `p mod n`. This gives maximum parallelization for queries over date ranges.

-   if also, the partitions in `par.txt` are on separate disks, this means that each thread gets its own disk or disks, and there should be no disk contention (i.e. not more than one thread issuing commands to any one disk). Ideally, there should be one disk per thread. Note that this works best where the disks have fully independent access paths CPU-disk controller-disk, but may be of little use with shared access due to disk contention, e.g. with SAN/RAID.

For example, `par.txt` might be:

```txt
/0/db
/1/db
/2/db
/3/db
```

with directories :

```txt
~$ls /0/db
2009.06.01 2009.06.05 2009.06.11 ...

~$ls /1/db
2009.06.02 2009.06.06 2009.06.12 ...

...
```


## Some considerations

-   the data should be partitioned correctly across the partitions – i.e. data for a particular date should reside in the partition for that date.  
<i class="far fa-hand-point-right"></i> [`.Q.par`](../ref/dotq.md#qpar-locate-partition)
-   the slave/directory partitioning is for both read and write.
-   the directories pointed to in `par.txt` may only contain appropriate database subdirectories. Any other content (file or directory) will give an error.
-   the same subdirectory name may be in multiple `par.txt` partitions. For example, this would allow symbols to be split, as in A-M on `/0/db`, N-Z on `/1/db` (e.g. to work around the 2-billion row limit). Aggregations are handled correctly, as long as data is properly split (not duplicated). Note that in this case, the same day would appear on multiple partitions.

