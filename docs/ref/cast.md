---
title: Cast converts data to another datatype | Reference | kdb+ and q documentation
description: Cast is a q operator that converts a data argument to another datatype.
keywords: cast, datatype, dollar, kdb+, q, tok
---

# `$` Cast



_Convert to another datatype_

Syntax: `x$y`, `$[x;y]`

Where `x` is: 

-   a lower-case letter, symbol or positive short atom (or list of such atoms), returns `y` cast according to `x`. A table of `x` values for Cast:

    <pre><code class="language-q">
    q)flip{(x;.Q.t x;key'[x\$\\:()])}5h\$where" "<>20#.Q.t
    1h  "b" \`boolean
    2h  "g" \`guid
    4h  "x" \`byte
    5h  "h" \`short
    6h  "i" \`int
    7h  "j" \`long
    8h  "e" \`real
    9h  "f" \`float
    10h "c" \`char
    11h "s" \`symbol
    12h "p" \`timestamp
    13h "m" \`month
    14h "d" \`date
    15h "z" \`datetime
    16h "n" \`timespan
    17h "u" \`minute
    18h "v" \`second
    19h "t" \`time
    </code></pre>

-   `0h` or `"*"`, returns `y` ([Identity](identity.md)).

    <pre><code class="language-q">
    q)("\*";0h)\$1
    1 1
    q)("\*";0h)\$\\:"2012-02-02"
    "2012-02-02"
    "2012-02-02"
    </code></pre>

Where `x` is an upper-case letter or a negative short int, and `y` is a string, see [Tok](tok.md).

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


## String to symbol

When converting a string to a symbol, leading and trailing blanks are automatically trimmed:

```q
q)`$"   IBM   "
`IBM
```


!!! tip "Use [Tok](tok.md) to cast a string to numeric or temporal"


## Infinities and beyond

!!! warning "Casting an infinity from a narrower to a wider datatype does not always return another infinity."

When an integral infinity is are cast to an integer of wider type, it **is** its underlying bit patterns, reinterpreted. Since this bit pattern is a legitimate value for the wider type, the cast results in a finite value.

```q
q)`float$0Wh
32767f
```

!!! tip "The infinity corresponding to numeric `x` is `min 0#x`."

:fontawesome-solid-book:
[Tok](tok.md), 
[dollar `$`](overloads.md#dollar)
<br>
:fontawesome-solid-book-open:
[Casting and encoding](../basics/casting.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§7.2 Cast](/q4m3/7_Transforming_Data/#731-data-to-strings)

