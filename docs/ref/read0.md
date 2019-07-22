---
title: read0
description: read0 is a q keyword that reads text from a file or process handle.
author: Stephen Taylor
keywords: file, filesystem, filehandle, handle, kdb+, lines, pipe, process, q, read, read0, text
---
# `read0`





_Read text from a file or process handle_

Syntax: `read0 x`, `read0[x]`

where `x` is a filename, file or process handle, or a file descriptor,
returns data from a text file or handle. 



## Filename

Where `x` is a filename,
returns the lines of the file as a list of strings. Lines are assumed delimited by either LF or CRLF, and the delimiters are removed.

```q
q)`:test.txt 0:("hello";"goodbye")  / write some text to a file
q)read0`:test.txt
("hello";"goodbye")

q)/ read 500000 lines, chunks of (up to) 100000 at a time
q)d:raze{read0(`:/tmp/data;x;100000)}each 100000*til 5
```


## File or process handle

Where `x` is a file or process handle
returns a line of text from it.

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


## File descriptor

Where `x` is a file descriptor,
i.e. a list of the form `(file; offset; length)`, returns bytes from `file`.

```q
q)`:foo 0: enlist "hello world"
q)read0 (`:foo;6;5)
"world"
```

Starting with V3.4 2016.05.31 `read0` allows user to specify how many bytes to read from a Fifo.

```q
q)h:hopen`$":fifo:///etc/redhat-release"
q)read0(h;8)
"Red Hat "
q)read0(h;8)
"Enterpri"
```


<i class="far fa-hand-point-right"></i>
[File and process handles](handles.md)  
Basics: [File system](../basics/files.md)
