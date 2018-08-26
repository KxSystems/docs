# `!` Enumeration



_Enumerated symbol list._

Syntax: `x!y`, `![x;y]`

Where 

-   `x` is a handle to a symbol list
-   `y` is an int vector in the domain `til count x`

returns an enumerated symbol list.
Enumeration is a uniform function.

```q
q)x:`a`b`c`d
q)`x!1 2 3
`x$`b`c`d
```


<i class="far fa-hand-point-right"></i> 
[Enumerations](../basics/enumerations.md),
[Enum Extend](enum-extend.md),
[Enumeration](enumeration.md),
_Q for Mortals:_ [§7.5 Enumerations](http://code.kx.com/q4m3/7_Transforming_Data/#75-enumerations), 
[`!` Bang](operators.md#bang)


