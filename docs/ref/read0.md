---
title: read0 reads text | Reference | kdb+ and q documentation
description: read0 is a q keyword that reads text from a file or process handle
author: Stephen Taylor
keywords: file, filesystem, filehandle, handle, kdb+, lines, pipe, process, q, read, read0, text
---
# :fontawesome-solid-database: `read0`





_Read text from a file or process handle_

```txt
read0 f           read0[f]
read0 (f;o;n)     read0[(f;o;n)]
read0 h           read0[h]
read0 (fifo;n)    read0[(fifo;n)]
```

where

-   `f` is a [file symbol](../basics/glossary.md#file-symbol)
-   `(f;o;n)` is a [file descriptor](../basics/glossary.md#file-descriptor)
-   `h` is a [system or connection handle](../basics/handles.md)
-   `fifo` is a communication handle to a [Fifo](hopen.md#communication-handles)
-   `n` is a non-negative integer

returns character data from the source as follows. 


## File symbol

Returns the lines of the file as a list of strings. Lines are assumed delimited by either LF or CRLF, and the delimiters are removed.

```q
q)`:test.txt 0:("hello";"goodbye")  / write some text to a file
q)read0`:test.txt
"hello"
"goodbye"

q)/ read 500000 lines, chunks of (up to) 100000 at a time
q)d:raze{read0(`:/tmp/data;x;100000)}each 100000*til 5
```


## File descriptor

Returns `n` chars from the file, starting from the position `o`.

```q
q)`:foo 0: enlist "hello world"
q)read0 (`:foo;6;5)
"world"
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


## Fifo/named pipe

Returns `n` characters from the pipe.
(Since V3.4 2016.05.31)

```q
q)h:hopen`$":fifo:///etc/redhat-release"
q)read0(h;8)
"Red Hat "
q)read0(h;8)
"Enterpri"
```

----
:fontawesome-solid-book-open:
[Connection handles](../basics/handles.md),
[File system](../basics/files.md),
[Interprocess communication](../basics/ipc.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§11.4.1 Reading and Writing Text Files](/q4m3/11_IO/#1141-reading-and-writing-text-files)