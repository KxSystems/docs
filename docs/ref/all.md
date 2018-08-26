# `all`




Syntax: `all x`, `all[x]`

Returns a boolean atom `1b` if all items of `x` are non-zero, and otherwise `0b`. 

It applies to all data types except symbol, first converting the type to boolean if necessary.

`all` is an aggregate function.

```q
q)all 1 2 3=1 2 4
q)all 1 2 3=1 2 3
q)if[all x in y;....]   / use in control structure
```

<i class="far fa-hand-point-right"></i>
[`&` `and`](minimum.md). 
Basics: [Logic](../basics/logic.md)