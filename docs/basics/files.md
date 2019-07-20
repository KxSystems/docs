---
title: File system
description: Operators and keywords for using the file system
keywords: file, kdb+, q
---
# File system




## File handles

A file handle is either

-   a symbol representing the filepath, e.g. `` `:/path/to/file``
-   a system file handle:
    +   `0` – console
    +   `1` – stdout
    +   `2` – stderr
-   an integer file handle returned by `hopen`


## Writing text to a file handle

Syntax: `h x`, `h[x]`

Where 

-   `h` is a file handle or its negation
-   `x` is a string or [parse tree](parsetrees.md)

Writes a string to the file.

```q
q)0 "1 \"hello\""
hello1
```

Negate the handle to append a newline to the string.

```q
q)1 "String vector here\n"
String vector here
1
q)-1 "String vector here"    / equivalent
String vector here
-1
```

Writing a [parse tree](parsetrees.md) evaluates it in the main thread.

```q
q)0 (+;2;2)
4
```

!!! tip "Reading from the console with [`read0`](../ref/read0.md#file-handle) permits interactive input."

Not just system file handles.

```q
q)a:hopen`:file.txt
q)a "first "
q)a "word\n"
q)hclose a
```

If `h` is negative and points to an existing file, then a newline is included.

```q
q)a:hopen`:file.txt
q)neg[a] "first line"
q)neg[a] "second line"
q)hclose a
```


### Prepare Text

The [Prepare Text](../ref/file-text.md#prepare-text) operator converts a table to strings ready to write to file. 

Keyword [`csv`](../ref/csv.md) specifies the comma delimiter to be used when [writing](../ref/file-text.md#save-text) or [loading](../ref/file-text.md#load-csv) a CSV.


## File functions

Three file operators and 14 keywords read from and write to file descriptors.

A file descriptor is either 

- a file handle
- a list `(file handle; offset; length)` to specify that the file is to be read from `offset` (int atom) for `length` (int atom) characters. 

function                             | semantics
-------------------------------------|-----------------------
[`0:`](../ref/file-text.md)          | [File Text](../ref/file-text.md):<br>- Prepare Text<br>- Save Text<br>- Load CSV<br>- Load Fixed<br>- Key-value Pairs
[`1:`](../ref/file-binary.md)        | [File Binary](../ref/file-binary.md):<br>- Read Binary<br>- Save Binary
[`2:`](../ref/dynamic-load.md)       | [Dynamic Load](../ref/dynamic-load.md) of C shared objects
[`dsave`](../ref/dsave.md)           | Save global tables to disk
[Enum Extend](../ref/enum-extend.md#filepath) | Extend and load sym file
[`get`](../ref/get.md)               | Read or memory-map a kdb+ data file
[`hclose`](../ref/handles.md#hclose) | Close a file or process handle
[`hcount`](../ref/handles.md#hcount) | File size
[`hdel`](../ref/handles.md#hdel)     | Delete a file or folder
[`hopen`](../ref/handles.md#hopen)   | Open a file or process handle
[`hsym`](../ref/handles.md#hsym)     | Convert a symbol to a file handle
[`load`](../ref/load.md)             | Load binary data from the filesystem
[`read0`](../ref/read0.md)           | Read text from a file
[`read1`](../ref/read1.md)           | read bytes from a file or named pipe
[`rload`](../ref/load.md#rload)      | Load a splayed table
[`rsave`](../ref/save.md#rsave)      | Save a splayed table to a directory
[`save`](../ref/save.md#save)        | Save global data to file
[`set`](../ref/get.md#set)           | Assign a value to a variable or file


