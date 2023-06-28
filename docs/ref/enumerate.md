---
title: Enumerate | Reference | kdb+ and q documentation
description: Enumerate is a q operator that returns one list as an enumeration of another.
author: Stephen Taylor
---
# `$` Enumerate



```syntax
x$y    $[x;y]
```

Where

-   `x` is a symbol containing the name of a global variable `d`
-   `d` is a list
-   `y` is a list
-   `d~distinct d`
-   items of `y` are all items of `d`

returns `y` as an enumeration of `d`, using `x` as the name of the enumeration domain.
Using built-in Enumerate:

```q
q)d:`a`b`c
q)y:`a`b`c`b`a`b`c`c`c`c`c`c`c
q)show e:`d$y;
`d$`a`b`c`b`a`b`c`c`c`c`c`c`c
```

Values are stored as indices and so need less space.

```q
q)"i"$e
0 1 2 1 0 1 2 2 2 2 2 2 2i
```

Changing one lookup value (in `d`) has the same effect as changing those values in the enumeration, while the indices backing `e` are unchanged.

```q
q)d[0]:`o
q)e
`d$`o`b`c`b`o`b`c`c`c`c`c`c`c
q)"i"$e
0 1 2 1 0 1 2 2 2 2 2 2 2i
```

To get `x` and `y` from `e`:

```q
q)key e
`d
q)value e
`o`b`c`b`o`b`c`c`c`c`c`c`c
```

!!! tip "Ensure all items of `y` are in `d`"

When creating an enumeration using `$`, the domain of the enumeration must be in `d`, otherwise a cast error is signalled. In this example ``c` is not in the domain:

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
cast  | item/s of `y` not in `d`


---
:fontawesome-solid-book:
[Enum Extend](enum-extend.md),
[Enumeration](enumeration.md),
[`$` dollar](overloads.md#dollar)
<br>
:fontawesome-solid-book-open:
[Enumerations](../basics/enumerations.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§7.5 Enumerations](/q4m3/7_Transforming_Data/#75-enumerations) ,
[§8.5 Foreign Keys and Virtual Columns](/q4m3/8_Tables/#84-foreign-keys-and-virtual-columns)
