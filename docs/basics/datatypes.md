---
title: Data types | Basics | kdb+ and q documentation
description: Every kdb+ object has a data type. This page tabulates the datatypes.
author: Stephen Taylor
keywords: atom, boolean, character, datatype, date, datetime, double, float, integer, kdb+, list, long, q, scalar, short, string, symbol, temporal, time, timespan, timestamp, type, vector
---
# Datatypes


<div markdown="1" class="typewriter">
**Basic datatypes**
n   c   name      sz  literal            null inf SQL       Java      .Net
\------------------------------------------------------------------------------------
0   *   list
1   b   boolean   1   0b                                    Boolean   boolean
2   g   guid      16                     0Ng                UUID      GUID
4   x   byte      1   0x00                                  Byte      byte
5   h   short     2   0h                 0Nh  0Wh smallint  Short     int16
6   i   int       4   0i                 0Ni  0Wi int       Integer   int32
7   j   long      8   0j                 0Nj  0Wj bigint    Long      int64
                      0                  0N   0W
8   e   real      4   0e                 0Ne  0We real      Float     single
9   f   float     8   0.0                0n   0w  float     Double    double
                      0f                 0Nf
10  c   char      1   " "                " "                Character char
11  s   symbol        \`                  \`        varchar
12  p   timestamp 8   dateDtimespan      0Np  0Wp           Timestamp DateTime (RW)
13  m   month     4   2000.01m           0Nm
14  d   date      4   2000.01.01         0Nd  0Wd date      Date
15  z   datetime  8   dateTtime          0Nz  0wz timestamp Timestamp DateTime (RO)
16  n   timespan  8   00:00:00.000000000 0Nn  0Wn           Timespan  TimeSpan
17  u   minute    4   00:00              0Nu  0Wu
18  v   second    4   00:00:00           0Nv  0Wv
19  t   time      4   00:00:00.000       0Nt  0Wt time      Time      TimeSpan

Columns:
_n_    short int returned by [`type`](../ref/type.md) and used for [Cast](../ref/cast.md), e.g. `9h$3`
_c_    character used lower-case for [Cast](../ref/cast.md) and upper-case for [Tok](../ref/tok.md) and [Load CSV](../ref/file-text.md#load-csv)
_sz_   size in bytes
_inf_  infinity (no math on temporal types); `0Wh` is `32767h`

RO: read only; RW: read-write

**Other datatypes**
20-76   enums
77      anymap                                      104  [projection](application.md#projection)
78-96   77+t – mapped list of lists of type t       105  [composition](../ref/compose.md)
97      nested sym enum                             106  [f'](../ref/maps.md#each)
98      table                                       107  [f/](../ref/accumulators.md)
99      dictionary                                  108  [f\\](../ref/accumulators.md)
100     [lambda](function-notation.md)                                      109  [f':](../ref/maps.md)
101     unary primitive                             110  [f/:](../ref/maps.md#each-left-and-each-right)
102     operator                                    111  [f\\:](../ref/maps.md#each-left-and-each-right)
103     [iterator](../ref/iterators.md)                                    112  [dynamic load](../ref/dynamic-load.md)
</div>

Above, `f` is an [applicable value](glossary.md#applicable-value).

Nested types are 77+t (e.g. 78 is boolean. 96 is time.)

The type is a short int: 

-    zero for a general list
-    negative for atoms of basic datatypes
-    positive for everything else


:fontawesome-solid-book:
[Cast](../ref/cast.md),
[Tok](../ref/tok.md),
[`type`](../ref/type.md),
[`.Q.ty`](../ref/dotq.md#qty-type) (type)
<br>
:fontawesome-solid-book-open:
:fontawesome-solid-graduation-cap:
[Temporal data](../kb/temporal-data.md),
[Timezones](../kb/timezones.md)


## Basic types

??? note "The default type for an integer is long (`7h` or `"j"`)."

    Before V3.0 it was int (`6h` or `"i"`).


### Strings

There is no string datatype. On this site, _string_ is a synonym for character vector (type `10h`). In q, the nearest equivalent to an atomic string is the symbol.

Strings can include multibyte characters, which each occupy the respective number of bytes. For example, assuming that the input encoding is UTF-8:

```q
q){(x;count x)}"Zürich"
"Z\303\274rich"
7
q){(x;count x)}"日本"
"\346\227\245\346\234\254"
6
```

Other encodings may give different results.

```q
q)\chcp
"Active code page: 850"
q)"Zürich"
"Z\201rich"

q)\chcp 1250
"Active code page: 1250"
q)"Zürich"
"Z\374rich"
```

:fontawesome-solid-graduation-cap:
[Unicode](../kb/unicode.md)


### Temporal

The valid date range is `0001.01.01` to `9999.12.31`. (Since V3.6 2017.10.23.)

!!! warning "The 4-byte datetime datatype (15) is deprecated in favour of the 8-byte timestamp datatype (12)."

```q
q)"D"$"3001.01.01"
3001.01.01
```

Internally, dates, times and timestamps are represented by integers:
```q
q)show noon:`minutes`seconds`nanoseconds!(12:00;12:00:00;12:00:00.000000000)
minutes    | 12:00
seconds    | 12:00:00
nanoseconds| 0D12:00:00.000000000
q)"j"$noon
minutes    | 720
seconds    | 43200
nanoseconds| 43200000000000
```

Date calculations assume the [proleptic Gregorian calendar](https://en.wikipedia.org/wiki/Proleptic_Gregorian_calendar "Wikipedia").

Casting to timestamp from date or datetime outside of the timestamp supported year range results in ±`0Wp`.
Out-of-range dates and datetimes display as `0000.00.00` and `0000.00.00T00:00:00:.000`.
```q
q)`timestamp$1666.09.02
-0Wp
q)0001.01.01-1
0000.00.00
q)"z"$0001.01.01-1 
0000.00.00T00:00:00.000
```

Valid ranges can be seen by incrementing or decrementing the infinities.

```q
q)-0W 0Wp+1 -1      / limit of timestamp type
1707.09.22D00:12:43.145224194 2292.04.10D23:47:16.854775806

q)0p+ -0W 0Wp+1 -1  / timespan offset of those from 0p
-106751D23:47:16.854775806 106751D23:47:16.854775806

q)-0W 0Wn+1 -1      / coincide with the min/max for timespan
```




### Symbols

A back tick `` ` `` followed by a series of characters represents a _symbol_, which is not the same as a string.

```q
q)`symbol ~ "symbol"
0b
```

A back tick without characters after it represents the _empty symbol_: `` ` ``.

!!! tip "Cast string to symbol"

    The empty symbol can be used with [Cast](../ref/cast.md) to cast a string into a symbol, creating symbols whose names could not otherwise be written, such as symbols containing spaces. `` `$x`` is shorthand for `"S"$x`.

    ```q
    'world
    q)s:`$"hello world"
    q)s
    `hello world
    ```

:fontawesome-solid-street-view:
_Q for Mortals_: [§2.4 Basic Data Types – Atoms](/q4m3/2_Basic_Data_Types_Atoms/#24-text-data)


### Filepaths

Filepaths are a special form of symbol.

```q
q)count read0 `:path/to/myfile.txt  / count lines in myfile.txt
```


### Infinities

Note that arithmetic for integer infinities (`0Wh`,`0Wi`,`0Wj`) is undefined, and does not retain the concept when cast.

```q
q)0Wi+5
2147483652
q)0Wi+5i
-2147483644i
q)`float$0Wj
9.223372e+18
q)`float$0Wi
2.147484e+09
```

Arithmetic for float infinities (`0we`,`0w`) behaves as expected.

```q
q)0we + 5
0we
q)0w + 5
0w
```

:fontawesome-solid-book:
[`.Q.M`](../ref/dotq.md#qm-long-infinity) (long infinity)

??? detail "To infinity and beyond"

    [![Buzz Lightyear](../img/faces/buzzlightyear.jpg)](https://toystory.disney.com/buzz-lightyear)
    {: .small-face style="margin-top:1em"}

    Floating-point arithmetic follows [IEEE754](https://en.wikipedia.org/wiki/IEEE_754 "Wikipedia").

    Integer arithmetic does no checks for infinities, just treats them as a signed integer.

        q)vs[0b]@/:0N!0W+til 3
        0W 0N -0W
        0111111111111111111111111111111111111111111111111111111111111111b
        1000000000000000000000000000000000000000000000000000000000000000b
        1000000000000000000000000000000000000000000000000000000000000001b

    but it does check for nulls.

        q)10+0W+til 3
        -9223372036854775799 0N -9223372036854775797

    This can be **abused** to push infinities on nulls which then become sticky and can be filtered out altogether, e.g.

        q)1+-1+-1+1+ -0W 0N 0W 1 2 3
        0N 0N 0N 1 2 3

    There is no display for short infinity.

        q)0Wh
        32767h
        q)-0Wh
        -32767h

    Integer promotion is documented for [Add](../../ref/add/#range-and-domains).

    Integer infinities 

    -   do not promote, other than the signed bit; there is no special treatment over any other int value
    -   map to int_min+1 and int_max, with `0N` as int_min; so there is no number smaller than `0N`

    **Best practice is to view infinities as placeholders only, and not perform arithmetic on them.**

    [![Infinity and beyond](../img/infinity-and-beyond.jpg)](https://toystory.disney.com/buzz-lightyear "Disney’s Toy Story")


### Guid

The guid type (since V3.0) is a 16-byte type, and can be used for storing arbitrary 16-byte values, typically transaction IDs.

!!! tip "Generation"

    Use [Deal](../ref/deal.md) to generate a guid (global unique: uses `.z.a .z.i .z.p`).

    ```q
    q)-2?0Ng
    337714f8-3d76-f283-cdc1-33ca89be59e9 0a369037-75d3-b24d-6721-5a1d44d4bed5
    ```

    If necessary, manipulate the bytes to make the uuid a [Version-4 'standard' uuid](https://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_.28random.29).

    Guids can also be created from strings or byte vectors, using `sv` or `"G"$`, e.g.
    
    ```q
    q)0x0 sv 16?0xff
    8c680a01-5a49-5aab-5a65-d4bfddb6a661
    q)"G"$"8c680a01-5a49-5aab-5a65-d4bfddb6a661"
    8c680a01-5a49-5aab-5a65-d4bfddb6a661
    ```

`0Ng` is null guid.

```q
q)0Ng
00000000-0000-0000-0000-000000000000
q)null 0Ng
1b
```

There is no literal entry for a guid, it has no conversions, and the only scalar primitives are `=`, `<` and `>` (similar to sym). In general, since V3.0, there should be no need for char vectors for IDs. IDs should be int, sym or guid. Guids are faster (much faster for `=`) than the 16-byte char vecs and take 2.5 times less storage (16 per instead of 40 per).


## Other types


### Enumerated types

Enumerated types are numbered from `20h` up to `76h`. For example, in a new session with no enumerations defined:

```q
q)type `sym$10?sym:`AAPL`AIG`GOOG`IBM
20h
q)type `city$10?city:`london`paris`rome
20h
```

(Since V3.0, type `20h` is reserved for `` `xxx$`` where `xxx` is the name of a variable.)

:fontawesome-solid-book:
[Enumerate](../ref/enumerate.md),
[Enumeration](../ref/enumeration.md),
[Enum Extend](../ref/enum-extend.md)<br>
:fontawesome-solid-book-open:
[Enumerations](enumerations.md)


### Nested types

These types are used for mapped lists of lists of the same type. The numbering is 77 + primitive type (e.g. 77 is [anymap](../releases/ChangesIn3.6.md#anymap), 78 is boolean, 96 is time and 97 is `` `sym$`` enumeration.)

```q
q)`:t1.dat set 2 3#til 6
`:t1.dat
q)a:get `:t1.dat
q)type a            /integer nested type
83h
q)a
0 1 2
3 4 5
```


### Dictionary and table

Dictionary is `99h` and table is `98h`.

```q
q)type d:`a`b`c!(1 2;3 5;7 11)     / dict
99h
q)type flip d                      / table
98h
```


### Functions, iterators, derived functions

Functions, lambdas, operators, iterators, projections, compositions and derived functions have types in the range [100–112].

```q
q)type each({x+y};neg;-;\;+[;1];<>;,';+/;+\;prev;+/:;+\:;`f 2:`f,1)
100 101 102 103 104 105 106 107 108 109 110 111 112h
```




