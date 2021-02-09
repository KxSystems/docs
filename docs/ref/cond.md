---
title: Cond | Reference | kdb+ and q documentation
description: Cond is a q control construct for conditional evaluation.
author: Stephen Taylor
keywords: cond, conditional, control, dollar, kdb+, q
---
# `$` Cond





_Conditional evaluation_

Syntax: `$[test;et;ef;…]`

Control construct: `test`, `et`, `ef`, etc. are q expressions.

## Three expressions

If `test` evaluates to zero, Cond evaluates and returns `ef`, otherwise `et`.

```q
q)$[0b;`true;`false]
`false
q)$[1b;`true;`false]
`true
```

Only the first expression `test` is certain to be evaluated.

```q
q)$[1b;`true;x:`false]
`true
q)x
'x
```

!!! warning "Although it returns a result, Cond is a control-flow construct, not an operator."

    It cannot be [iterated](iterators.md), nor projected onto a subset of expressions.


## Odd number of expressions

For brevity, nested triads can be flattened.

`$[q;a;r;b;c]` <=> `$[q;a;$[r;b;c]]`

These two expressions are equivalent:

```q
$[0;a;r;b;c]
    $[r;b;c]
```

<!-- !!! warning "`$[q;$[r;a;b];c]` is not the same as `$[q;r;a;b;c]`." -->

Cond with many expressions can be translated to triads by repeatedly replacing the last three expressions with the triad.

`$[q;a;r;b;s;c;d]` <=> `$[q;a;$[r;b;$[s;c;d]]]`

Equivalently
```q
$[q;a;  / if q, a
  r:b;  / else if r, b
  s;c;  / else if s, c
  d]    / else d
```

!!! example "Cond in a [`signum`](signum.md)-like function"

    <pre><code class="language-q">
    q){$[x>0;1;x<0;-1;0]}'[0 3 -9]
    0 1 -1
    </code></pre>


## Even number of expressions

An even number of expressions returns either a result or the generic null.

```q
q)$[1b;`true;1b;`foo]
`true
q)$[0b;`true;1b;`foo]
`foo
q)$[0b;`true;0b;`foo]           / return generic null
q)$[0b;`true;0b;`foo]~(::)
1b
```

Versions before V3.6 2018.12.06 signal `cond`.


## Name scope

Cond’s brackets do not create lexical scope.
Name scope within its brackets is the same as outside them.

!!! tip "Good style avoids using Cond to control side effects, such as amending variables."

    Using [`if`](if.md) is a clearer signal to the reader that a side effect is intended.)

    Also, setting a variable in a code branch can have [unintended consequences](../basics/function-notation.md#name-scope).


## Query templates

Cond is not supported inside [qSQL queries](../basics/qsql.md).
Instead, use [Vector Conditional](vector-conditional.md).


----
:fontawesome-solid-book:
[`$` dollar](overloads.md#dollar),
[Vector Conditional](vector-conditional.md)
<br>
:fontawesome-solid-book-open:
[Controlling evaluation](../basics/control.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§10.1.1 Basic Conditional Evaluation](/q4m3/10_Execution_Control/#1011-basic-conditional-evaluation)
