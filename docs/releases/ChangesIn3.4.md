---
title: Changes in 3.4
description: Changes to V3.4 of kdb+ from the previous version
author: Charles Skelton
---
# Changes in 3.4




Below is a summary of changes from V3.3. Commercially licensed users may obtain the detailed change list / release notes from <http://downloads.kx.com>


## Production release date

2016.05.31


## New

-   IPC message size limit raised from 2GB to 1TB.
-   supports IPC via [Unix domain sockets](../ref/handles.md#hopen) for lower latency, higher throughput local IPC connections.
-   can use both incoming and outgoing encrypted connections using [Secure Sockets Layer(SSL)/Transport Layer Security(TLS)](../kb/ssl.md).
-   can read directly from [NamedPipes](../kb/named-pipes.md) (e.g. avoid unzipping a CSV to disk, can pipe it directly into kdb+).
-   `varchar~\:x` and `x~/:varchar` are now ~10x faster.
-   improved performance by ~10x for `like` on nested char vectors on disk.
-   can utilize the [snappy](http://google.github.io/snappy) compression algorithm as algo \#3 for [File Compression](../kb/file-compression.md).
-   certain vector types can now be [updated efficiently](../ref/amend.md), directly on disk, rather than having to rewrite the whole file on change.
-   added async broadcast as [`-25!`(handles;msg)](../basics/internal.md#-25x-async-broadcast) which serializes the msg once, queuing it as async msg to each handle.
-   [`parse`](../basics/parsetrees.md#parse) can now handle k in addition to q code.
-   `.Q.en` can now handle lists of sym vectors: [Enumerating nested varchar columns](../kb/splayed-tables.md#enumerating-nested-varchar-columns-in-a-table)

## Not upwardly compatible

-   [`ema`](../ref/ema.md) is now a reserved word.

