---
title: File compression
description: How to work with compressed files in kdb+.
keywords: compress, decompress, file, kdb+, log, q, streaming
---
# File compression



Q has had built-in optional file compression since V2.7.


## How do I compress a file?

Use the [`-19!` internal function](../basics/internal.md#-19x-compress-file).


!!! warning "Nested data"

    As of V2.8 2011.10.06, do not try to compress the associated _name#_ or _name##_ files for nested data explicitly, as they will be compressed as part of compressing the root name file; e.g.

    <pre><code class="language-q">
    q)`:a set 1000#enlist asc 1000?10;-19!(`:a;`:za;17;2;9);0N!get[`:a]~get`:za;
    </code></pre>


## How do I save directly to a compressed file?

Since V2.8 2011.11.21, kdb+ supports streaming file compression, i.e. the data is compressed as it is written to disk.

This is achieved through the overriding of [`set`](../ref/get.md#set), in that the left argument of `set` can be a list describing the file or splay target, with the compression parameters. For example

```q
(`:ztest;17;2;6) set asc 10000?`3 
(`:zsplay/;17;2;6) set .Q.en[`:.;([]sym:asc 10000?`3;time:.z.p+til 10000;price:10000?1000.;size:10000?100)]
```

Kdb+ compressed files/splays can also be appended to.

```q
q)(`:zippedTest;17;2;6) set 100000?10;`:zippedTest upsert 100000?10;-21!`:zippedTest
```

Appending to files with an attribute (e.g. `` `p#`` on sym) causes the whole file to be read and rewritten. Currently, unless [`.z.zd`](../ref/dotz.md#zzd-zip-defaults) is set accordingly, this would be rewritten in a non-compressed format regardless of its original format.

'compress new files' mode is active if `.z.zd` (zip defaults) is present and valid. `.z.zd` can be set to an int vector of (blockSize;algo;zipLevel) to apply to all new files which do not have a file extension.

```q
q).z.zd:(17;2;6);`:zfile set asc 10000?`3 
```

[`-19!x`](../basics/internal.md#-19x-compress-file) and ``(`:file;size;algo;level) set x`` take precedence over `.z.zd`.

To reset to not compress new files, use `\x`.

```q
q)\x .z.zd
```

Since V2.8 2011.11.28, the zip params can be a dictionary of `filenames!zipParams`. The null `` ` `` entry in the dict is the default `zipParams`, or if no `` ` `` specified, then default will be: do not compress.

```q
q)(`:splay/;``a`b!((17;2;9);(17;2;6);(17;2;6)))set([]a:asc 1000000?10;b:asc 1000000?10;c:asc 1000000?10)
```

!!! warning "Log files and streaming compression"

    Do not use streaming compression with log files. In the event of a crash, the log file will be unusable as it will be missing meta information from the end of the file. Streaming compression maintains the last block in memory and compresses/purges it as needed or latest on close of file handle.


## How do I decompress a file?

Just read the file, e.g.

```q
get`:compressedFile
```

If you want to store it again decompressed, then use

```q
`:uncompressedFile set get `:compressedFile
```


## Do I need additional libraries to use algorithm \#2 (gzip)?

Yes, but they may already be installed on your system. It binds dynamically to 
[zlib](http://zlib.net).

For Windows, q is compatible with the pre-built zlib DLLs from [winimage.com/zLibDll](http://www.winimage.com/zLibDll/index.html)

For Linux and Solaris you may find it convenient to install zlib using your package manager, or consult your system administrator for assistance. 

!!! note "Like for like"

    You will require the matching 32- or 64-bit libs: i.e. 32-bit libs for 32-bit q; 64-bit libs for 64-bit q.


## Do I need additional libraries to use algorithm \#3 (snappy)?

Yes, but they may already be installed on your system, and can be utilized in V3.4 onwards. It binds dynamically to [snappy](http://google.github.io/snappy). Kdb+ will look for the following files on the respective OSs: 

-   Windows: snappy.dll
-   macOS: libsnappy.dylib
-   other: libsnappy.so.1. 
 
Consult your system administrator for assistance. 

!!! note "Like for like"

    You will require the matching 32- or 64-bit libs: i.e. 32-bit libs for 32-bit q; 64-bit libs for 64-bit q.

To install snappy on macOS, the simplest method is to use Macports:

```bash
$sudo port install snappy +universal
$export LD_LIBRARY_PATH=/opt/local/lib
```


## When compressing data, if the source file and the target file are on the same drive, it might run slowly. Why?

The compression routine is reading from the source file, compressing the data and writing to the target file. The disk is likely being given many seek requests. If you move the target file to a different physical disk, you will reduce the number of seeks needed.


## How can I tell if a file is compressed?

The [`21!` internal function](../basics/internal.md#-21x-compression-stats) returns a dictionary of compression statistics, or an empty dictionary if the file is not compressed. 

```q
q)-21!`:ztest       / compressed
compressedLength  | 137349
uncompressedLength| 80000016
algorithm         | 2i
logicalBlockSize  | 17i
zipLevel          | 6i
q)-21!`:test        / not compressed
q)count -21!`:test
0
```


## Does the compression format support random access to the data?

Yes.


## Does the compression require column data to be compressed using `-19!`, or will running gzip on column data also work?

Yes, you have to use the [`-19!` internal function](../basics/internal.md#-19x-compress-file), because the file format is different from gzip.


## Is it possible to compress selected partitions, or even selected columns for a table within a partition? 

For instance, for a database partitioned by date?

Yes, you can choose which files to compress, and which algorithm/level to use per file; the same kdb+ process can read compressed and uncompressed files. So for files that don’t compress well, or have an access pattern that does not perform well with compression, you could leave those uncompressed.


## How fast is the decompression?

A single thread with full use of a core can decompress approx 300MB/s, depending on data/algorithm and level.


## Is there a performance impact?

People are often concerned about the CPU overhead associated with compression, but the actual cost is difficult to calculate. On the one hand, compression does trade CPU utilization for disk-space savings. And up to a point, if you’re willing to trade more CPU time, you can save more space. But by reducing the space used, you end up doing less disk I/O, which can improve overall performance if your workload is bandwidth-limited. 

The only way to know the real impact of compression on your disk utilization and system performance is to run your workload with different levels of compression and observe the results.


## When is decompression done and how long is decompressed data cached?

Files are mapped or unmapped on demand during a query. Only the areas of the file that are touched are decompressed, i.e. q uses random access. Decompressed data is cached while a file is mapped. Since V2.7 2011.04.30 columns are mapped for the duration of the select.


## Say you’re querying by date and sum over a date partitioned table, with each partition parted by sym – will the query just decompress parts of the column data for the syms in the query predicate?

Yes.


## Can I append to a compressed file?

Yes, since V2.8 2011.11.21. Appending to compressed enum files was blocked in V3.0 2012.05.17 due to potential concurrency issues, hence these files should not be compressed.


## Which is better, ZFS compression or built-in q compression?

Currently, ZFS compression probably has an edge due to keeping more decompressed data in cache, which is available to all processes.


## Is the compression or decompression multithreaded?

The reading or writing of a compressed file must _not_ be performed concurrently from multiple threads. However, multiple files can be read or written from their own threads concurrently (one file per thread). For example, a [`par.txt`]](partition.md)’d historical database with slave threads will be using the decompression in a multithreaded mode.


## What’s the difference among different logicalBlockSize (pageSize to 1MB) and compressionLevel (1 to 9 for gzip)? What’s a standard recommendation?

The `logicalBlockSize` represents how much data is taken as a compression unit, and consequently the minimum size of a block to decompress. E.g. using a `logicalBlockSize` of 128kB, a file of size 128000kB would be cut into 100 blocks, and each block compressed independently of the others. Later, if a single byte is requested from that compressed file, a minimum of 128kB would be decompressed to access that byte. Fortunately those types of access patterns are rare, and typically you would be extracting clumps of data that make a logical block size of 128kB quite reasonable. Ultimately, you should experiment with what suits your data, hardware and access patterns best. A good balance for taq data and typical taq queries is to use algorithm 1 (the same algorithm as used for IPC compression) with 128kB `logicalBlockSize`. For those who can accept slower performance but better compression, they can choose gzip with compression level 6.


## ``hcount`:compressedFile`` returns the uncompressed file length. Is this intentional?

Yes. In our defense, ZFS has similar issues. 

<i class="far fa-hand-point-right"></i> 
[blog.buttermountain.co.uk](http://blog.buttermountain.co.uk/2008/05/10/zfs-compression-when-du-and-ls-appear-to-disagree)

Compressed file size can be obtained from the [`-21!` internal function](../basics/internal.md#-21x-compression-stats). 


## Is there a limit on the number of compressed files that can be open simultaneously?

For releases prior to V3.1 2013.02.21 the limit is 4096 files; releases since then are limited by the environment/OS only (e.g. `ulimit -n`). There is no practical internal limit on the number of uncompressed files.

!!! note

    If using compressed files, please note V3.2 onwards uses two file descriptors per file, so you may need to increase the `ulimit` that was used in prior versions.


## Does q file compression use more memory than working with non-compressed files?

Because of the nature of working with vectors, kdb+ allocates enough space to decompress the whole vector, regardless of how much it finally uses. This reservation of memory is required as there is no backing store for the decompressed data, unlike with mapped files of uncompressed data which can always read the pages from file again should they have been dropped. 

However, this is reservation of memory only, and can be accommodated by increasing the swap space available: even though the swap should never actually be written to, the OS has to be assured that in the worst-case scenario of decompressing the data in full, it could swap it out if needed. 

If you experience wsfull even when sufficient swap space is configured, check whether you have any soft/hard limits imposed with `ulimit -v`. 

!!! warning "Memory overcommit settings on Linux"

    `/proc/sys/vm/overcommit\_memory` and `/proc/sys/vm/overcommit\_ratio` – these control how careful Linux is when allocating address space with respect to available physical memory plus swap.


## What compression ratios should I expect?

Using real NYSE trade data, we observed the `gzip` algorithm at level 9 compressing to 15% of original size, and the IPC compression algorithm compressing to 33% of original size.


## Do you have any benchmarking tips?

Perform your benchmarks on the same hardware setup as you would use for production and be aware of the disk cache – flush the cache before each test. The disk cache can be flushed on Linux using

```bash
sync ; sudo echo 3 | sudo tee /proc/sys/vm/drop_caches
```
and on macOS, the OS command `purge` can be used.


## Can I use a hardware accelerator card to improve compression performance?

Yes. (Since V2.7.) 
If the card uses Zlib, then kdb+ should be able to use it. You will need to export the Zlib driver provided by AHA, e.g.

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

!!! detail "Test results"

    The AHA367 was observed to be compatible with V2.7 2010.08.24 on Linux 2.6.32-22-generic SMP Intel i5 750 @ 2.67&nbsp;GHz 8&nbsp;GB RAM. Using sample NYSE quote data from 2010.08.05, 482 million rows, compression ratios and timings were observed as below.

    The uncompressed size of the data was 12GB, which compressed to 1.7&nbsp;GB, yielding a compression ratio 7:1 (the card currently has a fixed compression level). The time taken to compress the data was 65077 mS with the AHA card enabled versus 552506 mS using zlib compression in pure software. i.e. using the AHA card took 12% of the time to compress the same amount of data to the same level, achieving approximately a 10× speed-up, using just one channel only. For those wishing to execute file compression in parallel using the `peach` command, all four channels on the card can be used.

    With kdb+ using just a single channel of the card, the decompression performance of the card was slightly slower than as in software, although when q was used in a multi-threaded mode, increased overall performance was observed due to all 4 channels being used thereby freeing up the main CPU.

Installation is very straightforward: unpack and plug in the card, compile and load the driver, compile and install the Zlib shared library. As an indication, it took less than 30 minutes from opening the box to having kdb+ use it for compression. A very smooth installation.

!!! tip "Runtime troubleshooting for the AHA 367 card"

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


## Do I need to tweak the kernel settings in order to work with compressed files?

On Linux, perhaps – it really depends on the size and number of compressed files you have open at any time, and the access patterns used. For example, random access to a compressed file will use many more kernel resources than sequential access. 

<i class="far fa-hand-point-right"></i> 
[Linux production notes/Compression](linux-production.md#compression)


## Can I run kdb+ under gdb (the GNU debugger), and use compressed files?

You should only ever need to run `gdb` if you are debugging your own custom shared libs loaded into kdb+.

`gdb` will intercept SIGSEGV which should be passed to q. To tell it to do so, issue the following command at the gdb prompt

```txt
(gdb) handle SIGSEGV nostop noprint
```


## I use q with R Server for Q, i.e. R as shared library loaded into q. Does this work with compressed files?

R uses signal handling to detect stack overflows. This conflicts with kdb+’s use of signals for handling compressed files, causing kdb+ to crash. R’s use of signals can be suppressed by setting the variable `R_SignalHandlers` (declared in Rinterface.h) to 0 when compiling the relevant R library.


## I’d like to use Transparent Huge Pages (THP) on Linux. Is this compatible with the kdb+ file compression?

No. We have had reports of systems stalling due to THP fragmentation. Disable THP either with the shell command

```bash
$ echo never >/sys/kernel/mm/redhat_transparent_hugepage/enabled
```

or more permanently via `grub` at boot time

```txt
transparent_hugepage=never
```

Kdb+ must be restarted to pick up the new setting. 

<i class="far fa-hand-point-right"></i> 
Linux production notes [Huge Pages and Transparent Huge Pages](linux-production.md#huge-pages-and-transparent-huge-pages-thp)
