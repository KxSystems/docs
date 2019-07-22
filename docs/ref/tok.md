---
title: Tok
description: Tok is a q operator that casts string data to another datatype.
author: Stephen Taylor
keywords: cast, datatype, kdb+, operator, q, string, tok
---
# `$` Tok



Syntax: `x$y`, `$[x;y]`

Where 

-   `x` is an upper-case letter or non-positive short int
-   `y` is a string

returns `y` interpreted as a value according to `x`. 

A table of `x` values for Tok:

```q
q)flip{(neg x;upper .Q.t x;key'[x$\:()])}5h$where" "<>20#.Q.t
-1h  "B" `boolean
-2h  "G" `guid
-4h  "X" `byte
-5h  "H" `short
-6h  "I" `int
-7h  "J" `long
-8h  "E" `real
-9h  "F" `float
-10h "C" `char
-11h "S" `symbol
-12h "P" `timestamp
-13h "M" `month
-14h "D" `date
-15h "Z" `datetime
-16h "N" `timespan
-17h "U" `minute
-18h "V" `second
-19h "T" `time
```

!!! Tip "String to symbol"

    Use `` `$y`` as shorthand for `"S"$y`.
    <pre><code class="language-q">
    q)"S"$"hello"
    `hello
    q)`$"hello"
    `hello
    </code></pre>

```q
q)"E"$"3.14"
3.14e
q)-8h$"3.14"
3.14e
q)"D"$"2000-12-12"
2000.12.12
q)"U"$"12:13:14"
12:13
q)"T"$"123456789"
12:34:56.789
q)"P"$"2015-10-28D03:55:58.6542"
2015.10.28D03:55:58.654200000
q)"I"$"192.168.1.34" /an IP address as an int
-1062731486i
q)"NT"$\:"123456123987654"  / since V3.4
0D12:34:56.123987654
12:34:56.123
```

!!! tip "Truthy characters"

    These characters are recognized as boolean true:

    <pre><code class="language-q">
    q).Q.an where"B"$'.Q.an
    "txyTXY1"
    </code></pre>

Parsing **Unix timestamps** (from seconds since Unix epoch), string with 9…11 digits:

```q
q)"P"$"10129708800"
2290.12.31D00:00:00.000000000
q)"P"$"00000000000"
1970.01.01D00:00:00.000000000
```

If these digits are followed by a `.` Tok will parse what follows `.` as parts of second, e.g. 

```q
q)"P"$"10129708800.123456789"
2290.12.31D00:00:00.123456789
q)"P"$"00000000000.123456789"
1970.01.01D00:00:00.123456789
```

`"D"$` will Tok **dates** with varied formats:

```txt
[yy]yymmdd
ddMMM[yy]yy
yyyy/[mm|MMM]/dd
[mm|MMM]/dd/[yy]yy  / \z 0  
dd/[mm|MMM]/[yy]yy  / \z 1
```

<i class="far fa-hand-point-right"></i> 
[`\z` (date format)](../basics/syscmds.md#z-date-parsing)  
[`.h.iso8601`](doth.md#hiso8601-iso-timestamp)  
Basics: [Casting](../basics/casting.md)  
[`$` dollar](overloads.md#dollar)

