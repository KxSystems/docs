---
title: Controlling evaluation – Basics – kdb+ and q documentation
description: Evaluation in q is controlled by [iterators](../ref/iterators.md) for iteration ; conditional evaluation; explicit return from a lambda; signalling and trapping errors; and control words.
author: Stephen Taylor
keywords: control, control words, distributive, evaluation, iterate, kdb+, operator, progressive, q, unary, word
---
# Controlling evaluation



<pre markdown="1" class="language-txt">

[' ': /: \:   each peach prior](../ref/maps.md "maps")     [\$[x;y;z] Cond](../ref/cond.md)
[\\ /          scan over](../ref/accumulators.md "accumulators")            [?[x;y;z] Vector Conditional](../ref/vector-conditional.md)

[.[f;x;e] Trap](../ref/apply.md#trap)          [: Return](function-notation.md#explicit-return)        [do](../ref/do.md)  [exit](../ref/exit.md)
[@[f;x;e] Trap-At](../ref/apply.md#trap)       [' Signal](../ref/signal.md)        [if](../ref/if.md)  [while](../ref/while.md)
</pre>

Evaluation is controlled by

-   [iterators](../ref/iterators.md) (maps and accumulators) for iteration
-   conditional evaluation
-   explicit return from a lambda
-   signalling and trapping errors
-   control words

<i class="fas fa-book-open"></i>
    [Debugging](debug.md)

## Iterators

[Iterators](../ref/iterators.md) are the primary means of iterating in q.


### Maps

The [maps](../ref/maps.md) Each, Each Left, Each Right, Each Parallel, and Each Prior are [iterators](../ref/iterators.md) that apply [values](glossary.md#applicable-value) across the items of lists and dictionaries.


### Accumulators

The [accumulators](../ref/accumulators.md) Scan and Over are iterators that apply values _progressively_: that is, first to argument/s, then progressively to the result of each evaluation.

For unary values, they have three forms, known as Converge, Do, and While.


### Case

Case control structures in other languages map values to code or result values. In q this mapping is more often handled by indexing into lists or dictionaries.

```q
q)show v:10?`v1`v2`v3               / values
`v1`v1`v3`v2`v3`v2`v3`v3`v2`v1
q)`r1`r2`r3 `v1`v2`v3?v             / Find
`r1`r1`r3`r2`r3`r2`r3`r3`r2`r1
q)(`v1`v2!`r1`r2) v                 / dictionary: implicit default
`r1`r1``r2``r2```r2`r1
q)`r1`r2`default `v1`v2?v           / explicit default
`r1`r1`default`r2`default`r2`default`default`r2`r1
```

The values mapped can be functions. The pseudocode

```txt
for-each (x in v) {
    switch(x) {
    case `v1:
        `abc,x;
        break;
    case `v2:
        string x;
        break;
    default:
        x;
    }
}
```

can be written in q as

```q
q)((`abc,;string;::) `v1`v2?v)@'v
`abc`v1
`abc`v1
`v3
"v2"
`v3
"v2"
`v3
`v3
"v2"
`abc`v1
```

and optimized with [`.Q.fu`](..//ref/dotq/#qfu-apply-unique).

See also the [Case](../ref/maps.md#case) iterator.


## Conditional evaluation

Syntax: `$[x;y;z]`

[Cond](../ref/cond.md) returns `z` when `x` is zero; else `y`.

Two arguments are evaluated: `x` and either `y` or `z`.

[Vector Conditional](../ref/vector-conditional.md) does something similar for lists of arguments, but evaluates all three arguments.
It should be used in [qSQL queries](qsql.md), which do not support Cond.


## Explicit return

Syntax: `:x`

The result of a lambda is the last expression in its definition, unless the last expression is empty or an assignment, in which case the lambda returns the generic null `::`.

`:x` has a lambda terminate and return `x`.

```q
q)foo:{if[0>type x;:x]; x cross x}
q)foo 2 3
2 2
2 3
3 2
3 3
q)foo 3
3
```

## Signalling and trapping errors

[Signal](../ref/signal.md) will exit the lambda under evaluation and signal an error to the expression that invoked it.

```q
q)goo:{if[0>type x;'`type]; x cross x}
q)goo 2 3
2 2
2 3
3 2
3 3
q)goo 3
'type
  [0]  goo 3
       ^
```

[Trap and Trap At](../ref/apply.md#trap) set traps to catch errors.


## Control words


[`do`](../ref/do.md)

: evaluate some expression/s some number of times

[`exit`](../ref/exit.md)

: terminate kdb+

[`if`](../ref/if.md)

: evaluate some expression/s if some condition holds

[`while`](../ref/while.md)

: evaluate some expression/s while some condition holds

!!! tip "Iteration"

    Control words are little used in practice for iteration.
    [Iterators](../ref/iterators.md) are more commonly used.

<i class="fas fa-book"></i> Iterators:
<br>
[Maps](../ref/maps.md) – Case, Each, Each Left, Each Right, Each Parallel, Each Prior<br>
[Accumulators](../ref/accumulators.md) – Converge, Do, While, Scan, Over


### Common errors

!!! warning "Control words are not functions, and return as a result only Identity."

A common error is forgetting to terminate with a semi-colon.

The result of `if`, `do`, and `while` is [Identity](../ref/identity.md), `(::)`, which allows one mistakenly to write code such as `a:if[1b;42]43` (instead use [Cond](../ref/cond.md)), or `a:0b;if[a;0N!42]a:1b` – the sequence is not as intended!


