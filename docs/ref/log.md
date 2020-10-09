---
title: log, xlog – logarithms | Reference | kdb+ and q documentation
description: log and xlog are q keywords that return logarithms, either natural or to a specified base.
author: Stephen Taylor
---
# `log`, `xlog`

_Logarithms and natural logarithms_



## `log`

_Natural logarithm_

```txt
log x    log[x]
```

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


### :fontawesome-solid-sitemap: Implicit iteration

`log` is an [atomic function](../basics/atomic.md).
It applies to [dictionaries and tables](../basics/math.md#dictionaries-and-tables)

```q
q)log(2;3 4)
0.6931472
1.098612 1.386294

q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 -21 3;4 5 -6)

q)log d
a| 2.302585          1.098612
b| 1.386294 1.609438

q)log t
a        b
-----------------
2.302585 1.386294
         1.609438
1.098612

q)log k
k  | a        b
---| -----------------
abc| 2.302585 1.386294
def|          1.609438
ghi| 1.098612
```


### Domain and range

```txt
domain b g x h i j e f c s p m d z n u v t
range  f . f f f f f f f . f f f z f f f f
```

Range: `fz`



----
## `xlog`

_Logarithm_

```txt
x xlog y    xlog[x;y]
```

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


### :fontawesome-solid-sitemap: Implicit iteration

`xlog` is an [atomic function](../basics/atomic.md).
It applies to [dictionaries and tables](../basics/math.md#dictionaries-and-tables)

```q
q)(2;3 4)xlog(4;5 6)
2f
1.464974 1.292481

q)10 xlog d
a| 1               0.4771213
b| 0.60206 0.69897

q)10 xlog t
a         b
-----------------
1         0.60206
          0.69897
0.4771213

q)10 xlog k
k  | a         b
---| -----------------
abc| 1         0.60206
def|           0.69897
ghi| 0.4771213
```


### `xlog` and `xexp`

`xlog` is the inverse of `xexp`, i.e. `y~x xexp x xlog y`.

```q
q)2 xexp 2 xlog -1 0 0.125 1 42
0n 0 0.125 1 42
```


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

----
:fontawesome-solid-book: 
[`exp`, `xexp`](exp.md)
<br>
:fontawesome-solid-book-open: 
[Datatypes](../basics/datatypes.md)

