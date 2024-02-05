---
title: flip – transpose a matrix or column disctionary | Reference | kdb+ and q documentation
description: flip is a q keyword that transposes its argument.
author: Stephen Taylor
---
# `flip`



```syntax
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

The flip of a dictionary is a table, and vice versa. If `x` is a dictionary where the keys are a list of symbols, and the values are lists of the same count (or atoms), then `flip x` returns a table.

The flip of a table is a dictionary.

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

If an atom(s) are provided, they are extended to match the length of the list(s).

```q
q)flip (1 2 3;4)
1 4
2 4
3 4
q)flip `sym`price`size!(`I;10.2 23.45 45.67;100)
sym price size
--------------
I   10.2  100
I   23.45 100
I   45.67 100
```

