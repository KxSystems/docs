---
keywords: dollar, enumerate, list, kdb+, q, vector
---

# `$` Enumerate


Syntax: `x$y`, `$[x;y]`

Where 

-   `x` and `y` are lists
-   `x~distinct x`
-   items of `y` are all items of `x`

returns `y` as an enumeration of `x`.
Using built-in Enumerate:

```q
q)show e:`x$y;
`x$`a`b`c`b`a`b`c`c`c`c`c`c`c
```

Values are stored as indexes and so need less space.

```q
q)"i"$e
0 1 2 1 0 1 2 2 2 2 2 2 2i
```

Changing one lookup value (in `x`) has the same effect as changing those values in the enumeration, while the indexes backing `e` are unchanged.

```q
q)x[0]:`o
q)e
x$`o`b`c`b`o`b`c`c`c`c`c`c`c
q)"i"$e
0 1 2 1 0 1 2 2 2 2 2 2 2i
```

To get `x` and `y` from `e`:

```q
q)(key;value)@\:e
`x
`o`b`c`b`o`b`c`c`c`c`c`c`c
```

!!! tip "Ensure all items of `y` are in `x`"

When creating an enumeration using `$`, the domain of the enumeration must be in `x`, otherwise a cast error will be signalled.

```q
q)y:`a`b`c`b`a`b`c`c`c`c`c`c`c
q)x:`a`b
q)`x$y
'cast
```

To expand the domain, use [`?` (Enum Extend)](enum-extend.md) instead of `$`.


## Errors

error | cause
------|--------------------------
cast  | item/s of `y` not in `x`


<i class="far fa-hand-point-right"></i> 
[Enum Extend](enum-extend.md),
[Enumeration](enumeration.md)  
Basics: [Enumerations](../basics/enumerations.md)  
_Q for Mortals:_ [§7.5 Enumerations](/q4m3/7_Transforming_Data/#75-enumerations)  
[`$` dollar](overloads.md#dollar)  


