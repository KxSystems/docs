---
title: Flag nulls in a list or dictionary | Reference | kdb+ and q documentation
description: null is a q keyword that flags where its argument is null.
author: Stephen Taylor
---
# `null`





_Is null_

```txt
null x     null[x]
```

Returns `1b` where `x` is null.

Applies to all data types except enums, and to items of lists, dict values and table columns.

`null` is an atomic function.

```q
q)null 0 0n 0w 1 0n
01001b

q)where all null ([] c1:`a`b`c; c2:0n 0n 0n; c3:10 0N 30)
,`c2
```

Enums always show as non-null.

```q
q)a:``a
q)`=`a$`            / non-enumerated and enumerated null symbol show as equivalent
1b
q)null`             / null symbol behaves as expected
1b
q)null`a$`          / enumeration of null symbol does not
0b
```

The intention was not to have nulls in the enums. That value is used to indicate _out of range_. (Think of them as a way to represent foreign keys.) To test for an enumeration backed by a null symbol, one can use the equality test – but at the cost of CPU cycles:

```q
q)a:10000000?`8
q)v:`a$a
q)\ts null v
18 16777344
q)\ts `=v
66 268435648
```


