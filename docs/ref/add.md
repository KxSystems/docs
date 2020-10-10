---
title: Add | Reference | kdb+ and q documentation
description: A q operator that returns the sum of two numeric, boolean or temporal arguments
keywords: add, kdb+, mathematics, plus, q, sum
---
# `+` Add


```txt
x+y     +[x;y]
```

Where `x` and `y` are numerics or temporals, returns their 
sum.

```q
q)2+3 4 5
5 6 7

q)2000.11.22 + 03:44:55.666  / date + time
2000.11.22T03:44:55.666

q)5+`a`b`c!100 200 300       / int + dict
a| 105
b| 205
c| 305

q)([sym:`ibm`goog`msoft]qty:1000 2000 3000;p:1550 375 98)+5  / table + int
sym  | qty  p
-----| ---------
ibm  | 1005 1555
goog | 2005 380
msoft| 3005 103
```

Add is generally faster than [Subtract](subtract.md).


## :fontawesome-solid-sitemap: Implicit iteration

Add is an [atomic function](../basics/atomic.md).

```q
q)(10;20 30)+(2;3 4)
12
23 34
```

It applies to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).

```q
q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 -21 3;4 5 -6)

q)d+10
a| 20 -11 13
b| 14 15  4

q)d+`b`c!(10 20 30;1000*1 2 3)  / upsert semantics
a| 10   -21  3
b| 14   25   24
c| 1000 2000 3000

q)t+100
a   b
-------
110 104
79  105
103 94

q)k+k
k  | a   b
---| -------
abc| 20  8
def| -42 10
ghi| 6   -12
```


### Range and domains

```txt
    b g x h i j e f c s p m d z n u v t
----------------------------------------
b | i . i i i j e f . . p m d z n u v t
g | . . . . . . . . . . . . . . . . . .
x | i . i i i j e f . . p m d z n u v t
h | i . i i i j e f . . p m d z n u v t
i | i . i i i j e f . . p m d z n u v t
j | j . j j j j e f . . p m d z n u v t
e | e . e e e e e f . . p m d z n u v t
f | f . f f f f f f f . f f z z f f f f
c | . . . . . . . f . . p m d z n u v t
s | . . . . . . . . . . . . . . . . . .
p | p . p p p p p f p . n . . . p p p p
m | m . m m m m m f m . . i . . p p p p
d | d . d d d d d z d . . . i . p p p p
z | z . z z z z z z z . . . . f p z z z
n | n . n n n n n f n . p p p p n n n n
u | u . u u u u u f u . p p p z n u v t
v | v . v v v v v f v . p p p z n v v t
t | t . t t t t t f t . p p p z n t t t
```

Range: `defijmnptuvz`


----
:fontawesome-solid-book:
[Subtract](subtract.md),
[`sum`](sum.md),
[`.Q.addmonths`](dotq.md#qaddmonths)
<br>
:fontawesome-solid-book-open:
[Datatypes](../basics/datatypes.md),
[Mathematics](../basics/math.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§4.9.2 Temporal Arithmetic](/q4m3/4_Operators/#492-temporal-arithmetic)

