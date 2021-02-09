---
title: Lesser, and | Reference | kdb+ and q documentation
description: Lesser is a q operator that returns the lesser of its arguments. and is a q keyword that performs a logical AND.
author: Stephen Taylor
---
# `&` Lesser, `and`




_Lesser of two values; logical AND_

```txt
x & y         &[x;y]
x and y       and[x;y]
```

Returns the [lesser](../basics/comparison.md) of the underlying values of `x` and `y`.

```q
q)2&3
2
q)1010b and 1100b  /logical AND with booleans
1000b
q)"sat"&"cow"
"cat"
```


## Flags

Where `x` and `y` are both [flags](../basics/glossary.md#flag), Lesser is logical AND.

!!! tip "Use `and` for flags"

    While Lesser and `and` are synonyms, it helps readers to apply `and` only and wherever flag arguments are expected. 

    There is no performance implication.


## Dictionaries and keyed tables

Where `x` and `y` are a pair of dictionaries or keyed tables their minimum is equivalent to upserting `y` into `x` where the values of `y` are less than those in `x`.

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
q)a&b
sym  | t
-----| -------
ibm  | 2016.12
msoft| 2017.08
appl | 2015.03
goog | 2017.11
```


## Mixed types

Where `x` and `y` are of different types the lesser of their underlying values is returned as the higher of the two types.

```q
q)98&"c"
"b"
```


## :fontawesome-solid-sitemap: Implicit iteration

Lesser and `and` are [atomic functions](../basics/atomic.md).

```q
q)(10;20 30)&(2;3 4)
2
3 4
```

They apply to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).

```q
q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 -21 3;4 5 -6)

q)d&5
a| 5 -21 3
b| 4 5   -6

q)d&`b`c!(10 20 30;1000*1 2 3)  / upsert semantics
a| 10   -21  3
b| 4    5    -6
c| 1000 2000 3000

q)t&5
a   b
------
5   4
-21 5
3   -6

q)k&5
k  | a   b
---| ------
abc| 5   4
def| -21 5
ghi| 3   -6
```




## Domain and range

```txt
    b g x h i j e f c s p m d z n u v t
----------------------------------------
b | b . x h i j e f c . p m d z n u v t
g | . . . . . . . . . . . . . . . . . .
x | x . x h i j e f c . p m d z n u v t
h | h . h h i j e f c . p m d z n u v t
i | i . i i i j e f c . p m d z n u v t
j | j . j j j j e f c . p m d z n u v t
e | e . e e e e e f c . p m d z n u v t
f | f . f f f f f f c . p m d z n u v t
c | c . c c c c c c c . p m d z n u v t
s | . . . . . . . . . . . . . . . . . .
p | p . p p p p p p p . p p p p n u v t
m | m . m m m m m m m . p m d . . . . .
d | d . d d d d d d d . p d d z . . . .
z | z . z z z z z z z . p . z z n u v t
n | n . n n n n n n n . n . . n n n n n
u | u . u u u u u u u . u . . u n u v t
v | v . v v v v v v v . v . . v n v v t
t | t . t t t t t t t . t . . t n t t t
```

Range: `bcdefhijmnptuvxz`

----
:fontawesome-solid-book:
[`or`, `|`, Greater](greater.md),
[`max`](max.md), [`min`](min.md)
<br>
:fontawesome-solid-book-open:
[Comparison](../basics/comparison.md),
[Logic](../basics/by-topic.md#logic)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§4.5 Greater and Lesser](/q4m3/4_Operators/#45-greater-and-lesser-amp)


