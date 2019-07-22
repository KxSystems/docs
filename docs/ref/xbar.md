---
title: xbar
description: xbar is a q keyword that returns one argument rounded down to the nearest multiple of the other. 
author: Stephen Taylor
keywords: bar, group, interval, kdb+, math, mathematics, q, xbar
---
# `xbar`



_Round down_

Syntax: `x xbar y`, `xbar[x;y]`

Where

-   `x` is a numeric atom
-   `y` is numeric or temporal

returns `y` rounded down to the nearest multiple of `x`.

```q
q)3 xbar til 16
0 0 0 3 3 3 6 6 6 9 9 9 12 12 12 15
q)2.5 xbar til 16
0 0 0 2.5 2.5 2.5 5 5 5 7.5 7.5 7.5 10 10 10 12.5
q)5 xbar 11:00 + 0 2 3 5 7 11 13
11:00 11:00 11:00 11:05 11:05 11:10 11:10
```

`xbar` is an atomic function. 

Interval bars are useful in aggregation queries. To get last price and total size in 10-minute bars:

```q
q)select last price, sum size by 10 xbar time.minute from trade where sym=`IBM
minute| price size
------| -----------
09:30 | 55.32 90094
09:40 | 54.99 48726
09:50 | 54.93 36511
10:00 | 55.23 35768
...
```

Group symbols by closing price:

```q
q)select sym by 5 xbar close from daily where date=last date
close| sym
-----| ----------------------
25   | `sym$`AIG`DOW`GOOG`PEP,...
30   | `sym$,`AAPL,...
45   | `sym$`HPQ`ORCL,...
...
```

!!! tip "Grouping at irregular intervals"

    To group at irregular intervals, one solution is to use [`bin`](bin.md).

    <pre><code class="language-q">
    q)x:\`s#10:00+00:00 00:08 00:13 00:27 00:30 00:36 00:39 00:50
    q)select count i by x x bin time.minute from ([]time:\`s#10:00:00+asc 100?3600)
    minute| x 
    ------| --
    10:00 | 8 
    10:08 | 13
    10:13 | 24
    10:27 | 4 
    10:30 | 9 
    10:36 | 3 
    10:39 | 19
    10:50 | 20
    </code></pre>


!!! warning "Duplicate keys or column names"

    Duplicate keys in a dictionary or duplicate column names in a table will cause sorts and grades to return unpredictable results.


## Domain and range

```txt
xbar| b g x h i j e f c s p m d z n u v t
----| -----------------------------------
b   | i . i i i j f f i . p m d z n u v t
g   | . . . . . . . . . . . . . . . . . .
x   | i . i i i j f f i . p m d z n u v t
h   | i . i i i j f f i . p m d z n u v t
i   | i . i i i j f f i . p m d z n u v t
j   | j . j j j j f f j . p m d z n u v t
e   | e . e e e e f f e . p m d z n u v t
f   | f . f f f f f f f . f f z z f f f f
c   | . . . . . . f f . . p m d z n u v t
s   | . . . . . . . . . . . . . . . . . .
p   | p . p p p p f f p . . . . . . . . .
m   | m . m m m m f f m . . . . . . . . .
d   | d . d d d d z z d . . . . . . . . .
z   | z . z z z z z z z . . . . . . . . .
n   | j . j j j j f f j . p m d z n u v t
u   | u . u u u u f f u . . . . . . . . .
v   | v . v v v v f f v . . . . . . . . .
t   | t . t t t t f f t . . . . . . . . .
```

Range: `ijfpmdznuvte`

<i class="far fa-hand-point-right"></i> 
[`bin`](bin.md), [`floor`](floor.md)  
Basics: [Mathematics](../basics/math.md)

