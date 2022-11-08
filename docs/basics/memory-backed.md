---
title: Memory backed by filesystem | Basics | q and kdb+ documentation
description: Memory can be backed by a filesystem, allowing use of DAX-enabled filesystems (e.g. AppDirect) as a non-persistent memory extension for kdb+
author: Charlie Skelton
date: November 2019
keywords: appdirect, dax, memory, thread
---
# Memory backed by filesystem


Since V4.0 2020.03.17

Memory can be backed by a filesystem, allowing use of DAX-enabled filesystems (e.g. AppDirect) as a non-persistent memory extension for kdb+.

:fontawesome-solid-book-open:
Command-line options [`-m`](cmdline.md#-m-memory-domain),
[`-w`](cmdline.md#-m-workspace),
System command [`\w`](syscmds.md#w-workspace)
<br>
:fontawesome-solid-book:
[`.m` namespace](../ref/dotm.md)

