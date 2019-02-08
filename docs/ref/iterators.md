---
keywords: adverb, iterator, infix, iterable, iterate, iteration, kdb+, operator, postfix, unary, variadic
---


# Iterators


The iterators (earlier known as _adverbs_) are native higher-order operators: they take [iterables](../basics/glossary.md#iterable) as arguments and return derived functions.

!!! detail "Iterable"

    An iterable is a q object that can be indexed or applied to arguments: a function (operator, keyword, lambda, or derived function), a list (vector, mixed list, matrix, or table), a process handle, or a dictionary.

Iterators are the primary means of [iterating](../basics/iteration.md) in q.

For example, the iterator Over (written `/`) uses an iterable to reduce a list or dictionary.

```q
q)+/[2 3 4]      /reduce 2 3 4 with +
9
q)*/[2 3 4]      /reduce 2 3 4 with *
24
```

Over is applied here postfix, with `+` as its argument. 
The derived function `+/` returns the sum of a list; `*/` returns its product.
(Compare _map-reduce_ in some other languages.)


## Variadic syntax

Each Prior, Over, and Scan applied to binary iterables derive functions with both unary and binary forms.

```q
q)+/[2 3 4]           / unary
9
q)+/[1000000;2 3 4]   / binary
1000009
```

<i class="far fa-hand-point-right"></i> 
[Variadic syntax](../basics/variadic.md)


## Postfix application

Like all functions, the iterators can be applied with bracket notation. 
But they can also be applied postfix, and almost always are.

```q
q)'[count][("The";"quick";"brown";"fox")]   / ' applied with brackets
3 5 5 3
q)count'[("The";"quick";"brown";"fox")]     / ' applied postfix
3 5 5 3
```

Only iterators can be applied postfix.


!!! important "Postfix returns an infix"

    Regardless of its rank,
    **a function derived by postfix application is always an infix**. 

To apply an infix derived function in any way besides infix, you can use bracket notation, as you can with any function.

```q
q)1000000+/2 3 4          / variadic function applied infix
1000009
q)+/[100000;2 3 4]        / variadic function applied binary with brackets
1000009
q)+/[2 3 4]               / variadic function applied unary with brackets
9
q)txt:("the";"quick";"brown";"fox")
q)count'[txt]             / unary function applied with brackets
3 5 5 4
```

If the derived function is unary or ambivalent, you can also parenthesize it and apply it prefix.

```q
q)(count')txt             / unary function applied prefix
3 5 5 4
q)(+/)2 3 4               / variadic function appled prefix
9
```


## Glyphs

Six glyphs are used to denote iterators. Some are overloaded.

Iterators 

-   in bold type derive **uniform** functions;
-   in italic type, _variadic_ functions.

Subscripts indicate the rank of the _iterable_; superscripts, the rank of the _derived function_. (Ranks 4-8 follow the same rule as rank 3.)

glyph | iterator/s
:----:|------------------------------------------
`'`   | ₁ **Case**; **Each**
`\:`  | ₂ **Each Left** ²
`/:`  | ₂ **Each Right** ²
`':`  | ₁ **Each Parallel** ¹ ; ₂ **_Each Prior_** ¹ ²
`/`   | ₁ Converge ¹ ; ₁ Do ² ; ₁ While ² ; ₂ _Reduce_ ¹ ² ; ₃ Reduce ³
`\`   | ₁ Converge ¹ ; ₁ Do ² ; ₁ While ² ; ₂ **_Accumulate_** ¹ ² ; ₃ **Accumulate** ³

Over and Scan, with iterables of rank >2, derive functions of the same rank as the iterable.

The overloads are resolved according to the following table of syntactic forms. 


## Two groups of iterators

There are two kinds of iterators: _maps_ and _accumulators_. 

Maps

: distribute the application of their iterables across the items of a list or dictionary. They are implicitly _parallel_.

Accumulators

: apply their iterables _successively_: first to the entire (left) argument, then to the result of that evaluation, and so on. With iterables of rank ≥2 they correspond to forms of _map reduce_ and _fold_ in other languages. 


## Application

A derived function, like any function, can be applied by **bracket notation**. 
Binary derived functions can also be applied **infix**. 
Unary derived functions can also be applied **prefix**. 
Some derived functions are **variadic** and can be applied as either unary or binary functions. 

This gives rise to multiple equivalent forms, tabulated here.
Because all functions can be applied with bracket notation, to simplify, such forms are omitted here in favour of prefix or infix application. 
For example, `f'[x]` is valid, but only `(f')x` is shown here.
(Iterators are applied here postfix only.)

The mnemonic keywords `each`, `over`, `peach`, `prior` and `scan` are also shown.

argument<br>rank | syntax                                                   | name                                                   | semantics
:----------------:|---------------------------------------------------------|--------------------------------------------------------|------------------------------------------------------
1<br>2<br>3+      | `(f')x`, `f each x`<br>`x g'y`<br>`ff'[x;y;z;…]`        | [Each](maps.md#each)                           | apply `f` to each item of `x`<br>apply `g` to corresponding items of `x` and `y`<br>apply `ff` to corresponding items of `x`, `y`, `z` …
2                 | `x g\:d`                                                | [Each Left](maps.md#each-left-and-each-right)  | apply `g` to `d` and items of `x`
2                 | `d g/:y`                                                | [Each Right](maps.md#each-left-and-each-right) | apply `g` to `d` and items of `y`
1                 | `(f':)x`, `f peach x`                                   | [Each Parallel](maps.md#each-parallel)         | apply `f` to items of `x` in parallel tasks
2                 | `(g':)y`,<br>`g prior y`,<br>`d g':y`                   | [Each Prior](maps.md#each-prior)               | apply `g` to (`d` and) successive pairs of items of `y`
1                 | `int'[x;y;…]`                                           | [Case](maps.md#case)                                        | select from `[x;y;…]`
1                 | `(f/)d`, `(f\)d`                                        | [Converge](accumulators.md#converge)                    | apply `f` to `d` until result converges
1                 | `n f/d`, `n f\d`                                        | [Do](accumulators.md#do)                                | apply `f` to `d`, `n` times
1                 | `t f/d`, `t f\d`                                        | [While](accumulators.md#while)                          | apply `f` to `d` until `t` of result is 0
1<br>2<br>3+      | `(g/)y`, `g over y`<br>`d g/y`<br>`gg/[d;y;z;…]`        | [Reduce](accumulators.md#binary-iterables)                   | reduce a list or lists 
1<br>2<br>3+      | `(g\)y`, `g scan y`<br>`d g\y`<br>`gg\[d;y;z;…]`        | [Accumulate](accumulators.md#binary-iterables)                     | scan a list or lists 

Key: 

```txt
d:   data                 gg: iterable, rank ≥2    
int: int vector           n: int atom ≥0 
ff:  iterable, rank ≥1    t: test iterable
f:   unary iterable       y: list
g:   binary iterable      x: list
```

