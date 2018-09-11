Below is a summary of changes from V3.3. Commercially licensed users may obtain the detailed change list / release notes from <http://downloads.kx.com>


## Production release date

2016.05.31


## New

-   IPC message size limit raised from 2GB to 1TB.
-   supports IPC via [Unix domain sockets](/ref/filewords/#hopen) for lower latency, higher throughput local IPC connections.
-   can use both incoming and outgoing encrypted connections using [Secure Sockets Layer(SSL)/Transport Layer Security(TLS)](/cookbook/ssl).
-   can read directly from [NamedPipes](/cookbook/named-pipes) (e.g. avoid unzipping a CSV to disk, can pipe it directly into kdb+).
-   `varchar~\:x` and `x~/:varchar` are now ~10x faster.
-   improved performance by ~10x for `like` on nested char vectors on disk.
-   can utilize the [snappy](http://google.github.io/snappy) compression algorithm as algo \#3 for [File Compression](/cookbook/file-compression).
-   certain vector types can now be [updated efficiently](/ref/lists/#amend), directly on disk, rather than having to rewrite the whole file on change.
-   added async broadcast as [`-25!`(handles;msg)](/ref/internal/#-25x-async-broadcast) which serializes the msg once, queuing it as async msg to each handle.
-   [`parse`](/ref/parsetrees/#parse) can now handle k in addition to q code.
-   `.Q.en` can now handle lists of sym vectors: [Enumerating nested varchar columns](/cookbook/splayed-tables/#enumerating-nested-varchar-columns-in-a-table)

## Not upwardly compatible

-   [`ema`](/ref/stats-moving/#ema) is now a reserved word.

