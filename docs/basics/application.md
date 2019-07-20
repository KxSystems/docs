---
title: Application and projection
description: Everything in q is a value and almost everything can be applied to some other values. To apply a value means to evaluate a function on its arguments, to select items from a list or dictionary, or to write to a file or process handle. Projection (or currying) is a partial application in which one or more values is bound.
author: Stephen Taylor
keywords: apply, curry, domain, function, index, kdb+, list, project, projection, q, value
---
# Application and projection


## Values

Everything in q is a value, and almost all values can be applied.

-   A list can be applied to its indexes to get its items.
-   A dictionary can be applied to its keys to get its values.
-   A matrix can be applied its row indexes to get its rows; 
or to its row and column indexes to get its items. 
-   A table can be applied to its row indexes to get its tuples; 
to its column names to get its columns;
or to its row indexes and column names to get its items.
-   A function (operator, keyword, or lambda) can be applied to its argument/s to get a result. 
-   A file or process handle can be applied to a string or parse tree

The _domain_ of a function is all valid values of its argument/s; its _range_ is all its possible results. 
For example, the domain of Add is numeric and temporal values, as is its range. 
By extension, 

-   the domain of a list is its indexes; its range, its items
-   the domains of a matrix are its row and column indexes
-   the domain of a dictionary is its keys; its range is its values
-   the domains of a table are its row indexes and column names

!!! info "Atoms need not apply."

    The only values that cannot be applied are atoms that are not file or process handles.

    In what follows, _value_ means _applicable value_.


## Application


To _apply a value_ means 

-  to evaluate a function on its arguments
-  to select items from a list or dictionary
-  to write to a file or process handle

There are several ways to do it.


## Bracket application

All applicable values can be applied with bracket notation. 

```q
q)"abcdef"[1 4 3]
"bed"
q)count[1 4 3]
3
q){x*x}[4]
16
q)+[2;3]
5
q)d:`cat`cow`dog`sheep!`chat`vache`chien`mouton
q)d[`cow`sheep]
`vache`mouton
q)ssr["Hello word!";"rd";"rld"]
"Hello world!"
q)m:("abc";"def";"ghi";"jkl")       / a matrix
q)m[3 1]                            / m is a list (unary)
"jkl"
"def"
q)m[0;2 0 1]                        / and also a matrix (binary)
"cab"
```


## Infix application

Operators, and some keywords and derived functions can also be applied infix.

```q
q)2+3                           / operator
5
q)2 mod 2 3 4 5                 / keyword
0 1 0 1
q)1000+\2 3 4                   / derived function
1002 1005 1009
```


## Apply operator

All applicable values can be applied by the [Apply](../ref/apply.md) operator. 

```q
q)"abcdef" . 1 4 3                      / list applied to its indexes
"bed"
q)count . 1 4 3                         / unary keyword applied to its argument
3
q)+ . 2 3                               / binary operator applied to its arguments
5
q).[+;2 3]                              / binary operator applied to its arguments
5
q)d . `cow`sheep                        / dictionary applied to its keys
`vache`mouton
q).[d;`cow`sheep]                       / dictionary applied to its keys
`vache`mouton
q)ssr . ("Hello word!";"rd";"rld")      / ternary function applied to its arguments
"Hello world!"
```


## Apply At operator

Lists, dictionaries and unary functions can be applied with the [Apply At](../ref/apply.md#apply-at) operator. 

```q
q)"abcdef"@1 4 3
"bed"
q)@[count;1 4 3]
3
q)d@`cow`sheep
`vache`mouton
```


## Prefix application

Lists, dictionaries and unary functions can also be applied prefix. 
(But not iterators.)
As this is equivalent to simply omitting the Apply At operator, the `@` is mostly redundant.

```q
q)"abcdef" 1 4 3
"bed"
q)count 1 4 3
3
q){x*x}4
16
q)d`cow`sheep
`vache`mouton
```


## Postfix application

Iterators are unary operators that can be (and almost always are) applied postfix. They derive functions from their value arguments. Some derived functions are variadic: they can be applied either unary or binary. 

```q
q)+\[2 3 4]                             / derived function applied unary
2 5 9
q)+\[1000;2 3 4]                        / derived function applied binary
1002 1005 1009
q)count'[("the";"quick";"brown";"fox")] / derived function applied unary
3 5 5 3
```

!!! info "Postfix yields infix."

    Functions derived by applying an iterator postfix have infix syntax – _no matter how many arguments they take_. 

Derived functions `+\` and `count'` have infix syntax. 
They can be applied unary by parenthesizing them.

```q
q)(+\)2 3 4
100 1005 1009
q)(count')("the";"quick";"brown";"fox")
3 5 5 3
```

rank of<br/>value f | bracket<br/>notation | Apply            | Apply At | other<br/>syntax | note 
:---:|-----------------------|------------------|----------|-------------|-----
0    | `f[]`                 | `f . enlist(::)` | `f@(::)` |             |
1    | `f[x]`                | `f . enlist x`   | `f@x`    | `f x`, `xf` | prefix, postfix
2    | `f[x;y]`              | `f . (x;y)`      |          | `x f y`     | infix
≥3   | `f[x;y;z;…]`          | `f . (x;y;z;…)`  |          |             |



## Long right scope

Values applied prefix or infix have long right scope. 
In other words:

When a unary value is applied prefix, its argument is _everything to its right_.
```q
q)sqrt count "It's about time!"
4
```
When a binary value is applied infix, its right argument is _everything to its right_.
```q
q)7 * 2 + 4
42
```

!!! info "Republic of values"

    There is no precedence among values. 
    In `7*2+4` the right argument of `*` is the result of evaluating the expression on its right. 

    This rule applies without exception. 


## Iterators

The [iterators](../ref/iterators.md) are almost invariably applied postfix. 

```q
q)+/[17 13 12]
42
```

In the above, the Over iterator `/` is applied postfix to its single argument `+` to derive the function `+/` (sum). 

An iterator applied postfix has _short left scope_. That is, its argument is the _value immediately to its left_. For the [Case](../ref/maps.md#case) iterator that value is an int vector. An iterator’s argument may itself be a derived function.

```q
q)txt:(("Now";"is";"the";"time");("for";"all";"good";"folk"))
q)txt
"Now" "is"  "the"  "time"
"for" "all" "good" "folk"
q)count[txt]
2
q)count'[txt]
4 4
q)count''[txt]
3 2 3 4
3 3 4 4
```

In the last example, the derived function `count'` is the argument of the second `'` (Each). 

Only iterators can be applied postfix. 

<i class="far fa-hand-point-right"></i> 
[Apply/Index and Apply/Index At](../ref/apply.md) for how to apply functions and index lists


## Rank and syntax

The _rank_ of a value is the number of 

-   arguments it evaluates, if it is a function
-   indexes required to select an atom, if it is a list

A value is _variadic_ if it can be used with more than one rank.
All matrixes and some derived functions are variadic.

```q
q)+/[til 5]           / unary
10
q)+/[1000000;til 5]   / binary
1000010
```

_Rank_ is a semantic property, and is _independent of syntax_. This is a ripe source of confusion.


## Postfix yields infix

The syntax of a derived function is determined by the application that produced it.

The derived function `+/` is variadic but has infix syntax. 
Applying it infix is straightforward.

```q
q)1000000+/til 5
1000010
```

How then to apply it as a unary? 
Bracket notation ‘overrides’ infix syntax.

```q
q)+/[til 5]           / unary
10
q)+/[1000000;til 5]   / binary
1000010
```

Or isolate it with parentheses.
It remains variadic.

```q
q)(+/)til 5           / unary
10
q)(+/)[1000000;til 5] / binary
1000010
```

The potential for confusion is even greater when the argument of a unary operator is a unary function. Here the derived function is unary – but it is still an infix! 
Parentheses or brackets can save us.

```q
q)count'[txt]
4 4
q)(count')txt
4 4
```

Or a keyword.

```q
q)count each txt
4 4
```

Conversely, if the unary operator is applied not postfix but with bracket notation, the derived function is _not_ an infix.
But it can still be variadic.

```q
q)'[count]txt             / unary derived function, applied prefix
4 4
q)/[+]til 5               / oops, a comment
q);/[+]til 5              / unary derived function, applied prefix
10
q);\[+][til 5]            / variadic derived function: applied unary
0 1 3 6 10
q);\[+][1000;til 5]       / variadic derived function: applied binary
1000 1001 1003 1006 1010
q)1000/[+]til 5           / but not infix
'type
  [0]  1000/[+]til 5
             ^
```

!!! tip "Applying a unary operator with bracket notation is unusual and discouraged."


## Projection

When a value of rank $n$ is applied to $m$ arguments and $m<n$, the result is a _projection_ of the value onto the supplied arguments (indexes), now known as the _projected_ arguments or indexes. 

In the projection, the values of projected arguments (or indexes) are fixed.

The rank of the projection is $n-m$.

```q
q)double:2*
q)double 5                         / unary
10
q)halve:%[;2]
q)halve[10]                        / unary
5
q)f:{x+y*z}                        / ternary
q)f[2;3;4]
14
q)g:f[2;;4]
q)g 3                              / unary
14
q)(f . 2 3) 4
14
q)l:("Buddy can you spare";;"?")
q)l "a dime"                       / unary
"Buddy can you spare"
"a dime"
"?"
q)m:("The";;;"fox")
q)m["quick";"brown"]               / binary
"The"
"quick"
"brown"
"fox"
```

!!! tip "Make projections explicit"

    When projecting a function onto an argument list, make the argument list full-length.
    This is not always necessary but it is good style, because it makes it clear the value is being projected, not applied. 

    <pre><code class="language-q">
    q)foo:{x+y+z}
    q)goo:foo[2]    / discouraged
    q)goo:foo[2;;]  / recommended
    </code></pre>

    You could reasonably make an exception for operators and keywords, where the rank is well known.

    <pre><code class="language-q">
    q)f:?["brown"]
    q)f "fox"
    5 2 5
    q)g:like["brown"]
    q)g "\*ow\*"
    1b
    </code></pre>

When projecting a [variadic function](variadic.md) the argument list must always be full-length.


