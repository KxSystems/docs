---
title: Dynamic Load – Reference – kdb+ and q documentation
description: Dynamic Load is a q operator that loads C shared objects for use in q programs.
keywords: c, dynamic, kdb+, load, object, q, shared
---
# `2:` Dynamic Load





_Load C shared objects_

```syntax
fs 2: (cfn;rnk)    2:[fs;(cfn;rnk)]
```

Where

-   `fs` is a [file symbol](../basics/glossary.md#file-symbol)
-   `cfn` is the name of a C function (symbol) 
-   `rnk` its [rank](../basics/glossary.md#rank) (int)

returns a function that calls it.

Suppose we have a C function in `cpu.so` with the prototype

```C
K q_read_cycles_of_this_cpu(K x);
```

assign it to `read_cycles`:

```q
read_cycles:`cpu 2:(`q_read_cycles_of_this_cpu;1)
```

If the shared library, as passed, does not exist, kdb+ will try to load it from `$QHOME/os`, where `os` is the operating system and architecture acronym, e.g. `l64`, `w64`, etc. 

If using a relative path which does not resolve to reside under `$QHOME/os`, ensure that `LD_LIBRARY_PATH` contains the required absolute search path for that library. (On Windows, use `PATH` instead of `LD_LIBRARY_PATH`.)

Since 3.6 2018.08.24 loading shared libraries via 2: resolved to a canonical path prior to load via the OS. This caused issues for libs whose run-time path was relative to a sym-link.
From 4.1t 2024.01.11 it resolves to an absolute path only, without resolving sym-links.

:fontawesome-solid-book-open: 
[File system](../basics/files.md)<br>
:fontawesome-brands-superpowers:
[Using C/C++ functions](../interfaces/using-c-functions.md)


