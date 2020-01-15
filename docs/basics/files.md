---
title: File system – Basics – kdb+ and q documentation
description: Operators and keywords for using the file system
keywords: file, kdb+, q
---
# File system


<pre markdown="1" class="language-txt">
0 console     [read0](../ref/read0.md)  [0: File Text](../ref/file-text.md)      read/write chars¹
1 stdout      [read1](../ref/read1.md)  [1: File Binary](../ref/file-binary.md)    read/write bytes¹
2 stderr             [2: Dynamic Load](../ref/dynamic-load.md)   load shared object
                     [?  Enum Extend](../ref/enum-extend.md#filepath)

[get set](../ref/get.md)       read/write or memory-map a data file¹

[hopen hclose](../ref/hopen.md)  open/close a file¹

[hcount](../ref/hcount.md)        file size
[hdel](../ref/hdel.md)          delete a file or folder
[hsym](../ref/hsym.md)          symbol/s to file symbol/s¹

[save](../ref/save.md#save)   [load](../ref/load.md)   a table
[rsave](../ref/save.md#rsave)  [rload](../ref/load.md#rload)  a splayed table
[dsave](../ref/dsave.md)         tables
</pre>

¹ Has application beyond the file system.

Kdb+ communicates with the system, file system, and with other processes through [connection handles](handles.md) and the operators
[File Text](../ref/file-text.md), [File Binary](../ref/file-binary.md), [Dynamic Load](../ref/dynamic-load.md), and [Enum Extend](../ref/enum-extend.md).
Keywords cover important use cases.


## Setting and getting

Keywords [`set` and `get`](../ref/get.md) write and read the values of files in the filesystem. (Also variables in memory.)

```q
q)`:data/foo`:data/bar set'(42;"thin white duke")
`:data/foo`:data/bar
q)get `:data/foo
42
q)get `:data/bar
"thin white duke"
```


## Writing and reading

&nbsp; | text | bytes
-------|------|------
write | [`hopen` `hclose`](../ref/hopen.md)<br>write with handle | [`hopen` `hclose`](../ref/hopen.md)<br>write with handle
 | [`0:` Save Text](../ref/file-text.md#save-text) | [`1:` Save Binary](../ref/file-binary.md#save-binary)
read | [`read0`](../ref/read0.md) | [`read1`](../ref/read1.md)
 | [`0:` Load CSV](../ref/file-text.md#load-csv)<br>[`0:` Load Fixed](../ref/file-text.md#load-fixed) | [`1:` Read Binary](../ref/file-binary.md#read-binary)

<i class="fas fa-book-open"></i>
[Writing with handles](handles.md)

!!! tip "File Text operator"

    Operator form [Prepare Text](../ref/file-text.md#prepare-text) represents a table as strings; [Key-Value Pairs](../ref/file-text.md#key-value-pairs) interprets key-value pairs.



## Tables

Kdb+ uses files and directories to represent database tables.
[Partitioning a table](../kb/partition.md) divides its rows across multiple directories.
[Splaying a table](../kb/splayed-tables.md) stores each column as a separate file.


## Relative filepaths

Relative filepaths are sought in the following locations, in order.

1.  current directory
2.  `QHOME`
3.  `QLIC`

