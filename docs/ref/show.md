---
title: show
description: show is a q keyword that formats its argument and displays it at the console.
author: Stephen Taylor
keywords: console, debug, develop, display, kdb+, q, tool
---
# `show`



_Format and display at the console._

Syntax: `show x`, `show[x]` 

Formats `x` and writes it to the console; returns the identity function `(::)`.

```q
q)a:show til 5
0 1 2 3 4
q)a~(::)
1b
```

!!! tip "Display intermediate values"

    <pre><code class="language-q">
    q)f:{a:x<5;sum a}
    q)f 2 3 5 7 3
    3
    q)f:{show a:x<5;sum a}    / same function, showing value of a
    q)f 2 3 5 7 3
    11001b
    3
    </code></pre>


<i class="far fa-hand-point-right"></i> 
[Display](display.md)  
Basics: [Debugging](../basics/debug.md)