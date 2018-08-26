# Glossary



Aggregate function
: A function that reduces its argument, typically a list to an atom, e.g. `sum`

Ambivalent 
: A map that may be applied to a variable number arguments is ambivalent. For example, a matrix, the operator `@`, or the extension `+/`. 

Apply
: As in _apply a function to its arguments_:  evaluate a function on values corresponding to its arguments.  
<i class="far fa-hand-point-right"></i> [Application](application.md)

Argument
: In the expression `10%4` the operator `%` is evaluated on the arguments 10 and 4. 10 is the _left argument_ and 4 is the _right argument_.

: By extension, the first and second arguments of a binary function are called its left argument and right argument regardless of whether it is applied infix.
In the expression `%[10;4]` 10 and 4 are still referred to as the left and right arguments. 

: By extension, where a function has rank >2, its left argument is its first argument, and its _right arguments_ are the remaining arguments.

: Correspondingly, the _left domain_ and _right domain_ of a binary function are the domains of its first and second arguments, regardless of whether or not the function may be applied infix. 

: By extension, where a function has rank >2, its _left domain_ is the domain of its first argument, and its _right domains_ are the domains of the remaining arguments.

: The terminology generalises to maps. 

    -   The left domain of a matrix `m` is `til count m`.
    -   The right domain of a matrix is `til count first m`.
    -   The right domains of a list of depth `n` are `1_n{til count first x}\m`. <!-- FIXME Check -->

: Because unary functions may be applied prefix, the single argument of a unary function is sometimes referred to as its _right argument_. 


Argument list
: A pair of square brackets enclosing zero or more items separated by semicolons. <pre><code class="language-q">%[10;4]  / % applied to argument list [10;4]</code></pre>

Atom
: A single instance of a [datatype](datatypes.md), eg `42`, `"a"`, `1b`, `2012.09.15`. The [`type`](../ref/type.md) of an atom is always negative. 

Atomic function 
: An atomic function is a uniform function such that for `r:f[x]`  `r[i]~f x[i]` is true for all `i`, e.g. `signum`. A function `f` is atomic if `f` is identical to `f'`. 

Binary  
: A map of rank 2, i.e. a function that takes 2 arguments, or a list of depth ≥2.

Bracket notation
: Applying a map to its argument/s or indexes by writing it to the left of an argument list, e.g. `+[2;3]` or `count["zero"]`.
<i class="far fa-hand-point-right"></i> [Application](application.md)

Conform
: Lists, dictionaries and tables conform if they are either atoms or have the same count.

Control word
: Control words interrupt the usual evaluation rules, e.g. by omitting expressions, terminating evaluation.
: <i class="far fa-hand-point-right"></i> [Evaluation control](control.md)

Count 
: The number of items in a list, keys in a dictionary or rows in a table. The count of an atom is 1.

Dictionary
: A map of a list of keys to a list of values.

Domain
: The domain of a function is the complete set of possible values of its argument.  
<i class="far fa-hand-point-right"></i> intmath.com: [Domain and range](http://www.intmath.com/functions-and-graphs/2a-domain-and-range.php)

Enumeration
: A representation of a list as indexes of the items in its nub or another list.  
<i class="far fa-hand-point-right"></i> [Enumerations](enumerations.md)

Expression block, expression list
: A pair of square brackets enclosing zero or more expressions separated by semicolons. 

Extension
: A function derived by a unary operator from a map that extends its application.

Function
: A map from domain/s to range defined by an algorithm.
: Operators, keywords, extensions, compositions, projections and lambdas are all functions. 

Identity element
: For function `f` the value `x` such that `y~f[x;y]` for any `y`. 
: Q knows the identity elements of some functions, e.g. `+` (zero), but not others, e.g. {x+y} (also zero). 
: <i class="far fa-hand-point-right"></i> [Ambivalent functions](ambivalence.md)

Infix
: Applying an operator by writing it between its arguments, e.g.  
`2+3`  applies `+` to 2 and 3

Item, list item
: A member of a list: can be any function or data structure.

Keyed table
: A table of which one or more columns have been defined as its key. A table’s key/s (if any) are supposed to be distinct: updating the table with rows with existing keys overwrites the previous records with those keys. A table without keys is a simple table. 

Lambda
: A function defined in the lambda notation. 

Lambda notation
: The notation in which functions are defined: an optional signature followed by a list of expressions, separated by semicolons, and all embraced by curly braces, e.g.  
`{[a;b](a*a)+(b*b)+2*a*b}`.  
<i class="far fa-hand-point-right"></i> [Syntax](syntax.md)

Left argument
: See _Argument_

Left domain
: See _Argument_

List
: An array, its items indexed by position.

List notation
: Zero, two, or more items separated by semicolons and enclosed by parentheses, e.g. ``("abc";`John;2012.09.15)`` and `()`. 

Map
: A function, list, or dictionary.  
<i class="far fa-hand-point-right"></i> [Maps](/tutorials/uq/maps)

Matrix
: A list in which all items are lists of the same count.

Native
: A synonym for _primitive_.

Nub
: The [`distinct`](../ref/distinct) items of a list.

Nullary
: A function of rank 0, i.e. that takes no arguments.

Operator
: A primitive binary function that may be applied infix as well as prefix, e.g. `+`, `&`.  
<i class="far fa-hand-point-right"></i> [Application](application.md)

Postfix
: Applying an adverb to its argument by writing it to the right, e.g. `+/` applies `/` to `+`. (Not to be confused with projecting an operator on its left argument.)

Prefix
: Prefix notation applies a unary map `m` to its argument or indices `x`; i.e. `m x` is equivalent to `m[x]`.  
<i class="far fa-hand-point-right"></i> [Application](application.md)

Primitive
: Defined in the q language.

Project, projection
: A function passed fewer arguments than its rank projects those arguments and returns a projection: a function of the unspecified argument/s.  
<i class="far fa-hand-point-right"></i> [Projection](syntax/#projection)

Range 
: The range of a function is the complete set of all its possible resulting values.  
<i class="far fa-hand-point-right"></i> intmath.com [Domain and range](http://www.intmath.com/functions-and-graphs/2a-domain-and-range.php)

Rank
: Of a **function**, the number of arguments it takes. For a lambda, the count of arguments in its signature, or, where the signature is omitted, by the here highest-numbered of the three default argument names `x` (1), `y` (2) and `z` (3) used in the function definition, e.g. `{x+z}` has rank 3. Functions of rank 0, 1, 2 and 3 are called nullary, unary, binary and ternary respectively.
: Of a **list**, the depth to which it is nested. A vector has rank 1.

Reference, pass by
: _Pass by reference_ means passing the name of an object (as a symbol atom) as an argument to a function, e.g. ``key `.q``.

Right argument/s
: See _Argument_

Right domain/s
: See _Argument_

Signature
: The argument list that (optionally) begins a lambda, e.g. in `{[a;b](a*a)+(b*b)+2*a*b}`, the signature is  `[a;b]`.

Simple table 
: A table with no key defined; i.e. not a keyed table.

String
: There is no string datatype in q. _String_ in q means a char vector, e.g. "abc". 

Table
: A list of uniform dictionaries that have the same keys.

Ternary
: A map of rank 3, i.e. a function wiith three arguments; or a list of depth ≥3.

Unary form
: Most binary operators have unary forms that take a single argument. Q provides more legible covers for these functions.  
: <i class="far fa-hand-point-right"></i> [Exposed infrastructure](exposed-infrastructure.md)

Unary function
: A map of rank 1, i.e. a function with 1 argument, or a list of depth ≥1.

Unary operator
: A primitive unary function that extends the application of its map argument, returning a derived function known as an _extension_. E.g. Over extends Add to return `+/`, an extension.

Uniform function 
: A uniform function `f` such that `count[x]~count f x`, e.g. `deltas`

Uniform list
: A list in which all items are of the same datatype. See also _vector_.

Unsigned function
: A lambda without a signature, e.g. `{x*x}`.  

Value, pass by
: _Pass by value_ means passing an object (not its name) as an argument to a function, e.g. `key .q`.

Vector
: A uniform list of basic types that has a special shorthand notation. A char vector is known as a _string_. 

x
: Default name of the first or only argument of an unsigned function.

y
: Default name of the second argument of an unsigned function.

z
: Default name of the third argument of an unsigned function.
