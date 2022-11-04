---
author: Stevan Apter
keywords: kdb+, q, style
---

# Which each?



[Projection](../basics/application.md#projection) and 
[Each](../ref/maps.md#each) are more general than 
[Each Right and Each Left](../ref/maps.md#each-left-and-each-right).
A function can be projected on any of its arguments, and a function can be applied to each item of many lists. 
Each Right and Each Left apply binary functions only, itemwise right, or itemwise left. 

Any expression involving Each Right and Each Left can be transformed into an equivalent expression using only projection and Each. 
For example:

```q
1 2 3 foo/:10 20 30 40
foo[1 2 3;] each 10 20 30 40
```

Typically, expressions using Each Right and Each Left are easier to read, and certainly easier to write, than expressions couched in terms of projection and Each. 
For example

```q
a foo/:\:b
```

expands to 

```q
({foo[x;]each y}[;b]) each a
```


**Prefer Each Right and Each Left to projection and Each.**
