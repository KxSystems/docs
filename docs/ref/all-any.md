---
title: all, any – Reference – kdb+ and q documentation
description: all and any are q keywords that invoke aggregator functions for vectors of flags
author: Stephen Taylor
keywords: all, any, boolean, kdb+, logic, q
---
# `all`, `any`




## `all`

_Everything is true_

Syntax: `all x`, `all[x]`

Returns a boolean atom `0b`; or `1b` where `x` is 

-   a list and all items are non-zero
-   a non-zero atom
-   an empty list

Applies to all datatypes except symbols and GUIDs. 
Strings are [cast](cast.md) to boolean. 

`all` is an aggregate function.

```q
q)all 1 2 3=1 2 4
0b
q)all 1 2 3=1 2 3
1b
q)all "YNYN" / string casts to 1111b
1b
q)all () /no zeros here
1b
q)all 2000.01.01
0b
q)all 2000.01.02 2010.01.02
1b

q)if[all x in y;....]   / use in control structure
```



# `any`

_Something is true_

Syntax: `any x`, `any[x]`

Returns a boolean atom `0b`; or `1b` where `x` is 

-   a list with at least one non-zero item
-   a non-zero atom

Applies to all datatypes except symbols and GUIDs. 
Strings are [cast](cast.md) to boolean. 

`any` is an aggregate function.

```q
q)any 1 2 3=10 20 4
0b
q)any 1 2 3=1 20 30
1b
q)any "YNYN" / string casts to 1111b
1b
q)any () / no non-zeros here
0b
q)any 2000.01.01
0b
q)any 2000.01.01 2000.01.02
1b

q)if[any x in y;....]   / use in control structure
```


<i class="far fa-hand-point-right"></i>
[Cast](cast.md),
[`&` `and`](lesser.md), 
[`|` `or`](greater.md), 
[`max`](max.md), 
[`min`](min.md)  
Basics: [Logic](../basics/logic.md)