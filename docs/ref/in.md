---
keywords: in, kdb+, q, search
---

# `in`



Syntax: `x in y`, `in[x;y]`

Where 

-   `x` is an atom and `y` is a list, returns a boolean indicating whether `x` matches an item of `y`
-   `x` and `y` are both lists and the first item of `y` is an atom, retuns a boolean indficating which items of `x` match items of `y`

`in` is left-uniform: its result conforms to `x`.

```q
q)1 3 7 6 4 in 5 4 1 6        / which of x are in y
10011b
q)1 2 in (9;(1 2;3 4))        / none of x are in y
00b
q)1 2 in (1 2;9)              / 1 2 is an item of y
1b
q)1 2 in ((1 2;3 4);9)        / 1 2 is not an item of y
0b
q)(1 2;3 4) in ((1 2;3 4);9)  / x is an item of y
1b
```

!!! tip "`in` is often used with `select`"

```q
q)\l sp.q
q)select from p where city in `paris`rome
p | name  color weight city
--| ------------------------
p2| bolt  green 17     paris
p3| screw blue  17     rome
p5| cam   blue  12     paris
```


<i class="far fa-hand-point-right"></i> 
[`except`](except.md), 
[`inter`](inter.md), 
[`union`](union.md)  
Basics: [Search](../basics/search.md) 

