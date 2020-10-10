---
title: Multiply | Reference | kdb+ and q documentation
description: Multiply is a q operator that returns the product of its arguments.
author: Stephen Taylor
---
# `*` Multiply




```txt
x*y     *[x;y]
```

Where `x` and `y` are [conformable](../basics/conformable.md) numerics or temporals, returns their 
product.

```q
q)3 4 5*2.2
6.6 8.8 11

q)1.1*`a`b`c!5 10 20
a| 5.5
b| 11
c| 22

q)t:([]price:10 20 30;qty:200 150 17)
q)t*\:1.15 1 /raise all prices 15%
price qty
---------
11.5  200
23    150
34.5  17

q)update price:price*1+.15*qty<50 from t /raise prices 15% where stock<50
price qty
---------
10    200
20    150
34.5  17
```


## :fontawesome-solid-sitemap: Implicit iteration

Multiply is an [atomic function](../basics/atomic.md).

```q
q)(10;20 30)*(2;3 4)
20
60 120
```

It applies to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).

```q
q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 -21 3;4 5 -6)

q)d*2
a| 20 -42 6
b| 8  10  -12

q)d*`b`c!(10 20 30;1000*1 2 3)  / upsert semantics
a| 10   -21  3
b| 40   100  -180
c| 1000 2000 3000

q)t*100
a     b
----------
1000  400
-2100 500
300   -600

q)k*k
k  | a   b
---| ------
abc| 100 16
def| 441 25
ghi| 9   36
```


## Range and domains

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
p | p . p p p p p f p . . . . . . . . .
m | m . m m m m m f m . . . . . . . . .
d | d . d d d d d z d . . . . . . . . .
z | z . z z z z z z z . . . . . . . . .
n | n . n n n n n f n . . . . . . . . .
u | u . u u u u u f u . . . . . . . . .
v | v . v v v v v f v . . . . . . . . .
t | t . t t t t t f t . . . . . . . . .
```

Range: `defijmnptuvz`

----
:fontawesome-solid-book:
[Divide](divide.md),
[`prd`, `prds`](prd.md),
[`.Q.addmonths`](dotq.md#qaddmonths)
<br>
:fontawesome-solid-book-open:
[Datatypes](../basics/datatypes.md),
[Mathematics](../basics/math.md)

