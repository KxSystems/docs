---
title: hsym converts symbol to file symbol | Reference | q and kdb+ documentation
description: Keyword hsym converts symbol/s to file- or process-symbol/s
author: Stephen Taylor
date: December 2019
---
# `hsym`



_Symbol/s to file or process symbol/s_

```txt
hsym x     hsym[x]
```

Where `x` is a symbol atom or vector (since V3.1) returns the symbol/s prefixed with a colon if it does begin with one.


```q
q)hsym`c:/q/test.txt                / file path to symbolic file handle
`:c:/q/test.txt
q)hsym`10.43.23.197                 / IP address to symbolic handle
`:10.43.23.197
q)hsym `host:port`localhost:8001    / hostname to symbolic handle
`:host:port`:localhost:8001

q)hsym `abc`:def`::ghi
`:abc`:def`::ghi
```

----
:fontawesome-solid-book:
[`hopen`](hopen.md)
<br>
:fontawesome-solid-book-open:
[File system](../basics/files.md),
[Interprocess communication](../basics/ipc.md)