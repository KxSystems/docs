---
title: Match | Reference | kdb+ and q documentation
description: Match is a q operator that flags whether its arguments have the same value.
author: Stephen Taylor
keywords: compare, kdb+, q, value
---
# `~` Match




Syntax: `x ~ y` 

Returns `0b` unless `x` and `y` are identical. [Comparison tolerance](../basics/precision.md#comparison-tolerance) is used when matching floats. 

```q
q)(1 2 3+4 5 6)~4 5 6+1 2 3   / the arguments are identical
1b
q)(1 2 3-4 5 6)~4 5 6-1 2 3   / these are not identical
0b
q)1 2 3 ~`a`b                 / any two data objects can be compared
0b
```

Match depends on the data type of the arguments, not just the values.

```q
q)1~1h
0b
q)3~3.0
0b
```

This means the same symbols from different enumerations do not match, even when equal.

```q
q)l1:`a`b`c
q)l2:`a`b`c
q)(`l1$`a)~`l2$`a
0b
q)(`l1$`a)=`l2$`a
1b
```

Match ignores attributes on lists.

```q
q)1 2 3~`s#1 2 3
1b
```

Two tables match even if they differ in attributes.

```q
q)t1:([]x:1 2 3)
q)t2:([]x:`s#1 2 3)
q)meta t1
c| t f a
-| -----
x| i
q)meta t2
c| t f a
-| -----
x| i   s
q)t1~t2
1b
```

:fontawesome-solid-book: 
[Equal `=`](equal.md), [Not Equal `<>`](not-equal.md)
<br>
:fontawesome-solid-book-open: 
[Comparison](../basics/comparison.md)
<br>
:fontawesome-solid-street-view: 
_Q for Mortals_: [§4.2 Match](/q4m3/4_Operators/#42-match)
