---
title: Datatypes | Kdb+ database and language primer | Documentation for kdb+ and q
author: Dennis Shasha (shasha@cs.nyu.edu)
description: Introduction to the kdb+ database and q language, used for Dennis Sasha’s college classes
hero: <i class="fas fa-graduation-cap"></i> Kdb+ database and language primer
---
# Datatypes




**Atoms** are single entities, e.g. a single number, a single character, a symbol. (The full set is boolean, byte, short, int, long, real, float, char, symbol, month, date, minute, second, time, timespan, and timestamp as we will
see them in examples.) 

A **list** is a sequence of atoms or other types, including lists.

!!! tip "Comments"

    Comments begin with a slash `/` and cause the parser to ignore everything up to the end of the line.

    The `/` operator is overloaded however and has a different meaning if it follows a two-argument operator.  We will see how.

<i class="fas fa-book-open"></i>
[Datatypes](../../basics/datatypes.md), 
[Syntax](../../basics/syntax.md)


```q
q)x:`abc / x is the symbol `abc (a symbol is represented internally as a number)
q)y:(`aaa; `bbbdef; `c) / a list of three symbols
q)y1:`aaa`bbbdef`c / another way to represent this list (no blanks between symbols)
q)y2:(`$"symbols may have interior blanks";`really;`$"truly!")
q)y[0]
`aaa
q)y 0 / juxtaposition eliminates the need for brackets
`aaa
q)y 0 2
`aaa`c
q)y[0 2]
`aaa`c

q)z:(`abc; 10 20 30; (`a; `b); 50 60 61) / lists can be complex
q)z 2 0 / z[2] is `a`b, and z[0] is `abc
`a`b
`abc
q)z[2;1] / `b is the second item of z[2]
`b
q)z[2;0] / `a is the first item of z[2]

q)x:"palo alto" / a list of characters
q)x 2 3
"lo"
```



---
<i class="far fa-hand-point-right"></i>
[Dictionaries](dictionaries.md)