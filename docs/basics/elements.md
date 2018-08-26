---
title: Elements
keywords: elements, kdb+, ontology, q
---

# Elements





> Ontology asks, _What exists?_,  
> to which the answer is _Everything_.  
> — W.V.O. Quine, _Word and Object_


## Comments

Line, trailing and multiline [comments](syntax.md#comments) are ignored by the interpreter.

```q
q)/Oh what a lovely day
q)2+2  /I know this one
4
```

```q
/
    Oh what a beautiful morning
    Oh what a wonderful day
\
a:42
\
ignore this and what follows
the restroom at the end of the universe
```


## Data structures

<div class="kx-compact" markdown="1">

structure            | examples                                                             
---------------------|----------------------------------------------------------------------
atom                 | `42`; `"a"`; `1b`; `2012.08.04`; `` `ibm``
list                 | `(43;"44";45)`; `("abc";0101b;)`;``(("abc";1 2 3); `ibm`abc)``
vector               | `(43;44;45)`; `"abc"`; `0101b`; `` `ibm`goo``; `2012.09.15 2012.07.05` 
dictionary           | `` `a`b`c!42 43 44``; `` `name`age!(`john`carol`ted;42 43)``
table                | ``([]name:`john`carol`ted; age:42 43 44)``
keyed table          | ``([name:`john`carol`ted] age:42 43 44)``

</div>


### Atoms

An _atom_ is a single number, character, boolean, symbol, timestamp… a single instance of any [datatype](datatypes.md).


### Lists

Lists are zero or more items, separated by semicolons, and enclosed in parentheses. An item can be any noun.

```q
q)count(42;`ibm;2012.08.17)    /list of 3 items
3
```
A list may have 0, 1 or more items.
```q
q)count()                      /empty list
0
q)count enlist 42              /1-list
1
q)count(42;43;44;45)           /4-list
4
```

!!! warning "An atom is not a 1-list"

    A list with 1 item is not an atom. The `enlist` function makes a 1-list from an atom.

    <pre><code class="language-q">
    q)42~enlist 42
    0b
    </code></pre>

A list item may be a noun, function or adverb.

```q
q)count("abc";0000111111b;42)  /2 vectors and an atom
3
q)count(+;rotate;/)            /2 operators and an adverb
3
```


### Vectors

In a _vector_ (or _simple list_) all items are of the same datatype.
Char vectors are also known as _strings_.

<div class="kx-compact" markdown="1">

type    | example
--------|-------------------------
numeric | `42 43 44`
date    | `2012.09.15 2012.07.05`
char    | `"abc"`
boolean | `0101b`
symbol  | `` `ibm`att`ora``

</div>

<i class="far fa-hand-point-right"></i> [Vector syntax](syntax.md#vectors)


### Attributes

Attributes are metadata that apply to lists of special form. 
They are often used on a dictionary domain or a table column to reduce storage requirements or to speed retrieval.

<i class="far fa-hand-point-right"></i> [`#` Set attribute](FIXME/#set-attribute)

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
-    Searching: [`bin`](search/#bin-binr), [`distinct`](search/#distinct), [_find_](search/#find) and [`in`](search/#in) (if the right argument has an attribute)
-    Sorting: [`iasc`](sort/#iasc) and [`idesc`](sort/#idesc)
-    Dictionaries: [`group`](dictsandtables/#group)


### Dictionaries

A _dictionary_ is a map from a list of keys to a list of values. (The keys should be unique, though q does not enforce this.) The values of a dictionary can be any data structure.

```q
q)/4 keys and 4 atomic values
q)`bob`carol`ted`alice!42 39 51 44
bob  | 42
carol| 39
ted  | 51
alice| 44
q)/2 keys and 2 list values
q)show kids:`names`ages!(`bob`carol`ted`alice;42 39 51 44)
names| bob carol ted alice
ages | 42  39    51  44
```

<i class="far fa-hand-point-right"></i> [`!` Dict](../ref/dict.md)

### Tables

A dictionary in which the values are all lists of the same count can be flipped into a table.
```q
q)count each kids
names| 4
ages | 4
q)tkids:flip kids  / flipped dictionary
names ages
----------
bob   42
carol 39
ted   51
alice 44
```

Or the table specified directly using [table syntax](syntax/#simple-tables), e.g.

```q
q)/a flipped dictionary is a table
q)tkids~([]names:`bob`carol`ted`alice; ages:42 39 51 44)
1b
```

Table syntax can declare one or more columns of a table as a _key_. The values of the key column/s of a table are unique.

```q
q)([names:`bob`carol`bob`alice;city:`NYC`CHI`SFO`SFO]; ages:42 39 51 44)
names city| ages
----------| ----
bob   NYC | 42
carol CHI | 39
bob   SFO | 51
alice SFO | 44
```

A keyed table is a dictionary. 


## Names and namespaces

A [namespace](https://en.wikipedia.org/wiki/Namespace) is a container or context within which a name resolves to a unique value. 
Namespaces are children of the _default namespace_ and are designated by a dot prefix. 
Names in the default namespace have no prefix. 
The default namespace of a q session is parent to multiple namespaces, e.g. `.h`, `.Q` and `.z`. 
(Namespaces with 1-character names – of either case – are reserved for use by Kx.)

```q
q).z.p                         / UTC timestamp
2017.02.01D14:58:38.579614000
```

!!! tip "Namespaces are dictionaries"

    Namespace contents can be treated as dictionary entries.

    <pre><code class="language-q">
    q)v:5
    q).ns.v:6
    q)`.[`v]      / value of v in root namespace
    5
    q)`.ns[`v]    / value of v in ns
    6
    q)`. `v       / indexed by juxtaposition
    5
    q)`.ns `v`v
    6 6
    q)`.`.ns@\:`v
    5 6
    </code></pre>

<a class="far fa-hand-point-right"></a> [Names in context](syntax/#name-scope)


## Functions

Functions are:

1. [operators](../ref/operators.md), e.g. `+`, `&`, `':`
2. [keywords](../ref/index.md#keywords, e.g. `min`, `sum`, `count`
3. [lambdas](FIXME/#definition), e.g. `{x+2*y}`
4. _derived_ from (1), (2) and (3) by [unary operators](../ref/unary-operators.md), eg `+/`, `count'`

Functions are first-class objects and can be passed as arguments to other functions. 

<i class="far fa-hand-point-right"></i> [`.Q.res`](../ref/dotq.md#qres-k-words) returns a list of keywords


## Control words

The control words `do`, `if` and `while` [govern evaluation](control.md#control-words).


## Views

A view is a calculation that is re-evaluated only if the values of the underlying dependencies have changed since its last evaluation.
Views can help avoid expensive calculations by delaying propagation of change until a result is demanded.

The syntax for the definition is

```q
q)viewname::[expression;expression;…]expression
```

The act of defining a view does not trigger its evaluation.

A view should not have side-effects, i.e. should not update global variables.

<i class="far fa-hand-point-right"></i> [Views tutorial](/tutorials/views), [`view`](metadata/#view), [`views`](metadata/#views), [`.Q.view`](dotq/#qview-subview) (subview)


## System commands

Expressions beginning with `\` are [system commands](syscmds.md) or multiline comments (see above).

```q
q)/ load the script in file my_app.q
q)\l my_app.q
```


## Scripts

A script is a text file; its lines a list of expressions and/or system commands, to be executed in sequence. 
By convention, script files have the extension `q`.

Within a script

- function definitions may extend over multiple lines
- an empty comment begins a _multiline comment_.

