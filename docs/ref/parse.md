---
title: parse | Reference | kdb+ and q documentation
description: parse is a q keyword that returns a parse tree for a string expression.
author: Stephen Taylor
---
# parse 






_Parse a string_

Syntax: `parse x`, `parse[x]`

Where `x` is a string representing 

-   a well-formed q expression, returns a parse tree (V3.4 can accept newlines within the string; earlier versions cannot.)
-   a function, returns the function

```q
q)parse "1 2 3 + 5"            / the list 1 2 3 is parsed as a single item
+
1 2 3
5

q)parse "{x*x}"
{x*x}
```

!!! tip "A parse tree can clarify order of execution."

```q
q)parse "1 2 3 +/: 5 7"        / Each Right has postfix syntax
(/:;+)
1 2 3
5 7
q)parse "1 2 3 +neg 5 7"       / neg is applied before +
+
1 2 3
(-:;5 7)
```

A parse tree can be executed with [`eval`](eval.md).

<!-- 
K expressions should be prefixed with `"k)"`, e.g.
```q
q)parse "k)!10"
!:
10
```
 -->
```q
q)eval parse "1 2 3 +/: 5 7"
6 7 8
8 9 10
```

Explicit definitions in `.q` are shown in full:

```q
q)foo:{x+2}
q)parse "foo each til 5"
k){x'y}
`foo
(k){$[-6h=@x;!x;'`type]};5)
```


## Q-SQL

Q-SQL statements are parsed to the corresponding functional form.

```q
q)\l sp.q
q)x:parse "select part:p,qty by sup:s from sp where qty>200,p=`p1"
q)x
?
`sp
,((>;`qty;200);(=;`p;,`p1))
(,`sup)!,`s
`part`qty!`p`qty
q)eval x
sup| part qty
---| --------
s1 | p1   300
s2 | p1   300
```


## Views

Views are special in that they are not parsable (sensibly) with `-5!x` (`parse`).

```q
q)eval parse"a::5"
5
q)a
5
q)views[]
`symbol$()
```



:fontawesome-regular-hand-point-right:
[`eval` and `reval`](eval.md),  
Basics: [Internal function `-5!`](../basics/internal.md)
