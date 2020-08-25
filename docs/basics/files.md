---
title: File system | Basics | kdb+ and q documentation
description: Operators and keywords for using the file system
keywords: file, kdb+, q
---
# :fontawesome-solid-database: File system


Kdb+ communicates with the filesystem through

-   one-shot operations
-   handles to persistent connections

Handles are more efficient for multiple operations on a file.

!!! info "File paths are displayed separated with forward slashes, regardless of the operating system."


## :fontawesome-solid-thumbs-up: One-shot operations

<pre markdown="1" class="language-txt">
[get set](../ref/get.md)       read/write or memory-map a data file¹
[value](../ref/value.md)         read a data file¹

[hcount](../ref/hcount.md)        file size
[hdel](../ref/hdel.md)          delete a file or folder
[hsym](../ref/hsym.md)          symbol/s to file symbol/s¹

[0: File Text](../ref/file-text.md)      read/write chars¹       [read0](../ref/read0.md)  read chars¹
[1: File Binary](../ref/file-binary.md)    read/write bytes¹       [read1](../ref/read1.md)  read bytes¹
[2: Dynamic Load](../ref/dynamic-load.md)   load shared object

[save](../ref/save.md#save)   [load](../ref/load.md)   a variable
[rsave](../ref/save.md#rsave)  [rload](../ref/load.md#rload)  a splayed table
[dsave](../ref/dsave.md)         tables
[?  Enum Extend](../ref/enum-extend.md#filepath)
</pre>

¹ Has application beyond the file system.


### Setting and getting

Keywords [`set` and `get`](../ref/get.md) let you treat files as variables that persist in the filesystem.

```q
q)`:data/foo`:data/bar set'(42;"thin white duke")
`:data/foo`:data/bar
q)get `:data/foo
42
q)get `:data/bar
"thin white duke"
```


### File utilities

<pre markdown="1" class="language-txt">
[hcount](../ref/hcount.md)        file size
[hdel](../ref/hdel.md)          delete a file or folder
[hsym](../ref/hsym.md)          symbol/s to file symbol/s
</pre>


### Writing and reading

Any file can be read or written as bytes (binary).
Text-file primitives handle text files.

`0` associates with text; `1` with bytes.

<pre markdown="1" class="language-txt">
[read0](../ref/read0.md)               [read1](../ref/read1.md)
[0: Load CSV](../ref/file-text.md#load-csv)         [1: Read Binary](../ref/file-binary.md#read-binary)
[0: Load Fixed](../ref/file-text.md#load-fixed)

[0: Save Text](../ref/file-text.md#save-text)        [1: Save Binary](../ref/file-binary.md#save-binary)
</pre>

!!! tip "The [File Text operator `0:`](../ref/file-text.md) can also represent a table as strings, and interpret key-value pairs."


### Tables

<pre markdown="1" class="language-txt">
[save](../ref/save.md#save)   [load](../ref/load.md)   a table
[rsave](../ref/save.md#rsave)  [rload](../ref/load.md#rload)  a splayed table
[dsave](../ref/dsave.md)         tables
[?  Enum Extend](../ref/enum-extend.md#filepath)
</pre>

Kdb+ uses files and directories to persist database tables.
[Partitioning a table](../kb/partition.md) divides its rows across multiple directories.
[Splaying a table](../kb/splayed-tables.md) stores each column as a separate file.


## :fontawesome-solid-hands-helping: Connections

A persistent connection enables multiple operations on a file without repeatedly opening and closing it. 

Opening a connection to a file returns a handle to the connection. The handle takes the form of an int that is also an applicable value. 

System handles 0, 1, and 2 are to the console, stdout, and stderr.
They are always open.

<pre markdown="1" class="language-txt">
0 console          [hopen](../ref/hopen.md)   open a file¹
1 stdout           [hclose](../ref/hopen.md#hclose)  close a file¹
2 stderr
</pre>

Opening a connection to a non-existent file creates it and any missing ancestor directories.

Applying the handle to data appends it to the file as bytes.
Applying the `neg` of the handle to char data appends it as text. 
The result of a successful operation is the positive or negative handle.

### Text

```q
q)key `:foo/                            / does not exist
q)show h:hopen `:foo/bar.txt
12i
q)key `:foo/                            / file and dir created
,`bar.txt

q)neg[h] "hear the lark and hearken"
-12i
q)-12i "to the barking of the dog fox"
-12i
q)neg[h] "gone to ground"
-12i

q)hclose h
q)hcount `:foo/bar.txt
71
q)read0 `:foo/bar.txt
"hear the lark and hearken"
"to the barking of the dog fox"
"gone to ground"

q)read0 (`:foo/bar.txt;10;20)
"ark and hearken"
"to t"
```


### Bytes

```q
q)hopen ":foo/hello.dat"
7i
q)7i 0x68656c6c6f776f726c64
7i
q)hclose 7i
q)read1 `:foo/hello.dat
0x68656c6c6f776f726c64
```


## Relative filepaths

Relative filepaths are sought in the following locations, in order.

1.  current directory
1.  [`QHOME`](../basics/environment.md)
1.  [`QLIC`](../basics/environment.md)


