---
title: value | Reference | kdb+ and q documentation
description: value is a q keyword that returns the value of a named variable, or metadata.
author: Stephen Taylor
---
[![Swiss army knife](../img/swiss-army-knife.jpg)](https://www.victorinox.com/ "victorinox.com")
{: style="float: right; max-width: 200px"}


# `value`


_Recurse the interpreter_



```txt
value x     value[x]
```

Returns the value of `x`:

<div markdown="1" class="typewriter">
dictionary           value of the dictionary
symbol atom          value of the variable it names
enumeration          corresponding symbol vector

string               result of evaluating it in current context
list                 result of evaluating list as a [parse tree](../basics/parsetrees.md)

projection           list: function followed by argument/s
composition          list of composed values
derived function     argument of the iterator
operator             internal code

view                 [list of metadata](#view)
lambda               [structure](#lambda)

file symbol          [content of datafile](#get)
</div>


Examples:

```q
q)value `q`w`e!(1 2;3 4;5 6)        / dictionary
1 2
3 4
5 6

q)a:1 2 3
q)value `a                          / symbol
1 2 3

q)e:`a`b`c
q)x:`e$`a`a`c`b
q)x
`e$`a`a`c`b
q)value x                           / enumeration
`a`a`c`b

q)value "enlist a:til 5"            / string
0 1 2 3 4
q)value "{x*x}"
{x*x}
q)value "iasc 2 7 3 1"
3 0 2 1
q)\d .a
q.a)value"b:2"
2
q.a)b
2
q.a)\d .
q)b
'b
q).a.b
2

q)value(+;1;2)                      / list - evaluated as parse tree
3
q)/ if the first item is a string or symbol, it is evaluated first
q)value(`.q.neg;2)
-2
q)value("{x+y}";1;2)
3

q)value +[2]                        / projection
+
2
q)value differ                      / composition
~:
~':
q)f:,/:\:                           / derived function
q)value f
,/:
q)value each (::;+;-;*;%)           / operator
0 1 2 3 4
```

!!! tip "The string form can be useful as a kind of ‘prepared statement’ from the Java client API since the Java serializer doesn’t support lambdas and keywords."


## View

returns a list of metadata:

-   cached value
-   parse tree
-   dependencies
-   definition

When the view is _pending_, the cached value is `::`.

```q
q)a:1
q)b::a+1
q)get`. `b
::
(+;`a;1)
,`a
"a+1"
q)b
2
q)get`. `b
2
(+;`a;1)
,`a
"a+1"
q)
```


## Lambda

!!! warning "The structure of the result of `value` on a lambda is subject to change between versions."

As of V3.5 the structure is:

```txt
(bytecode;parameters;locals;(namespace,globals);constants[0];…;constants[n];m;n;f;l;s)
```

where

this | is
-----|------
`m`  | bytecode to source position map; `-1` if position unknown
`n`  | fully qualified (with namespace) function name as a string, set on first global assignment, with `@` appended for inner lambdas; `()` if not applicable
`f`  | full path to the file where the function originated from; `""` if not applicable
`l`  | line number in said file; `-1` if n/a
`s`  | source code

```q
q)f:{[a;b]d::neg c:a*b+5;c+e}
q)value f
0xa0624161430309220b048100028269410004
`a`b
,`c
``d`e
5
21 19 20 17 18 0 16 11 0 9 0 9 0 25 23 24 2
"..f"
""
-1
"{[a;b]d::neg c:a*b+5;c+e}"
q)/Now define in .test context – globals refer to current context of test
q)\d .test
q.test)f:{[a;b]d::neg c:a*b+5;c+e}
q.test)value f
0xa0624161430309220b048100028269410004
`a`b
,`c
`test`d`e
5
21 19 20 17 18 0 16 11 0 9 0 9 0 25 23 24 2
".test.f"
""
-1
"{[a;b]d::neg c:a*b+5;c+e}"
```



## Local values in suspended functions

See changes since V3.5 that support [debugging](../basics/debug.md#debugger).


## `get`

The function `value` is the same as [`get`](get.md)

By convention `get` is used for file I/O but the two are interchangeable.

```q
q)get "2+3"                / same as value
5
q)value each (get;value)   / same internal code
19 19
```


----
:fontawesome-solid-book: 
[`eval`](eval.md),
[`get`](get.md),
[`parse`](parse.md),
[`.Q.v`](dotq.md#qv-value)

