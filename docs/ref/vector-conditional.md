---
title: Vector Conditional
description: Vector Conditional isd a q operator that replaces selected items of one list with corresponding items of another.
author: Stephen Taylor
keywords: condition, item, kdb+, q, vector
---
# `?` Vector Conditional 




_Replace selected items of one list with corresponding items of another_

Syntax: `?[x;y;z]`

Where

-   `x` is a boolean vector
-   `y` and `z` are lists of the same type
-   `x`, `y`, and `z` conform

returns a new list by replacing elements of `y` with the elements of `z` when `x` is false. 

All three arguments are evaluated.

```q
q)?[11001b;1 2 3 4 5;10 20 30 40 50]
1 2 30 40 5
```

If `x`, `y`, or `z` are atomic, they repeated.

```q
q)?[11001b;1;10 20 30 40 50]
1 1 30 40 1
q)?[11001b;1 2 3 4 5;99]
1 2 99 99 5
```

Since V2.7 2010.10.07 `?[x;y;z]` works for atoms too.

It can be useful to have more than just a true/false selection, 
e.g. match1/match2/match3/others mapping to result1/result2/result3/default. This can be achieved with [Find](find.md), e.g.

```q
q)input:10?`m1`m2`m3`other`yetanother
q)input
`yetanother`m1`m3`m2`m3`m2`m3`other`m3`yetanother
q)`r1`r2`r3`default `m1`m2`m3?input
`default`r1`r3`r2`r3`r2`r3`default`r3`default
```
