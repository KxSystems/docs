---
title: Dynamic Load
description: Dynamic Load is a q operator that loads C shared objects for use in q programs.
keywords: c, dynamic, kdb+, load, object, q, shared
---
# `2:` Dynamic Load





_Load C shared objects_

Syntax: `x 2: y`, `2:[x;y]`

Where

-   `x` is a file symbol
-   `y` is a 2-item list: the name of a C function (symbol) and its rank (int)

returns a function that calls it.

Suppose we have a C function in `cpu.so` with the prototype

```C
K q_read_cycles_of_this_cpu(K x);
```

assign it to `read_cycles`:

```q
read_cycles:`cpu 2:(`q_read_cycles_of_this_cpu;1)
```

If the shared library, as passed, does not exist, kdb+ will try to load it from `$QHOME/os`, where `os` is the operating system and architecture acronym, e.g. `l64`, `w64`, etc. If using a relative path which does not resolve to reside under `$QHOME/os`, ensure that `LD_LIBRARY_PATH` contains the required absolute search path for that library. On Windows, use `PATH` instead of `LD_LIBRARY_PATH`.

<i class="far fa-hand-point-right"></i> 
Basics: [File system](../basics/files.md)  
Interfaces: [Using C/C++ functions](../interfaces/using-c-functions.md)


