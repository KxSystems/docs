---
title: Tok interprets string data to another datatype | Reference | kdb+ and q documentation
description: Tok is a q operator that interprets string data to another datatype.
author: Stephen Taylor
---
# `$` Tok


_Interpret a string as a data value_


```txt
x$y    $[x;y]
```

Where

-   `y` is a **string**
-   `x` is a **non-positive short or upper-case char** as below (or the null symbol as a synonym for `"S"`)

returns `y` as an atom value interpreted according to `x`.

`x` values for Tok:

```q
q){([result:key'[x$\:()]];short:neg x;char:upper .Q.t x)}5h$where" "<>20#.Q.t
result   | short char
---------| ----------
string   |  0    *
boolean  | -1    B
guid     | -2    G
byte     | -4    X
short    | -5    H
int      | -6    I
long     | -7    J
real     | -8    E
float    | -9    F
char     | -10   C
symbol   | -11   S
timestamp| -12   P
month    | -13   M
date     | -14   D
datetime | -15   Z
timespan | -16   N
minute   | -17   U
second   | -18   V
time     | -19   T
```

A left argument of `0h` or "*" returns the `y` string unchanged.

Where `x` is a **positive or zero short**, a **lower-case char**, **`"*"`**, or a non-null **symbol**, see [Cast](cast.md).


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
```


## :fontawesome-solid-sitemap: Iteration

Tok is a near-[atomic function](../basics/atomic.md).
Implicit recursion stops at strings, not atoms.

```q
q)"BXH"$("42";"42";"42")
0b
0x42
42h

q)("B";"XHI")$("42";("42";"42";"42"))
0b
(0x42;42h;42i)

q)"B"$"   Y  "
1b
q)"B"$'"   Y  "
000100b
```


## Symbols

!!! tip Use "Use the null symbol as a shorthand left argument for `"S"`."

```q
q)"S"$"hello"
`hello
q)`$"hello"
`hello
```

Converting a string to a symbol removes leading and trailing blanks.

```q
q)`$"   IBM   "
`IBM
```


## Truthy characters

Certain characters are recognized as boolean True:

```q
q)"B"$(" Y ";"    N ")
10b
q)" ",.Q.an
" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789"
q)"B"$'" ",.Q.an
0000000000000000000010001100000000000000000000100011000100000000b

q).Q.an where"B"$'.Q.an
"txyTXY1"
```

Contrast this with [casting to boolean](cast.md#boolean):

```q
q)"b"$" ",.Q.an
1111111111111111111111111111111111111111111111111111111111111111b
```


## IP address

```q
q)"I"$"192.168.1.34" /an IP address as an int
-1062731486i
q)"NT"$\:"123456123987654"  / since V3.4
0D12:34:56.123987654
12:34:56.123
```

:fontawesome-solid-book:
[`.Q.addr`](dotq.md#qaddr-ip-address),
[`.Q.host`](dotq.md#qhost-hostname)


## Unix timestamps

(from seconds since Unix epoch), string with 9…11 digits:

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

q)"PZ"$\:"20191122-11:11:11.123"
2019.11.22D11:11:11.123000000
2019.11.22T11:11:11.123
```


## Date formats

`"D"$` will Tok dates with varied formats:

```txt
[yy]yymmdd
ddMMM[yy]yy
yyyy/[mm|MMM]/dd
[mm|MMM]/dd/[yy]yy  / \z 0  
dd/[mm|MMM]/[yy]yy  / \z 1
```

:fontawesome-solid-book-open:
[Command-line option `-z` (date format)](../basics/cmdline.md#-z-date-format)
<br>
:fontawesome-solid-book-open:
[System command `\z` (date format)](../basics/syscmds.md#z-date-parsing)

----
:fontawesome-solid-book:
[Cast](cast.md)
<br>
:fontawesome-solid-book:
[Overloads of `$`](overloads.md#dollar)
<br>
:fontawesome-solid-book:
[`.h.iso8601`](doth.md#hiso8601-iso-timestamp) ISO 8601 timestamp
<br>
:fontawesome-solid-book-open:
[Casting](../basics/by-topic.md#casting)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§7.3.3 Parsing Data from Strings](/q4m3/7_Transforming_Data/#733-parsing-data-from-strings)

