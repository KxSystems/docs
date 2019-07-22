---
title: Divide
description: Divide is a q operator that returns the ratio of its arguments.
author: Stephen Taylor
keywords: div, divide, division, divisor,kdb+, math, mathematics, numerator, percent, q, ratio
---
# `%` Divide





Syntax: `x%y`, `%[x;y]` 

Where `x` and `y` are conformable numerics or (both) timespans, returns their ratio as a float. 

Note that this is different from some other programming languages, e.g. C++.

```q
q)2%3
0.6666667
q)halve:%[;2]                              /projection
q)halve til 5
0 0.5 1 1.5 2
q)(`a`b`c!100 200 300)%2                   /dictionary
a| 50
b| 100
c| 150
q)t:([]price:10 20 30;qty:200 150 17)
q)t%\:1 2                                  /halve the quantities
price qty
---------
10    100
20    75
30    8.5
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

Divide is an atomic function. 


## Range and domains

Both domains are `b g x h i j e f c s p m d z n u v t`.

The result is always a float.

<i class="far fa-hand-point-right"></i> 
[`div`](div.md), 
[`ratios`](ratios.md)  
Basics: [Mathematics](../basics/math.md)  
_Q for Mortals_: [§4.4 Basic Arithmetic](/q4m3/4_Operators/#44-basic-arithmetic-)


## Errors

error  | cause
-------|--------------------------------------------------
length | the arguments are not conformable
type   | an atom of an argument is not numeric or temporal