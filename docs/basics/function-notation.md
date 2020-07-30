---
title: Function notation – Basics – kdb+ and q documentation
description: Function notation enables the definition of functions. Function notation is also known as the lambda notation and the defined functions as lambdas.
author: Stephen Taylor
keywords: abort, control, expression, function, kdb+, lambda, multiline, notation, q, rank, signal, signed, unsigned
---
# Function notation





Function notation enables the definition of functions.
Function notation is also known as the _lambda notation_ and the defined functions as _lambdas_. 

!!! note "Anonymity"

    Although the term _lambda_ originated elsewhere as a name for an anonymous function, we use it to denote any function defined using the lambda notation.

    In this usage a lambda assigned a name is still a lambda.
    For example, if `plus:{x+y}`, then `plus` is a lambda.

    Lambdas have datatype 100. 


A lambda is defined as a pair of braces (curly brackets) enclosing an optional _signature_ (a list of up to 8 argument names) followed by a zero or more expressions separated by semicolons. 


## Signature

```q
q){[a;b] a2:a*a; b2:b*b; a2+b2+2*a*b}[20;4]  / binary function
576
```

Functions with 3 or fewer arguments may omit the signature and instead use default argument names `x`, `y` and `z`. 

A lambda with a signature is _signed_; without, _unsigned_.

```q
q){[x;y](x*x)+(y*y)+2*x*y}[20;4]  / signed lambda
576
q){(x*x)+(y*y)+2*x*y}[20;4]       / unsigned lambda
576
```

!!! tip "Use `x`, `y`, and `z` only as names of the first three arguments"

    Using other names for the first arguments of a lambda often helps the reader. But using `x`, `y`, or `z` for any other argument sows confusion.


## Rank

The [rank](glossary.md#rank) of a function is the number of arguments it takes. 

The rank of a signed lambda is the number of names in its signature.

The rank of an unsigned lambda is the here highest-numbered of the three default argument names `x` (1), `y` (2) and `z` (3) used in the function definition.

```q
{[h;l;o;c].5*(h-l;c-o)}      / rank 4
{x+y*10}                     / rank 2
{x+z*10}                     / rank 3
```


## Result

The result of the lambda is the result of the last statement evaluated. If the last statement is empty, the result is the generic null, which is not displayed.

```q
q)f:{2*x;}      / last statement is empty
q)f 10          / no result shown
q)(::)~f 10     / matches generic null
1b
```


## Explicit return

To terminate evaluation successfully and return a value, use an empty assignment, which is `:` with a value to its right and no variable to its left.

```q
q)c:0
q)f:{a:6;b:7;:a*b;c::98}
q)f 0
42
q)c
0
```

:fontawesome-regular-hand-point-right: 
[Evaluation control](control.md)


## Abort

To abort evaluation immediately, use Signal, which is `'` with a value to its right.

```q
q)c:0
q)g:{a:6;b:7;'`TheEnd;c::98}
q)g 0
{a:6;b:7;'`TheEnd;c::98}
'TheEnd
q)c
0
```

:fontawesome-regular-hand-point-right: 
[Error handling](errors.md) 


## Name scope

Within the context of a function, 

-   name assignments with `:` are _local_ to it and end after evaluation
-   assignments with `::` are _global_ (in the session root) and persist after evaluation _unless_ the name assigned is an argument or already defined as a local 

```q
q)a:b:0                      / set globals a and b to 0
q)f:{a:10+3*x;b::100+a;}     / f sets local a, global b
q)f 1 2 3                    / apply f
q)a                          / global a is unchanged
0
q)b                          / global b is updated
113 116 119

q)b:42
q){[a;b]b::99;a+b}[10;20]    / assignment is local
109
q)b
42
q){b:x=y;b::99;x+b}[10;20]   / assignment is local
109
q)b
42
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

Local variables are identified on parsing and initialized as `()` (empty list). Assignments within code branches (never recommended) can produce unexpected results. 

```q
q)t:([]0 1)
q){select from t}[]                       / global t
x
-
0
1
q){if[x;t:([]`a`b)];select from t} 1b     / local t
x
-
a
b
q) {if[x;t:([]`a`b)];select from t} 0b     / local t is ()
'type
  [4]  {if[x;t:([]`a`b)];select from t}
                         ^
```

!!! tip "Within lambdas, read and set global variables with `get` and `set`"

:fontawesome-solid-book:
[`get`, `set`](../ref/get.md)


## Multiline definition

In scripts function definitions can straddle multiple lines.

```q
sqsum:{[a;b]   / square of sum
  a2:a*a;
  b2:b*b;
  a2+b2+2*a*b  / implicit result
  }
```


:fontawesome-solid-book-open:
[Multiline expressions](syntax.md#multiline-expressions)


## Variables and constants

A lambda definition can include up to: 

&nbsp;    | in use | current     | <V3.6 2017.09.26
----------|--------|-------------|------------------
arguments |        | 8           | 8
locals    | $m$    | 110         | 23
globals   | $n$    | 110         | 31
constants |        | $240-(m+n)$ | $95-(m+n)$

:fontawesome-solid-book-open:
[Parse errors](errors.md#parse-errors)

