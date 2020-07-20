---
title: string – Reference – kdb+ and q documentation
description: string is a q keyword that casts its argument to a string.
author: Stephen Taylor
keywords: kdb+, q , string, text
---
# `string`

_Cast to string_





Syntax: `string x`, `string[x]` 

Returns each item in list or atom `x` as a string; applies to all data types.

```q
q)string `ibm`goog
"ibm"
"goog"
q)string 2 7 15
,"2"
,"7"
"15"
q)string (2 3;"abc")
(,"2";,"3")
(,"a";,"b";,"c")
```

It applies to the values of a dictionary, and the columns of a table:

```q
q)string `a`b`c!2002 2004 2010
a| "2002"
b| "2004"
c| "2010"
q)string ([]a:1 2 3;b:`ibm`goog`aapl)
a    b
-----------
,"1" "ibm"
,"2" "goog"
,"3" "aapl"
```

:fontawesome-solid-street-view:
_Q for Mortals_
[§7.3.1 Data to Strings](/q4m3/7_Transforming_Data/#731-data-to-strings)


## Domain and range 

```txt
domain b g x h i j e f c s p m d z n u v t
range  c c c c c c c c c c c c c c c c c c
```

Range: `c`


:fontawesome-regular-hand-point-right: 
Namespace [`.h`](doth.md)  
.Q: [`.Q.addr`](dotq.md#qaddr-ip-address) (IP address), 
[`.Q.f`](dotq.md#qf-format) (format), 
[`.Q.fmt`](dotq.md#qfmt-format) (format)


