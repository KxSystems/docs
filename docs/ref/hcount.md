---
title: hcount returns file size | Reference | q and kdb+ documentation
description: Keyword hcount returns the size in bytes of a file
author: Stephen Taylor
date: December 2019
keywords: file, size
---
# :fontawesome-solid-database: `hcount`



_Size of a file in bytes_

```txt
hcount x     hcount[x]
```

Where `x` is a [file symbol](../basics/glossary.md#file-symbol), 
returns as a long the size of the file.

```q
q)hcount`:c:/q/test.txt
42
```

On a compressed file returns the size of the original uncompressed file.

----
:fontawesome-solid-book-open:
[File system](../basics/files.md)
