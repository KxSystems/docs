---
title: File compression | Database | kdb+ and q documentation
description: How to work with compressed files in kdb+
author: Stephen Taylor
date: October 2020
---
# File compression




Kdb+ can compress data as it is written to disk.
Q operators and keywords read both compressed and uncompressed files.


## Write compressed files

Use [`set`](../ref/get.md#set) with a left argument that specifies the file or splay target, and the [compression parameters](#compression-parameters).
(For a splayed table, you can [specify the compression of each column](../ref/get.md#compression).)

```q
q)`:a set 1000#enlist asc 1000?10  / uncompressed file
`:a
q)(`:za;17;2;9)set get`:a          / compressed file
`:za
q)get[`:a]~get`:za
1b
```

Using real NYSE trade data, we observed the `gzip` algorithm at level 9 compressing to 15% of original size, and the IPC compression algorithm compressing to 33% of original size.

The compressed file allows random access to the data.

??? tip "Source and target file on the same drive might run slowly"

    Compression reads from the source file, compresses the data and writes to the target file. The disk is likely receiving many seek requests.

    If you move the target file to a different physical disk, you will reduce the number of seeks needed.

Cautions:

-   Do not use streaming compression with **log files**. After a crash, the log file would be unusable as it will be missing meta information from the end of the file. Streaming compression maintains the last block in memory and compresses/purges it as needed or latest on close of file handle.
-   When a **nested data** column file, e.g. `name`, is compressed, its companion file `name#` or `name##` is also compressed: do not try to compress it explicitly.
-   Use `set` and not **gzip**: they produce different results.



### Compression parameters

Compression is specified by three integers representing logical block size,   algorithm, and compression level.


Logical block size

: A power of 2 between 12 and 20: pageSize or allocation granularity to 1MB.

: PageSize for AMD64 is 4kB, SPARC is 8kB. Windows seems to have a default allocation granularity of 64kB.

: When choosing the logical block size, consider the minimum of all the platforms that will access the files directly – otherwise you may encounter `disk compression - bad logicalBlockSize`.

: This value affects both compression speed and compression ratio: larger blocks can be slower and better compressed.


Algorithm and compression level

: Pick from: <pre class="language-txt">
alg  algorithm  level  since
\----------------------------
0    none       0
1    q IPC      0
2    gzip       0-9
3    snappy     0      V3.4
4    lz4hc      1-12   V3.6
</pre>


### Selective compression

You can choose which files to compress, and which algorithm/level to use per file.

Q operators read both compressed and uncompressed files.
So files that do not compress well, or have an access pattern that does not perform well with compression, can be left uncompressed.


### Compression statistics

The [`-21!` internal function](../basics/internal.md#-21x-compression-stats) returns a dictionary of compression statistics, or an empty dictionary if the file is not compressed.

[`hcount`](../ref/hcount.md) returns the uncompressed file length.


### Compression by default

Kdb+ can write compressed files by default.

This is governed by the [zip defaults `.z.zd`](../ref/dotz.md#zzd-zip-defaults).
Set this as an integer vector, e.g.

```q
.z.zd:17 2 6
```

and [`set`](../ref/get.md#set) will write files (with no extension) compressed in this way unless given different parameters.

To disable compression by default, set `.z.zd` to `3#0`, or expunge it.

```q
.z.zd:3#0   / no compression
\x .z.zd    / no compression
```

By default, `.z.zd` is undefined and q writes files uncompressed.


### Append to a compressed file or splay

```q
q)(`:zippedTest;17;2;6) set 100000?10
`:zippedTest
q)`:zippedTest upsert 100000?10
`:zippedTest

q)-21!`:zippedTest
compressedLength  | 148946
uncompressedLength| 1600016
algorithm         | 2i
logicalBlockSize  | 17i
zipLevel          | 6i
```

Appending to files with an attribute (e.g. `` `p#`` on sym) causes the whole file to be read and rewritten.

??? warning "Appending to compressed enum files in V3.0 2012.05.17"

    Appending to compressed enum files was blocked in V3.0 2012.05.17 due to potential concurrency issues, hence these files should not be compressed.


## Decompression

Decompression is implicit: q operators and keywords read both compressed and uncompressed files.

```q
get`:compressedFile

\x .z.zd                                    / write uncompressed by default
`:uncompressedFile set get `:compressedFile / store again decompressed
```

Files are mapped or unmapped on demand during a query. Only the areas of the file that are touched are decompressed, i.e. kdb+ uses random access. Decompressed data is cached while a file is mapped.
Columns are mapped for the duration of the select.

For example, say you are querying by date and sum over a date-partitioned table, with each partition parted by sym. The query decompresses only the parts of the column data for the syms in the query predicate.


### Concurrently open files

The number of concurrently open files is limited by the environment/OS only (e.g. `ulimit -n`).

??? detail "Prior to V3.2"

    V3.2+ uses two file descriptors per file: you might need to increase the `ulimit -n` value used in prior versions.

    Prior to V3.1 2013.02.21 no more than 4096 compressed files could be open concurrently.

There is no practical internal limit on the number of uncompressed files.


### Memory allocation

Kdb+ allocates enough memory to decompress the whole vector, regardless of how much it finally uses. This reservation is required as there is no backing store for the decompressed data, unlike with mapped files of uncompressed data, which can always read the pages from file again should they have been dropped.

This is reservation only, and can be accommodated by increasing the swap space available: even though the swap should never actually be written to, the OS has to be assured that in the worst-case scenario of decompressing the data in full, it could swap it out if needed.

If you experience `wsfull` even with sufficient swap space configured, check whether you have any soft/hard limits imposed with `ulimit -v`.

??? tip "Memory overcommit settings on Linux"

    `/proc/sys/vm/overcommit\_memory` and `/proc/sys/vm/overcommit\_ratio` – these control how careful Linux is when allocating address space with respect to available physical memory plus swap.


## Performance

A single thread with full use of a core can decompress approx 300MB/s, depending on data/algorithm and level.


###  Benchmarking

It is difficult to estimate the impact of compression on performance.
On the one hand, compression does trade CPU utilization for disk-space savings. And up to a point, if you’re willing to trade more CPU time, you can save more space. But by reducing the space used, you end up doing less disk I/O, which can improve overall performance if your workload is bandwidth-limited.

The only way to know the real impact of compression on your disk utilization and system performance is to run your workload with different levels of compression and observe the results.

Currently, ZFS compression probably has an edge over native kdb+ compression, due to keeping more decompressed data in cache, which is available to all processes.

Perform your benchmarks on the same hardware setup as you would use for production and be aware of the disk cache – flush the cache before each test. The disk cache can be flushed on Linux using

```bash
sync ; sudo echo 3 | sudo tee /proc/sys/vm/drop_caches
```
and on macOS, the OS command `purge` can be used.


### Compression parameters

The `logicalBlockSize` represents how much data is taken as a compression unit, and consequently the minimum size of a block to decompress. E.g. using a `logicalBlockSize` of 128kB, a file of size 128000kB would be cut into 100 blocks, and each block compressed independently of the others. Later, if a single byte is requested from that compressed file, a minimum of 128kB would be decompressed to access that byte. Fortunately those types of access patterns are rare, and typically you would be extracting clumps of data that make a logical block size of 128kB quite reasonable.

Experiment to discover what suits your data, hardware and access patterns best. A good balance for TAQ data and typical TAQ queries is to use algorithm 1 (the same algorithm as used for IPC compression) with 128kB `logicalBlockSize`. To trade performance for better compression, choose gzip with compression level 6.


### Hardware acceleration

A hardware accelerator card can improve compression performance.

If it uses Zlib, then kdb+ should be able to use it. You will need to export the Zlib driver provided by AHA, e.g.

```bash
export LD_LIBRARY_PATH=/home/AHA3x/zlib
```

The library can be run in three modes:

-   compression and decompression
-   compression only
-   decompression only

We have tested some [AHA](http://www.aha.com) compression/decompression accelerator cards:

-   AHA372 (C01) 20 GBIT/SEC GZIP BOARD
-   AHA378 (B01) 80 GBIT/SEC GZIP BOARD
-   AHA367-PCIe 10 GBIT/SEC GZIP BOARD

??? detail "Test results"

    The AHA367 was observed to be compatible with V2.7 2010.08.24 on Linux 2.6.32-22-generic SMP Intel i5 750 @ 2.67&nbsp;GHz 8&nbsp;GB RAM. Using sample NYSE quote data from 2010.08.05, 482 million rows, compression ratios and timings were observed as below.

    The uncompressed size of the data was 12GB, which compressed to 1.7&nbsp;GB, yielding a compression ratio 7:1 (the card currently has a fixed compression level). The time taken to compress the data was 65077 mS with the AHA card enabled versus 552506 mS using zlib compression in pure software. i.e. using the AHA card took 12% of the time to compress the same amount of data to the same level, achieving approximately a 10× speed-up, using just one channel only. For those wishing to execute file compression in parallel using the `peach` command, all four channels on the card can be used.

    With kdb+ using just a single channel of the card, the decompression performance of the card was slightly slower than as in software, although when q was used in a multi-threaded mode, increased overall performance was observed due to all 4 channels being used thereby freeing up the main CPU.

Installation is very straightforward: unpack and plug in the card, compile and load the driver, compile and install the Zlib shared library. As an indication, it took less than 30 minutes from opening the box to having kdb+ use it for compression. A very smooth installation.

??? tip "Runtime troubleshooting for the AHA 367 card"

    If you see the error message

    <pre><code class="language-txt">
    aha367 - ahagz\_api.c: open() call failed with error: 2 on device /dev/aha367\_board
    </code></pre>

    it likely means the kernel module has not been loaded. Remedy: go to the AHA install dir:

    <pre><code class="language-bash">
    aha_install_dir$ cd bin
    aha_install_dir$ sudo ./load_module
    </code></pre>

    and select the 367 card option.


### Kernel settings

Tweaking the kernel settings on Linux may help – it really depends on the size and number of compressed files you have open at any time, and the access patterns used. For example, random access to a compressed file will use many more kernel resources than sequential access.

:fontawesome-solid-graduation-cap:
[Linux production notes/Compression](linux-production.md#compression)


## Multithreading

!!! danger "Do not read or write a compressed file concurrently from multiple threads."

However, multiple files can be read or written from their own threads concurrently (one file per thread). For example, a [segmented](../database/segment.md) historical database with secondary threads will be using the decompression in a multithreaded mode.


## Requirements

Libraries for gzip and snappy may already be installed on your system.
Kdb+ binds dynamically to [zlib](http://zlib.net) and looks for certain files for snappy.

!!! detail "64-bit and 32-bit kdb+ require corresponding 64-bit and 32-bit libs"

If in doubt, consult your system administrator for assistance.

algorithm | source | :fontawesome-brands-linux: Linux | :fontawesome-brands-apple: macOS | :fontawesome-brands-windows: Windows
---|---|---|---|---
2 (gzip) | [zlib.net](http://zlib.net) | zlib | (pre-installed) | [winimage.com](http://www.winimage.com/zLibDll/index.html "winimage.com")
3 (snappy) | [GitHub](http://google.github.io/snappy/) | `libsnappy.so.1` | `libsnappy.dylib` | `snappy.dll`

:fontawesome-brands-apple:
To install snappy on macOS, use a package manager such as [Homebrew](https://brew.sh/) or [MacPorts](https://www.macports.org/):

```bash
> # install with MacPorts
> sudo port install snappy +universal
> export LD_LIBRARY_PATH=/opt/local/lib
```

??? danger "Certain releases of `lz4` do not function correctly within kdb+"

    Notably, `lz4-1.7.5` does not compress, and `lz4-1.8.0` appears to hang the process.

    Kdb+ requires at least `lz4-r129`.
    `lz4-1.8.3` works.
    We recommend using the latest `lz4` [release](https://github.com/lz4/lz4/releases) available.


## Running kdb+ under gdb

You should only ever need to run gdb (the GNU debugger) if you are debugging your own custom shared libs loaded into kdb+.

Gdb will intercept SIGSEGV which should be passed to q. To tell it to do so, issue the following command at the gdb prompt

```txt
(gdb) handle SIGSEGV nostop noprint
```


<!-- ## R Server for Q

R Server for Q loads R into q as a shared library.

R uses signal handling to detect stack overflows. This conflicts with kdb+’s use of signals for handling compressed files, causing kdb+ to crash.

R’s use of signals can be suppressed by setting the variable `R_SignalHandlers` (declared in Rinterface.h) to 0 when compiling the relevant R library.
 -->

-----
:fontawesome-solid-book:
[`set`](../ref/get.md#set)
<br>
:fontawesome-regular-map:
[Compression in kdb+](../wp/compress/index.md)
<br>
:fontawesome-solid-graduation-cap:
[Linux production notes: Huge Pages and Transparent Huge Pages](linux-production.md#huge-pages-and-transparent-huge-pages-thp)
