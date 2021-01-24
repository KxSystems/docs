---
title: Syntax | Basics | kdb+ and q documentation
description: Syntax of the q programming language
author: Stephen Taylor
keywords: attribute, bracket, colon, comment, composition, compound, conditional, control, empty, function, infix, iterators, kdb+, multiline, name, namespace, operator, parenthesis, precedence, prefix, projection, postfix, q, space, syntax, token, vector
---


# Syntax

> It is a privilege to learn a language,  
> a journey into the immediate  
> – _Marilyn Hacker_, “Learning Distances”



!!! info "The q-SQL query templates `select`, `exec`, `update`, and `delete` have their [own syntax](qsql.md)."


## Elements

The elements of q are 

-   functions: operators, keywords, lambdas, and extensions
-   data structures: atoms, lists, dictionaries, tables, expression lists, and parse trees
-   attributes of data structures
-   control words
-   scripts
-   environment variables

!!! info "Applicable values"

    Lists, dictionaries, file and process handles, and functions of all kinds are all _applicable values_. An applicable value is a mapping. 

    A function maps its domains to its range. 
    A list maps its indexes to its items.
    A dictionary maps its keys to its values.


## Tokens

All the ASCII symbols have syntactic significance in q. Some denote functions, that is, actions to be taken; some denote nouns, which are acted on by functions; some denote iterators, which modify nouns and functions to produce new functions; some are grouped to form names and constants; and others are punctuation that bound and separate expressions and expression groups.

The term **token** is used to mean one or more characters that form a syntactic unit. For instance, the tokens in the expression `10.86 +/ LIST` are the constant `10.86`, the name `LIST`, and the symbols `+` and `/`. The only tokens that can have more than one character are constants and names and the following.

```q
<=   / less-than-or-equal
>=   / greater-than-or-equal
<>   / not-equal
::   / null, view, set global
/:   / each-right
\:   / each-left
':   / each-prior, each-parallel
```

When it is necessary to refer to the token to the left or right of another unit, terms like “immediately to the left” and “followed immediately by” mean that there are no spaces between the two tokens.


## Nouns

All data are syntactically **nouns**. Data include 

-   atomic values
-   collections of atomic values in lists
-   lists of lists, and so on

Atomic values

: include character, integer, floating-point, and temporal values, as well as symbols, functions, dictionaries, and a special atom `::`, called _null_. All functions are atomic data. 

List constants

: include several forms for the empty list denoting the empty integer list, empty symbol list, and so on. (One-item lists are displayed using the comma to distinguish them from atoms, as in `,2` the one-item list consisting of the single integer item 2.)

Numerical constants

: (integer and floating-point) are denoted in the usual ways, with both decimal and exponential notation for floating-point numbers. 
A negative numerical constant is denoted by a minus sign immediately to the left of a positive numerical constant.
Special atoms for numerical and temporal datatypes (e.g. `0W` and `0N`) refer to infinities and “not-a-number” (or “null” in database parlance) concepts. 

Temporal constants

: include timestamps, months, dates, datetimes, timespans, minutes, and seconds. 

    <pre><code class="language-q">
    2017.01              / month   
    2017.01.18           / date    
    00:00:00.000000000   / timespan
    00:00                / minute  
    00:00:00             / second  
    00:00:00.000         / time    
    </code></pre>

:fontawesome-solid-book-open: 
[Datatypes](datatypes.md)

Character constants

: An atomic character constant is denoted by a single character between double quote marks, as in `"a"`; more than one such character, or none, between double quotes denotes a list of characters. 

Symbol constants

: A symbol constant is denoted by a back-quote to the left of a string of characters that form a valid name, as in `` `a.b_2``. 

<!-- 
The string of characters can be empty; that is, back-quote alone is a valid symbol constant. A symbol constant can also be formed for a string of characters that does not form a valid name by including the string in double-quotes with a back-quote immediately to the left, as in `` `"a-b!"``.
 -->
Dictionaries

: are [created](../ref/dict.md) from lists of a special form. 

Tables

: A table is a list of dictionaries, all of which have the same keys. 
These keys comprise the names of the table columns. 

Functions

: can be denoted in several ways; see below. Any notation for a function without its arguments denotes a **constant function atom**, such as `+` for the Add operator. 


## List notation

A sequence of expressions separated by semicolons and surrounded by left and right parentheses denotes a noun called a _list_. The expression for the list is called a _list expression_, and this manner of denoting a list is called _list notation_. 
For example:

```q
(3 + 4; a _ b; -20.45)
```

denotes a list. The empty list is denoted by `()`, but otherwise at least one semicolon is required. When parentheses enclose only one expression they have the common mathematical meaning of bounding a sub-expression within another expression. 
For example, in

```q
(a * b) + c
```

the product `a * b` is formed first and its result is added to `c`; the expression `(a * b)` is not list notation. 

An atom is not a one-item list.
One-item lists are formed with the `enlist` function, as in `enlist"a"` and `enlist 3.1416`.

```q
q)3           /atom
3
q)enlist 3    / 1-item list
,3
```


## Vector notation

Lists in which all the items have the same datatype play an important role in kdb+. Q gives vector constants a special notation, which varies by datatype. 

```q
01110001b                           / boolean
"abcdefg"                           / character
`ibm`aapl`msft                      / symbol
```

Numeric and temporal vectors separate items with spaces and if necessary declare their type with a suffixed lower-case character.

```q
2018.05 2018.07 2019.01m            / month
2 3 4 5 6h                          / short integer (2 bytes)
2 3 4 5 6i                          / xxxxx integer (4 bytes)
2 3 4 5 6                           / long  integer (8 bytes)
2 3 4 5 6j                          / long  integer (8 bytes)
2 3 4 5.6                           / float         (8 bytes)
2 3 4 5 6f                          / float         (8 bytes)
```

type    | example                
--------|------------------------
numeric | `42 43 44`             
date    | `2012.09.15 2012.07.05`
char    | `"abc"`                
boolean | `0101b`                
symbol  | `` `ibm`att`ora``      


### Strings

Char vectors are also known as _strings_.

When `\` is used inside character or string displays, it serves as an escape character.


|        |                                           |
|--------|-------------------------------------------|
|`\"`    | double quote                              |
|`\NNN`  | character with octal value NNN (3 digits) |
|`\\`    | backslash                                 |
|`\n`    | new line                                  |
|`\r`    | carriage return                           |
|`\t`    | horizontal tab                            |


## Table notation

A table can be written as a list: an expression list followed by one or more expressions.

An empty expression list indicates a simple table.

```q
q)([]sym:`aapl`msft`goog;price:100 200 300)
sym  price
----------
aapl 100
msft 200
goog 300
```

The names assigned become the column names. The values assigned must conform: be lists of the same count, or atoms. The empty brackets indicate that the table is _simple_: it has no key. 

You if you specify the column values as variables without specifying column names, the names of the variables will be used.

```q
q)sym:`aapl`msft`goog
q)price:100 200 300
q)([] sym; price)
sym  price
----------
aapl 100
msft 200
goog 300
```

Some columns can be specified as atoms.

```q
q)([] sym:`aapl`msft`goog; price: 300)
sym  price
----------
aapl 300
msft 300
goog 300
```

But not all. To define a 1-row table, enlist at least one of the column values.

```q
q)([] sym:enlist`aapl; price:100)
sym  price
----------
aapl 100
```

The initial expression list can declare one or more columns as a _key_. The values of the key column/s of a table should be unique. 

```q
q)([names:`bob`carol`bob`alice;city:`NYC`CHI`SFO`SFO]; ages:42 39 51 44)
names city| ages
----------| ----
bob   NYC | 42
carol CHI | 39
bob   SFO | 51
alice SFO | 44
```

:fontawesome-solid-book: 
[`!` Key](../ref/key.md)
<br>
:fontawesome-solid-book-open: 
[Dictionaries and tables](dictsandtables.md)
<br>
:fontawesome-solid-street-view: 
_Q for Mortals_
[§8. Tables](/q4m3/8_Tables/)


## Attributes

Attributes are metadata that apply to lists of special form. 
They are often used on a dictionary domain or a table column to reduce storage requirements or to speed retrieval.

:fontawesome-solid-book: 
[Set Attribute](../ref/set-attribute.md), 
[Step dictionaries](../ref/apply.md#step-dictionaries)

<!-- 
FIXME move elsewhere

For 64-bit V3.0+, where `n` is the number of items and `d` is the number of distinct (unique) items, the byte overhead in memory is:

example       |         | byte overhead
--------------|---------|--------------
`` `s#2 2 3`` | sorted  | `0`
`` `u#2 4 5`` | unique  | `32*d`
`` `p#2 2 1`` | parted  | `(48*d)+8*n`
`` `g#2 1 2`` | grouped | `(16*d)+8*n`


Attribute `u` is for unique lists – where all items are distinct.

!!! tip "Grouped and parted"

    Attributes `p` and `g` are useful for lists in memory with a lot of repetition.

    If the data can be sorted such that `p` can be applied, the `p` attribute effects better speedups than `g`, both on disk and in memory.

    The `g` attribute implies an entry’s data may be dispersed – and possibly slow to retrieve from disk.

Some q functions use attributes to work faster:

-    Where-clauses in [`select` and `exec` templates](qsql) run faster with `where =`, `where in` and `where within`
-    Searching: [`bin`](search.md#bin-binr), [`distinct`](search.md#distinct), [_find_](search.md#find) and [`in`](search.md#in) (if the right argument has an attribute)
-    Sorting: [`iasc`](sort.md#iasc) and [`idesc`](sort.md#idesc)
-    Dictionaries: [`group`](dictsandtables.md#group)

 -->


## Bracket notation

A sequence of expressions separated by semicolons and surrounded by left and right brackets (`[` and `]`) denotes either the indexes of a list or the arguments of a function. The expression for the set of indexes or arguments is called an _index expression_ or _argument expression_, and this manner of denoting a set of indexes or arguments is called _bracket notation_. 

For example, `m[0;0]` selects the element in the upper left corner of a matrix `m`, and `f[a;b;c]` evaluates the function `f` with the three arguments `a`, `b`, and `c`. 

Unlike list notation, bracket notation does not require at least one semicolon; one expression between brackets – or none – will do.

Operators can also be evaluated with bracket notation. For example, `+[a;b]`means the same as `a + b`. All operators can be used infix.

Bracket pairs with nothing between them also have meaning; `m[]` selects all items of a list `m` and `f[]` evaluates the no-argument function `f`. 

!!! tip "The similarity of index and argument notation is not accidental."


## Conditional evaluation and control statements

A sequence of expressions separated by semicolons and surrounded by left and right brackets (`[` and `]`), where the left bracket is preceded immediately by a `$`, denotes [conditional evaluation](../ref/cond.md). 

If the word `do`, `if`, or `while` appears instead of the `$` then that word together with the sequence of expressions denotes a [control statement](control.md). 

The first line below shows conditional evaluation; the next three show control statements:

```q
        $[a;b;c]
       do[a;b;c]
       if[a;b;c]
    while[a;b;c]
```

Control words are not functions and do not return results.


## Function notation

A sequence of expressions separated by semicolons and surrounded by left and right braces (`{` and `}`) denotes a function. The expression for the function definition is called a _function expression_ or _lambda_, and this manner of defining a function is called _function_ or _lambda notation_. 

The first expression in a function expression can be a _signature_: an argument expression of the form `[name1;name2;…;nameN]` naming the arguments of the function. Like bracket notation, function notation does not require at least one semicolon; one expression (or none) between braces will do.

Within a script, a function may be defined across [multiple lines](#multi-line-expressions).

:fontawesome-solid-book-open: 
[Function notation](function-notation.md)


## Prefix, infix, postfix

There are various ways to apply a function to its argument/s.

```q
f[x]         / bracket notation
f x          / prefix
x + y        / infix
f\           / postfix
```

In the last example above, the iterator `\` is applied postfix to the function `f`, which appears immediately to the left of the iterator. 
[Iterators](../ref/iterators.md) are the only functions that can be applied postfix.

Bracket and prefix notation are also used to apply a list to its indexes.

```q
q)"abcdef" 1 0 3
"bad"
```

:fontawesome-solid-book-open: 
[Application](application.md)
<br>
:fontawesome-solid-book: 
[Iterators](../ref/iterators.md)


### Postfix yields infix

An iterator applied to an [applicable value](glossary.md#applicable-value) derives a function. For example, Scan applied to Add derives the function Add Scan: `+\`.

If the iterator is applied postfix, as it almost always is, the derived function has infix syntax.

!!! warning "This rule holds **regardless of the rank** of the derived function"

    For example, counterintuitively, `count'` is unary but has infix syntax. 

A common consequence is that many derived functions must be parenthesized to be applied postfix. (See below.)


### Prefix and vector notation

Index and argument notation (i.e. bracket notation) are similar. 
Prefix expressions evaluate unary functions as in `til 3`. This form of evaluation is permitted for any unary. 

```q
q){x - 2} 5 3
3 1
```

This form can also be used for item selection.

```q
q)(1; "a"; 3.5; `xyz) 2
3.5
```

Juxtaposition is also used in vector notation.

```q
3.4 57 1.2e20
```

The items in vector notation bind more tightly than the tokens in function call and item selection. For example, `{x - 2} 5 6` is the function `{x - 2}` applied to the vector `5 6`, not the function `{x - 2}` applied to 5, followed by 6.


### Parentheses around a function with infix syntax

Parentheses around a function with infix syntax capture it as a value and prevent it being parsed as an infix. 

Add Scan `+\` is variadic and has infix syntax. 

```q
q)+\[1 2 3 4 5]                 / unary
1 3 6 10 15
q)+\[1000;1 2 3 4 5]            / unary
1001 1003 1006 1010 1015
q)1000+\1 2 3 4 5               / binary, applied infix
1001 1003 1006 1010 1015
```

Captured as a value by parentheses, it remains variadic, but can be applied postfix as a unary.

```q
q)(+\)[1000;1 2 3 4 5]          / binary
1001 1003 1006 1010 1015
q)(+\)1 2 3 4 5                 / unary, applied postfix
1 3 6 10 15
```

Captured as a value, a function with infix syntax can be passed as an argument to another function.

```q
q)(*) scan 1 2 3 4 5            / * is binary and infix
1 2 6 24 120
q)n:("the ";("quick ";"brown ";("fox ";"jumps ";"over ");"the ");("lazy ";"dog."))
q)(,/) over n                   / ,/ is variadic and infix
"the quick brown fox jumps over the lazy dog."
```

For functions without infix syntax, parentheses are unnecessary.

```q
q)raze over n
"the quick brown fox jumps over the lazy dog."
q){,/[x]}over n
"the quick brown fox jumps over the lazy dog."
```


## Compound expressions

Function expressions, index expressions, argument expressions and list expressions are collectively referred to as _compound expressions_.


## Empty expressions

An empty expression occurs in a compound expression wherever the place of an individual expression is either empty or all blanks. For example, the second and fourth expressions in the list expression `(a+b;;c-d;)` are empty expressions. Empty expressions in both list expressions and function expressions actually represent a special atomic value called _null_.


## Colon

### Assign

The most common use of colon is to [name values](../ref/assign.md).


### Explicit return

Within a lambda (function definition) a colon followed by a value terminates evaluation of the function, and the value is returned as its result. 

The [explicit return](function-notation.md#explicit-return) is a common form when detecting edge cases, e.g.

```q
...
if[type[x]<0; :x];  / if atom, return it
...
```


### Colons in names

The functions associated with I/O and [interprocess communication](ipc.md) are denoted by a colon following a digit, as in `0:` and `1:`.

The q operators are all binary functions.
They inherit unary forms from k, denoted by a colon suffix, e.g. (`#:`).
Use of these forms in q programs is [deprecated](exposed-infrastructure.md#unary-forms). 


## Colon colon

A pair of colons with a name to its left and an expression on the right

-   within a function expression, denotes global assignment, that is, assignment to a global name (`{… ; x::3 ; …}`)
-   outside a function expression, defines a [view](../learn/views.md)


## Iterators

Iterators are higher-order operators. Their arguments are applicable values (functions, process handles, lists, and dictionaries) and their results are derived functions that iterate the application of the value. 

Three symbols, and three symbol pairs, denote iterators:

token         | semantics
--------------|---------------------
`'`           | Case and Each 
`':`          | Each Prior, Each Parallel
`/:` and `\:` | Each Right and Each Left
`/` and `\`   | Converge, Do, While, Reduce 

Any of these in combination with the value immediately to its left, derives a new function. 

The derived function is a variant of the value modified by the iterator. 
For example, `+` is Add and `+/` is _sum_.

```q
q)(+/)1 2 3 4       / sum the list 1 2 3 4
10
q)16 + 1 2 3 4      / sum the list with starting value 16
26
```

Any notation for a derived function without its arguments (e.g. `+/`) denotes a constant function atom. 

:fontawesome-solid-book-open: 
[Application](application.md) for how to apply iterators


## Names and namespaces

Names consist of the upper- and lower-case alphabetic characters, the numeric characters, dot (`.`) and underscore (`_`). The first character in a name cannot be numeric or the underscore.

!!! warning "Underscores in names"

    While q permits the use of underscores in names, this usage is **strongly deprecated** because it is easily confused with [Drop](../ref/drop.md).

    <pre><code class="language-q">
    q)foo_bar:42
    q)foo:3
    q)bar:til 6
    </code></pre>

    Is `foo_bar` now `42` or `3 4 5`?

A name is unique in its namespace. 
A kdb+ session has a default namespace, and child namespaces, nested arbitrarily deep. 
This hierarchy is known as the _K-tree_. 
Namespaces are identified by a leading dot in their names.

Kdb+ includes namespaces `.h`, `.j`, `.q`, `.Q`, and `.z`. 
(All namespaces with one-character names are reserved for use by KX.)

Names with dots are _compound_ names, and the segments between dots are _simple_ names. All simple names in a compound name have meaning relative to the K-tree, and the dots denote the K-tree relationships among them.
Two dots cannot occur together in a name. Compound names beginning with a dot are called _absolute_ names, and all others are _relative_ names.


## Iterator composition

A derived function is _composed_ by any string of iterators with an applicable value to the left and no spaces between any of the iterator glyphs or between the value and the leftmost iterator glyph. For example, `+\/:\:` composes a well-formed function. The meaning of such a sequence of symbols is understood from left to right. The leftmost iterator (`\`) modifies the operator (`+`) to create a new function. The next iterator to the right of that one (`/:`) modifies the new function to create another new function, and so on, all the way to the iterator at the right end.


## Projecting the left argument of an operator

If the left argument of an operator is present but the right argument is not, the argument and operator symbol together denote a _projection_. For example, `3 +` denotes the unary function “3 plus”, which in the expression `(3 +) 4` is applied to 4 to give 7.

:fontawesome-solid-book-open:
[Application and projection](application.md#projection)


## Precedence and order of evaluation

All functions in expressions have the same precedence, and with the exception of certain compound expressions the order of evaluation is strictly right to left. 

```q
a * b +c
```

is `a*(b+c)`, not `(a*b)+c`.

This rule applies to each expression within a compound expression and, other than the exceptions noted below, to the set of expressions as well. That is, the rightmost expression is evaluated first, then the one to its left, and so on to the leftmost one. 

For example, in the following pair of expressions, the first one assigns the value 10 to `x`. In the second one, the rightmost expression uses the value of `x` assigned above; the center expression assigns the value 20 to `x`, and that value is used in the leftmost expression:

```q
q)x: 10
q)(x + 5; x: 20; x - 5)
25 20 5
```

The sets of expressions in index expressions and argument expressions are also evaluated from right to left. However, in function expressions, conditional evaluations, and control statements the sets of expressions are evaluated left to right. 

```q
q)f:{a : 10; : x + a; a : 20}
q)f[5]
15
```

The reason for this order of evaluation is that the function `f` written on one line above is identical to:

```q
f:{ 
  a : 10;
  :x+ a;
  a : 20 }
```

It would be neither intuitive nor suitable behavior to have functions executed from the bottom up. (Note that in the context of function expressions, unary colon is Return.)


## Multiline expressions

Individual expressions can occupy more than one line in a script. Expressions can be broken after the semicolons that separate the individual expressions within compound expressions; it is necessary only to indent the continuation with one or more spaces.
For example:

```q
(a + b;
  ;
  c - d)
```

is the 3-item list `(a+b;;c-d)`. 

Note that whenever a set of expressions is evaluated left to right, such as those in a function expression, if those expressions occupy more than one line then the lines are evaluated from top to bottom.


## Spaces

Any number of spaces are usually permitted between tokens in expressions, and usually the spaces are not required. The exceptions are:

-   No spaces are permitted between the symbols 
    -   `'` and `:` when denoting the iterator `':`
    -   `\` and `:` when denoting the iterator `\:`
    -   `/` and `:` when denoting the iterator `/:`
    -   a digit and `:` when denoting a function such as `0:`
    -   `:` and `:` for assignments of the form `name :: value`
-   No spaces are permitted between an iterator glyph and the value or
iterator symbol to its left.
-   No spaces are permitted between an operator glyph and a colon to its right whose purpose is to denote assignment.
-   If a `/` is meant to denote the left end of a comment then it must be preceded by a blank (or newline); otherwise it will be taken to be part of an iterator.
-   Both the underscore character (`_`) and dot character (`.`) denote operators and can also be part of a name. The default choice is part of a name. A space is therefore required between an underscore or dot and a name to its left or right when denoting a function.
-   At least one space is required between neighboring numeric constants in vector notation.
-   A minus sign (`-`) denotes both an operator and part of the format of negative constants. A minus sign is part of a negative constant if it is next to a positive constant and there are no spaces between, except that a minus sign is always considered to be the function if the token to the left is a name, a constant, a right parenthesis or a right bracket, and there is no space between that token and the minus sign. The following examples illustrate the various cases:

<pre><code class="language-q">
x-1            / x minus 1
x -1           / x applied to -1
3.5-1          / 3.5 minus 1
3.5 -1         / numeric list with two elements 
x[1]-1         / x[1] minus 1
(a+b)- 1       / (a+b) minus 1
</code></pre>


## Comments

Line, trailing, and multiline comments are ignored by the interpreter.

`/` will comment out the rest of the line. 

```q
q)/Oh what a lovely day
q)2+2  /I know this one
4
```

unless embedded within a string or preceded by a system command.

```q
q)count"2/3"
3
q)\l /data/files
```

Sections of script can be commented out with matching singleton `/` and `\`.

```q
/
    Oh what a beautiful morning
    Oh what a wonderful day
\
```

When not terminating a multi-line comment, a singleton `\` will exit the script.

```q
a:42
\
ignore this and what follows
the restroom at the end of the universe
```


## Special constructs

Back-slash, colon and single-quote (`/ \ : '`) all have special meanings outside ordinary expressions, denoting [system commands](syscmds.md) and [debugging controls](debug.md).

