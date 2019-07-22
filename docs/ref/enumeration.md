---
title: Enumeration
description: Enumeration isd a q operator that returns an enumerated symbol list.
author: Stephen Taylor
keywords: bang, enumerate, enumeration, list, kdb+, q
---
# `!` Enumeration



_Enumerated symbol list_

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
[Enum Extend](enum-extend.md),
[Enumeration](enumeration.md)  
[`!` bang](overloads.md#bang)  
Basics: [Enumerations](../basics/enumerations.md)  
_Q for Mortals:_ [§7.5 Enumerations](/q4m3/7_Transforming_Data/#75-enumerations)


