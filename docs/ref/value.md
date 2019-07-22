---
title: value
description: value is a q keyword that returns the value of a named variable, or metadata.
author: Stephen Taylor
keywords: kdb+, metadata, q, value,
---
<div style="float: right">
<i class="fas fa-wrench fa-5x"></i>
</div>

# `value`


_Various metadata_



Syntax: `value x`, `value[x]`

Where `x` is a:


## Dictionary

returns its values.

```q
q)d:`q`w`e!(1 2;3 4;5 6)
q)value d
1 2
3 4
5 6
```


## Symbol

returns the value of the variable it names.

```q
q)a:1 2 3
q)`a
`a
q)value `a
1 2 3
```

<i class="far fa-hand-point-right"></i> 
[`.Q.v`](dotq.md#qv-value) (value)


## Enumeration

returns the corresponding symbol vector.

```q
q)e:`a`b`c
q)x:`e$`a`a`c`b
q)x
`e$`a`a`c`b
q)value x
`a`a`c`b
```


## Lambda

!!! warning "Subject to change"

    The structure of the result of `value` on a lambda, e.g. `value {x+y}`, is subject to change between versions.

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


## Projection

returns a list of the function followed by the given arguments.

```q
q)value +[2]
+
2
```


## Composition

returns a list of the composed functions.

```q
q)value differ
~:
~':
```


## Primitive

returns the internal code for the primitive.

```q
q)value each (::;+;-;*;%)
0 1 2 3 4
```


## Derived function

returns the original [applicable value](../basics/glossary.md#applicable-value).

```q
q)f:+/
q)f 1 2 3
6
q)value f
+
```


## String

returns the result of evaluating it in the current context.

```q
q)value "enlist a:til 5"
0 1 2 3 4
q)value "k)<2 7 3 1"
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
```


## List

returns the result of applying the first item to the rest. If the first item is a symbol, it is evaluated first.

```q
q)value(+;1;2)
3
q)value(`.q.neg;2)
-2
q)value("{x+y}";1;2)
3
```

The string form can be useful as a kind of ‘prepared statement’ from the Java client API since the Java serializer doesn’t support lambdas and keywords.

!!! note "`value` and `get`"

    The function `value` is the same as [`get`](get.md). By convention `get` is used for file I/O but the two are interchangeable.

    <pre><code class="language-q">
    q)get "2+3"                / same as value
    5
    q)value each (get;value)   / same internal code
    19 19
    </code></pre>


!!! tip "Local values in suspended functions"

    See changes since V3.5 that support [debugging](../basics/debug.md#debugger).

