---
title: string casts its argument to a string | Reference | KDB-X and q documentation
description: string is a q keyword that casts its argument to a string.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `string`

_Cast to string_

```syntax
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

`string` is an [atomic function](atomic.md) and iterates through dictionaries and tables.

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

[`.h` namespace](doth.md)
<br>

[`.Q.addr`](dotq.md#addr-iphost-as-int) (IP/host as int),
[`.Q.f`](dotq.md#f-precision-format) (precision format),
[`.Q.fmt`](dotq.md#fmt-precision-format) (precision format with length)
<br>

_Q for Mortals_
[§7.3.1 Data to Strings](../learn/q4m/7_Transforming_Data.md/#731-data-to-strings)
