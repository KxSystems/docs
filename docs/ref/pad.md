---
title: Pad a string to a specified length | Reference | kdb+ and q documentation
description: Pad is a q operator that pads a string to a specified length.
author: Stephen Taylor
---
# `$` Pad


```txt
x$y    $[x;y]
```

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


----
:fontawesome-solid-book:
[dollar](overloads.md#dollar)
<br>
:fontawesome-solid-book-open:
[Strings](../basics/strings.md)  