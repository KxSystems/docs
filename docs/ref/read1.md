---
title: read1 reads bytes | Reference | kdb+ and q documentation
description: read1 is a q keyword that reads bytes from a file or named pipe
author: Stephen Taylor
keywords: bytes, file, filehandle, filesystem, handle, kdb+, pipe, process, q, read, read1
---
# `read1`






_Read bytes from a file or named pipe_

Syntax: `read1 x`, `read1[x]`

Where `x` is a

-   [file symbol](../basics/glossary.md#file-symbol)
-   [file descriptor](../basics/glossary.md#file-descriptor)
-   [handle](../basics/handles.md) to a [fifo](hopen.md#fifonamed-pipes)
-   2-list: a handle to a fifo, and a byte count (int)

returns bytes from the source, as follows.


## File

Where `x` is 

-   an file symbol, returns the entire content of the file
-   a list `(file;offset;length)`, returns up to `length` bytes from `file` starting at `offset`
-   a list `(file;offset)`, returns the entire content of `file` from `offset` onwards

```q
q)`:test.txt 0:("hello";"goodbye")      / write some text to a file
q)read1`:test.txt                       / read in as bytes
0x68656c6c6f0a676f6f646279650a
q)"c"$read1`:test.txt                   / convert from bytes to char
"hello\ngoodbye\n"

q)/ read 500000 lines, chunks of (up to) 100000 at a time
q)d:raze{read1(`:/tmp/data;x;100000)}each 100000*til 5 
```

<i class="fas fa-book-open"></i>
[File system](../basics/files.md)


## Named pipe

(Since V3.4.) Where `x` is

-   a list `(fifo;length)`, returns `length` bytes read from `fifo`
-   an atom `fifo`, blocks and returns bytes from `fifo` when EOF is encountered (`0#0x` if immediate)

```q
q)h:hopen`$":fifo:///etc/redhat-release"
q)"c"$read1(h;8)
"Red Hat "
q)"c"$read1(h;8)
"Enterpri"
q)system"mkfifo somefifo";h:hopen`fifo:somefifo; 0N!read1 h; hclose h
```

<i class="fas fa-book-open"></i>
[Interprocess communicaion](../basics/ipc.md)

