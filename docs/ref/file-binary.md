---
title: File Binary
description: File Binary is a q operator that reads or writes a binary file.
author: Stephen Taylor
keywords: binary, file, kdb+, q, read, write
---
# `1:` File Binary 

_Read or write a binary file_






## Read Binary

Syntax: `x 1: y`, `1:[x;y]`

Where 

-   `x` is a 2-item list of types (char vector) and widths (int vector), of which the order determines whether the data is parsed as little-endian or big-endian
-   `y` is a file descriptor or string, or byte sequence

returns the content of `y` as atom, list or matrix.

```q
q)(enlist 4;enlist"i")1:0x01000000 / big endian
16777216
q)(enlist"i";enlist 4)1:0x01000000 / little endian
1
q)(enlist"f";enlist 8)1:0x7fbdc282fb210940 / pi as little endian 64bit float
3.141593
```

Read two records containing an integer, a character and a short from a byte sequence. Note the integer is read with a 4-byte width, the character with 1 byte and the short with 2 bytes. (When reading byte sequences, recall that a byte is 2 hex digits.)

```q
q)("ich";4 1 2)1:0x00000000410000FF00000042FFFF
0 255
A B
0 -1

q)("ich";4 1 2)1:"arthur!"
1752461921
u
8562
```

With `offset` and `length`:

```q
/load 500000 records, 100000 at a time
q)d:raze{("ii";4 4)1:(`:/tmp/data;x;100000)}each 100000*til 5
```


## Save Binary

Syntax: `x 1: y`, `1:[x;y]`

writes bytes `y` to file `x`.

```q
`:hello 1: 0x68656c6c6f776f726c64
```


<i class="far fa-hand-point-right"></i>
[File Text](file-text.md)  
Basics: [File system](../basics/files.md)
