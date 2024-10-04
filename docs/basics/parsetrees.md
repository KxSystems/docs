---
title: Parse trees – Basics – kdb+ and q documentation
description: A parse tree represents an expression, not immediately evaluated. Its virtue is that the expression can be evaluated whenever and in whatever context it is needed. The two main functions dealing with parse trees are eval, which evaluates a parse tree, and parse, which returns one from a string containing a valid q expression.
keywords: kdb+, parse, parse tree, q, k4, k
author: [Peter Storeng, Stephen Taylor, Simon Shanks]
---
# Parse trees

## Overview

[`parse`](../ref/parse.md) is a useful tool for seeing how a statement in q is evaluated. Pass the `parse` keyword a q statement as a string and it returns the parse tree of that expression.

A _parse tree_ represents an expression, not immediately evaluated. Its virtue is that the expression can be evaluated whenever and in whatever context it is needed. The two main functions dealing with parse trees are:

1. [`eval`](../ref/eval.md), which evaluates a parse tree.
2. [`parse`](../ref/parse.md), which returns one from a string containing a valid q expression.

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

## k4, q and `q.k`

kdb+ is a database management system which ships with the general-purpose and database language q. Q is an embedded domain-specific language implemented in the k programming language, sometimes known as k4. The q interpreter can switch between q and k modes and evaluate expressions written in k as well as q.

The `parse` keyword can expose the underlying implementation in `k`.

The k language is for KX implementors.
It is not documented or supported for use outside KX.
All the same functionality is available in the much more readable q language. However in certain cases, such as debugging, a basic understanding of some k syntax can be useful.

The `q.k` file is part of the standard installation of q and loads into each q session on startup. It defines many of the q keywords in terms of k. To see how a q keyword is defined in terms of k we could check the `q.k` file or simply enter it into the q prompt:

```q
q)type
@:
```

The `parse` keyword on an operation involving the example above exposes the `k` code. Using the underlying code, it can be run using kdb+ in-build k interpreter to show that it produces the same result:
```q
q)type 6
-7h
q)parse "type 6"
@:
6
q)k)@6
-7h
```

A few q keywords are defined natively from C and do not have a k representation:

```q
q)like
like
```

## Parse trees

A parse tree is a q construct which represents an expression but which is not immediately evaluated. It takes the form of a list where the first item is a function and the remaining items are the arguments. Any of the items of the list can be parse trees themselves.

Note that, in a parse tree, a variable is represented by a symbol containing its name. Thus, to distinguish a symbol or a list of symbols from a variable, it is necessary to enlist that expression. When we apply the `parse` function to create a parse tree, explicit definitions in `.q` are shown in their full k form. In particular, an enlisted element is represented by a preceding comma.

```q
q)parse"5 6 7 8 + 1 2 3 4"
+                          //the function/operator
5 6 7 8                    //first argument
1 2 3 4                    //second argument
```
```q
q)parse"2+4*7"
+                          //the function/operator
2                          //first argument
(*;4;7)                    //second argument, itself a parse tree
```
```q
q)v:`e`f
q)`a`b`c,`d,v
`a`b`c`d`e`f
q)parse"`a`b`c,`d,v"
,                          // join operator
,`a`b`c                    //actual symbols/lists of symbols are enlisted
(,;,`d;`v)                 //v a variable represented as a symbol
```

We can also manually construct a parse tree:

```q
q)show pTree:parse "(aggr;data) fby grp"
k){@[(#y)#x[0]0#x 1;g;:;x[0]'x[1]g:.=y]} //fby in k form
(enlist;`aggr;`data)
`grp

q)pTree~(fby;(enlist;`aggr;`data);`grp)  //manually constructed
1b                                       //parse tree
```

As asserted previously every statement in q parses into the form:

```txt
(function; arg 1; …; arg n)
```

where every item could itself be a parse tree. In this way we see that every action in q is essentially a function evaluation.


## `eval` and `value`

[`eval`](../ref/eval.md) can be thought of as the dual to `parse`. The following holds for all valid q statements (without side effects) put into a string. (Recall that `value` executes the command inside a string.)

```q
//a tautology (for all valid q expressions str)
q)value[str]~eval parse str
1b
q)value["2+4*7"]~eval parse"2+4*7" //simple example
1b
```

When passed a list, `value` applies the first item (which contains a function) to the rest of the list (the arguments).

```q
q)function[arg 1;..;arg n] ~ value(function;arg 1;..;arg n)
1b
```

When `eval` and `value` operate on a parse tree with no nested parse trees, they return the same result. However it is not true that `eval` and `value` are equivalent in general. `eval` operates on parse trees, evaluating any nested parse trees, whereas `value` operates on the literals.

```q
q)value(+;7;3)                  //parse tree, with no nested trees
10
q)eval(+;7;3)
10
q)eval(+;7;(+;2;1))             //parse tree with nested trees
10
q)value(+;7;(+;2;1))
'type
```
```q
q)value(,;`a;`b)
`a`b
q)eval(,;`a;`b)                 //no variable b defined
'b
q)eval(,;enlist `a;enlist `b)
`a`b
```


## Variadic operators

Many operators and some keywords in k and q are [variadic](glossary.md#variadic): they are overloaded so that the behavior of the operator changes depending on the number and type of arguments. In q (not k) the unary form of operators such as (`+`, `$`, `.`, `&` etc.) is disabled: keywords are provided instead.

For example, in k the unary form of the `$` operator equates to the `string`
keyword in q.

```q
q)k)$42
"42"
q)$42                  //$ unary form disabled in q
'$
q)string 42
"42"
```

!!! info "A parenthesized variadic function applied prefix is parsed as its unary form."

```q
q)($)42
"42"
```

A familiar example of a variadic function is the Add Over function `+/` derived by applying the Over iterator to the Add operator.

```q
q)+/[1000;2 3 4]    // +/ applied binary
1009
q)+/[2 3 4]         // +/ applied unary
9
q)(+/)2 3 4         // +/ applied unary
9
```

In k, the unary form of an operator can also be specified explicitly by suffixing it with a colon.

```q
q)k)$:42
"42"
```

`+:` is a unary operator; the unary form of `+`. We can see this in the parse tree:

```q
q)parse"6(+)4"
6
(+:;4)
```

The items of a `parse` result use k syntax. Since (most of) the q keywords are defined in the `.q` namespace, we can use dictionary reverse lookup to find the meaning.

```q
q).q?(+:)
`flip
```

So we can see that in k, the unary form of `+` corresponds to `flip` in q.

```q
q)d:`c1`c2`c3!(1 2;3 4;5 6)
q)d
c1| 1 2
c2| 3 4
c3| 5 6
q)k)+d
c1 c2 c3
--------
1  3  5
2  4  6
q)k)+:d
c1 c2 c3
--------
1  3  5
2  4  6
```

!!! warning "Exposed infrastructure"

    The unary forms of operators are [exposed infrastructure]().
    Their use in q expressions is **strongly discouraged**.
    Use the corresponding q keywords instead.

    For example, write `flip d` rather than `(+:)d`.

    The unary forms are reviewed here to enable an understanding of parse trees, in which k syntax is visible.

<!--
The monadic functionality of a special character operator can be used
in q only if it is wrapped in parentheses:

```q
q)+d
'+

q)flip d
c1 c2 c3
--------
1  3  5
2  4  6

q)(+)d
c1 c2 c3
--------
1  3  5
2  4  6
```
 -->

When using reverse lookup on the `.q` context we are slightly hampered by the fact that it is not an injective mapping. The Find `?` operator returns only the first q keyword matching the k expression. In some cases there is more than one. Instead use the following function:

```q
q)qfind:{key[.q]where x~/:string value .q}

q)qfind"k){x*y div x:$[16h=abs[@x];\"j\"$x;x]}"
,`xbar
q)qfind"~:"
`not`hdel
```

We see `not` and `hdel` are equivalent. Writing the following could be confusing:

```q
q)hdel 01001b
10110b
```

So q provides two different names for clarity.


## Iterators as higher-order functions

An iterator applies to a value (function, list, or dictionary) to produce a  related function. This is again easy to see by inspecting the parse tree:

```q
q)+/[1 2 3 4]
10
q)parse "+/[1 2 3 4]"
(/;+)
1 2 3 4
```

The first item of the parse tree is `(/;+)`, which is itself a parse
tree. We know the first item of a parse tree is to be applied to the
remaining items. Here `/` (the Over iterator) is applied to `+` to
produce a new function which sums the items of a list.

:fontawesome-regular-hand-point-right:
[Iterators](../wp/iterators/index.md)


## Functional form of a qSQL query

Sometimes you need to translate a [qSQL query](qsql.md) into its [functional form](funsql.md), for example, so you can pass column names as arguments. 
Details are provided [here](funsql.md#conversion-using-parse).

