---
title: read1 reads bytes | Reference | kdb+ and q documentation
description: read1 is a q keyword that reads bytes from a file or named pipe
author: Stephen Taylor
keywords: bytes, file, filehandle, filesystem, handle, kdb+, pipe, process, q, read, read1
---
# :fontawesome-solid-database: `read1`






_Read bytes from a file or named pipe_

```txt
read1 f           read1[f]
read1 (f;o;n)     read1[(f;o;n)]
read1 h           read1[h]
read1 (fifo;n)    read1[(fifo;n)]
```

Where

-   `f` is a [file symbol](../basics/glossary.md#file-symbol)
-   `(f;o;n)` is a [file descriptor](../basics/glossary.md#file-descriptor)
-   `h` is a [system or process handle](../basics/handles.md)
-   `fifo` is a communication handle to a [Fifo](hopen.md#communication-handles)
-   `n` is a non-negative integer

returns bytes from the source, as follows.


## File

Where the argument is 

-   a file symbol, returns the entire content of the file
-   a file descriptor `(f;o;n)`, returns up to `n` bytes from `f` starting at `o`
-   a file descriptor `(f;o)`, returns the entire content of `f` from `o` onwards

```q
q)`:test.txt 0:("hello";"goodbye")      / write some text to a file
q)read1`:test.txt                       / read in as bytes
0x68656c6c6f0a676f6f646279650a
q)"c"$read1`:test.txt                   / convert from bytes to char
"hello\ngoodbye\n"

q)/ read 500000 lines, chunks of (up to) 100000 at a time
q)d:raze{read1(`:/tmp/data;x;100000)}each 100000*til 5 
```


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

----
:fontawesome-solid-book-open:
[File system](../basics/files.md),
[Interprocess communicaion](../basics/ipc.md)

