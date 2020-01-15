---
title: hsym converts symbol to file symbol | Reference | q and kdb+ documentation
description: Keyword hsym converts symbol/s to file- or process-symbol/s
author: Stephen Taylor
date: December 2019
---
# `hsym`



_Symbol/s to file or process symbol/s_

Syntax: `hsym x`, `hsym[x]`

Where `x` is a symbol atom or vector (since V3.1) representing a

-   file name
-   valid hostname
-   IP address

returns a [file symbol](../basics/glossary.md#file-symbol) or process symbol.

```q
q)hsym`c:/q/test.txt
`:c:/q/test.txt
q)hsym`10.43.23.197
`:10.43.23.197
q)hsym `host:port`localhost:8001
`:host:port`:localhost:8001
```

<i class="fas fa-book-open"></i>
[File system](../basics/files.md)
[Interprocess communication](../basics/ipc.md)
<br>
<i class="fas fa-book"></i>
[`hopen`](hopen.md)