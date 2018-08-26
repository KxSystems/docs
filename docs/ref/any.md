# `any`



Syntax: `any x`, `any[x]`

Returns a boolean atom `1b` if any item of `x` is non-zero, and otherwise `0b`; applies to all data types except symbol, first converting the type to boolean if necessary.

`any` is an aggregate function.

```q
q)any 1 2 3=10 20 4
0b
q)any 1 2 3=1 20 30
1b
q)if[any x in y;....]   / use in control structure
```


<i class="far fa-hand-point-right"></i>
[`all`](all.md), [`max`](max.md), [`min`](min.md)  
Basics: [Logic](../basics/logic.md)