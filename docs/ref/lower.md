---
title: Shift to lower or upper case | Reference | kdb+ and q documentation
description: lower and upper are q keywords that shift text to lower or upper case respectively.
author: Stephen Taylor
---
# `lower`, `upper`

_Shift case_



```txt
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


----
:fontawesome-solid-book-open:
[Strings](../basics/strings.md)