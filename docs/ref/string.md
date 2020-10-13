---
title: string casts its argument to a string | Reference | kdb+ and q documentation
description: string is a q keyword that casts its argument to a string.
author: Stephen Taylor
---
# `string`

_Cast to string_




```txt
string x    string[x]
```

Returns `x` as a string.  Applies to all datatypes.

```q
q)string `ibm
"ibm"
q)string 2
,"2"
q)string {x*x}
"{x*x}"
q)string (+/)
"+/"
```


## Implicit iteration

`string` is an [atomic function](../basics/atomic.md) and iterates through dictionaries and tables.

```q
q)string (2 3;"abc")
(,"2";,"3")
(,"a";,"b";,"c")

q)string "cat"        / not the no-op you might expect
,"c"
,"a"
,"t"

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


## Domain and range

```txt
domain b g x h i j e f c s p m d z n u v t
range  c c c c c c c c c c c c c c c c c c
```

Range: `c`

----
:fontawesome-solid-book: 
[`.h` namespace](doth.md)
<br>
:fontawesome-solid-book: 
[`.Q.addr`](dotq.md#qaddr-ip-address) (IP address),
[`.Q.f`](dotq.md#qf-format) (format),
[`.Q.fmt`](dotq.md#qfmt-format) (format)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§7.3.1 Data to Strings](/q4m3/7_Transforming_Data/#731-data-to-strings)



