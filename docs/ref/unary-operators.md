---
title: Unary operators
keywords: adverb, iteration, kdb+, operator, unary
---


# Unary operators


The unary operators (earlier known as _adverbs_) are native higher-order functions: they take maps as arguments and return derived functions, known as [_derivatives_](#derivatives).

They are the primary means of [iterating](/basics/iteration).

For example, the operator Over (written `/`) uses a map to reduce a list or dictionary.
```q
q)+/[2 3 4]      /reduce 2 3 4 with +
9
q)*/[2 3 4]      /reduce 2 3 4 with *
24
```

Over is applied here postfix, with `+` as its argument. 
The derivative `+/` returns the sum of a list; `*/` returns its product.
(Compare _map-reduce_ in some other languages.)


## Ambivalence

Each Prior, Over, and Scan applied to binary maps return derivatives with both unary and binary forms.

```q
q)+/[2 3 4]           / unary
9
q)+/[1000000;2 3 4]   / binary
1000009
```

<i class="far fa-hand-point-right"></i> [Ambivalence](/basics/ambivalence)


## Postfix application

Like all functions, the unary operators can be applied with bracket notation. 
But they can also be applied postfix, and almost always are.

```q
q)'[count][("The";"quick";"brown";"fox")]
3 5 5 3
q)count'[("The";"quick";"brown";"fox")]
3 5 5 3
```

Only unary operators can be applied postfix.


!!! important "Postfix returns an infix"

    Regardless of its rank,
    **a derivative formed by postfix application is always an infix**. 

To apply an infix derivative in any way besides infix, you can always use bracket notation.

```q
q)1000000+/2 3 4          / ambivalent derivative applied infix
1000009
q)+/[100000;2 3 4]        / ambivalent derivative applied binary with brackets
1000009
q)+/[2 3 4]               / ambivalent derivative applied unary with brackets
9
q)txt:("the";"quick";"brown";"fox")
q)count'[txt]             / unary derivative applied with brackets
3 5 5 4
```

If the derivative is unary or ambivalent, you can also parenthesize it and apply it prefix.

```q
q)(count')txt             / unary derivative applied prefix
3 5 5 4
q)(+/)2 3 4               / ambivalent derivative appled prefix
9
```


## Glyphs

Six glyphs are used to denote unary operators. Some are overloaded.

Operators in bold type derive **uniform** functions; in italic type, _ambivalent_ functions.

Subscripts indicate the rank of the argument; superscripts, the rank of the derivative. 

glyph | operator/s
:----:|------------------------------------------
`'`   | **Case**; **Each**
`\:`  | ₂ **Each Left** ²
`/:`  | ₂ **Each Right** ²
`':`  | ₁ **Each Parallel** ¹ ; ₂ **_Each Prior_** ¹ ²
`/`   | ₁ Over: Converge ¹, Do ², While ² ; ₂ _Reduce_ ¹ ² ; ₃ Reduce ³
`\`   | ₁ Scan: Converge ¹, Do ², While ² ; ₂ **_Scan_** ¹ ² ; ₃ **Scan** ³

For Over and Scan, arguments of rank >2 derive functions of the same rank as the argument.

The overloads are resolved according to the following table of syntactic forms. 


## Forms

Any derivative, like any function, can be applied by **bracket notation**. 
Binary derivatives can also be applied **infix**. 
Unary functions can also be applied **prefix**. 
Some [derivatives](#derivatives) are **ambivalent** and can be applied as either unary or binary functions. 

This gives rise to multiple equivalent forms, tabulated here.
Because all functions can be applied with bracket notation, to simplify, such forms are omitted here in favour of prefix or infix application. 
For example, `f'[x]` is valid, but only `(f')x` is shown.
(Unary operators are applied postfix only.)

The mnemonic keywords `each`, `over`, `peach`, `prior` and `scan` are also shown.

argument<br>rank | syntax                                                   | name                                            | semantics
:----------------:|---------------------------------------------------------|-------------------------------------------------|------------------------------------------------------
1                 | `int'[x;y;…]`                                           | [Case](case.md)                                 | select from `[x;y;…]`
1<br>2<br>3+      | `(f')x`, `f each x`<br>`x g'y`<br>`ff'[x;y;z;…]`        | [Each](/ref/iterate/#each)                      | apply `f` to each item of `x`<br>apply `g` to corresponding items of `x` and `y`<br>apply `ff` to corresponding items of `x`, `y`, `z` …
2                 | `x g\:d`                                                | [Each Left](/ref/each-left)                     | apply `g` to `d` and items of `x`
2                 | `d g/:y`                                                | [Each Right](/ref/each-right)                   | apply `g` to `d` and items of `y`
1                 | `(f':)x`, `f peach x`                                   | [Each Parallel](/ref/quote-colon/each-parallel) | apply `f` to items of `x` in parallel tasks
2                 | `(g':)y`,<br>`g prior y`,<br>`d g':y`                   | [Each Prior](/ref/each/#eachprior)              | apply `g` to (`d` and) successive pairs of items of `y`
1                 | `(f/)d`, `(f\)d`                                        | [Converge](/ref/iterate/#converge)              | apply `f` to `d` until result converges
1                 | `n f/d`, `n f\d`                                        | [Do](/ref/iterate/#repeat)                      | apply `f` to `d`, `n` times
1                 | `t f/d`, `t f\d`                                        | [While](/ref/iterate/#while)                    | apply `f` to `d` until `t` of result is 0
1<br>2<br>3+      | `(g/)y`, `g over y`<br>`d g/y`<br>`gg/[d;y;z;…]`        | [Reduce](/ref/reduce)                           | reduce a list or lists 
1<br>2<br>3+      | `(g\)y`, `g scan y`<br>`d g\y`<br>`gg\[d;y;z;…]`        | [Scan](/ref/reduce)                             | scan a list or lists 

Key: 
```
d:   data            gg: map, rank ≥2    
int: int vector      n: int atom ≥0 
ff:  map, rank ≥1    t: test map
f:   unary map       y: list
g:   binary map      x: list
```


