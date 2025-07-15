---
title: Segmented databases | Database | Documentation for q and kdb+
description: How to segment a kdb+ database across multiple storage devices
author: Stephen Taylor
date: October 2020
---
# Segmented databases


Partitioned tables can be distributed across multiple storage devices to

-   give them more space
-   support parallelization

The root of a segmented database contains only the sym list and a file `par.txt`, which is used to unify the partitions of a database, presenting them as a single database for querying.


## `par.txt`

File `par.txt` defines the top-level partitioning of the database into directories. Each row of `par.txt` is a directory path. Each such directory is itself partitioned in the usual way, typically by date. The directories should not be empty. 
<!-- The `par.txt` file should be created in the main database directory. -->

```txt
DISK 0             DISK 1                     DISK 2  
db                 db                        db             
├── par.txt        ├── 2020.10.03            ├── 2020.10.04                         
└── sym            │   ├── quotes            │   ├── quotes                         
                   │   │   ├── price         │   │   ├── price                            
                   │   │   ├── sym           │   │   ├── sym                          
                   │   │   └── time          │   │   └── time                           
                   │   └── trades            │   └── trades                         
                   │       ├── price         │       ├── price                            
                   │       ├── sym           │       ├── sym                          
                   │       ├── time          │       ├── time                           
                   │       └── vol           │       └── vol                          
                   ├── 2020.10.05            ├── 2020.10.06                         
                   │   ├── quotes            │   ├── quotes      
               ..                    ..
```

`par.txt` for the above:

```txt
/1/db
/2/db
```

!!! danger "Do not end the paths with a folder delimiter"

      `/0/db` is good, but `/0/db/` can be bad, depending on the filesystem.

### Using symlinks

Security related options such as [`reval`](../ref/eval.md#reval), or the command line option [`-u 1`](../basics/cmdline.md#-u-usr-pwd), restrict access to within the current directory. 
This can prevent users from accessing a segmented database when `par.txt` contains references to partitions that are situated outside the current directory.

In order to provide access, symlinks can be used. An example of using symlinks is as follows:

```bash
$ ln -s /db1 db1$
$ ln -s /db2 db2$
$ ls -l
total 16
lrwxr-xr-x  1 user  kx   6 18 Sep 12:30 db1$ -> /db1
lrwxr-xr-x  1 user  kx   6 18 Sep 12:30 db2$ -> /db2
-rw-r--r--  1 user  kx  10 18 Sep 12:30 par.txt
-rw-r--r--  1 user  kx  48 18 Sep 12:30 sym
$ cat par.txt
db1$
db2$
```

Using a trailing `$` in the directory name ensures the originating symlinks are not picked up by kdb+, instead using the directory referenced.

## Multithreading

Segmentation is particularly useful in combination with multithreading. 

[Starting kdb+ with secondary threads](../basics/cmdline.md#-s-secondary-threads), with each partition in `par.txt` on a separate local disk, the partitions in `par.txt` are allocated to secondary threads on a round robin.
That is, if kdb+ is started with `n` secondary threads, then partition `p` is assigned to secondary thread `p mod n`. This gives maximum parallelization for queries over date ranges.

Each thread gets its own disk or disks, and there should be no disk contention, i.e. not more than one thread issuing commands to any one disk. 

Ideally there is one disk per thread. This works best where the disks have fully independent access paths CPU-disk controller-disk, but may be of little use with shared access due to disk contention, e.g. with SAN/RAID.

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
2019.06.01 2019.06.05 2019.06.11 ...

~$ ls /1/db
2019.06.02 2019.06.06 2019.06.12 ...

...
```

Since 4.1 2025.01.17 queries on partitioned tables in segmented databases use secondary threads if available on each segment and partition. Previously parallelism was only at the segment level.


## Considerations

Partition data correctly: data for a particular date must reside in the partition for that date.

:fontawesome-solid-book: 
[`.Q.par`](../ref/dotq.md#par-get-expected-partition-location)

The secondary/directory partitioning is for both read and write.

The directories pointed to in `par.txt` may contain only appropriate database subdirectories. Any other content (file or directory) will give an error.

The same subdirectory name may be in multiple `par.txt` partitions. For example, this would allow symbols to be split, as in A-M on `/0/db`, N-Z on `/1/db`. Aggregations are handled correctly, as long as data is properly split (not duplicated). Note that in this case, the same day would appear on multiple partitions.

----
:fontawesome-solid-bolt:
[Multithreading primitives](../kb/mt-primitives.md)
<br>
:fontawesome-solid-database:
[Multi-partitioned kdb+ databases](../wp/multi-partitioned-dbs/index.md)
<br>
:fontawesome-regular-map:
[Multithreading in kdb+](../wp/multi-thread/index.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_ 
[§14.4 Segmented Tables](/q4m3/14_Introduction_to_Kdb+/#144-segmented-tables)
