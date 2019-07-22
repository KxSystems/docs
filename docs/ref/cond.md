---
title: Cond
description: Cond is a q ternary operator that enables conditional evaluation.
author: Stephen Taylor
keywords: cond, conditional, control, dollar, kdb+, q
---
# `$` Cond





_Conditional evaluation_

Syntax: `$[x;y;z]`


Where `x` evaluates to zero, returns `z`, otherwise `y`.

```q
q)$[0b;`true;`false]
`false
q)$[1b;`true;`false]
`true
```

Only the first argument is certain to be evaluated.

```q
q)$[1b;`true;x:`false]
`true
q)x
'x
```

For brevity, nested triads can be flattened: `$[q;a;$[r;b;c]]` is equivalent to `$[q;a;r;b;c]`. An example of Cond in a [`signum`](signum.md)-like function:

```q
q){$[x>0;1;x<0;-1;0]}'[0 3 -9]
0 1 -1
```

`$[q;$[r;a;b];c]` is not the same as `$[q;r;a;b;c]`.

Cond with many arguments can be translated to triads by repeatedly replacing the last three arguments with the triad: `$[q;a;r;b;s;c;d]` is `$[q;a;$[r;b;$[s;c;d]]]`. 
So Cond always has an odd number of arguments.
(Until V3.6 2018.12.06 – see below.)

These two expressions are equivalent:

```q
q)$[0;a;r;b;c]
q)    $[r;b;c]
```

!!! warning "Assigning a local variable within a code branch"

    Good style avoids using Cond to control side effects, such as amending variables. (Using [`if`](if.md) is a clearer signal to the reader that a side effect is intended.) 

    Also, setting local variables in a code branch can have [unintended consequences](../basics/function-notation.md#name-scope).



## Even numbers of arguments

Since V3.6 2018.12.06 an even number of arguments does not signal `'cond` but will return either a result or the generic null.

```q
q)$[1b;`true;1b;`foo]
`true
q)$[0b;`true;1b;`foo]
`foo
q)$[0b;`true;0b;`foo]           / return generic null
q)$[0b;`true;0b;`foo]~(::)
1b
```

<i class="far fa-hand-point-right"></i> 
[`$` dollar](overloads.md#dollar)  
Basics: [Evaluation control](../basics/control.md)