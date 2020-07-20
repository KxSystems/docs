---
title: lower, upper – Reference – kdb+ and q documentation
description: lower and upper are q keywords that shift text to lower or upper case respectively. 
author: Stephen Taylor
keywords: case, kdb+, lower, q, string, text, upper
---
# `lower`, `upper`

_Shift case_





## `lower`

_Lower case_

Syntax: `lower x`, `lower[x]`

Returns symbol or string `x` with any bicameral characters in the lower case. 

```q
q)lower"IBM"
"ibm"
q)lower`IBM
`ibm
```


## `upper`

_Upper case_

Syntax: `upper x`, `upper[x]`

Returns symbol or string `x` with any bicameral characters in the upper case. 

```q
q)upper"ibm"
"IBM"
q)upper`ibm
`IBM
```


:fontawesome-regular-hand-point-right: 
Basics: [Strings](../basics/strings.md)