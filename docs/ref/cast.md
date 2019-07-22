---
title: Cast
description: Cast is a q operator that converts a data argument to another datatype.
keywords: cast, datatype, dollar, kdb+,q
---

# `$` Cast



_Convert to another datatype_

Syntax: `x$y`, `$[x;y]`

Where `x` is a lower-case letter, symbol or non-negative short atom (or list of such atoms), returns `y` cast according to `x`. A table of `x` values for Cast:

```q
q)flip{(x;.Q.t x;key'[x$\:()])}5h$where" "<>20#.Q.t
1h  "b" `boolean
2h  "g" `guid
4h  "x" `byte
5h  "h" `short
6h  "i" `int
7h  "j" `long
8h  "e" `real
9h  "f" `float
10h "c" `char
11h "s" `symbol
12h "p" `timestamp
13h "m" `month
14h "d" `date
15h "z" `datetime
16h "n" `timespan
17h "u" `minute
18h "v" `second
19h "t" `time
```


## Integer

Cast to integer:

```q
q)"i"$10
10i
q)(`int;"i";6h)$10
10 10 10i
```


## Boolean

Cast to boolean:

```q
q)1h$1 0 2
101b
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


## Identity

```q
q)("*";0h)$1
10 10
q)("*";0h)$\:"2012-02-02"
"2012-02-02"
"2012-02-02"
```


## Infinities and beyond

!!! warning "Casting an infinity from a narrower to a wider datatype does not always return another infinity."

```q
q)`float$0Wh
32767f
```

Space rangers! The infinity corresponding to numeric `x` is `min 0#x`.

<i class="far fa-hand-point-right"></i> 
[Tok](tok.md)  
[dollar `$`](overloads.md#dollar)  
Basics: [Casting & encoding](../basics/casting.md)