---
title: Pad strings to a specified length | Reference | kdb+ and q documentation
description: Pad is a q operator that pads a string or list of strings to a specified length
author: Stephen Taylor
---
# `$` Pad


```txt
x$y    $[x;y]
```

Where 

-   `x` is a long
-   `y` is a string

returns `y` padded to length `x`.

```q
q)9$"foo"
"foo      "
q)-9$"foo"
"      foo"
```


## Implicit iteration

Pad is [string-atomic](../basics/atomic.md#string-atomic) and applies to dictionaries and tables.

```q
q)9$("The";("fox";("jumps";"over"));("the";"dog"))      / string-atomic
"The      "
("fox      ";("jumps    ";"over     "))
("the      ";"dog      ")

q)-9$`a`b`c!("quick";"brown";"fox")                     / dictionary
a| "    quick"
b| "    brown"
c| "      fox"

q)-9$string([]a:`quick`brown`fox;b:`jumps`over`the)     / table
a           b
-----------------------
"    quick" "    jumps"
"    brown" "     over"
"      fox" "      the"

```

!!! warning "With a short left argument `$` is Cast."

```q
q)9$("quick";"brown";"fox")
"quick    "
"brown    "
"fox      "

q)9h$("quick";"brown";"fox")
113 117 105 99 107f
98 114 111 119 110f
102 111 120f
```

:fontawesome-solid-book:
[Overloads of dollar](overloads.md#dollar)


----
:fontawesome-solid-book-open:
[Strings](../basics/by-topic.md#strings)  