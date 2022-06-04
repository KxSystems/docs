---
title: Shift to lower or upper case | Reference | kdb+ and q documentation
description: lower and upper are q keywords that shift text to lower or upper case respectively.
author: Stephen Taylor
---
# `lower`, `upper`

_Shift case_



```syntax
lower x     lower[x]
upper x     upper[x]
```

Where `x` is a character or symbol atom or vector, returns it with any bicameral characters in the lower/upper case.


```q
q)lower"IBM"
"ibm"
q)lower`IBM
`ibm

q)upper"ibm"
"IBM"
q)upper`ibm`msft
`IBM`MSFT
```

```txt
domain: b g x h i j e f c s p m d z n u v t
range:  . . . . . . . . c s . . . . . . . .
```

## :fontawesome-solid-sitemap: Implicit iteration

`lower` and `upper` are [atomic functions](../basics/atomic.md).

```q
q)upper(`The;(`quick`brown;(`fox;`jumps`over));`a;`lazy`dog)
`THE
(`QUICK`BROWN;(`FOX;`JUMPS`OVER))
`A
`LAZY`DOG
```

----
:fontawesome-solid-book-open:
[Strings](../basics/by-topic.md#strings)