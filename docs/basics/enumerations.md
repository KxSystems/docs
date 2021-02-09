---
title: Enumerations – Basics – kdb+ and q documentation
description: For a long list containing few distinct values, an enumeration can reduce storage requirements. 
keywords: enumerate, enumeration, enumerations, extend, kdb+, q
---
# Enumerations





For a long list containing few distinct values, an enumeration can reduce storage requirements. The ‘manual’ way to create an enum (for understanding, not recommended):

```q
q)y:`a`b`c`b`a`b`c`c`c`c`c`c`c
q)x:`a`b`c
q)show e:"i"$x?y;
0 1 2 1 0 1 2 2 2 2 2 2 2i  /these values are what we store instead of y.
q)x e                       /get back the symbols any time from x and e.
`a`b`c`b`a`b`c`c`c`c`c`c`c
q)`x!e / same result as `x$y 
`x$`a`b`c`b`a`b`c`c`c`c`c`c`c
```

Create, extend and resolve enumerations using these operators:

operator | name                                 | semantics
---------|--------------------------------------|-----------------------
`$`      | [Enumerate](../ref/enumerate.md)     | create an enumeration
`?`      | [Enum Extend](../ref/enum-extend.md) | extend an enumeration
`!`      | [Enumeration](../ref/enumeration.md) | resolve values from an enumeration


:fontawesome-solid-street-view: 
_Q for Mortals_
[§7.5 Enumerations](/q4m3/7_Transforming_Data/#75-enumerations)  
