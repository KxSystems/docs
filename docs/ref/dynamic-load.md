---
title: Dynamic Load – Reference – kdb+ and q documentation
description: Dynamic Load is a q operator that loads C shared objects for use in q programs.
keywords: c, dynamic, kdb+, load, object, q, shared
---
# `2:` Dynamic Load





_Load C shared objects_

Syntax: `file symbol 2: (cfn;rnk)`, `2:[file symbol;(cfn;rnk)]`

Where

-   `file symbol` is a [file symbol](../basics/glossary.md#file-symbol)
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

<i class="fas fa-book-open"></i> 
[File system](../basics/files.md)<br>
<i class="fab fa-superpowers"></i>
[Using C/C++ functions](../interfaces/using-c-functions.md)


