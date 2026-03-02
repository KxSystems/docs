---
title: show – Reference – KDB-X and q documentation
description: show is a q keyword that formats its argument and displays it at the console.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: console, debug, develop, display, KDB-X, q, tool
---
# `show`



_Format and display at the console._

```syntax
show x    show[x]
```

Formats `x` and writes it to the console; returns the identity function `(::)`.

```q
q)a:show til 5
0 1 2 3 4
q)a~(::)
1b
```

!!! tip "Display intermediate values"

    ```q
    q)f:{a:x<5;sum a}
    q)f 2 3 5 7 3
    3
    q)f:{show a:x<5;sum a}    / same function, showing value of a
    q)f 2 3 5 7 3
    11001b
    3
    ```



[Display](display.md)
<br>

[Debugging](../how_to/working-with-code/debug.md)