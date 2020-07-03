---
title: Tok casts string data to another datatype | Reference | kdb+ and q documentation
description: Tok is a q operator that casts string data to another datatype.
author: Stephen Taylor
keywords: cast, datatype, kdb+, operator, q, string, tok
---
# `$` Tok



Syntax: `x$y`, `$[x;y]`

Where 

-   `x` is an upper-case letter or negative short int
-   `y` is a string

returns `y` interpreted as a value according to `x`. 

`x` values for Tok:

```q
q){([result:key'[x$\:()]];short:neg x;char:upper .Q.t x)}5h$where" "<>20#.Q.t
result   | short char
---------| ----------
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

`0h$` and `"*"$` are no-ops. 
For positive short or lower-case letter values of `x`, see [Cast](cast.md).


!!! tip Use "`` `$y`` as shorthand for `"S"$y`"

    <pre><code class="language-q">
    q)"S"\$"hello"
    \`hello
    q)\`\$"hello"
    \`hello
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

:fontawesome-solid-book:
[`.Q.addr`](dotq.md#qaddr-ip-address),
[`.Q.host`](dotq.md#qhost-hostname)


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

:fontawesome-solid-book:
[Cast](cast.md), 
[`$` dollar](overloads.md#dollar),
[`.h.iso8601`](doth.md#hiso8601-iso-timestamp)
<br>
:fontawesome-solid-book-open:
[system command `\z` (date format)](../basics/syscmds.md#z-date-parsing),
[Casting](../basics/casting.md) 
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§7.3.3 Parsing Data from Strings](/q4m3/7_Transforming_Data/#733-parsing-data-from-strings)  

