---
title: Handles to files and processes | Basics | q and kdb+ documentation
description: Kdb+ communicates with the system, filesystem, and other processes through handles
author: Stephen Taylor
date: December 2019
---
# Connection handles


Kdb+ communicates with the system (console, stdout, stderr), file system, and other processes through connection _handles_. 

There are three permanent _system handles_:

```txt
0  console
1  stdout
2  stderr
```

Other handles are created by [`hopen`](../ref/hopen.md) and destroyed 
by [`hclose`](../ref/hopen.md#hclose).


## Syntax

A handle is an int atom but is [variadic](glossary.md#variadic). 
Syntactically, it can be an int atom or a unary function.


```q
q)1           / one is one
1
q)1["abc\n"]  / or stdout
abc
1
```

A handle is an [applicable value](glossary.md#applicable-value). It (and its negation) can be applied to an argument and iterated. 


## Write to a handle

Applied to an argument, a handle writes the argument to its target and returns itself. 


### stdout and stderr

```q
q)a:1 "quick brown fox\n"
quick brown fox
q)a
1
```

Write only chars to stdout and stderr.

```q
q)1[200 300]
'type
  [0]  1[200 300]
       ^
```

### Newlines

Negate the handle to append a newline to the string.

```q
q)1 "lazy dog"
lazy dog1
q)-1 "lazy dog"
lazy dog
-1
```


### Console

Writing a string or a [parse tree](parsetrees.md) to the console [evaluates](../ref/eval.md) it in the main thread.

```q
q)0 "1 \"hello\""   /string
hello1

q)0 (+;2;2)         /parse tree
4
```

Reading from the console with [`read0`](../ref/read0.md#system-or-process-handle) permits interactive input.


### File

```q
q)\ls data
ls: data: No such file or directory
'os
  [0]  \ls data
       ^
q)h:hopen `:data/new
q)h                        /handle is an integer
3i
q)type h                   /atom
-6h
q)h "now is the time"      /but can be applied as a unary
3i
q)/and iterated
q)h each (" for all good men";" to come to the aid of the party")
3 3i
q)hclose h
q)read0 `:data/new         /hopen created file path
"now is the time for all good men to come to the aid of the party"
```

## Read from a handle

Use [`read0`](../ref/read0.md), [File Text](../ref/file-text.md), [`read1`](../ref/read1.md), or [File Binary](../ref/file-binary.md).


<i class="fas fa-book-open"></i>
[File system](files.md),
[Interprocess communication](ipc.md)<br>
<i class="fas fa-book"></i>
[`hopen`, `hclose`](../ref/hopen.md),
[`hsym`](../ref/hsym.md)
