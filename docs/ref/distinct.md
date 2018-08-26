# `distinct`



Syntax: `distinct x`, `distinct[x]`  
Syntax: `(?)x`, `?[x]` (deprecated)

Returns the distinct (unique) items of `x` in the order of their first occurrence.
```q
q)distinct 2 3 7 3 5 3
2 3 7 5
```
Returns the distinct rows of a table.
```q
q)distinct flip `a`b`c!(1 2 1;2 3 2;"aba")
a b c
-----
1 2 a
2 3 b
```
It does not use [comparison tolerance](/basics/precision)
```q
q)\P 14
q)distinct 2 + 0f,10 xexp -13
2 2.0000000000001
```
<i class="far fa-hand-point-right"></i> 
[`.Q.fu`](dotq/#qfu-apply-unique) (apply unique)


## Errors

error | cause
------|----------------
rank  | `x` is an atom