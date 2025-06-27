---
title: sv – scalar from vector | Reference | kdb+ and q documentation
description: sv is a q keyword that performs a variety of functions under the general scheme of scalar (atom) from vector – join strings or filepath elements; decode a vector to an atom.
author: Stephen Taylor
---

# `sv`

_“Scalar from vector”_

-   _join strings, symbols, or filepath elements_
-   _decode a vector to an atom_


```syntax
x sv y    sv[x;y]
```


## Join


### Strings

Where

-   `y` is a list of strings
-   `x` is a char atom, string, or the empty symbol

returns as a string the strings in `y` joined by `x`.

Where `x` is the empty symbol `` ` ``, the strings are separated by the host line separator: `\n` on Unix, `\r\n` on Windows.

```q
q)"," sv ("one";"two";"three")    / comma-separated
"one,two,three"
q)"\t" sv ("one";"two";"three")   / tab-separated
"one\ttwo\tthree"
q)", " sv ("one";"two";"three")   / x may be a string
"one, two, three"
q)"." sv string 192 168 1 23      / form IP address
"192.168.1.23"
q)` sv ("one";"two";"three")      / use host line separator
"one\ntwo\nthree\n"
```


### Symbols

Where

-   `x` is the empty symbol `` ` ``
-   `y` is a symbol list

returns a symbol atom in which the items of `y` are joined by periods, i.e. 

```q
q)` sv `quick`brown`fox
`quick.brown.fox
q)`$"."sv string `quick`brown`fox
`quick.brown.fox
```


### Bytes

Since 4.1t 2024.01.11, `y` can be a list of byte vectors, which can be joined by byte(s) `x`.

```q
q)0x03 sv 0x02 vs 0x0102010201
0x0103010301
q)0x0203 sv 0x0203 vs "x"$til 6
0x0001020304
q)0x02 sv (enlist 0x01;enlist 0x01;enlist 0x01)
0x0102010201
```


### Filepath components

Where

-   `x` is the empty symbol `` ` ``
-   `y` is a symbol list of which the first item is a file handle

returns a file handle where the items of the list are joined, separated by slashes. (This is useful when building file paths.)

```q
q)` sv `:/home/kdb/q`data`2010.03.22`trade
`:/home/kdb/q/data/2010.03.22/trade
```

If the first item is not a file handle, returns a symbol where the items are joined, separated by `.` (dot). This is useful for building filenames with a given extension:

```q
q)` sv `mywork`dat
`mywork.dat
```


:fontawesome-solid-book:
[`vs`](vs.md#partition) partition


## Decode


### Base to integer

Where `x` and `y` are **numeric** atoms or lists, `y` is evaluated to base `x`.

```q
q)10 sv 2 3 5 7
2357
q)100 sv 2010 3 17
20100317
q)0 24 60 60 sv 2 3 5 7   / 2 days, 3 hours, 5 minutes, 7 seconds
183907
```

When `x` is a list, the first number is not used. The calculation is done as:

```q
q)baseval:{y wsum reverse prds 1,reverse 1_x}
q)baseval[0 24 60 60;2 3 5 7]
183907f
```


### Bytes to integer

Where

-   `x` is `0x0`
-   `y` is a vector of bytes of length 2, 4 or 8

returns `y` converted to the corresponding integer.

```q
q)0x0 sv "x" $0 255           / short
255h
q)0x0 sv "x" $128 255
-32513h
q)0x0 sv "x" $0 64 128 255    / int
4227327
q)0x0 sv "x" $til 8           / long
283686952306183
q)256 sv til 8                / same calculation
283686952306183
```

!!! tip "Converting non-integers"

    Use [File Binary](file-binary.md) – e.g.:

    ```q
    q)show a:0x0 vs 3.1415
    0x400921cac083126f
    q)(enlist 8;enlist "f")1: a   /float
    3.1415
    ```


### Bits to integer

Where

-   `x` is `0b`
-   `y` is a boolean vector of length 8, 16, 32, or 64

returns `y` converted to the corresponding integer or (in the case of 8 bits) a byte value.

```q
q)0b sv 64#1b
-1
q)0b sv 32#1b
-1i
q)0b sv 16#1b
-1h
q)0b sv 8#1b
0xff
```

Since 4.1t 2021.09.03, `y` also supports guids.

```q
q)0b sv 10001100011010111000101101100100011010000001010101100000100001000000101000111110000101111000010000000001001001010001101101101000b
8c6b8b64-6815-6084-0a3e-178401251b68
```

:fontawesome-solid-book:
[`vs`](vs.md#encode) encode
<br>
:fontawesome-solid-book:
[`.Q.j10`](dotq.md#j10-encode-binhex) (encode binhex), 
[`.Q.x10`](dotq.md#x10-decode-binhex) (decode binhex)
<br>
:fontawesome-solid-book:
[`.Q.j12`](dotq.md#j12-encode-base-36) (encode base36), 
[`.Q.x12`](dotq.md#x12-decode-base-36) (decode base36)

