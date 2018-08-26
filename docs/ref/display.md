---
title : Display
keywords: console, debug, display, kdb+
---

# ! Display


_Write to console and return._

Syntax: `0N!x`

Returns `x` after printing its unformatted text representation to the console. 
```q
q)2+0N!3
3
5
```
Useful for debugging, or avoiding formatting that obscures the data’s structure.

<i class="far fa-hand-point-right"></i> 
[Debugging](../basics/debug.md),
[`show`](show.md)