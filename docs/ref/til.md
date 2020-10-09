---
title: til returns the first natural numbers | Reference | kdb+ and q documentation
description: til is a q keyword that returns the natural numbers up to its argument.
author: Stephen Taylor
---
# `til`




_First x natural numbers_ 

```txt
til x    til[x]
```

Where `x` is a non-negative integer atom, returns a vector of the first `x` integers. 

```q
q)til 0
`long$()
q)til 1b
,0
q)til 5
0 1 2 3 4
q)til 5f
'type
  [0]  til 5f
       ^
```

`til` and [`key`](key.md) are synonyms, but the above usage is conventionally reserved to `til`.

----
:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)
