---
title: log, xlog | Reference | kdb+ and q documentation
description: log and xlog are q keywords that return logarithms, either natural or to a specified base.
author: Stephen Taylor
keywords: e, log, logarithm, kdb+, natural, power, q, xlog 
---
# `log`, `xlog`

_Logarithms and natural logarithms_



## `log`

_Natural logarithm_

Syntax: `log x`, `log[x]`

Where `x` is numeric and 

-   null, returns null
-   0, returns `-0w`
-   a datetime, returns `x`
-   otherwise, the natural logarithm of `x`

```q
q)log 1
0f
q)log 0.5
-0.6931472
q)log exp 42
42f
q)log -2 0n 0 0.1 1 42
0n 0n -0w -2.302585 0 3.73767
```

An atomic function.


### Domain and range

```txt
domain b g x h i j e f c s p m d z n u v t
range  f . f f f f f f f . f f f z f f f f
```

Range: `fz`




## `xlog`

_Logarithm_

Syntax: `x xlog y`, `xlog[x;y]`

Returns the base-`xf` logarithm of `yf`, where `xf` and `yf` are `x` and `y` cast to floats, i.e. `"f"$(x;y)`.

Where `yf` is negative or zero, the result is null and negative infinity respectively.

```q
q)2 xlog 8
3f

q)2 xlog 0.125
-3f

q)1.5 xlog 0 0.125 1 3 0n
-0w -5.128534 0 2.709511 0n

q)`float$"AC"
65 67f
q)65 xlog 67
1.00726
q)"A"xlog"C"
1.00726
```

`xlog` is an atomic function.


### `xlog` and `xexp`

`xlog` is the inverse of `xexp`. Where both are defined, `y=x xexp x xlog y`.

```q
q)2 xexp 2 xlog -1 0 0.125 1 42
0n 0 0.125 1 42
```

These functions return integer results from integer arguments. 
(Many will also accept non-integer arguments.) 


### Domain and range

```txt
xlog | b g x h i j e f c s p m d z n u v t
---- | -----------------------------------
b    | f . f f f f f f f . f f f . f f f f
g    | . . . . . . . . . . . . . . . . . .
x    | f . f f f f f f f . f f f . f f f f
h    | f . f f f f f f f . f f f . f f f f
i    | f . f f f f f f f . f f f . f f f f
j    | f . f f f f f f f . f f f . f f f f
e    | f . f f f f f f f . f f f . f f f f
f    | f . f f f f f f f . f f f . f f f f
c    | f . f f f f f f f . f f f . f f f f
s
p    | f . f f f f f f f . f f f . f f f f
m    | f . f f f f f f f . f f f . f f f f
d    | f . f f f f f f f . f f f . f f f f
z    | . . . . . . . . . . . . . . . . . .
n    | f . f f f f f f f . f f f . f f f f
u    | f . f f f f f f f . f f f . f f f f
v    | f . f f f f f f f . f f f . f f f f
t    | f . f f f f f f f . f f f . f f f f
```

Range: `f`

Function is commutative under datatype.

:fontawesome-solid-book: 
[`exp`, `xexp`](exp.md)
<br>
:fontawesome-solid-book-open: 
[Datatypes](../basics/datatypes.md)

