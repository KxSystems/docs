---
title: Display – Reference – kdb+ and q documentation
description: Display is a q operator that writes a value to the console before returning it.
author: Stephen Taylor
keywords: bang, console, debug, display, kdb+
---
# `!` Display



_Write to console and return_

```syntax
0N!x    ![0N;x]
```

Returns `x` after printing its unformatted text representation to the console. 

```q
q)2+0N!3
3
5
```

Useful for debugging, or avoiding formatting that obscures the data’s structure.

---
:fontawesome-solid-book: 
[`show`](show.md) 
<br>
:fontawesome-solid-book-open: 
[Debugging](../basics/debug.md)