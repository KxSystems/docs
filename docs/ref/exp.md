---
title: exp, xexp | Reference | kdb+ and q documentation
description: exp and xexp are q keywords. exp raises e to the power of its argument; xexp raises its left argument to the power of its right.
author: Stephen Taylor
keywords: e, kdb+, mathematics, power, q
---
# `exp`, `xexp`

_Raise to a power_




## `exp`

_Raise e to a power_

Syntax: `exp x`, `exp[x]`

Where 

-   `x` is numeric 
-   _e_ is the base of natural logarithms

returns _e_<sup>x</sup>, or null if `x` is null.

```q
q)exp 1
2.718282

q)exp 0.5
1.648721

q)exp -4.2 0 0.1 0n 0w
0.01499558 1 1.105171 0n 0w

q)exp 00:00:00 00:00:12 12:00:00
1 162754.8 0w
```

`exp` is an atomic function.


### Domain and range

```txt
domain b g x h i j e f c s p m d z n u v t
range  f . f f f f f f f . f f f z f f f f
```

Range: `fz`


## `xexp`

_Raise x to a power_

Syntax: `x xexp y`, `xexp[x;y]`

Where `x` and `y` are numerics, returns as a float where `x` is

-   non-negative, x<sup>y</sup>
-   null or negative, `0n`

```q
q)2 xexp 8
256f

q)-2 2 xexp .5
0n 1.414214

q)1.5 xexp -4.2 0 0.1 0n 0w
0.1821448 1 1.04138 0n 0w
```

`exp` is an atomic function.

!!! warning "The calculation is performed as `exp y * log x`." 

    If `y` is integer, this is not identical to `prd y#x`.

    <pre><code class="language-q">
    q)\P 0
    q)prd 3#2
    8
    q)2 xexp 3
    7.9999999999999982
    q)exp 3 * log 2
    7.9999999999999982
    </code></pre>


### Domain and range

```txt
xexp| b g x h i j e f c s p m d z n u v t
----| -----------------------------------
b   | f . f f f f f f . . . . . . . . . .
g   | . . . . . . . . . . . . . . . . . .
x   | f . f f f f f f . . . . . . . . . .
h   | f . f f f f f f . . . . . . . . . .
i   | f . f f f f f f . . . . . . . . . .
j   | f . f f f f f f . . . . . . . . . .
e   | f . f f f f f f . . . . . . . . . .
f   | f . f f f f f f . . . . . . . . . .
c   | . . . . . . . . . . . . . . . . . .
s   | . . . . . . . . . . . . . . . . . .
p   | . . . . . . . . . . . . . . . . . .
m   | . . . . . . . . . . . . . . . . . .
d   | . . . . . . . . . . . . . . . . . .
z   | . . . . . . . . . . . . . . . . . .
n   | . . . . . . . . . . . . . . . . . .
u   | . . . . . . . . . . . . . . . . . .
v   | . . . . . . . . . . . . . . . . . .
t   | . . . . . . . . . . . . . . . . . .
```

Range: `f`

:fontawesome-solid-book: 
[`log`, `xlog`](log.md) 
