
> It is a privilege to learn a language,  
> a journey into the immediate  
> — _Marilyn Hacker_, “Learning Distances”


## Comments

Line comment
: Any line that begins with a `/` (slash) is a comment.  
`q)/Oh what a lovely day`

Trailing comment
: Anything to the right of ` /` (space slash) is a comment.  
`q)2+2  /I know this one`

Multiline comment
: As first and only non-whitespace char on a line:  
* `/` starts a multiline comment  
* `\` terminates a multiline comment or, if not in a comment, comments to end of script  
```q
/
    Oh what a beautiful morning
    Oh what a wonderful day
\
a:42
\
goodbye to all that
the restroom at the end of the universe
```


## Separation

The semicolon `;` is an all-purpose separator. It separates expressions, [function](elements/#functions) arguments, list items, and so on.
```q
q)a:5;b:3   /expressions
q)a
5
q)(1;2;3)   /items of a list
1 2 3
q)+[2;3]    /function arguments
5
```

!!! tip "Evaluating a sequence of expressions"
    When a _sequence_ of expressions is evaluated, only the last one returns a result. (They may all have side effects, such as setting a variable.) Evaluating a sequence of expressions is not the same as evaluating a _list_ of expressions.
    <pre><code class="language-q">
    q)1+1;b:2+2;3+3
    6
    q)b
    4
    q)(1+1;b:2+2;3+3)
    2 4 6
    </code></pre>


## Naming and assignment

Names consist of upper- and lower-case alphabetics. They may contain, but not begin with, underscores and numbers. For example: `a`, `foo`, `foo2_bar`. 

!!! warning "Underscores in names"
    While q permits the use of underscores in names, this usage is **strongly deprecated** because it is easily confused with _drop_.
    <pre><code class="language-q">
    q)foo_bar:42
    q)foo:3
    q)bar:til 6
    </code></pre>
    Is `foo_bar` now `42` or `3 4 5`?

Values may be named, using single or double colons. The double colon binds the value to a name in the session root; the single colon binds the name in the local context. In a session with no evaluation suspended their effects are the same.
```q
q)foo:42
q)foo
42
q)foo::103
q)foo
103
```
Named values can be _amended_, either entirely or selectively. 
```q
q)show foo:42 43 44
42 43 44
q)foo[1]:100
q)foo
42 100 43
```
Amendment through assignment can be modified by any operator. 
```q
q)foo*:2
q)foo
84 200 86
q)foo[2]+:4
q)foo
84 200 90
```

!!! warning "Amending vectors"
    Amending vectors through modified selective assignment requires an operator that returns the same datatype. 

<i class="far fa-hand-point-right"></i> [_amend_ function](lists/#amend)


## Nouns

The syntactic class of [nouns](elements/#nouns) includes all data structures. 

!!! tip "Noun syntax for functions and adverbs"
    Operators, functions and adverbs can be given noun syntax by listing or parenthesising them. 
    <pre><code class="language-q">
    q)count(+)
    1
    q)count(+;within;\)
    3
    </code></pre>

### Lists

A [_list_](elements/#lists) is enclosed in parentheses, its items – if any – separated by semicolons. 
```q
q)count(42;`ibm;2012.08.17)    /list of 3 items
3
```

!!! note "Functions and adverbs in lists"
    Functions and adverbs in lists are treated as nouns, but juxtaposition becomes [application](#application), not [indexing](#indexing).
    <pre><code class="language-q">
    q)(count;+/;/)1          /indexing
    +/
    q)(count;+/;/)[1] 2 3 4  /application
    9
    </code></pre>


### Vectors

A [vector](elements/#vectors) can be represented without parentheses: numeric, boolean, char and symbol vectors all have distinct forms. 

Char vectors are also known as _strings_.

<div class="kx-compact" markdown="1">

| type    | example                 |
|---------|-------------------------|
| numeric | `42 43 44`              |
| date    | `2012.09.15 2012.07.05` |
| char    | `"abc"`                 |
| boolean | `0101b`                 |
| symbol  | `` `ibm`att`ora``       |

</div>

```q
q)42 43 44 45~(42;43;44;45)    / 4-item vectors
1b
q)("a";"b";"c")~"abc"          / char vectors
1b
q)3<til 10                     / boolean vector
0000111111b
```

When `\` is used inside character or string displays, it serves as an escape character.


|        |                                           |
|--------|-------------------------------------------|
|`\"`    | double quote                              |
|`\NNN` | character with octal value NNN (3 digits) |
|`\\`    | backslash                                 |
|`\n`    | new line                                  |
|`\r`    | carriage return                           |
|`\t`    | horizontal tab                            |


### Simple tables
A simple [table](elements/#tables) can be created by flipping a [dictionary](elements/#dictionaries) in which all the values have the same count – or written directly in table syntax:
```q
q)([]names:`bob`carol`ted`alice; ages:42 39 51 44)
names ages
----------
bob   42
carol 39
ted   51
alice 44
```


### Keyed tables
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

<i class="far fa-hand-point-right"></i> [`!` _key_](dictsandtables/#key)

### Indexing

Lists, dictionaries and simple tables can be indexed; keyed tables cannot. 
```q
q)l:"abcdef" /list
q)d:`first`family`date!`John`Doe`1987.09.15 /dict
q)t:([]name:`Bob`Ted`Carol;city:`SFO`LAX`SEA;age:42 43 45) /simple table
q)l[1 4 0 3]      /list indexes
"bead"
q)d[`date`first]  /dict keys
1987.09.15
`John
q)t[`age`city]    /table columns
42  43  45
SFO LAX SEA
q)t[2 0]          /table rows
name  city age
--------------
Carol SEA  45
Bob   SFO  42
```


### Juxtaposing nouns

In noun syntax, juxtaposition is indexing.
```q
q)l 1 4 0 3      /list indexes
"bead"
q)d`date`first   /dict keys
1987.09.15
`John
q)t`age`city     /table columns
42  43  45
SFO LAX SEA
q)t 2 0          /table rows
name  city age
--------------
Carol SEA  45
Bob   SFO  42
```


## Functions

### Rank

A the _rank_ of a [function](elements/#functions) is the number of arguments it takes. Functions of rank 1 or 2 are known respectively as _unary_ and _binary_. 


### Application

In applying a function, the canonical form of its arguments is a bracketed list separated by semicolons. 

<code>f[a<sub>1</sub>;a<sub>2</sub>;…;a<sub>n</sub>]</code>

The expression in brackets lists parameters to the function, but is _not_ itself a list, i.e. it is not the same as:

<code>(a<sub>1</sub>;a<sub>2</sub>;…;a<sub>n</sub>)</code>

All functions can be applied prefix. 
```q
q)til[5]            /one (atom) argument
0 1 2 3 4
q)count[1 4 3]      /one (vector) argument 
1 16 9
q)+[2;3 4]          /two arguments
5 6
q){x+y+2*z}[2;3;4]  /three (atom) arguments
13
```
[Operators](elements/#operators) and some [derivatives](elements/#adverbs) can also be applied infix. 
```q
q)2|3                 /operator
3
q)2 rotate 2 3 4 5 6  /operator
4 5 6 2 3
q)2+/2 3 4 5 6        /derivative
22
```

!!! note "Infix is always optional"
    <pre><code class="language-q">
    q)|[2;3]
    3
    q)rotate[2; 2 3 4 5 6]
    4 5 6 2 3
    q)+/[2;2 3 4 5 6]
    22
    </code></pre>
A unary function can be applied by juxtaposition.
```q
q)reverse[0 1 2]    /function syntax
2 1 0
q)(reverse)(0 1 2)  /juxtaposition is application
2 1 0
q)reverse 0 1 2     /the parens are redundant
2 1 0
```
A unary function `g` with argument `d` can be evaluated by `g@d` or `g.enlist d`.
```q
q)f:{x*2}
q)f@42
84
```
<i class="far fa-hand-point-right"></i> [`.` _apply_](unclassified/#apply) 

When applied infix or by juxtaposition, a function’s right argument is the result of the _entire_ expression to its right. When applied infix, its left argument is the noun _immediately_ on its left.
```q
q}double:2*
q)double 1 2 3 4 + 5   /arg of double is 6 7 8 9
12 14 16 18
q)double[1 2 3 4] + 5  /left-arg of + is 2 4 6 8
7 9 11 13
```
Parentheses can be used conventionally to modify this order of evaluation.
```q
q)2 * 1 2 3 4 + 5
12 14 16 18
q)(2 * 1 2 3 4) + 5
7 9 11 13
```

!!! note "No hierarchy"
    There is no hierarchy of precedence in evaluating functions. 
    For example, neither `*` nor `%` has precedence over `+` and `-`.

**Functions with no arguments** require special handling. For example, if `f:{2+3}` then `f` can be evaluated with `@` and with any argument.
```q
q)f:{2+3}
q)f[]
5
q)f@0
5
```
Both `.` and `@` are referred to as _index_ and _apply_ according to use. 
In most cases, `@` can be replaced more readably with whitespace. 

!!! note "Function arguments and list indexes"
    A function is a mapping from its arguments to its result. A list is a mapping from its indexes to its values. They use the same syntax, including – for unary functions – juxtaposition. 

        q){x*x}[3 4 5]
        9 16 25
        q)0 1 4 9 16 25 36 49[3 4 5]
        9 16 25
        q){x*x} 3 4 5
        9 16 25
        q)x:0 1 4 9 16 25 36 49
        q)x 3 4 5
        9 16 25


### Definition

A function is defined explicitly as a _signature_ (a list of up to 8 argument names) followed by a list of expressions enclosed in curly braces and separated by semicolons. This is known as the _lambda notation_, and functions so defined as _lambdas_.
```q
q){[a;b] a2:a*a; b2:b*b; a2+b2+2*a*b}[20;4]  / binary function
576
```
Functions with 3 or fewer arguments may omit the signature and instead use default names `x`, `y` and `z`. 
```q
q){(x*x)+(y*y)+2*x*y}[20;4]
576
```
The result of the function is the result of the last statement evaluated. If the last statement is empty, the result is the generic null, which is not displayed.
```q
q)f:{2*x;}      / last statement is empty
q)f 10          / no result shown
q)(::)~f 10     / matches generic null
1b
```
To terminate evaluation successfully and return a value, use an empty assignment, which is `:` with a value to its right and no variable to its left.
```q
q)c:0
q)f:{a:6;b:7;:a*b;c::98}
q)f 0
42
q)c
0
```
To abort evaluation immediately, use _signal_, which is `'` with a value to its right.
```q
q)c:0
q)g:{a:6;b:7;'`TheEnd;c::98}
q)g 0
{a:6;b:7;'`TheEnd;c::98}
'TheEnd
q)c
0
```
<i class="far fa-hand-point-right"></i> [error handling](errors), [evaluation control](control)


### Name scope

Within the context of a function, name assignments with `:` are _local_ to it and end after evaluation. Assignments with `::` are _global_ (in the session root) and persist after evaluation.
```q
q)a:b:0                      / set globals a and b to 0
q)f:{a:10+3*x;b::100+a;}     / f sets local a, global b
q)f 1 2 3                    / apply f
q)a                          / global a is unchanged
0
q)b                          / global b is updated
113 116 119
```
References to names _not_ assigned locally are resolved in the session root. Local assignments are _strictly local_: invisible to other functions applied during evaluation. 
```q
q)a:42           / assigned in root
q)f:{a+x}
q)f 1            / f reads a in root
43
q){a:1000;f x}1  / f reads a in root
43
```


### Projection

A function applied to more arguments than its rank signals a rank error. 
A function applied to fewer arguments than its rank returns a _projection_ of the function on the specified argument/s, in which their value/s are fixed. The projection is a function only of the _unspecified_ argument/s.
```q
q)foo:{x+y+2*z}
q)bar:foo[;;1000]  /bar is a projection of foo on z:1000
q)bar[2;3]
2005
```
Where `f` is a function of rank $N$, and `g` is a projection of `f` on $m$ arguments (where $N \gt m$) `g` has rank $N-m$.

Operators can be projected in the usual way; but also by eliding the right-argument. 
```q
q)double:*[2]
q)halve:%[;2]
q)treble:3*
q)total:(+)over
```


### Operators as left arguments

Some operators take functions as left-arguments. To pass an _operator_ `f` as the left-argument of operator `g`, parenthesise it.
```q
q)(+)over til 10
45
q)(and)over til 10
0
q){x+y}over til 10  / parens required only for operators
45
```


## Adverbs

[Adverbs](adverbs) are primitive higher-order functions that return _derivatives_ (derived functions). Unary adverbs are applied postfix. 
```q
q)double:2*         /unary projection of * 
q)double/[3;2 3 4]  /repeat: apply double 3 times
16 24 32
```

!!! warning "Stay close"
    A space preceding `/` begins a trailing comment so, for example, `+/`, never `+ /`.


### Derivatives

Except for derivatives of _compose_, binary derivatives can also be applied infix. 
```q
q)10+/2 3 4
19
q)3 double/2 3 4    /repeat: apply double 3 times
16 24 32
```
Some derivatives are _ambivalent_: they can be be applied with different ranks.
```q
q)+/[2 3 4]         /+ over: unary 
9
q)+/[10;2 3 4]      /+ over: binary 
19
```

<div class="kx-compact" markdown="1">

| form       | adverb                                | derivative rank/s |
|------------|---------------------------------------|-------------------|
| `int'`     | [case](adverbs/#case)                 | `1+max int`       |
| `'[fn;g1]` | [compose](adverbs/#compose)           | n                 |
| `f1'`      | [each-both](adverbs/#each-both)       | 2                 |
| `f2\:`     | [each-left](adverbs/#each-left)       | 2                 |
| `f2/:`     | [each-right](adverbs/#each-right)     | 2                 |
| `f1':`     | [each-parallel](adverbs/#each-right)  | 1                 |
| `f2':`     | [each-prior](adverbs/#each-prior)     | 1, 2              |
| `f1/`      | [repeat](adverbs/#converge-repeat)    | 2                 |
| `f2/`      | [over](adverbs/#over)                 | 1, 2              |
| `fn/`      | [fold](adverbs/#fold)                 | n                 |
| `f1\`      | [converge](adverbs/#converge-iterate) | 1                 |
| `f1\`      | [iterate](adverbs/#converge-iterate)  | 2                 |
| `f2\`      | [scan](adverbs/#scan)                 | 1, 2, …           |

</div>
Key: `int`: int vector; `f1`: unary function; `g1`: unary function; `f2`: binary function; `fn`: function of rank n&gt;2.


### Ambivalent derivatives

When an ambivalent derivative is applied to a single argument, instead of projecting the function, a default `x` is assumed. 
```q
q)+/[0;2 3 4]
9
q)+/[2 3 4]          /not a projection
9
q)foo:+/[;2 3 4]     /projection
q)foo 10
19
q)+/[10;2 3 4]
19
q)tot:+/             /assignment preserves ambivalence
q)tot[2 3 4]         /unary application
9
q)tot[10;2 3 4]      /binary application
19
```
Applying an ambivalent function by juxtaposition (in noun syntax) applies it as a unary function. 
```q
q)10+/2 3 4    /infix in function syntax
19
q)(+/)2 3 4    /derivative applied by juxtaposition in noun syntax
9
q)10(+/)2 3 4  /noun syntax precludes infix
'Cannot write to handle 10. OS reports: Bad file descriptor
```


## Q-SQL

Expressions beginning with `insert`, `select` or `update` employ [q-SQL template syntax](qsql). 


## Control words

The control words `do`, `if`, `while` [govern evaluation](control). 
A control word is followed by a bracketed list of expressions:

<code>[e<sub>0</sub>;e<sub>1</sub>;e<sub>2</sub>; … ;e<sub>n</sub>]</code>

Expression <code>e<sub>0</sub></code> is always evaluated. Whether any other expression is evaluated is governed by the control word. 


## K syntax

!!! warning "K is deprecated"
    Q is a domain-specific language for finance embedded in the k programming language. Many reserved words in q expose definitions in k. 

        q)show rotate
        k){$[0h>@y;'`rank;98h<@y;'`type;#y;,/|(0;mod[x;#y])_y;y]}[k){1 .Q.s x;}]

    Because of this, there are k expressions that work in the q interpreter, but which are not defined as part of the q language. 
    
    Although q provides a toggle for switching in and out of k, k is currently undocumented and its use in q scripts is deprecated and unsupported.
    
    If you find a k expression in a q script, you should be able to replace it with a q expression.
    <pre><code class="language-q">
    q)(-)1 2 3       /k - deprecated
    -1 -2 -3
    q)neg 1 2 3      /q equivalent
    -1 -2 -3
    q)(|)1 2 3       /k - deprecated
    3 2 1
    q)reverse 1 2 3  /q equivalent
    3 2 1
    </code></pre>