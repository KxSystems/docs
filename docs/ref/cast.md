---
title: Cast converts data to another datatype | Reference | kdb+ and q documentation
description: Cast is a q operator that converts a data argument to another datatype.
---

# `$` Cast



_Convert to another datatype_

```txt
x$y     $[x;y]
```

Where `x` is: 

-   a **positive short, lower-case letter, or symbol** from the following table, returns `y` cast according to `x`

    <pre><code class="txt">
    1h  "b" \`boolean
    2h  "g" \`guid
    4h  "x" \`byte
    5h  "h" \`short
    6h  "i" \`int
    7h  "j" \`long
    8h  "e" \`real
    9h  "f" \`float
    10h "c" \`char
    12h "p" \`timestamp
    13h "m" \`month
    14h "d" \`date
    15h "z" \`datetime
    16h "n" \`timespan
    17h "u" \`minute
    18h "v" \`second
    19h "t" \`time
    </code></pre>

-   a symbol from the list **`` `year`dd`mm`hh`uu`ss``** and `y` is a temporal type, returns the year, day, month, hour, minute, or seconds value from `y` as [tabulated below](#temporal)

-   **`0h` or `"*"`**, and `y` is not a string, returns `y` ([Identity](#identity))

-   an **upper-case letter** or a **negative short int**, see [Tok](tok.md)

Casting does not change the underlying bit pattern of the data, only how it is represented.


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


## Temporal

Find parts of time:

```q
q)`hh`uu`ss$03:55:58.11
3 55 58i
q)`year`dd`mm`hh`uu`ss$2015.10.28D03:55:58
2015 28 10 3 55 58i
```

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


milliseconds: "i"$time mod 1000
milliseconds: "i"$mod[;1000]"t"$datetime
nanoseconds: "i"$timestamp mod 1000000000
```


## Identity

```q
q)("*";0h)$1
1 1
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

