---
title: Divide | Reference | kdb+ and q documentation
description: Divide is a q operator that returns the ratio of its arguments.
author: Stephen Taylor
---
# `%` Divide





```txt
x%y     %[x;y]
```

Returns the
ratio of the underlying values of `x` and `y` as a float.

Note that this is different from some other programming languages, e.g. C++.

```q
q)2%3
0.6666667
q)halve:%[;2]                              /projection
q)halve til 5
0 0.5 1 1.5 2

q)"z"%"a"
1.257732
q)1b%0b
0w

q)00:00:10.000000000 % 00:00:05.000000000  /ratio of timespans
2f
```

Dates are represented internally as days after 2000.01.01, so the ratio of two dates is the ratio of their respective number of days since 2000.01.01.

```q
q)"i"$2010.01.01 2005.01.01                /days since 2000.01.01
3653 1827i
q)(%/)"i"$2010.01.01 2005.01.01
1.999453
q)2010.01.01 % 2005.01.01
1.999453
```


## :fontawesome-solid-sitemap: Implicit iteration

Divide is an [atomic function](../basics/atomic.md).

```q
q)(10;20 30)%(2;3 4)
5f
6.666667 7.5
```

It applies to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).

```q
q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 -21 3;4 5 -6)

q)d%2
a| 5 -10.5 1.5
b| 2 2.5   -3

q)d%`b`c!(10 20 30;1000*1 2 3)             /upsert semantics
a| 10   -21  3
b| 0.4  0.25 -0.2
c| 1000 2000 3000

q)t%100
a     b
-----------
0.1   0.04
-0.21 0.05
0.03  -0.06

q)k%k
k  | a b
---| ---
abc| 1 1
def| 1 1
ghi| 1 1
```


## Range and domains

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

----
:fontawesome-solid-book:
[`div`](div.md),
[Multiply](multiply.md),
[`ratios`](ratios.md)
<br>
:fontawesome-solid-street-view:
[Mathematics](../basics/math.md)
<br>
:fontawesome-solid-book-open:
_Q for Mortals_
[§4.4 Basic Arithmetic](/q4m3/4_Operators/#44-basic-arithmetic-)
