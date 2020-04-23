---
title: Handles to files and processes | Basics | q and kdb+ documentation
description: Kdb+ communicates with the console, stdout, stderr, filesystem, and other processes through handles
author: Stephen Taylor
date: April 2020
---
# Connection handles


Kdb+ communicates with the console, stdout, stderr, file system, and other processes through connection _handles_. 

There are three permanent _system handles_:

```txt
0  console
1  stdout
2  stderr
```

File and process handles are created by `hopen` and destroyed by `hclose`.

:fontawesome-solid-book:
[`hopen`, `hclose`](../ref/hopen.md),
[`hsym`](../ref/hsym.md)


## Write

Syntax:
```txt
    h  x
neg[h] x
```

where `h` is a handle, writes `x` to its target as described below and returns itself.

A handle is an int atom but is [variadic](glossary.md#variadic). 
Syntactically, it can be an int atom or a unary function.

```q
q)1           / one is one
1
q)1 "abc\n"   / or stdout
abc
1
```

:fontawesome-regular-comment:
A handle is an [applicable value](glossary.md#applicable-value). It (and its negation) can be applied to an argument and iterated. 


### Console

Where `h` is 0 and `x` is a string or parse tree, evaluates `x` in the main thread and returns the result.

```q
q)0 "1 \"hello\""   /string
hello1

q)0 (+;2;2)         /parse tree
4
```

:fontawesome-solid-book:
[`eval`](../ref/eval.md)
<br>
:fontawesome-solid-book-open:
[Parse trees](parsetrees.md)


### File, stdout, stderr

Where `h` is stdout, stderr, or a file handle

-   `h x` appends string `x` to the file 
-   `neg[h] x` where `x` is a
    -   string, appends `x,"\n"` 
    -   list of strings, appends `x,'"\n"`
    to the file.

```q
q)a:1 "quick brown fox\n"
quick brown fox
q)a
1

q)a:-1 ("quick";"brown";"fox")
quick
brown
fox
q)a
-1

q)f:`:tmp.txt
q)hopen f
3i
q)3 "quick brown fox"
3
q)-3 ("quick";"brown";"fox")
-3
q)hclose 3
q)read0 f
"quick brown foxquick"
"brown"
"fox"

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

:fontawesome-solid-book-open:
[File system](files.md)


### Process

-   `h x` sends string `x` as a sync request (get)
-   `neg[h] x` sends string `x` as an async request (set)

:fontawesome-solid-book-open:
[Interprocess communication](ipc.md)


## Read

### Console

Reading from the console with [`read0`](../ref/read0.md#system-or-process-handle) permits interactive input.

```q
q)s:{1 x;read0 0}"Next track: "
Next track: Bewlay Brothers
q)s
"Bewlay Brothers"
```


### File 

:fontawesome-solid-book:
[`read0`](../ref/read0.md), 
[File Text](../ref/file-text.md)
<br>
:fontawesome-solid-book:
[`read1`](../ref/read1.md), 
[File Binary](../ref/file-binary.md)




