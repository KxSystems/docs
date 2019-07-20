---
title: Parse trees
description: A parse tree represents an expression, not immediately evaluated. Its virtue is that the expression can be evaluated whenever and in whatever context it is needed. The two main functions dealing with parse trees are eval, which evaluates a parse tree, and parse, which returns one from a string containing a valid q expression.
keywords: kdb+, parse, parse tree, q
---
# Parse trees



A _parse tree_ represents an expression, not immediately evaluated. Its virtue is that the expression can be evaluated whenever and in whatever context it is needed. The two main functions dealing with parse trees are [`eval`](../ref/eval.md), which evaluates a parse tree, and [`parse`](../ref/parse.md), which returns one from a string containing a valid q expression.

Parse trees may be the result of applying `parse`, or constructed explicitly. The simplest parse tree is a single constant expression. Note that, in a parse tree, a variable is represented by a symbol containing its name. To represent a symbol or a list of symbols, you will need to use [`enlist`](../ref/enlist.md) on that expression.

```q
q)eval 45
45
q)x:4
q)eval `x
4
q)eval enlist `x
`x
```

Any other parse tree takes a form of a list, of which the first item is a function and the remaining items are its arguments. Any of these items can be parse trees. Parse trees may be arbitrarily deep (up to thousands of layers), so any expression can be represented.

```q
q)eval (til;4)
0 1 2 3
q)eval (/;+)
+/
q)eval ((/;+);(til;(+;2;2)))
6
```


<i class="far fa-hand-point-right"></i> 
Technical Whitepaper: [_Parse Trees and Functional Forms_](../wp/parse_trees_and_functional_forms.pdf)

