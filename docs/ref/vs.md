---
title: vs – Reference – kdb+ and q documentation
description: vs is a q keyword that performs variousn functions under the scheme vector-from-scalar (atom).
author: Stephen Taylor
keywords: atom, decode, kdb+, keyword, q, scalar, vector, vs
---
[![Swiss army knife](../img/swiss-army-knife.jpg)](https://www.victorinox.com/ "victorinox.com")
{: style="float: right; max-width: 200px"}


# `vs`




_“Vector from scalar”_

-   _partition a list_
-   _encode a vector from an atom_

```txt
x vs y    vs[x;y]
```


## Partition


### String by char

Where `x` is a char atom or string, and `y` is a string, returns a list of strings: `y` cut using `x` as the delimiter.

```q
q)"," vs "one,two,three"
"one"
"two"
"three"
q)", " vs "spring, summer, autumn, winter"
"spring"
"summer"
"autumn"
"winter"
q)"|" vs "red|green||blue"
"red"
"green"
""
"blue"
```


### String by linebreak

Where `x` is the empty symbol `` ` ``, and `y` is a string, returns as a list of strings `y` partitioned on embedded line terminators into lines. (Recognizes both Unix `\n` and Windows `\r\n` terminators).

```q
q)` vs "abc\ndef\nghi"
"abc"
"def"
"ghi"
q)` vs "abc\r\ndef\r\nghi"
"abc"
"def"
"ghi"
```


### Symbol by dot

Where `x` is the null symbol `` ` ``, and `y` is a symbol, returns as a symbol vector `y` split on `` `.` ``.

```q
q)` vs `mywork.dat
`mywork`dat
```


### File handle

Where `x` is the empty symbol `` ` ``, and `y` is a file handle, returns as a symbol vector `y` split into directory and  file parts.

```q
q)` vs `:/home/kdb/data/mywork.dat
`:/home/kdb/data`mywork.dat
```

:fontawesome-solid-book:
[sv](sv.md#join) join


## Encode


### Bit representation

Where `x` is `0b` and `y` is an integer, returns the bit representation of `y`.

```q
q)0b vs 23173h
0101101010000101b
q)0b vs 23173
00000000000000000101101010000101b
```


### Byte representation

Where `x` is `0x0` and `y` is a number, returns the internal representation of `y`, with each byte in hex.

```q
q)0x0 vs 2413h
0x096d
q)0x0 vs 2413
0x0000096d
q)0x0 vs 2413e
0x4516d000
q)0x0 vs 2413f
0x40a2da0000000000
q)"."sv string"h"$0x0 vs .z.a / ip address string from .z.a
"192.168.1.213"
```


### Base-x representation

Where `x` and `y` are integer, the result is the representation of `y` in base `x`. (Since V3.4t 2015.12.13.)

```q
q)10 vs 1995
1 9 9 5
q)2 vs 9
1 0 0 1
q)24 60 60 vs 3805
1 3 25
q)"." sv string 256 vs .z.a / ip address string from .z.a
"192.168.1.213"
```

Where `y` is an integer vector the result is a matrix with `count[x]` items whose `i`-th column `(x vs y)[;i]` is identical to `x vs y[i]`.
More generally, `y` can be any list of integers, and each item of the result is identical to `y` in structure.

```q
q)a:10 vs 1995 1996 1997
q)a
1 1 1
9 9 9
9 9 9
5 6 7
q)a[;0]
1 9 9 5
q)10 vs(1995;1996 1997)
1 1 1
9 9 9
9 9 9
5 6 7
```


:fontawesome-solid-book:
[`sv`](sv.md#decode) decode
<br>
:fontawesome-solid-book:
[`.Q.j10`](dotq.md#qj10-encode-binhex) encode binhex, 
[`.Q.j12`](dotq.md#qj12-encode-base64) encode base64
<br>
:fontawesome-solid-book:
[`.Q.x10`](dotq.md#qx10-decode-binhex) decode binhex,
[`.Q.x12`](dotq.md#qx12-decode-base64) decode base64


