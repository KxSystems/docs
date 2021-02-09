---
title: flip – transpose a matrix or column disctionary | Reference | kdb+ and q documentation
description: flip is a q keyword that transposes its argument.
author: Stephen Taylor
---
# `flip`



```txt
flip x     flip[x]
```

Returns `x` transposed, where `x` may be a list of lists, a dictionary or a table. 

In a list of lists, each list must be the same length.

```q
q)flip (1 2 3;4 5 6)
1 4
2 5
3 6
```

The flip of a dictionary is a table, and vice versa. If `x` is a dictionary where the keys are a list of symbols, and the values are lists of the same count (or atoms), then `flip x` will return a table. The flip of a table is a dictionary.

```q
q)D:`sym`price`size!(`IBM`MSFT;10.2 23.45;100 100)
q)flip D
sym  price size
---------------
IBM  10.2  100
MSFT 23.45 100
q)D~flip flip D
1b
```


