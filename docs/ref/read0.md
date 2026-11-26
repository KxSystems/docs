---
title: read0 reads text | Reference | kdb+ and q documentation
description: read0 is a q keyword that reads text from a file or process handle.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: file, filesystem, filehandle, handle, kdb+, lines, pipe, process, q, read, read0, text
---

# `read0`

_Read text from a file or process handle_

```syntax
read0 f           read0[f]
read0 (f;o)       read0[(f;o)]
read0 (f;o;n)     read0[(f;o;n)]
read0 h           read0[h]
read0 (fifo;n)    read0[(fifo;n)]
```

Where

- `f` is a [file symbol](../basics/glossary.md#file-symbol)
- `o` is an offset in bytes as a non-negative integer
- `h` is a [system or connection handle](../basics/handles.md)
- `fifo` is a communication handle to a [Fifo](hopen.md#communication-handles)
- `n` is a length in bytes as a non-negative integer

returns character data from the source as follows.

## File symbol

Returns the lines of the file as a list of strings. `read0` treats either line feed (LF) or carriage return plus line feed (CRLF) as the line delimiter, and removes the delimiters.

```q
q)`:test.txt 0:("hello";"goodbye")  / write some text to a file
`:test.txt
q)read0`:test.txt
"hello"
"goodbye"
```

## File symbol with offset and length

Returns the lines of the file, starting from byte `o`.

```q
q)`:foo 0: enlist "hello world"
`:foo
q)read0 (`:foo;6)
"world"
```

Returns the lines in the `n` bytes of the file starting from byte `o`.

```q
q)read0 (`:foo;6;2)
"wo"
```

The offset and length count bytes, not lines, so a line that crosses the end of the range is cut short.

```q
q)read0 (`:test.txt;0;8)
"hello"
"go"
```

## System or process handle

Returns a line of text from the source.

```q
q)rl:{1">> ";read0 0}
q)rl`
>> xiskso
"xiskso"
```

Reading the console permits interactive input.

```q
q)1">> ";a:read0 0
>> whatever
q)a[4+til 4]
"ever"
```

## Fifo or named pipe

(Since V3.4 2016.05.31) Where the argument is a handle `fifo` to a Fifo, returns the lines read from the pipe until end of file (EOF).
Where the argument is `(fifo;n)`, returns `n` characters from the pipe.

```q
q)system"mkfifo mypipe"
q)system"(echo 'Red Hat Enterprise Linux' > mypipe &)"  / write to the pipe in the background
q)h:hopen`:fifo://mypipe
q)read0(h;8)
"Red Hat "
q)read0(h;8)
"Enterpri"
q)hclose h
```

----

[Connection handles](../basics/handles.md),
[File system](../basics/files.md),
[Interprocess communication](../basics/ipc.md)
<br>

_Q for Mortals_
[§11.4.1 Reading and Writing Text Files](/q4m3/11_IO/#1141-reading-and-writing-text-files)
