---
title: Datatypes in kdb+ | A mountain tour of kdb+ and the q programming language
description: Types of data handled by kdb+ and how they are represented in q
author: Stephen Taylor
date: February 2020
---
# Datatypes in kdb+


Different types of data have different representations in q, corresponding to different internal representations in kdb+.
This is of particular importance in the representation of _vectors_: 
Lists of atoms of the same type are called _vectors_ (sometimes _simple_ or _homogenous_ lists) and have representations that vary by type.

Every object in q has a datatype, reported by the [`type`](../../ref/type.md) keyword.

```q
q)type 42 43 44     / vector of longs
7h
q)type (+)          / even an operator has a type
102h
```

:fontawesome-solid-book-open:
[Datatypes](../../basics/datatypes.md) for a complete table.


## Numbers

```txt
type       atom    vector       null   inf
------------------------------------------
short      42h     42 43 44h    0Nh    0Wh
int        42i     42 43 44i    0Ni    0Wi
long       42j     42 43 44j    0Nj    0Wj
           42      42 43 44     0N     0W
real       42e     42 43 44e    0Ne    0We
float      42f     42 43 44f    0n     0w
           42.     42 43 44.
```

The default integer type is long, so the `j` suffix can be omitted.
A decimal point in a number is sufficient to denote a float, so is an alternative to the `f` suffix.

Nulls and infinities are typed as shown.


## Text

Text data is represented either as char vectors or as symbols.

```q
"a"                         / char atom
"quick brown fox"           / char vector
("quick";"brown";"fox")     / list of char vectors
```

Char vectors can be indexed and are mutable, but are known in q as _strings_.

```q
q)s:"quick"                 / string
q)s[2]                      / indexing
"i"
q)s[2]:"a"                  / mutable
q)s
"quack"
```

Symbols are atomic and immutable. They are suitable for representing recurring values.

```q
`screw                      / symbol atom
`screw`nail`screw           / symbol vector
```
```q
q)count `screw`nail`screw   / symbols are atomic
3
```

The null string is `" "` and the null symbol is a single backtick `` ` ``.


## Dates and times

```txt
type       atom         vector                      null  inf
-------------------------------------------------------------
month      2020.01m     2020.01 2019.08m            0Nm
date       2020.01.01   2020.01.01 2020.01.02       0Nd   0Wd

minute     12:34         12:34 12:46                0Nu   0Wu
second     12:34:56      12:34:56 12:46:30          0Nv   0Wv
time       12:34:56.789  12:34:56.789 12:46:30.500  0Nt   0Wt
```

```txt
type       atom                                     null  inf
-------------------------------------------------------------
timestamp  2020.02.29D12:11:42.381000000            0Np   0Wp
datetime   2020.02.29T12:14:42.718                  0Nz   0Wz
timespan   0D00:05:14.659000000                     0Nn   0Wn
```

!!! tip "Datetime is deprecated. Prefer the nanosecond precision of timestamps."


## Booleans

Booleans have the most compact vector representation in q.

```q
q)"Many hands make light work."="a"
010000100000100000000000000b
```


## GUIDs

In general, there should be no need for char vectors for IDs. IDs should be int, sym or guid. Guids are faster (much faster for `=`) than the 16-byte char vectors and take 2.5 times less storage (16 per instead of 40 per).

Use [Deal](../../ref/deal.md) to generate unique guids.

```q
q)-2?0Ng
cf74afa1-6c49-8e11-d599-736eba641207 6080b044-aa79-2d30-62a4-34390a4c81d1
```

----
:fontawesome-solid-book-open:
[Datatypes](../../basics/datatypes.md)
<br>
:fontawesome-solid-book:
[Cast](../../ref/cast.md),
[Tok](../../ref/tok.md),
[`null`](../../ref/null.md),
[`type`](../../ref/type.md)
<br>
:fontawesome-solid-graduation-cap:
_Q for Mortals_ [§2.4 Basic Data Types – Atoms](/q4m3/2_Basic_Data_Types_Atoms/#24-text-data)
<br>
