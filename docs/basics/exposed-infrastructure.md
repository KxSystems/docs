---
title: Exposed infrastructure – Basics – kdb+ and q documentation
description: Q is an embedded domain-specific language for time-series analysis, implemented in the proprietary programming language k. As such, q leaves features of k exposed. They should be avoided.
author: Stephen Taylor
keywords: embedded, domain-specific language, dsl, k, kdb+, q
---
# Exposed infrastructure



## The k programming language

Q is an embedded domain-specific language for time-series analysis, implemented in the proprietary programming language k. 
As such, q leaves features of k exposed. They should be avoided.

The k language has no public documentation and is for use by KX system programmers only. 
It changes from version to version of q.
These changes are not documented. 

!!! warning "Use of k in q scripts" 

    The use of k expressions in kdb+ applications is **unsupported** and **strongly discouraged**.


## Internal functions

The operator `!` with a negative left argument calls an [internal function](internal.md).

Q cover functions should be substituted where available.


## Unary forms

Many q binary operators have unary forms.

They can be evaluated in q but this use is discouraged as poor q style.

```q
q)(#:)"zero"         / discouraged
4
q)count "zero"       / supported
4
```

Instead, use the corresponding q keywords.

```txt
!:   key/til
#:   count
$:   string
%:   reciprocal
&:   where
*:   first
+:   flip
,:   enlist
-:   neg
.:   get
0::  read0
1::  read1
<:   iasc
=:   group
>:   idesc
?:   distinct
@:   type
^:   null
_:   floor
|:   reverse
~:   not
```


## Variadic keywords

Q keywords, such as `deltas`, that are simple covers of extensions inherit their [variadic syntax](variadic.md), though they cannot be applied infix as the extensions can.

```q
q)deltas                  / cover for the extension
-':
q)y:1 1 3 5 8 13
q)-':[y]                  / unary
1 0 2 2 3 5
q)deltas[y]               / unary
1 0 2 2 3 5
q)-':[10;y]               / binary, bracket
-9 0 2 2 3 5
q)deltas[10;y]            / binary, bracket
-9 0 2 2 3 5
q)10-':y                  / binary, infix
-9 0 2 2 3 5
q)10 deltas y             / cannot be applied infix
'Cannot write to handle 10. OS reports: Bad file descriptor
  [0]  10 deltas y
       ^
```

The keywords are intended as covers for the unary application of the extension. For binary application, use the extension, as shown above.

!!! warning "Binary application of variadic keywords"

    The binary application of variadic keywords is deprecated. 
    Support for it may be withdrawn in the future. 

The variadic keywords are:

```txt
deltas 
differ 
max maxs 
min mins 
prd prds 
ratios 
sum sums
```


## `sv` and `vs`

The keywords [`sv`](../ref/sv.md) and [`vs`](../ref/vs.md) cover overloads of `/:` and `\:`.

```q
q)(0x40\:)2                /poor q style
0x00000000000000000002
q)0x40 vs 2
0x00000000000000000002     /good q style
```

The keywords are defined for readability. Use them.


