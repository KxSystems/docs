# `raze`



Syntax: `raze x`, `raze[x]`

_Return the items of `x` joined, collapsing one level of nesting._

To collapse all levels, use [Converge](progressors.md#converge) i.e. `raze/[x]`.

```q
q)raze (1 2;3 4 5)
1 2 3 4 5
q)b:(1 2;(3 4;5 6);7;8)
q)raze b                 / flatten one level
1
2
3 4
5 6
7
8
q)raze/[b]               / flatten all levels
1 2 3 4 5 6 7 8
q)raze 42                / atom returned as a list
,42
```

Returns the flattened values from a dictionary.

```q
q)d:`q`w`e!(1 2;3 4;5 6)
q)value d
1 2
3 4
5 6
q)raze d
1 2 3 4 5 6
```

!!! warning "Use only on items that can be joined"

`raze` is the extension `,/` (Join Over) and requires items that can be joined together. 

```q
q)d:`a`b!(1 2;3 5)
q)10,d          / cannot join integer and dictionary
'type
q)raze (10;d)   / raze will not work
'type
```


<i class="far fa-hand-point-right"></i>
[Join](join.md)