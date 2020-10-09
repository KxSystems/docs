---
title: Greater, or | Reference | kdb+ and q documentation
description: Greater is a q operator that returns the greater of its arguments. or is a q keyword that performs a logical OR.
author: Stephen Taylor
---
# `|` Greater, `or`

_Greater; logical OR_



```txt
x|y       |[x;y]
x or y    or[x;y]
```

Where `x` and `y` are [conformable](../basics/conformable.md) numerics or temporals, returns their 
the [greater](../basics/comparison.md) of them.

```q
q)2|3
3
q)1010b or 1100b  /logical OR with booleans
1110b
q)"sat"|"cow"
"sow"
```


## Booleans

Where `x` and `y` are flags, Greater is logical OR.

While Greater and `or` are synonyms, it helps readers to apply `or` only and wherever flag arguments are expected. 
There is no performance implication.


## Dictionaries and keyed tables

Where `x` and `y` are a pair of dictionaries or keyed tables the result is equivalent to upserting `y` into `x` where the values of `y` exceed those in `x`.

```q
q)show a:([sym:`ibm`msoft`appl`goog]t:2017.05 2017.09 2015.03 2017.11m)
sym  | t
-----| -------
ibm  | 2017.05
msoft| 2017.09
appl | 2015.03
goog | 2017.11

q)show b:([sym:`msoft`goog`ibm]t:2017.08 2017.12 2016.12m)
sym  | t
-----| -------
msoft| 2017.08
goog | 2017.12
ibm  | 2016.12
q)a|b
sym  | t
-----| -------
ibm  | 2017.05
msoft| 2017.09
appl | 2015.03
goog | 2017.12
```


## Mixed types

Where `x` and `y` are of different types the greater of their underlying values is returned as the higher of the two types.

```q
q)98|"a"
"b"
```


## :fontawesome-solid-sitemap: Implicit iteration

Greater and `or` are [atomic functions](../basics/atomic.md).

```q
q)(10;20 30)|(2;3 4)
10
20 30
```

## Domain and range

```txt
|| b g x h i j e f c s p m d z n u v t
-| -----------------------------------
b| b . x h i j e f c . p m d z n u v t
g| . . . . . . . . . . . . . . . . . .
x| x . x h i j e f c . p m d z n u v t
h| h . h h i j e f c . p m d z n u v t
i| i . i i i j e f c . p m d z n u v t
j| j . j j j j e f c . p m d z n u v t
e| e . e e e e e f c . p m d z n u v t
f| f . f f f f f f c . p m d z n u v t
c| c . c c c c c c c . p m d z n u v t
s| . . . . . . . . . . . . . . . . . .
p| p . p p p p p p p . p p p p n u v t
m| m . m m m m m m m . p m d . . . . .
d| d . d d d d d d d . p d d z . . . .
z| z . z z z z z z z . p . z z n u v t
n| n . n n n n n n n . n . . n n n n n
u| u . u u u u u u u . u . . u n u v t
v| v . v v v v v v v . v . . v n v v t
t| t . t t t t t t t . t . . t n t t t
```

Range: `bxhijefcpmdznuvt`

----
:fontawesome-solid-book:
[`&` and Lesser](lesser.md), [`max`](max.md), [`min`](min.md)
<br>
:fontawesome-solid-book-open:
[Comparison](../basics/comparison.md),
[Logic](../basics/logic.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§4.5 Greater and Lesser](/q4m3/4_Operators/#45-greater-and-lesser-amp)
