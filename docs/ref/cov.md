---
title: covariance and sample covariance | Reference | KDB-X and q documentation
description: cov and scov are q keyword, that return respectively the covariance and sample covariance of two conforming numeric lists.
---
# `cov`, `scov`

_Covariance_

## `cov`

```syntax
x cov y    cov[x;y]
```

Where `x` and `y` are [conforming](conformable.md) numeric lists, returns their [covariance](https://en.wikipedia.org/wiki/Covariance "Wikipedia") as a floating-point number. Applies to all numeric data types.

```q
q)2 3 5 7 cov 3 3 5 9
4.5
q)t:([]a:2 3 5 7;b:4 3 0 2)
q)exec a cov b from t
-1.8125
```

`cov` is an aggregate function.

The function `cov` is equivalent to `{avg[x*y]-avg[x]*avg y}`.

Domain and range:

```txt
    B G X H I J E F C S P M D Z N U V T
----------------------------------------
B | f . f f f f f f f . f f f f f f f f
G | . . . . . . . . . . . . . . . . . .
X | f . f f f f f f f . f f f f f f f f
H | f . f f f f f f f . f f f f f f f f
I | f . f f f f f f f . f f f f f f f f
J | f . f f f f f f f . f f f f f f f f
E | f . f f f f f f f . f f f f f f f f
F | f . f f f f f f f . f f f f f f f f
C | f . f f f f f f f . f f f f f f f f
S | . . . . . . . . . . . . . . . . . .
P | f . f f f f f f f . f f f f f f f f
M | f . f f f f f f f . f f f f f f f f
D | f . f f f f f f f . f f f f f f f f
Z | f . f f f f f f f . f f f f f f f f
N | f . f f f f f f f . f f f f f f f f
U | f . f f f f f f f . f f f f f f f f
V | f . f f f f f f f . f f f f f f f f
T | f . f f f f f f f . f f f f f f f f
```

Range: `f`

`cov` is a [multithreaded primitive](mt-primitives.md).

## `scov`

_Sample covariance_

```syntax
x scov y    scov[x;y]
```

Where `x` and `y` are conforming numeric lists, returns their [sample covariance](https://en.wikipedia.org/wiki/Covariance#Calculating_the_sample_covariance "Wikipedia") as a float atom.

$$\mathrm{scov}(x,y)=\frac{n}{n-1} \mathrm{cov}(x,y)$$

Applies to all numeric data types and signals an error with temporal types, char and sym.

```q
q)2 3 5 7 scov 3 3 5 9
6f
q)t:([]a:2 3 5 7;b:4 3 0 2)
q)exec a scov b from t
-2.416667
```

`scov` is an aggregate function.

The function `scov` is equivalent to `{cov[x;y]*count[x]%-1+count x}`.

Domain and range:

```txt
    B G X H I J E F C S P M D Z N U V T
----------------------------------------
B | f . f f f f f f f . f f f f f f f f
G | . . . . . . . . . . . . . . . . . .
X | f . f f f f f f f . f f f f f f f f
H | f . f f f f f f f . f f f f f f f f
I | f . f f f f f f f . f f f f f f f f
J | f . f f f f f f f . f f f f f f f f
E | f . f f f f f f f . f f f f f f f f
F | f . f f f f f f f . f f f f f f f f
C | f . f f f f f f f . f f f f f f f f
S | . . . . . . . . . . . . . . . . . .
P | f . f f f f f f f . f f f f f f f f
M | f . f f f f f f f . f f f f f f f f
D | f . f f f f f f f . f f f f f f f f
Z | f . f f f f f f f . f f f f f f f f
N | f . f f f f f f f . f f f f f f f f
U | f . f f f f f f f . f f f f f f f f
V | f . f f f f f f f . f f f f f f f f
T | f . f f f f f f f . f f f f f f f f
```

Range: `f`

`scov` is a [multithreaded primitive](mt-primitives.md).

----

[`var, svar`](var.md)
<br>

[Mathematics](math.md)
