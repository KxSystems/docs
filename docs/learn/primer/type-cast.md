---
title: Datatypes and casting in kdb+ | Kdb+ database and language primer | Documentation for kdb+ and q
author: Dennis Shasha (shasha@cs.nyu.edu)
description: Datatypes and casting in q and kdb+
hero: <i class="fas fa-graduation-cap"></i> Kdb+ database and language primer
---
# Appendix 5: Datatypes and casting



## `type`

The keyword [`type`](../../ref/type.md) returns the type of a q object.

```q
q)type 100
-6h
q)type 100 99 88
6h
q)type 1.2 3.1
9h
```

Lists have positive type; atoms negative.


## Cast

The [Cast](../../ref/cast.md) operator (`a$b`) converts `b` to the type specified by `a`. The atom left argument is from the datatypes table:

<i class="fas fa-book-open"></i>
[Datatypes](../../basics/datatypes.md)

Some examples.

```q
q)"x"$97                  / cast the int 97 to byte representation in hex
0x61
q)"x"$"a"                 / "a" also happens to be encoded in hex 97
0x61
q)"c"$0x41                / cast a byte to a char
"A"
q)"d"$2019.03.23T08:31:53 / extract the date from a datetime value
2019.03.23
q)"t"$2019.03.23T08:31:53
08:31:53.000
```

<i class="fas fa-book-open"></i>
[Casting](../../basics/casting.md)


## Tok

Use the [Tok](../../ref/tok.md) operator to interpret (tokenize) strings.
The left argument is the upper case of character for the type.

```q
q)"I"$"67"
67
q)"S"$"abc 012"
`abc 012
q)"D"$"2019.03.23"
2019.03.23
q)"D"$"2019-03-23"
2019.03.23
q)"D"$"03/23/2019"
2019.03.23
```


## `string`


Use [`string`](../../ref/string.md) to cast data to text.

```q
q)string "D"$"03/23/2019"
"2019.03.23"
```


## Nulls

The IEEE arithmetic NaN (not-a-number) for floats is a float denoted by `0n`.

```q
q)0%0
0n
```

It is a null.
Null values often represent missing values.

Two functions manipulate nulls: 

-   [`null`](../../ref/null.md) flags the null items of a list
-   [Fill](../../ref/fill.md) (`^`) replaces them by other values

```q
q)null 1 2 -5 0N 10 0N
000101b
```

Suppose we have a sales vector and, some days, an unknown number of sales.

```q
q)sales: 45 21 0N 13 0N 11 34
```

We could fill in those unknown days with 0s.

```q
q)0^sales
45 21 0 13 0 11 34
```

Or we could fill in with the average of the non-null values.

```q
q)(avg sales) ^ sales
45 21 24.8 13 24.8 11 34
```

Aggregates such as [`avg`](../../ref/avg.md) ignore null values.


## Infinities

Positive and negative float infinities are denoted by `0w` and `-0w`.

```q
q)1%0
0w
q)-1%0
-0w
q)0w> 99999999
1b
```

Nulls and infinities are type-specific and listed in the datatypes table, which you will surely have bookmarked by now.

<i class="fas fa-book-open"></i>
[Datatypes](../../basics/datatypes.md)

---
<i class="far fa-hand-point-right"></i>
[Debugging](debug.md)
