---
title: all, any
description: all and any are q keywords that invoke aggregator functions for vectors of flags
author: Stephen Taylor
keywords: all, any, boolean, kdb+, logic, q
---

# `all`, `any`



## `all`

_Everything is true_

Syntax: `all x`, `all[x]`

Returns a boolean atom `1b` if all items of `x` are non-zero, and otherwise `0b`. 

It applies to all data types except symbol, first converting the type to boolean if necessary.

`all` is an aggregate function.

```q
q)all 1 2 3=1 2 4
q)all 1 2 3=1 2 3
q)if[all x in y;....]   / use in control structure
```



# `any`

_At least something is true_

Syntax: `any x`, `any[x]`

Returns a boolean atom `1b` if any item of `x` is non-zero, and otherwise `0b`. Applies to all data types except symbol, first converting the type to boolean if necessary.

`any` is an aggregate function.

```q
q)any 1 2 3=10 20 4
0b
q)any 1 2 3=1 20 30
1b
q)if[any x in y;....]   / use in control structure
```


<i class="far fa-hand-point-right"></i>
[`&` `and`](lesser.md), 
[`|` `or`](greater.md), 
[`max`](max.md), 
[`min`](min.md)  
Basics: [Logic](../basics/logic.md)