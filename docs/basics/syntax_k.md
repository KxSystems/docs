# Syntax


!!! note "Adapted from Chapter 2 of the _K Reference Manual_"

> It is a prvilege to learn a language,  
> a journey into the immediate  
> – _Marilyn Hacker_, “Learning Distances”


In this section:

-   how to arrange symbols and names into expressions
-   how the expressions are executed

All the ASCII symbols have syntactic significance in q. Some denote functions, that is, actions to be taken; some denote nouns, which are acted on by functions; some denote adverbs, which modify nouns and functions to produce new functions; some are grouped to form names and constants; and others are punctuation that bound and separate expressions and expression groups.

The term **token** is used to mean one or more characters that form a syntactic unit. For instance, the tokens in the expression `10.86 +/ LIST` are the constant `10.86`, the name `LIST`, and the symbols `+` and `/`. The only tokens that can have more than one character are constants and names and the following.
```q
<=   / less-than-or-equal
>=   / greater-than-or-equal
<>   / not-equal
::   / nil, view, set global
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

The **atomic values** include character, integer, floating-point, and temporal values, as well as symbols, functions, dictionaries, and a special atom `::`, called _nil_. All functions are atomic data. 

**List constants** include several forms for the empty list denoting the empty integer list, empty symbol list, and so on. (One-item lists are displayed using the comma to distinguish them from atoms, as in `,2` the one-item list consisting of the single integer item 2.)

**Numerical constants** (integer and floating-point) are denoted in the usual ways, with both decimal and exponential notation for floating-point numbers. 
A negative numerical constant is denoted by a minus sign immediately to the left of a positive numerical constant.
Special atoms for numerical and temporal datatypes (e.g. `0W` and `0N`) refer to infinities and “not-a-number” (or “null” in database parlance) concepts. 

**Temporal constants** include timestamps, months, dates, datetimes, timespans, minutes, and seconds. 
For example:
```q
2017.01              / month   
2017.01.18           / date    
00:00:00.000000000   / timespan
00:00                / minute  
00:00:00             / second  
00:00:00.000         / time    
```
<i class="far fa-hand-point-right"></i> [Datatypes](datatypes)

An atomic **character constant** is denoted by a single character between double quote marks, as in `"a"`; more than one such character, or none, between double quotes denotes a list of characters. 

A **symbol constant** is denoted by a back-quote to the left of a string of characters that form a valid name, as in `` `a.b_2``. The string of characters can be empty; that is, back-quote alone is a valid symbol constant. A symbol constant can also be formed for a string of characters that does not form a valid name by including the string in double-quotes with a back-quote immediately to the left, as in `` `"a-b!"``.

**Dictionaries** are created from lists of a special form. 

Functions can be denoted in several ways; see below. Any notation for a function without its arguments denotes a **constant function atom**, such as `+` for the _plus_ function. 

**Adverbs** are higher-order primitive functions. Their arguments are functions and lists, and their results are _derived functions_ (or _derivatives_). 

Three symbols, and three symbol pairs, denote adverbs:

token         | semantics
--------------|---------------------
`'`           | case, compose, each 
`':`          | each-prior, each-parallel
`/:` and `\:` | each-right and each-left
`/` and `\`   | converge, repeat, while, reduce 

Any one of these, in combination with the noun or function immediately to its left, denotes a new function. 

The derivative is a variant of the object modified by the adverb. 
For example, `+` is _plus_ and `+/` is _sum_.
```q
q)(+/)1 2 3 4       / sum the list 1 2 3 4
10
q)16 + 1 2 3 4      / sum the list with starting value 16
26
```
Any notation for a derivative without its arguments (e.g. `+/`) also denotes a constant function atom. 

<i class="far fa-hand-point-right"></i> [Application](FIXME) for how to apply adverbs and derivatives.


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
the product `a * b` is formed first and its result is added to `c`; the expression `(a * b)` is not list notation. One-item lists are formed with the `enlist` function, as in `enlist"a"` and `enlist 3.1416`.


## Index and argument notation

A sequence of expressions separated by semicolons and surrounded by left and right brackets (`[` and `]`) denotes either the indexes of a list or the arguments of a function. The expression for the set of indexes or arguments is called an _index expression_ or _argument expression_, and this manner of denoting a set of indexes or arguments is called _index_ or _argument notation_. 

For example, `m[0;0]` selects the element in the upper left corner of a matrix `m`, and `f[a;b;c]` evaluates the function `f` with the three arguments `a`, `b`, and `c`. 

Unlike list notation, index and argument notation do not require at least one semicolon; one expression between brackets will do.

Operators can also be evaluated with argument notation. For example, `+[a;b]`means the same as `a + b`. All operators can be used either prefix or infix.

Bracket pairs with nothing between them also have meaning; `m[]` selects all items of a list `m` and `f[]` evaluates the no-argument function `f`. 

!!! tip 
    The similarity of index and argument notation is not accidental.

    <i class="far fa-hand-point-right"></i> [Maps](maps)


## Conditional evaluation and control statements

A sequence of expressions separated by semicolons and surrounded by left and right brackets (`[` and `]`), where the left bracket is preceded immediately by a `$`, denotes conditional evaluation. 

If the word `do`, `if`, or `while` appears instead of the `$` then that word together with the sequence of expressions denotes a control statement. 

The first line below shows conditional evaluation; the next three show control statements:
```q
        $[a;b;c]
       do[a;b;c]
       if[a;b;c]
    while[a;b;c]
```


## Function notation

A sequence of expressions separated by semicolons and surrounded by left and right braces (`{` and `}`) denotes a function. The expression for the function definition is called a _function expression_ or _lambda_, and this manner of defining a function is called _function_ or _lambda notation_. 

The first expression in a function expression can optionally be an argument expression of the form `[name1;name2;…;nameN]` specifying the arguments of the function. Like index and argument notation, function notation does not require at least one semicolon; one expression (or none) between braces will do.

<i class="far fa-hand-point-right"></i> [Functions](functions)


## Prefix, infix, postfix

There are various ways to apply a function to its argument/s.
```q
f[x]         / prefix
f x          / juxtaposition
x + y        / infix
f\           / postfix
```
In the last example above, the adverb `\` is applied postfix to the function `f`, which appears immediately to the left of the adverb. Adverbs are the only functions that can be applied postfix. 

<i class="far fa-hand-point-right"></i> [Application](application)


## Juxtaposition and vector notation

There is another similarity between index and argument notation. Prefix expressions evaluate unary functions as in `til 3`. This form of evaluation is permitted for any unary. 
For example:
```q
q){x - 2} 5 3
3 1
```
This form can also be used for item selection, as in:
```q
q)(1; "a"; 3.5; `xyz) 2
3.5
```
Juxtaposition is also used to form constant numeric lists, as in:
```q
3.4 57 1.2e20
```
which is a list of three items, the first 3.4, the second 57, and the third `1.2e20`. This method of forming a constant numeric list is called _vector notation_.

The items in vector notation bind more tightly than the objects in function call and item selection. For example, `{x - 2} 5 6` is the function `{x - 2}` applied to the vector `5 6`, not the function `{x - 2}` applied to 5, followed by 6.


## Compound expressions

As a matter of convenience, function expressions, index expressions, argument expressions and list expressions are collectively referred to as _compound expressions_.


## Empty expressions

An empty expression occurs in a compound expression wherever the place of an individual expression is either empty or all blanks. For example, the second and fourth expressions in the list expression `(a+b;;c-d;)` are empty expressions. Empty expressions in both list expressions and function expressions actually represent a special atomic value called _nil_.


## Colon

The colon has several uses. Its principal use is denoting assignment. It can appear with a name to its left and a noun or function to its right, or a name followed by an index expression to its left and a noun to its right, as in `x:y` and x`[i]:y`. It can also have a primitive operator immediately to its left, with a name or a name and index expression to the left of that, as in `x+:y `and `x[i],:y`. 

A pair of colons with a name to its left and an expression on the right

-   within a function expression, denotes global assignment, that is, assignment to a global name (`{… ; x::3 ; …}`)
-   outside a function expression, defines a [view](views)

The functions associated with I/O and [interprocess communication](ipc) are denoted by a colon following a digit, as in `0:` and `1:`.

A colon used as a unary in a function expression, as in `:r` , means return with the result `r`.

The q operators are all binary functions, but inherit unary forms from k. 
For example:
```q
q)3#5            / binary: 3 take 5
5 5 5
q)(#)"abc"       / unary: count "abc"
3
q)#:["abc"]      / unary: count "abc"
3
q)count "abc"    / q style
3
```
The colon suffix denotes the unary form. 

!!! warning "Unary forms deprecated"
    Q is designed to be more readable than k. It provides unary functions to cover these forms. 

    It is poor style in q to use the unary forms from k.


## Names

Names consist of the upper- and lower-case alphabetic characters, the numeric characters, dot (`.`) and underscore (`_`). The first character in a name cannot be numeric or the underscore.

Names with dots are _compound_ names, and the segments between dots are _simple_ names. All simple names in a compound name have meaning relative to the K-tree, and the dots denote the K-tree relationships among them.
Two dots cannot occur together in a name. Compound names beginning with a dot are called _absolute_ names, and all others are _relative_ names.


## Adverb composition

A function is created by any string of adverb symbols with a noun or function to the left of the string and no spaces between any of the adverb symbols or between the noun or verb and the leftmost adverb symbol. For example, `+\/:\:` is a well-formed adverb composition. The meaning of such a sequence of symbols is understood from left to right. The leftmost adverb modifies the function or noun to create a new function, the next adverb to the right of that one modifies the new function to create another new function, and so on, all the way to the adverb at the right end.


## Projecting the left argument of an operator

If the left argument of an operator is present but the right argument is not, the argument and operator symbol together denote a _projection_. For example, `3 +` denotes the unary function “3 plus”, which in the expression `(3 +) 4` is applied to 4 to give 7.


## Precedence and order of evaluation

All functions in expressions have the same precedence, and with the exception of certain compound expressions the order of evaluation is strictly right to left. 
For example,
```q
a * b +c
```
is `a*(b+c)`, not `(a*b)+c`.

This rule applies to each expression within a compound expression and, other than the exceptions noted below, to the set of expressions as well. That is, the rightmost expression is evaluated first, then the one to its left, and so on to the leftmost one. For example, in the following pair of expressions, the first one assigns the value 10 to `x`. In the second one, the rightmost expression uses the value of `x` assigned above; the center expression assigns the value 20 to `x`, and that value is used in the leftmost expression:
```q
q)x: 10
q)(x + 5; x: 20; x - 5)
25 20 5
```
The sets of expressions in index expressions and argument expressions are also evaluated from right to left. However, in function expressions, conditional evaluations, and control statements the sets of expressions are evaluated left to right. 
For example:
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


## Multi-line expressions

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
  -   `'` and `:` when denoting the adverb `':`
  -   `\` and `:` when denoting the adverb `\:`
  -   `/` and `:` when denoting the adverb `/:`
  -   a digit and `:` when denoting a function such as `0:`
  -   `:` and `:` for assignments of the form `name :: value`
-   No spaces are permitted between an adverb symbol and the function, noun or
adverb symbol to its left.
-   No spaces are permitted between an operator symbol and a colon to its right whose purpose is to denote either assignment or the unary form of the operator.
-   No spaces are permitted between a left bracket and the character to its left. Index and argument notation as well as the left bracket in a conditional evaluation or control statement must immediately follow the token to its left.
-   If a `/` is meant to denote the left end of a comment then it must be preceded by a blank (or newline), for otherwise it will be taken to be part of an adverb
-   Both the underscore character (`_`) and dot character (`.`) denote operators and can also be part of a name. The default choice is part of a name. A space is therefore required between an underscore or dot and a name to its left or right when denoting a function.
-   At least one space is required between neighboring numeric constants in vector notation.
-   A minus sign (`-`) denotes both an operator and part of the format of negative constants. A minus sign is part of a negative constant if it is next to a positive constant and there are no spaces between, except that a minus sign is always considered to be the function if the token to the left is a name, a constant, a right parenthesis or a right bracket, and there is no space between that token and the minus sign. The following examples illustrate the various cases:<pre><code class="language-q">
x-1            / x minus 1
x -1           / x applied to -1
3.5-1          / 3.5 minus 1
3.5 -1         / numeric list with two elements 
x[1]-1         / x[1] minus 1
(a+b)- 1       / (a+b) minus 1
</code></pre>


## Special constructs

Slash, back-slash, colon and single-quote (`/ \ : '`) all have special meanings outside ordinary expressions, denoting comments, commands and debugging controls.

