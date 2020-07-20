---
title: Subtract | Reference | kdb+ and q documentation
description: Subtract is a q operator that returns the difference of its arguments for a wide range of datatypes.
author: Stephen Taylor
keywords: difference, kdb+, math, mathematics, minus, subtract
---
# `-` Subtract



Syntax: `x-y`, `-[x;y]`

Where `x` and `y` are numerics or temporals, returns their difference/s.

```q
q)3 4 5-2
1 2 3

q)2000.11.22 - 03:44:55.666
2000.11.21D20:15:04.334000000
```

An atomic function.

[Add](add.md) is generally faster than Subtract.
<!-- FIXME Examples with dictionaries and tables -->


## Range and domains

```txt
-| b g x h i j e f c s p m d z n u v t
-| -----------------------------------
b| i . i i i j e f i . p m d z n u v t
g| . . . . . . . . . . . . . . . . . .
x| i . i i i j e f i . p m d z n u v t
h| i . i i i j e f i . p m d z n u v t
i| i . i i i j e f i . p m d z n u v t
j| j . j j j j e f j . p m d z n u v t
e| e . e e e e e f e . p m d z n u v t
f| f . f f f f f f f . f f z z f f f f
c| . . . . . . . f . . p m d z n u v t
s| . . . . . . . . . . . . . . . . . .
p| p . p p p p p f p . n . . . p p p p
m| m . m m m m m f m . . i . . p p p p
d| d . d d d d d z d . . . i . p p p p
z| z . z z z z z z z . . . . f p z z z
n| n . n n n n n f n . p p p p n n n n
u| u . u u u u u f u . p p p z n u v t
v| v . v v v v v f v . p p p z n v v t
t| t . t t t t t f t . p p p z n t t t
```

Range: `ijefpmdznuvt`

:fontawesome-regular-hand-point-right: 
[Add](add.md), 
.Q: [`.Q.addmonths`](dotq.md#qaddmonths)  
Basics: [Datatypes](../basics/datatypes.md), 

:fontawesome-solid-book: 
[Add](add.md), 
[`deltas`](deltas.md),
[`differ`](differ.md),
[`.Q.addmonths`](dotq.md#qaddmonths) 
<br>
:fontawesome-solid-book-open:
[Datatypes](../basics/datatypes.md),
[Mathematics](../basics/math.md)
<br>
:fontawesome-solid-graduation-cap:
[How to handle temporal data in q](../kb/temporal-data.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§4.9.2 Temporal Arithmetic](/q4m3/4_Operators/#492-temporal-arithmetic)


