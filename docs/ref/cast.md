---
title: Cast converts data to another datatype | Reference | kdb+ and q documentation
description: Cast is a q operator that converts a data argument to another datatype.
---

# `$` Cast



_Convert to another datatype_

```syntax
x$y     $[x;y]
```

Where `x` is:

-   a **positive short, lower-case letter, or symbol** from the following table, returns `y` cast according to `x`

    ```txt
    1h  "b" `boolean
    2h  "g" `guid
    4h  "x" `byte
    5h  "h" `short
    6h  "i" `int
    7h  "j" `long
    8h  "e" `real
    9h  "f" `float
    10h "c" `char
    12h "p" `timestamp
    13h "m" `month
    14h "d" `date
    15h "z" `datetime
    16h "n" `timespan
    17h "u" `minute
    18h "v" `second
    19h "t" `time
    ```

-   a symbol from the list **`` `year`dd`mm`hh`uu`ss``** and `y` is a temporal type, returns the year, day, month, hour, minute, or seconds value from `y` as [tabulated below](#temporal)

-   **`0h` or `"*"`**, and `y` is not a string, returns `y` ([Identity](#identity))

-   an **upper-case letter** or a **negative short int** interprets the value from a string, see [Tok](tok.md)

Casting does not change the underlying bit pattern of the data, only how it is represented.

`$`(cast) is a [multithreaded primitive](../kb/mt-primitives.md).

## :fontawesome-solid-sitemap: Iteration

Cast is an [atomic function](../basics/atomic.md).

```q
q)12 13 14 15 16 17 18 19h$42
2000.01.01D00:00:00.000000042
2003.07m
2000.02.12
2000.02.12T00:00:00.000
0D00:00:00.000000042
00:42
00:00:42
00:00:00.042

q)(12h;"m";`date)$42
2000.01.01D00:00:00.000000042
2003.07m
2000.02.12

q)(12h;"m";`date)$42 43 44
2000.01.01D00:00:00.000000042
2003.08m
2000.02.14

q)(12h;13 14h)$(42;42 42)
2000.01.01D00:00:00.000000042
(2003.07m;2000.02.12)
```


## Integer

Cast to integer:

```q
q)"i"$10
10i
q)(`int;"i";6h)$10
10 10 10i
q)`int$(neg\)6.1 6.6
6  7
-6 -7
```


## Boolean

Cast to boolean:

```q
q)1h$(neg\)1 0 2
101b
101b
```

Characters are cast to True.

```q
q)" ",.Q.an
" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789"
q)"b"$" ",.Q.an
1111111111111111111111111111111111111111111111111111111111111111b
```


## Byte

```q
q)"x"$3 4 5
0x030405
q)"x"$"abc"
0x616263
```

??? danger "Casting longs above int infinity"

    Longs greater than `0wi` cast to `0xff`

    ```q
    q)"x"$-2 -1 0 1 2+0Wi
    0xfdfeffffff
    ```

    This is considered an error and is planned to change to `0x00`.


## Temporal

The following symbols can be used to extract parts of a temporal type

* `year` to provide year as an integer
* `month` to provide `month` datatype
* `mm` to provide month as an integer, where January is 01i
* `week` to provide a `date` datatype, presenting the week in which the temporal variable resides. The value returned is the start of the week (Monday). If the `date` represents a Monday, it is not altered.
* `dd` to provide day as an integer, where 1st of the month is 1i
* `hh` to provide hour as an integer
* `uu` to provide minutes as an integer
* `ss` to provide to seconds as an integer

For example:

```q
q)`hh`uu`ss$03:55:58.11
3 55 58i
q)`year`dd`mm`hh`uu`ss$2015.10.28D03:55:58
2015 28 10 3 55 58i
```

The following shows which information can be extracted from each temporal [datatype](../basics/datatypes.md)

```txt
          | year | month | mm | week | dd | hh | uu | ss
--------------------------------------------------------
timestamp |  x   |   x   | x  |  x   | x  | x  | x  | x
month     |  x   |   x   | x  |      |    |    |    |
date      |  x   |   x   | x  |  x   | x  |    |    |
datetime  |  x   |   x   | x  |  x   | x  | x  | x  | x
timespan  |      |       |    |      |    | x  | x  | x
minute    |      |       |    |      |    | x  | x  | x
second    |      |       |    |      |    | x  | x  | x
time      |      |       |    |      |    | x  | x  | x
```

!!! detail "Casting to narrower temporal type truncates rather than rounds"

    Such conversions use floor, because the day, hour, minute, second… are all [) notions. (What hour are we in; what millisecond are we in…)

    For example, `"d"$2017.08.23T23:50:12` is `2017.08.23` even though the datetime is closer to `2017.08.24`.

    As a consequence `.z.t-.z.n` is typically negative. 

Numeric calculations on the base numeric type can also be used to extract part of a temporal type, for the example using the [`mod`](mod.md) keyword

```q
milliseconds: "i"$01:00:00.100 mod 1000                         / extract milliseconds from time datatype
milliseconds: "i"$mod[;1000]"t"$2000.01.01T12:00:00.500         / extract milliseconds from datetime datatype
nanoseconds: "i"$2014.11.22D17:43:40.123456789 mod 1000000000   / extract nanoseconds from timestamp datatype
```

## Identity

```q
q)("*";0h)$1
1 1
```

For string values of `y`, see [Tok](tok.md).

## Infinities and beyond

!!! danger "Casting an infinity from a narrower to a wider datatype returns a finite value."

When an integral infinity is cast to an integer of wider type, it is the _same underlying bit pattern_, reinterpreted.

Since this bit pattern is a legitimate value for the wider type, the cast returns a finite value.

```q
q)`float$0Wh
32767f
```

!!! tip "The infinity corresponding to numeric `x` is `min 0#x`."

----
:fontawesome-solid-book:
[Tok](tok.md)
<br>
:fontawesome-solid-book:
[Overloads of `$`](overloads.md#dollar)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§7.2 Cast](/q4m3/7_Transforming_Data/#731-data-to-strings)

