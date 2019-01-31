# Application and projection


## Iterables

An _iterable_ is a list, dictionary,process handle, or function.
It is a mapping from its argument/s to its result. 

-   A list is a mapping from its indexes to its items. 
-   A dictionary is a mapping from its keys to its values.
-   A matrix is a mapping from its row indexes to its rows; 
or a mapping from its row and column indexes to its items. 
-   A table is a mapping from its row indexes to its tuples; 
or a mapping from its column names to its columns;
or a mapping from its row indexes and column names to its items.

A function is a mapping from its _domain/s_ (all its possible valid arguments)
to its _range_ – all its possible results.

Operators, keywords and lambdas are all functions.


## Application

To _apply an iterable_ means 

-  to evaluate a function on its arguments
-  to select items from a list or dictionary

There are several ways to do it.

All iterables can be applied using either bracket notation or the [Apply](/ref/apply) operator. 

Functions can also be applied prefix, infix, postfix, or using the [Apply At](/ref/apply/#apply-at) operator. 

rank<br/>of f | argument<br/>notation | Apply            | Apply At | other       | note
-----|-----------------------|------------------|----------|-------------|-----
0    | `f[]`                 | `f . enlist(::)` | `f@(::)` |             |
1    | `f[x]`                | `f . enlist x`   | `f@x`    | `f x`, `xf` | prefix, postfix
2    | `f[x;y]`              | `f . (x;y)`      |          | `x f y`     | infix
\>2   | `f[x;y;z;…]`          | `f . (x;y;z;…)`  |          |             |

Binary operators and many binary keywords can be applied infix.

```q
q)2+2                         / binary operator
4
q)3 in 0 1 2 3 4              / binary keyword
1b
```

Unary iterables (keywords, lambdas, dictionaries, and lists – but not iterators) can be applied prefix.

```q
q)count "zero"                / unary keyword
4
q){x*x}4                      / unary lambda
16
q)d:`Tom`Dick`Harry!42 97 35  / dictionary
q)d `Harry`Tom
35 42
q)m:3 4#"abcdefghijkl"        / a matrix (binary iterable)
q)m 1 3                       / is also a list (unary iterable)
"def"
"jkl"
```

Iterators can be applied postfix, and usually are.

```q
q)subtots:sum'                / '[sum]
q)subtots 3 4#til 12
3 12 21 30
```



## Long right scope

Iterables applied prefix or infix, have long right scope. 
In other words:

When a unary iterable is applied prefix, its argument is _everything to its right_.
```q
q)sqrt count "It's about time!"
4
```
When a binary iterable is applied infix, its right argument is _everything to its right_.
```q
q)7 * 2 + 4
42
```

!!! info "Republic of iterables"

    There is no precedence among iterables. 
    In `7*2+4` the right argument of `*` is the result of evaluating the expression on its right. 

    This rule applies without exception. 


## Iterators

The iterators are almost invariably applied postfix. 

```q
q)+/[17 13 12]
42
```

In the above, the Over iterators `/` is applied postfix to its single argument `+` to derive the [_function_](../ref/iterators.md) `+/` (sum). 

An iterator applied postfix has _short left scope_. That is, its argument is the _object immediately to its left_. For the [Case](../ref/maps.md#case) iterator that object is an int vector; for all other iterators, an iterable. But note that an iterator’s argument may itself be a deerived function.

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

The _rank_ of an iterable is the number of 

-   arguments it evaluates, if it is a function
-   indexes required to select an atom, if it is a list

An iterable is _variadic_ if it can be used with more than one rank.
All matrixes and some derived functions are variadic.

```q
q)+/[til 5]           / unary
10
q)+/[1000000;til 5]   / binary
1000010
```

_Rank_ is a semantic property, and is independent of syntax. This is a ripe source of confusion.

The syntax of aderived function is determined by the application that produced it.

!!! important "Postfix application produces an infix."

The derived function `+/` is variadic buthas infix syntax. 
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
Only parentheses or brackets can save us.

```q
q)count'[txt]
4 4
q)(count')txt
4 4
```

Or the `each` keyword.

```q
q)count each txt
4 4
```

Conversely, if the unary operator is applied, not postfix, but with bracket notation (unusual and not recommended) the derived function is _not_ an infix.
But it is still variadic.

```q
q)/[+]til 5               / oops, a comment
q);/[+]til 5              / unary, prefix
10
q);/[+][til 5]            / unary, bracket notation
10
q);/[+][10000;til 5]      / binary, bracket notation
10010
q)100000/[+]til 5         / but not infix
'type
  [0]  100000/[+]til 5
             ^
q)'[count]txt             / unary, prefix
4 4
```

!!! tip "Applying a unary operator with bracket notation is unusual and not recommended."


## Projection

When an iterable of rank $n$ is applied to $m$ arguments and $m<n$, the result is a _projection_ of the iterable onto the supplied arguments (indexes), now known as the _projected_ arguments or indexes. 

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
    This is not always necessary but it is good style, because it makes it clear the iterable is being projected, not applied. 

    <pre><code class="language-q">
    q)foo:{x+y+z}
    q)goo:foo[2]    / discouraged
    q)goo:foo[2;;]  / recommended
    </code></pre>

    You could make an exception for operators and keywords, where the rank is well known.

    <pre><code class="language-q">
    q)f:?["brown"]
    q)f "fox"
    5 2 5
    q)g:like["brown"]
    q)g "\*ow\*"
    1b
    </code></pre>

When projecting a [variadic function](variadic.md) the argument list must always be full-length.


