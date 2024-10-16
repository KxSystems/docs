---
title: Named pipes – Knowledge Base – kdb+ and q documentation
description: How to read FIFOs/named pipes on Unix.
keywords: fifo, kdb+, named, pipe, q, unix
---
# Named pipes

## Overview

Since V3.4 it has been possible to read FIFOs/named pipes on Unix.

```q
q)h:hopen`:fifo://file / Opens file as read-only. Note the fifo prefix
q)read1 h              / Performs a single blocking read into a 64k byte buffer. 
q)/ Returns empty byte vector on eof
q)read1 (h;n)          / Alternatively, specify the buffer size n. 
q)/ At most, n bytes will be read, perhaps fewer
q)hclose h             / Close the file to clean up
```

A `` `:fifo://`` handle is also useful for reading certain non-seekable or zero-length (therefore, unsuitable for the regular `read1`) system files or devices, e.g.

```q
q)a:hopen`:fifo:///dev/urandom
q)read1 (a;8)
0x8f172b7ea00b85e6
q)hclose a
```

## Streaming

[`.Q.fps`](../ref/dotq.md#fps-pipe-streaming) and [`.Q.fpn`](../ref/dotq.md#fpn-pipe-streaming) provide the ability to streaming data from a fifo/named pipe.

This can be useful for various applications, such as streaming data in from a compressed file without having to decompress the contents to disk.

For example, using a csv file (t.csv) with the contents
```csv
MSFT,12:01:10.000,A,O,300,55.60
APPL,12:01:20.000,B,O,500,67.70
IBM,12:01:20.100,A,O,100,61.11
MSFT,12:01:10.100,A,O,300,55.60
APPL,12:01:20.100,B,O,500,67.70
IBM,12:01:20.200,A,O,100,61.11
MSFT,12:01:10.200,A,O,300,55.60
APPL,12:01:20.200,B,O,500,67.70
IBM,12:01:20.200,A,O,100,61.11
MSFT,12:01:10.300,A,O,300,55.60
APPL,12:01:20.400,B,O,500,67.70
IBM,12:01:20.500,A,O,100,61.11
MSFT,12:01:10.500,A,O,300,55.60
APPL,12:01:20.600,B,O,500,67.70
IBM,12:01:20.600,A,O,100,61.11
MSFT,12:01:10.700,A,O,300,55.60
APPL,12:01:20.700,B,O,500,67.70
IBM,12:01:20.800,A,O,100,61.11
MSFT,12:01:10.900,A,O,300,55.60
APPL,12:01:20.900,B,O,500,67.70
IBM,12:01:20.990,A,O,100,61.11
```

If the file is compressed into a ZIP archive (t.zip), the system command `unzip` has the option to uncompress to stdout, which can be combined with a `fifo`.
The following loads the CSV file via a FIFO without having the intermediary step of creating the unzipped file:

```q
q)system"rm -f fifo && mkfifo fifo"
q)trade:flip `sym`time`ex`cond`size`price!"STCCFF"$\:()
q)system"unzip -p t.zip > fifo &"
q).Q.fps[{`trade insert ("STCCFF";",")0:x}]`:fifo
q)trade
```

Alternatively, if the file was compressed using gzip (t.gz), the system command `gunzip` can be used:

```q
q)system"rm -f fifo && mkfifo fifo"
q)trade:flip `sym`time`ex`cond`size`price!"STCCFF"$\:()
q)system"gunzip -cf t.gz > fifo &"
q).Q.fps[{`trade insert ("STCCFF";",")0:x}]`:fifo
q)trade
```

:fontawesome-regular-hand-point-right:
[`0:`](../ref/file-text.md#load-csv) (load csv)<br>
:fontawesome-solid-book-open:
[mkfifo](https://linux.die.net/man/1/mkfifo),
[unzip](https://linux.die.net/man/1/unzip), [gunzip](https://linux.die.net/man/1/unzip)
