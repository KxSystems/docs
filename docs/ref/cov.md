---
title: covariance and sample covariance | Reference | kdb+ and q documentation
description: cov and scov are q keyword, that return respectively the covariance and sample covariance of two conforming numeric lists.
---
# `cov`, `scov`

_Covariance_




## `cov`

```syntax
x cov y    cov[x;y]
```

Where `x` and `y` are [conforming](../basics/conformable.md) numeric lists returns their [covariance](https://en.wikipedia.org/wiki/Covariance "Wikipedia") as a floating-point number. Applies to all numeric data types and signals an error with temporal types, char and sym.

```q
q)2 3 5 7 cov 3 3 5 9
4.5
q)2 3 5 7 cov 4 3 0 2
-1.8125
q)select price cov size by sym from trade
```


`cov` is an aggregate function.

The function `cov` is equivalent to `{avg[x*y]-avg[x]*avg y}`.

Domain and range:
```txt
    b g x h i j e f c s p m d z n u v t
----------------------------------------
b | f . f f f f f f f . f f f f f f f f
g | . . . . . . . . . . . . . . . . . .
x | f . f f f f f f f . f f f f f f f f
h | f . f f f f f f f . f f f f f f f f
i | f . f f f f f f f . f f f f f f f f
j | f . f f f f f f f . f f f f f f f f
e | f . f f f f f f f . f f f f f f f f
f | f . f f f f f f f . f f f f f f f f
c | f . f f f f f f f . f f f f f f f f
s | . . . . . . . . . . . . . . . . . .
p | f . f f f f f f f . f f f f f f f f
m | f . f f f f f f f . f f f f f f f f
d | f . f f f f f f f . f f f f f f f f
z | f . f f f f f f f . f f f f f f f f
n | f . f f f f f f f . f f f f f f f f
u | f . f f f f f f f . f f f f f f f f
v | f . f f f f f f f . f f f f f f f f
t | f . f f f f f f f . f f f f f f f f
```

Range: `f`



## `scov`

_Sample covariance_

```syntax
x scov y    scov[x;y]
```

Where `x` and `y` are conforming numeric lists returns their [sample covariance](https://en.wikipedia.org/wiki/Covariance#Calculating_the_sample_covariance "Wikipedia") as a float atom.

$$scov(x,y)=\frac{n}{n-1} cov(x,y)$$

Applies to all numeric data types and signals an error with temporal types, char and sym.

```q
q)2 3 5 7 scov 3 3 5 9
8
q)2 3 5 7 scov 4 3 0 2
-2.416667
q)select price scov size by sym from trade
```

`scov` is an aggregate function.

The function `scov` is equivalent to `{cov[x;y]*count[x]%-1+count x}`.

Domain and range:
```txt
    b g x h i j e f c s p m d z n u v t
----------------------------------------
b | f . f f f f f f . . f f f f f f f f
g | . . . . . . . . . . . . . . . . . .
x | f . f f f f f f . . f f f f f f f f
h | f . f f f f f f . . f f f f f f f f
i | f . f f f f f f . . f f f f f f f f
j | f . f f f f f f . . f f f f f f f f
e | f . f f f f f f . . f f f f f f f f
f | f . f f f f f f f . f f f f f f f f
c | . . . . . . . f . . f f f f f f f f
s | . . . . . . . . . . . . . . . . . .
p | f . f f f f f f f . f . . . f f f f
m | f . f f f f f f f . . f . . f f f f
d | f . f f f f f f f . . . f . f f f f
z | f . f f f f f f f . . . . f f f f f
n | f . f f f f f f f . f f f f f f f f
u | f . f f f f f f f . f f f f f f f f
v | f . f f f f f f f . f f f f f f f f
t | f . f f f f f f f . f f f f f f f f
```

Range: `f`


----
:fontawesome-solid-book:
[`var, svar`](var.md)
<br>
:fontawesome-solid-book:
[Mathematics](../basics/math.md)
<br>
:fontawesome-brands-wikipedia-w: 
[Covariance](https://en.wikipedia.org/wiki/Covariance)
