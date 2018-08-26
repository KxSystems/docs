---
authors: 
    - Conor Slattery
    - Stephen Taylor
title: Efficient use of unary operators
date: August 2018
keywords: efficiency, kdb+, operator, q, unary
---

# Efficient use of unary operators


In addition to the large number of built-in functions, and the ability
to create your own functions quickly and easily, kdb+ provides unary operators,
which can alter function behavior to improve efficiency and
keep code concise. Employing unary operators correctly can bypass the need for
multiple loops and conditionals, with significant performance
enhancements.

This whitepaper provides an introduction to the basic use of the
different unary operators in q, with examples of how they
differ when applied to unary, binary and higher-rank functions.

It also covers how unary operators can be combined to extend the
built-in functions. Common use cases, such as
using operators for recursion and to modify nested columns
in a table, are looked at in more detail. These examples provide
solutions to common problems encountered when building
systems in kdb+ and demonstrate the range of situations where unary operators
can be used to achieve the desired result.

All tests were run using kdb+ version 3.1 (2013.08.09)

!!! note "Maps"

    Unary operators take maps as their arguments. 
    A function is a map: it maps its domain/s to its range.
    But so too are lists and dictionaries. 

    This introductory paper addresses only the use of functions with unary operators.


## Function types

Functions in q can be one of several basic types, each associated with a range of type numbers. 

range   | type
--------|------
100     | lambda
101     | unary keyword
102     | binary operator
103     | unary operator
104     | projection
105     | composition
106-111 | derivative

In general, how a unary operator applies a function `f` depends only on the number <!-- and type --> of the parameters passed to the function they derive, not on the type of `f`. So we will not distinguish between function types when talking about unary operators.


## Basic use of unary operators with functions

There are eight unary operators. This paper addresses the seven that take function arguments. (The eighth, [Case](/ref/case), takes an integer list as argument.)

The operator takes a function argument and derives a new function, the _derivative_, based on the argument.
The derivative applies the original function in a new way.

-   Some unary operators take only argument functions of certain rank. E.g. Each Right and Each Left take only binary functions.
-   In some cases the derivative is [ambivalent](/ref/ambivalence): it can be applied as a unary function or as a binary.
-   Some operators derive functions with more than one way to apply the original function. How the original function is applied depends on whether the derivative is applied as a unary, a binary, or a higher-rank function. 

<!-- , each of which will either modify the
functionality of a function, modify the way a function is applied over
its parameters or – in some cases – make no changes at all. 
 -->
Understanding the basic behavior of each unary operator and how this behavior varies is key to both writing and debugging q code. 
This understanding is grounded in rank and syntax.


## Types of operator

There are two groups of unary operators: the _distribution_ and the _progression_ operators. 

group        | glyph | operator      | argument rank
-------------|:-----:|---------------|--------------
distribution | `'`   | Each          | any
distribution | `\:`  | Each Left     | 2
distribution | `/:`  | Each Right    | 2
distribution | `':`  | Each Parallel | 1
distribution | `':`  | Each Prior    | 2
progression  | `/`   | Over          | any
progression  | `\`   | Scan          | any

Each Parallel and Each Prior have the same glyph. 
They are distinguished by the rank of the argument function. 

The distribution operators evaluate their functions **itemwise** across their arguments. The evaluations are independent of each other.

The progression operators evaluate their functions **successively**. 
The result of each evaluation becomes the first argument of the next.


## Syntax

The unary operators are themselves a type of function and can be applied with bracket notation.

```q
q)/[+]2 3 4
9
```

Here the unary Over operator `/` takes the binary Add operator `+` as its argument, deriving the sum function `/[+]`, which is applied prefix to the vector `2 3 4`.

Unlike any other q function, the unary operators can also be applied postfix, and usually are.
For example, the sum function above is more usually derived `+/` with the Over operator `/` taking `+` _on its left_ as the sole argument. 

```q
q)+/[2 3 4]
9
```

!!! important "A function derived postfix has infix syntax regardless of its rank."

The sum function is in fact [ambivalent](/ref/ambivalence). It can be applied as rank 1 or 2. 
It can take one or two arguments.

```q
q)+/[2 3 4]               / unary application
9
q)+/[1000 2000;2 3 4]     / binary application
1009 2009
```

Because postfix derivation yields an infix, `+/` can be applied infix.

```q
q)1000 2000+/2 3 4        / binary application, infix
1009 2009
```

Whether unary or ambivalent, an infix derivative can be applied prefix only when parenthesized.

```q
q)(+/)2 3 4
9
q)(count')("the";"quick";"brown";"fox")
3 5 5 3
```

!!! detail "Deriving with bracket notation"

    Deriving with bracket notation (unusual) can also produce an ambivalent function, but never an infix.

    <pre><code class="language-q">
    q)/[+][2 3 4]        / unary application
    9
    q)/[+][1000;2 3 4]   / binary application
    9
    q)1000/[+]2 3 4
    'type
    </code></pre>

A named derivative retains any ambivalence, but not infix syntax.

```q
q)tot:+/
q)tot[1000;2 3 4]     / binary application
1009
q)tot[2 3 4]          / unary application - still ambivalent
9
q)1000 tot 2 3 4      / not infix
'Cannot write to handle 1000. OS reports: Bad file descriptor
q)tot 2 3 4           / not infix, so prefix without parens
9
```

While operators and derivatives are functions and so can always be applied with bracket notation, this paper follows common practice and prefers to apply

-   unary operators postfix, e.g `+/`
-   binary derivatives infix, e.g. `x f\:y`
-   unary derivatives prefix, e.g. `(+\)x`


