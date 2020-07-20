---
title: Pad – Reference – kdb+ and q documentation
description: Pad is a q operator that pads a string to a specified length.
author: Stephen Taylor
keywords: fill, dollar, kdb+, pad, q
---
# `$` Pad



Syntax: `x$y`, `$[x;y]` 

Where 

-   `x` is a long
-   `y` a string

returns `y` padded to length `x`.

```q
q)10$"foo"
"foo       "
q)-10$"foo"
"       foo"
```

:fontawesome-regular-hand-point-right: 
Basics: [Strings](../basics/strings.md)  
[`$` dollar](overloads.md#dollar)