---
title: read1 reads bytes | Reference | kdb+ and q documentation
description: read1 is a q keyword that reads bytes from a file or named pipe.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: bytes, file, filehandle, filesystem, handle, kdb+, pipe, process, q, read, read1
---

# `read1`

_Read bytes from a file or named pipe_

```syntax
read1 f           read1[f]
read1 (f;o)       read1[(f;o)]
read1 (f;o;n)     read1[(f;o;n)]
read1 h           read1[h]
read1 (fifo;n)    read1[(fifo;n)]
```

Where

- `f` is a [file symbol](../basics/glossary.md#file-symbol)
- `o` is an offset in bytes as a non-negative integer
- `h` is a [system or process handle](../basics/handles.md)
- `fifo` is a communication handle to a [Fifo](hopen.md#communication-handles)
- `n` is a length in bytes as a non-negative integer

returns bytes from the source, as follows.

## File

Where the argument is

- a file symbol, returns the entire content of the file
- a file symbol and offset `(f;o)`, returns the entire content of `f` from `o` onwards
- a file symbol, offset, and length `(f;o;n)`, returns up to `n` bytes from `f` starting at `o`

```q
q)`:test.txt 0:("hello";"goodbye")      / write some text to a file
`:test.txt
q)read1`:test.txt                       / read in as bytes
0x68656c6c6f0a676f6f646279650a
q)"c"$read1`:test.txt                   / convert from bytes to char
"hello\ngoodbye\n"
q)read1(`:test.txt;6;3)
0x676f6f
```

Reading a large file in chunks:

```q
q)`:data.txt 0:string til 100000
`:data.txt
q)/ read the file in chunks of (up to) 100000 bytes
q)d:raze{read1(`:data.txt;x;100000)}each 100000*til 6
q)d~read1`:data.txt
1b
```

### Compression

If the file is compressed, `read1` returns the uncompressed data.

```q
q)(`:file;17;2;9)1:100#0x0
`:file
q)\cat file
"kxzippedx\332c`\240=\000\000\000d\000\001\003\000\000\000\002\t\000\000d\000..
q)read1`:file
0x000000000000000000000000000000000000000000000000000000000000000000000000000..
```

## Named pipe

Where the argument is

- a list `(fifo;n)`, returns `n` bytes read from `fifo`
- an integer atom `fifo`, blocks until end of file (EOF), then returns the bytes read from `fifo` (`0#0x` if the pipe is already at EOF)

```q
q)system"mkfifo mypipe"
q)system"(echo 'Red Hat Enterprise Linux' > mypipe &)"  / write to the pipe in the background
q)h:hopen`:fifo://mypipe
q)"c"$read1(h;8)
"Red Hat "
q)"c"$read1(h;8)
"Enterpri"
q)"c"$read1 h                           / read the rest, up to EOF
"se Linux\n"
q)hclose h
```

----

[File system](../basics/files.md),
[Interprocess communication](../basics/ipc.md)
