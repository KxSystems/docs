---
title: div
description: div is a q keyword that performs integer division. 
author: Stephen Taylor
keywords: div, divide, division, in, integer, kdb+, math, mathematics, q
---
# `div`




_Integer division_

Syntax: `x div y`, `div[x;y]` 

Integer division: returns the greatest whole number that does not exceed `x%y`.
```q
q)7 div 3
2
```

<!-- FIXME Examples with dictionaries and tables -->
Except for char, byte, short, and real, preserves the type of the first argument.

```q
q)7f div 2
3f
q)6i div 4
1i
q)2014.10.13 div 365
2000.01.15
```

The exceptions are char, byte, short, and real, which get converted to ints.

```q
q)7h div 3
2i
q)0x80 div 16
8i
q)"\023" div 8
2i
```


## Domain and range
```txt
div| b g x h i j e f c s p m d z n u v t
---| -----------------------------------
b  | i . i i i i i i i . i i i i i i i i
g  | . . . . . . . . . . . . . . . . . .
x  | i . i i i i i i i . i i i i i i i i
h  | i . i i i i i i i . i i i i i i i i
i  | i . i i i i i i i . i i i i i i i i
j  | j . j j j j j j j . j j j j j j j j
e  | f . f f f f f f f . f f f f f f f f
f  | f . f f f f f f f . f f f f f f f f
c  | i . i i i i i i i . i i i i i i i i
s  | . . . . . . . . . . . . . . . . . .
p  | p . p p p p p p p . p p p p p p p p
m  | m . m m m m m m m . m m m m m m m m
d  | d . d d d d d d d . d d d d d d d d
z  | z . z z z z z z z . z z z z z z z z
n  | n . n n n n n n n . n n n n n n n n
u  | u . u u u u u u u . u u u u u u u u
v  | v . v v v v v v v . v v v v v v v v
t  | t . t t t t t t t . t t t t t t t t
```

Range: `ijfpmdznuvt`

<i class="far fa-hand-point-right"></i> 
[`%` Divide](divide.md), [`reciprocal`](reciprocal.md)  
Basics: [Mathematics](../basics/math.md)


