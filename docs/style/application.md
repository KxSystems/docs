---
title: Style – application and indexing  – kdb+ and q documentation
description: In q, there are several ways to apply a function and index a variable. Underlying them all is the ur-function Apply/Index.
author: Stevan Apter
keywords: apply, at, dot, index, kdb+, q, style, trap
---
# Application and indexing 


## All the forms of dot

In q, there are several ways to apply a function and index a variable. Underlying them all is the _ur_-function [Apply/Index](../ref/apply.md)

```q
.
```

pronounced _dot_. Application of the rank-_n_ function `f` to a list of arguments `v` of count _n_ is expressed: 

```q
f . v
```


## Where it’s `@`

> The only place you can fall from  
> is where it’s at; and when you’re down,  
> you’re not there – that’s why.  
> — _Alastair Howard Robertson_

Application of the unary function `g` to `w` is expressed:

```q
g . enlist w
```

sugar for which is 

```q
g@w
```

Even more simply:

```q
g w
```

Brackets are more sugar:

```q
f[first v;…;last v]
g[w]
```


**Maximize readability by using the simplest syntax available.**


## Brackets and parens

All functions can be applied with bracket notation.
Infix and prefix syntax is usually clearer and preferable.

```q
+[2;2]     2+2
til[5]     til 5
```

Not always, particularly when composing the left argument of an infix.

Short expressions within brackets or parentheses are clearer than long expressions.
Bracket notation can avoid parenthesizing a longer expression.

```q
+/[foo goo v]             / less clear
(+/) foo goo v            / more clear

bar[(+//)m; goo v]        / less clear
((+//)m) bar goo v        / clearer?
+//[m] bar goo v          / clear
```

**Minimize the distance between opening and closing brackets and parentheses.**