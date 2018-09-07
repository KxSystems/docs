
# Terminology 

!!! info "Adapted from the _K Reference Manual_"
    Intention is to merge with the [Glossary](glossary).

    Longer entries should become separate articles.


## Atoms

All data are atoms and lists composed ultimately of atoms. 

<i class="far fa-hand-point-right"></i> [Nouns](FIXME "Syntax")


## Atomic functions

There are several recursively-defined primitive functions, which for at least one argument apply to lists by working their way down to items of some depth, or all the way down to atoms. Where the recursion goes all the way down to atoms the functions are called _atom functions_, or _atomic functions_.

<i class="far fa-hand-point-right"></i>
Basics: [Atomic functions](basics/atomic.md)


## Binary

A binary (or binary function) is a map of rank 2. (The terms _dyad_ and _dyadic_ are now deprecated.)

Binary operators and keywords may be used either infix or prefix. However, defined binaries may be used prefix only.


## Character constant

A character constant is defined by entering the characters between double-quotes, as in `"abcdefg"`. If only one character is entered the constant is an atom, otherwise the constant is a list. For example, `"a"` is an atom. The expression `enlist "a"` is required to indicate a one character list. 

<i class="far fa-hand-point-right"></i>  [Escape sequences](#escape-sequences) for entering non-graphic characters in character constants.


## Character vector

A character vector is a simple list whose items are all character atoms. When displayed in a session, it appears as a string of characters surrounded by double-quotes, as in: `"abcdefg"`, not as individual characters separated by semicolons and surrounded by parentheses (that is, not in list notation). 

When a character vector contains only one character, the display is distinguished from the atomic character by prepending a comma, as in `,"x"`.

_String_ is another name for character vector.


## Comparison tolerance

Because floating-point values resulting from computations are usually only approximations to the true mathematical values, the Equal operator is defined so that `x = y` is `1b` (true) for two floating-point values that are either near one another or identical. 

<i class="far fa-hand-point-right"></i> Basics: [Precision](basics/precision.md)


## Conformable data objects

The idea of [conformable objects](basics/conformable.md) is tied to atomic functions such as Add, functions like Cast with behavior very much like atom functions, and functions derived from Each. 


## Console

Console refers to the source of messages to q and their responses that are typed in a q session.


## Dependencies

==FIXME Rewrite for Views==

Dependencies provide spreadsheet-like formulas within applications. A dependency is a global variable with an associated expression describing its relationship with other global variables. The expression is automatically evaluated whenever the variable is referenced and any of the global variables in the expression have changed value since the last time the variable was referenced. If evaluated, the result of the expression is the value of the variable. If not referenced, the value of this variable is the last value it received, either by ordinary specification or a previous evalua- tion of the dependency expression.
The dependency expression is an attribute of a global variable whose value is a character string holding the dependency expression, for example:
v..d: "b + c"
for “v is b+c”. For example:
  b: 10 20 30
  c: 100
  v..d: "b + c"
  v
110 120 130
vhasthevalue b + c

v[2]: 1000
v
110 120 1000
b[1]: 25
v
110 120 130
v can be amended
amend any part of b or c onceagain,vhasthevalue b + c
And of course, b and c can also be dependencies. Note that relative referents like b and c are not resolved in the attribute dictionary of v, but are entries in the same directory as v. Moreover, the dependency expression on v cannot contain an ex- plicit reference to v itself.


### Dependent variables

If a dependency expression is defined for a variable `v` then `v` is said to be _directly dependent_ on all those variables that appear in that expression and dependent on all those variables than can cause it to be re-evaluated when it is referenced. Not only is v dependent on all variables in its dependency expression, but on all variables in the dependency expressions of those variables, and so on.


## Depth

The depth of a list is the number of levels of nesting. For example, an atom has depth 0, a list of atoms has depth 1, a list of lists of atoms has depth 2, and so on. 

The following function computes the depth of any data object:

```q
q)depth:{$[0>type x; 0; 1 + max depth'[x]]}
```

That is, an atom has depth 0 and a list has depth equal to 1 plus the maximum depth of its items. 

```q
q)depth 10             / atom
0
q)depth 10 20          / vector
1
q)depth (10 20;30)     / list
2
```


## Dictionary

==FIXME Rewrite==

<!-- A dictionary is an atom that is created from a list of a special form, using the Make Dictionary operator, denoted by the dot (.) . Each item in the list is a list of three items, the entry, the value and the attributes. The entry is a symbol, holding a simple name, that is, a name with no dots. The value may be any atom or list. The at- tributes are themselves a dictionary, giving the attributes of the item. An entry may have no attributes, or equivalently an empty dictionary (.() ) or null. A dictionary can be indexed by any one of its symbols, and the result is the value of the symbol. When a dictionary is a global variable it is also a directory on the K-tree, and its entries are the global variables in that directory. See Make/Unmake Dictionary and K-tree.
 -->


## Empty list

The generic empty list has no items, has count 0, and is denoted by `()`. The empty character vector may be written `""`, the empty integer vector `0#0`, the empty floating-point vector `0#0.0`, and the empty symbol vector ``0#` `` or `` `$()``. 

The distinction between `()` and the typed empty lists is relevant to certain operators (e.g. Match) and also to formatting data on the screen.


## Entry

The entries of a dictionary `d` are the symbols given by its enumeration, `key d` . A global dictionary is a directory on the K-tree, and its entries are the global variables in that directory.


## Escape sequence

An escape sequence is a special sequence of characters representing a character atom. An escape sequence usually has some non-graphic meaning, for example the tab character. An escape sequence can be entered in a character constant and displayed in character data. 

==FIXME Move rest to separate article or to Syntax==

The escape sequences in q are the same as those in the C language, but often have different meanings. As in C, the sequence `\b` denotes the backspace character, `\n` denotes the newline character, `\t` denotes the horizontal tab character, \" denotes the double-quote character, and \\ denotes the back-slash character.

In addition, \o and \oo and \ooo where each o is one of the digits from 0 through 7, denotes an octal number. If the character with that ASCII value has graphic meaning, that graphic is displayed, or if that character is one that can be specified by one of the escape sequences in the first paragraph, that sequence is displayed. For example:
"\b\a\11" enter a character constant
"\ba\t" \b displays as \b, \a as a, \11 as \t


## Floating-point vector

A floating-point vector is a simple list whose items are all floating-point numbers. When displayed in a session, it appears as a string of numbers separated by blanks, as in:

```q
10.56 3.41e10 -20.5
```

not as individual numbers separated by semicolons and surrounded by parentheses (that is, not in list notation). The empty floating-point vector is denoted `0#0.0`.


## Function atom

A function can appear in an expression as data, and not be subject to immediate evaluation when the expression is executed, in which case it is an atom. For example:

```q
q)f: +            / f is assigned Add 
q)(f;102)         / an item in a list
+
102
```


## Handle

A handle is a symbol holding the name of a global variable, which is a node in the K-tree. For example, the handle of the name `a_c` is `` `a_c``. The term _handle_ is used to point out that a global variable is directly accessed. Both of the following expressions amend `x`:

```q
x: .[ x; i; f; y]
   .[`x; i; f; y]
```

In the first, referencing `x` as the first argument causes its entire value to be constructed, even though only a small part may be needed. In the second, the symbol `` `x`` is used as the first argument. In this case, only the parts of `x` referred to by the index `i` will be referenced and reassigned. The second case is usually more efficient than the first, sometimes significantly so. 

Where `x` is a directory, referencing the global variable `x` causes the entire dictionary value to be constructed, even though only a small part of it may be needed. Consequently, in the description of Amend, the symbol atoms holding global variable names are referred to as handles.


## Homogeneous list

A homogeneous list is one whose atoms are all of the same type. For example, a character vector is a homogeneous list of depth 1. A list of integers is one whose atoms are all integers. Similarly for a list of characters, or floating-point numbers, or symbols.


## Integer vector

An integer vector is a simple list whose items are all integers. When displayed in a session, it appears as a string of numbers separated by blanks, as in:

```q
10 20 -30 40
```

not as individual integers separated by semicolons and surrounded by parentheses (that is, not in list notation). The empty integer vector is `til 0`.


## Item

An item is a component of a list, and may be either an atom or a list. The item of `x` at index position `i` is called the ith item and is denoted by `x[i]`.

If an item is a list then it also has items, and any of these items that are lists may have items, and so on. Items of a list are sometimes called _top-level items_ to distinguish them from items of items, items of items of items, etc., which are generally referred to as _items-at-depth_. When it is necessary to be more specific, top-level items are called items at level 1 or items at depth 1, items of items are called items at level 2 or items at depth 2, and so on. Generally, an item is at depth $n$ if it requires $n$ indices to reach it.

There is also the related concept of _items of specified depth_, meaning items-at-depth that are a specified level above the bottom. For example, items of depth 1 would be lists of atoms within another list, as in:

```q
(1 2 3;(4 5; ("a";`bc)))
```

where the items of depth 1 are `1 2 3` and `4 5` and ``("a";`bc)``. (The items at depth 1 are `1 2 3` and `(4 5;("a";`bc))`.) Generally, an item is of depth $n$ if there is an atom within it that is at depth $n$, but no atom at depth $n+1$.

A list may contain one or more empty items (i.e. the null value `::`), which are typically indicated by omission:

```q
(1 ; :: ; 2)
(1;;2)
```


## K-tree

The K-tree is the hierarchical name space containing all global variables created in a session. The initial state of the K-tree when kdb+ is started is a working directory whose absolute path name is `` `.`` together with a set of other top-level directories containing various utilities. The working directory is for interactive use and is the default active, or current, directory. 

An application should define its own top-level directory that serves as its logical root, using a name which will not conflict with any other top-level application or utility directories present. Every subdirectory in the K-tree is a dictionary that can be accessed like any other variable, simply by its name. 


## Left-atomic function

A left-atomic function `f` is a binary `f` that is atomic in its left, or first, argument. That is, for every valid right argument `y`, the unary `f[;y]` is atomic.


## List

A list is one of the two fundamental data types, the other being the atom. The components of a list are called items.


## Matrix

A matrix is a rectangular list of depth 2. An integer matrix is one whose atoms are all integer atoms. Similarly for character matrix, floating-point matrix, and symbol matrix.


## Null

Null is the value of an unspecified item in a list formed with parentheses and semicolons. For example, null is the item at index position 2 of ``(1 2;"abc";;`xyz)``. 

Null is an atom; its value is `::` <!-- , or `first()` -->. Nulls have special meaning in the right argument of the operator Index and in the bracket form of function application.


## Nullary

A nullary function, has no arguments. The terms _nilad_ and _niladic_ are now deprecated.


## Numeric list

A numeric list is one whose atoms are either integers or floating-point numbers. For example, the arguments to Add and Multiply are numeric lists.


## Numeric vector

A numeric vector is a list that is either an integer vector or a floating-point vector.


## Primitive function

A primitive function is native to q; that is, it is an operator or keyword defined in the language as shipped. (Functions defined in the Kx single-character namespaces are excluded.)


## Rank

The rank of a list is the depth to which it is rectangular, and corresponds to _dimensions_ in other array notations.
(The term _valence_ is now deprecated.)
<!-- The rank of a **list** x is the number of items in its shape, namely `count shape x`. The rank of an atom is always 0, and that of a list is always 1 or more. If the rank of a list is $n$, then the list must be rectangular to depth $n$.  -->
The rank of a matrix is 2. 

<!-- The rank of a dictionary `d` is defined to be `first shape d[]`. -->

The rank of a function is the number of its arguments. The term _valence_ is now deprecated.


## Rectangular list

A list is rectangular at a given depth if all the items at that depth have the same count.

By definition, a matrix is rectangular at depth 2. 
<!-- 
A list of depth 2 is said to be _rectangular_ if all its items are lists of the same count. For example:

```q
q)(1 2 3; "abc"; `x`y`z; 5.4 1.2 -3.56)
1   2   3
a   b   c
x   y   z
5.4 1.2 -3.56
```

is a rectangular list. 

The shape of a rectangular list of depth 2 has two items, the first being the count of the list and the second the count of any item.

```q
q)shape (1 2 3; "abc"; `x`y`z; 5.4 1.2 -3.56)
4 3
```

Analogously, a list of depth 3 is rectangular if all items have depth 2 and all items of items are lists of the same count. The shape of a rectangular list of depth 3 has three items, the first being the count of the list, the second the count of any item, and the third the count of any item of any item. 

For example:
```q
((1 2; `a `b; "AB"); ("CD"; 3 4; `c `d))
```

is a rectangular list of depth 3 and its shape is:

```q
q)shape((1 2; `a `b; "AB"); ("CD"; 3 4; `c `d)) 
2 3 2
```

Rectangular lists of any depth can be defined.

It is possible for a list of depth $d$ to be rectangular to depth $n$, where $n$ is less than $d$. For example, the following list is of depth 3 and is rectangular to depth 2:

```q
((0 1 2; `a; "AB"); ("CD"; 3 4; `c`d))
```

This list has two items, each of which has three items, but the next level of items vary in count. The shape of this list has only two items, the first being the count of the list and the second the count of any item:

```q
q)shape ((0 1 2; `a; "AB"); ("CD"; 3 4; `c `d))
2 3
```

The list `x` is rectangular to depth `n` if its shape has `n` items, that is if `n` equals `count shape x`. 
 -->

## Right-atomic function

A right-atomic function `f` is a binary that is atomic in its right, or second, argument. That is, for every valid left argument `x`, the unary function `f[x;]` is an atomic function.


## Script

A script file, or _script_ for short, is a source file for an application or utility. It is a text file of function definitions and statements for execution, possibly including commands to load other scripts or operating system commands. The typical way to start an application is to give the name of its start-up script in the command that launches kdb+.


<!-- ## Simple list

A list whose items are all atoms, i.e. a list of depth 1. The atoms need not be of the same type.
 -->

## String

A synonym for [character vector](#character-vector).


<!-- ## String-atomic function

A string-atomic function `f` is like an atom function, except that the recursion stops at strings rather than their individual atomic characters.
 -->

## String vector

A list whose items are all strings.


## Symbol

A symbol is an atom which holds a string of characters, much as an integer holds a string of digits. For example, `` `abc`` denotes a symbol atom. This method of forming symbols can only be used when the characters are those that can appear in names. To form symbols containing other characters, put the contents between double quotes, as in `` `$"abc-345"``.

A symbol is an atom, and as such has count 1; its count is not related to the number of characters that appear in its display. The individual characters in a symbol are not directly accessible, but symbols can be sorted and compared with other symbols. Symbols are analogous to integers and floating-point numbers, in that they are atoms but their displays may require more than one character. (If they are needed, the characters in a symbol can be accessed by converting it to a character string.)


## Symbol vector

A symbol vector is a simple list whose items are all symbols. When displayed in a session, it appears as a string of symbols, as in:

```q
`a`b`x_y.z`"123"
```

not as individual symbols separated by semicolons and surrounded by parentheses (that is, not in list notation). The empty symbol vector is written ``0#```.


<!-- ## Trigger

A trigger is an expression associated with a global variable that is executed imme- diately whenever the value of the variable is set or modified. The purpose of a trigger is to have side effects, such as setting the value of another global variable. For example, suppose that whenever the value of the global variable x changes, the new value is to be sent to another K process where it is to become the new value of the 0th item of the variable b. This trigger is set simply by placing the expression on the appropriate node of the K-tree:
     x..t: "pid 3: (`b; 0; :; x)"
where pid is the identifier of the other process. Note that relative referents like b are not resolved in the attribute dictionary of x, but are entries in the same directory as x.
 -->

## Vector

A list whose items are all atoms of the same type is a vector of that type. 

<!-- Function vectors? Dictionary vectors? -->


## Vector notation

==FIXME Summarize. Treat fully in Syntax==

An integer or floating-point vector constant can be defined by putting the atoms next to one another with at least one space between each atom. For example, for the integer vector `1 -2 3`:
```q
q)count 1 -2 3              / a vector with 3 items
3
q)1 -2 3[1]                 / item 1 of the vector 
-2
q)count 3 4 5.721 1.023e10   / a vector with 4 items
4
```
Note that only one item of a floating-point vector defined by vector notation has to be given in decimal or exponential notation. The other items, if whole numbers, can be given in integer format, such as the items 3 and 4 in the above floating-point vector. For example, `1 2 3.0 4` is a floating-point vector, while `1 2 3 4` is an integer vector.

Characters appear between double-quote marks for string vectors. Items in symbol vectors need not be delimited by spaces, since the back-quote character serves to distinguish them.
```q
q)`one`two`three 
`one`two`three 
q)count "Kx Systems"
10
```
One-item vectors are displayed with a comma to distinguish them from atoms.
```q
q)1#"a"
,"a"
q)enlist `abc
,`abc
q)2 _ 3 2 1.618
,1.618
```
==Empty vectors are denoted as !0, 0#0.0, "" and 0#` for integer, floating-point, string and symbol vectors, respectively.==



## Unary

A map with one argument. The terms _monad_ and _monadic_ are now deprecated.


