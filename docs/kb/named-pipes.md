---
title: Named pipes
description: How to read FIFOs/named pipes on Unix.
keywords: fifo, kdb+, named, pipe, q, unix
---
# Named pipes




Since V3.4 it has been possible to read FIFOs/named pipes on Unix.

```q
q)h:hopen`:fifo://file / Opens file as read-only. Note the fifo prefix
q)read1 h              / Performs a single blocking read into a 64k byte buffer. 
q)/ Returns empty byte vector on eof
q)read1 (h;n)          / Alternatively, specify the buffer size n. 
q)/ At most, n bytes will be read, perhaps fewer
q)hclose h             / Close the file to clean up
```

[`.Q.fps`](../ref/dotq.md#qfps-streaming-algorithm "streaming algorithm") is [`.Q.fs`](../ref/dotq.md#qfs-streaming-algorithm "streaming algorithm") for pipes. 
(`.Q.fpn` corresponds to [`.Q.fsn`](../ref/dotq.md#qfsn-streaming-algorithm "streaming algorithm").) 

The following example loads a CSV via FIFO, avoiding decompressing to disk:

```q
q)system"rm -f fifo && mkfifo fifo"
q)system"unzip -p t.zip t.csv > fifo &"
q)trade:flip `sym`time`ex`cond`size`price!"STCCFF"$\:()
q).Q.fps[{`trade insert ("STCCFF";",")0:x}]`:fifo
```

A `` `:fifo://`` handle is also useful for reading certain non-seekable or zero-length (therefore, unsuitable for the regular `read1`) system files or devices, e.g.

```q
q)a:hopen`:fifo:///dev/urandom
q)read1 (a;8)
0x8f172b7ea00b85e6
q)hclose a
```

