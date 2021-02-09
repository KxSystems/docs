---
title: neg | Reference | kdb+ and q documentation
description: neg is a q keyword that returns the negation of its argument. 
author: Stephen Taylor
---
# `neg`

_Negate_



```txt
neg x    neg[x]
```

Returns the negation of boolean or numeric `x`. 
A null has no sign, so is its own negation. 

```q
q)neg -1 0 1 2
1 0 -1 -2

q)neg 01001b
0 -1 0 0 -1i

q)neg (0W;-0w;0N)               / infinities and a null
-0W
0w
0N

q)neg 2000.01.01 2012.01.01     / negates the underlying data value
2000.01.01 1988.01.01
```

An atomic function.


## Domain and range

```txt
domain b g x h i j e f c s p m d z n u v t
range  i . i h i j e f i . p m d z n u v t
```

Range: `ihjefpmdznuvt`


---- 
:fontawesome-solid-book:
[`not`](not.md), 
[Subtract](subtract.md) 
<br>
:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§4.3.2 Not Zero `not`](/q4m3//4_Operators/#431-equality-and-disequality)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§4.9.2 Temporal Arithmetic](/q4m3/4_Operators/#492-temporal-arithmetic)
