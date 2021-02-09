---
title: not | Reference | kdb+ and q documentation
description: not is a q keyword that flags whether its argument is false.
author: Stephen Taylor
keywords: false, kdb+, logic, not, q, true
---
# `not`



_Not zero_

Syntax: `not x` 

Returns `0b` where `x` **not** equal to zero, and `1b` otherwise.

Applies to all data types except symbol, and to items of lists, dictionary values and table columns, referring to the underlying data value.

Nulls and infinities never equal zero.

```q
q)not -1 0 1 2
0100b

q)not "abc","c"$0
0001b

q)not `a`b!(-1 0 2;"abc","c"$0)
a| 010b
b| 0001b

q)not 2000.01.01 2020.06.30
10b

q)not 00:00:00
1b

q)not 12:00:00.000000000
0b

q)not (0W;-0w;0N)
000b
```

An atomic function. 


:fontawesome-solid-book:
[`neg`](neg.md) 
<br>
:fontawesome-solid-book-open:
[Logic](../basics/by-topic.md#logic)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§4.3.2 Not Zero `not`](/q4m3//4_Operators/#431-equality-and-disequality)
