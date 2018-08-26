---
authors: 
    - Conor Slattery
    - Stephen Taylor
title: Efficient use of unary operators
date: August 2018
keywords: distribution, kdb+, operator, Over, progression, Scan, q, unary
---

# Progression operators




The [progression operators](/basics/progression-operators) are Scan `\` and Over `/`.

Scan and Over derivatives apply their function arguments _successively_:
the result of each evaluation becomes the (first) argument of the next.

Scan and Over have the same syntax and perform the same computations.
They differ in that Scan derivatives return the result of each evaluation, 
while Over derivatives return only the last.
That is:

```txt
(f/)x    <==>    last (f\)x
x f/y    <==>    last x f\y
```

!!! tip "Map reduce"

    Derivatives of Over with non-unary functions correspond to _map reduce_ in some other programming languages.

The number of evaluations the derivative performs is determined according to the rank of the argument function:

-   for a **unary** argument, by the derivative’s left argument – or its absence
-   otherwise, by the count of the derivative’s argument/s

!!! detail "Memory usage: Scan vs Over"

    For any given argument function, Scan and Over derivatives perform the same computation. But Over, in general, requires less memory, as it discards intermediate results.


## Unary argument

The function derived by a progression operator from a unary argument is ambivalent: it can be applied to one or two arguments. 

<br/>Scan | <br/>Over | application<br/>rank | <br/>iteration
----------|-----------|:--------------------:|---------------
`(f\)x`   | `(f/)x`   | 1                    | Converge
`n f\x`   | `n f/x`   | 2                    | Repeat
`t f\x`   | `t f/x`   | 2                    | While

```txt
Key:
f:  unary function      n: non-negative integer     t: truth map
```

The left argument of the derivative – or its absence – determines how many evaluations are performed.


### Converge

Syntax: `(f\)x`, `(f/)x`

When the derivative is applied as a **unary**, `f` is applied until either 

-   two successive evaluations match 
-   an evaluation matches `x`

```q
q)(raze/)(1 2;(3 4;5 6);7;8)
1 2 3 4 5 6 7 8
```

Matching is governed by [comparison tolerance](/kb/precision/#comparison-tolerance).


### Repeat

Syntax: `n f\x`, `n f/x`

When the derivative is applied as a **binary**, with a **non-negative integer** left argument, `f` is evaluated `n` times. 
The result has count `n+1`; its first item is `x`. 

```q
q)10{2*x}\2
2 4 8 16 32 64 128 256 512 1024 2048
```


### While

Syntax: `t f\x`, `t f/x`

When the derivative is applied as a **binary**, with a **truth map** as left argument, `f` is evaluated until `t` evaluated on the result returns zero. 
(The truth map `t` can be a function, list or dictionary.)

```q
q)(10>){2*x}\2
2 4 8 16
```


## Binary argument

The function derived by a progression operator from a binary argument `f` is ambivalent: it can be applied to one or two arguments. 

application | Scan    | Over
------------|---------|---------
unary       | `(f\)x` | `(f/)x`
binary      | `x f\y` | `x f/y`

The Scan derivative `f\` is a uniform function: `(f\)x` has the same count as `x`, and `x f\y` has the same count as `y`.

application | Scan      | `count r` | `r 0`       | `r i`
------------|-----------|-----------|-------------|---------
unary       | `r:(f\)x` | `count x` | `x 0`       | `f[r i-1;x i]`
binary      | `r:x f\y` | `count y` | `f[x;y 0]`  | `f[r i-1;y i]`

The i-th item of result `r` is 

-   for **unary** application, `f[r i-1;x i]`
-   for **binary** application, `f[r i-1;y i]`

Unary and binary applications differ in the evaluation of `r[0]`:

-   for **unary** application `r[0]` is `x[0]`
-   for **binary** application, `r[0]` is `f[x;y[0]]`

The Over derivatives perform the same computation but return only the result of the last evaluation.

```q
q)(+\)12 10 1 90 73
12 22 23 113 186
q)100+\12 10 1 90 73
112 122 123 213 286
q)(+/)12 10 1 90 73
186
q)100+/12 10 1 90 73
286
```

The keywords `scan` and `over` can be used to avoid parenthesizing binaries that are not also infixes.

```q
q){x+y} scan 12 10 1 90 73    / lambda is not an infix
12 22 23 113 186
q)(+) over 12 10 1 90 73      / + is an infix
186
```


## Higher-rank arguments

Syntax: `f\[x;y;z…]`, `f/[x;y;z…]`

Derivatives of higher-rank argument functions are not ambivalent: they have the same rank as their functions. 

They follow the derivatives of binary arguments applied as binary functions.
This may appear more clearly using bracket notation.

`f`     | `r:`        | `r 0`          | `r i`
--------|-------------|----------------|----------------
binary  | `f\[x;y]`   | `f[x;y 0]`     | `f[r i-1;y i]`
ternary | `f\[x;y;z]` | `f[x;y 0;z 0]` | `f[r i-1;y i;z i]`

And so on for higher ranks of `f`.

```q
q)ssr\["hello word." ;("h";".";"rd");("H";"!";"rld")]
"Hello word."
"Hello word!"
"Hello world!"
```

In the above example the successive evaluations are

```q
ssr["hello word.";"h";"H"]
ssr["Hello word.";".";"!"]
ssr["Hello word!";"rd";"rld"]
```

The right arguments of the derivative must conform: they must be lists or dictionaries of the same count, or atoms. 
The following two statements are equivalent.

```q
q){x+y+z}\[1;2 3 4;5]
8 16 25
q){x+y+z}\[1;2 3 4;5 5 5]
8 16 25
```


## Empty lists

The derivatives of non-unary functions are

-   **uniform** with Scan
-   **aggregates** with Over

Applied to empty lists, the Scan derivatives return empty lists without evaluating the function. The result is not always of the same type as the argument list/s.

Applied to empty lists, the Over derivatives return an atom without evaluating the function. 

See [Progression operators](/basics/progression-operators/#empty-lists) for details.


## Exponential moving average

Since V3.1 (2013.07.07), the exponential moving average of a list can be calculated using Scan.
While it was previously possible to define an exponential moving average function, the new syntax shortens execution times.

```q
//Function defined using the old syntax
q) ema_old: {{z+x*y}\[first y;1-x;x*y]}
//Function defined using the new syntax
//Requires V3.1 2013.07.07 or later 
q) ema_new:{first[y](1-x)\x*y}
q) t:til 10
q) ema_new[0.1;t]
0
0.1
0.29
0.561
0.9049
1.31441
1.782959
2.304672
2.874205
3.486784
//Functions produce the same results but ema_new is significantly faster
q) ema_old[0.1;t]~ema_new[0.1;t]
1b
q) t2:til 1000000
q) \t ema_old[0.1;t2]
421
q) \t ema_new[0.1;t2]
31
```


