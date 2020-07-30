---
title: Enumeration | Reference | kdb+ and q documentation
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


:fontawesome-solid-book:
[Enum Extend](enum-extend.md),
[Enumerate](enumerate.md),
[`!` bang](overloads.md#bang)
<br>
:fontawesome-solid-book-open:
[Enumerations](../basics/enumerations.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§7.5 Enumerations](/q4m3/7_Transforming_Data/#75-enumerations),
[§8.5 Foreign Keys and Virtual Columns](/q4m3/8_Tables/#84-foreign-keys-and-virtual-columns)

