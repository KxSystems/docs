---
title: File Binary | Reference | kdb+ and q documentation
description: File Binary is a q operator that reads or writes a binary file.
author: Stephen Taylor
---
# :fontawesome-solid-database: `1:` File Binary

_Read and parse, or write bytes_



> There are 10 types of people: those who use binary arithmetic and those who don’t. 


## Read Binary

```syntax
x 1: y     1:[x;y]
```

Where 

-   `x` is a 2-item list (a string of [types](#column-types-and-widths) and an int vector of widths) of which the order determines whether the data is parsed as little-endian or big-endian
-   `y` is a [file descriptor](../basics/glossary.md#file-descriptor) or string, or byte sequence

returns the content of `y` as a matrix.

```q
q)(enlist 4;enlist"i")1:0x01000000                  / big endian
16777216
q)(enlist"i";enlist 4)1:0x01000000                  / little endian
1
q)show pi:(enlist"f";enlist 8)1:0x7fbdc282fb210940  / pi as little endian 64-bit float
3.141593
q).Q.s1 pi                                          / 1×1 matrix
",,3.141593"
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

Since 4.1t 2022.11.01,4.0 2022.12.02 quotes are no longer stripped from `y`

```q
q)("**";4 4)1:"abcd\"ef\""
"abcd"
"\"ef\""
```

### Column types and widths

```txt
b        boolean         1
g        guid            16
x        byte            1
h        short           2
i        int             4
j        long            8
e        real            4
f        float           8
c        char            1
s        symbol          n
p        timestamp       8
m        month           4
d        date            4
z        datetime        8
n        timespan        8
u        minute          4
v        second          4
t        time            4
(blank)  skip           
```

:fontawesome-solid-street-view:
_Q for Mortals_
[§11.5.1 Fixed-Width Records](/q4m3/11_IO/#1151-fixed-width-records)

### Multithreaded Load

Binary load can use multiple threads when kdb+ is running in [multithreaded mode](https://code.kx.com/q/basics/syscmds/#s-number-of-secondary-threads)

Since 4.1t 2021.09.28.


## Save Binary

```syntax
x 1: y     1:[x;y]
```

Where

-   `x` is a [`filesymbol`](../basics/glossary.md#file-symbol) or (since 4.1t 2023.04.17) a 4 item list ([`filesymbol`](../basics/glossary.md#file-symbol), logical block size, compression algorithm and compression level) to write compressed data
-   `y` is data to write

writes `bytes` to [`filesymbol`](../basics/glossary.md#file-symbol) and returns it. If `filesymbol`

-   does not exist, it is created, with any required directories
-   exists, it is overwritten

```q
q)`:hello 1: 0x68656c6c6f776f726c64
`:hello
```

### Compression

Since 4.1t 2023.04.17 data can be compressed while writing, by including [`compression parameters`](../kb/file-compression.md#compression-parameters)

```q
q)(`:file;17;2;9)1:100#0x0
`:file
```

----
:fontawesome-solid-book:
[`0:` File Text](file-text.md)
<br>
:fontawesome-solid-book-open:
[File system](../basics/files.md)
