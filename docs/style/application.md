---
hero: <i class="fas fa-pen-nib"></i> Remarks on Style
author: Stevan Apter
keywords: kdb+, q, style
---

# All the forms of dot



In q, there are several ways to apply a function and index a variable. Underlying them all is the _ur_-function Apply/Index

```q
.
```

pronounced _dot_. Application of the rank-_n_ function `f` to a list of arguments `v` of count _n_ is expressed: 

```q
f . v
```


## Where it’s at

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