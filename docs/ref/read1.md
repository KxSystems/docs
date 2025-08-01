---
title: read1 reads bytes | Reference | kdb+ and q documentation
description: read1 is a q keyword that reads bytes from a file or named pipe
author: Stephen Taylor
keywords: bytes, file, filehandle, filesystem, handle, kdb+, pipe, process, q, read, read1
---
# :fontawesome-solid-database: `read1`


_Read bytes from a file or named pipe_

```syntax
read1 f           read1[f]
read1 (f;o)       read1[(f;o)]
read1 (f;o;n)     read1[(f;o;n)]
read1 h           read1[h]
read1 (fifo;n)    read1[(fifo;n)]
```

Where

-   `f` is a [file symbol](../basics/glossary.md#file-symbol)
-   `o` is an offset as a non-negative integer/long
-   `h` is a [system or process handle](../basics/handles.md)
-   `fifo` is a communication handle to a [Fifo](hopen.md#communication-handles)
-   `n` is a length as a non-negative integer/long

returns bytes from the source, as follows.

## File

Where the argument is 

-   a file symbol. Returns the entire content of the file
-   a file symbol and offset `(f;o)`. Returns the entire content of `f` from `o` onwards
-   a file symbol, offset and length `(f;o;n)`. Returns up to `n` bytes from `f` starting at `o`

```q
q)`:test.txt 0:("hello";"goodbye")      / write some text to a file
q)read1`:test.txt                       / read in as bytes
0x68656c6c6f0a676f6f646279650a
q)"c"$read1`:test.txt                   / convert from bytes to char
"hello\ngoodbye\n"

q)/ read 500000 lines, chunks of (up to) 100000 at a time
q)d:raze{read1(`:/tmp/data;x;100000)}each 100000*til 5 
```

### Compression

If the file is compressed, `read1` will return the uncompressed data.

```q
q)(`:file;17;2;9)1:100#0x0
`:file
q)\cat file
"kxzippedx\332c`\240=\000\000\000d\000\001\003\000\..
q)read1`:file
0x0000000000000000000000000000000000000000000000000..
```

## Named pipe

(Since V3.4.) Where `x` is

-   a list `(fifo;length)`, returns `length` bytes read from `fifo`
-   an integer atom `fifo`, blocks and returns bytes from `fifo` when EOF is encountered (`0#0x` if immediate)

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
[Interprocess communication](../basics/ipc.md)

