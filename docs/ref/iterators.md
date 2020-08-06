---
title: Iterators | Reference | kdb+ and q documentation
description: The iterators (earlier known as adverbs) are native higher-order operators. They take applicable values as arguments and return derived functions.
keywords: adverb, iterator, infix, iterate, iteration, kdb+, operator, postfix, unary, value, variadic
date: March 2019
author: Stephen Taylor
---
# Iterators


<pre markdown="1" class="language-txt">
--------- [maps](maps.md) --------     --------- [accumulators](accumulators.md) ----------
['  Each](maps.md#each)           [each](maps.md#each-keyword)      / [Over](accumulators.md#binary-application)  [over](over.md)  [Converge](accumulators.md#converge), [Do](accumulators.md#do), [While](accumulators.md#while)
[': Each Parallel](maps.md#each-parallel)  [peach](maps.md#peach-keyword)     \\ [Scan](accumulators.md#binary-application)  [scan](over.md)  [Converge](accumulators.md#converge), [Do](accumulators.md#do), [While](accumulators.md#while)
[': Each Prior](maps.md#each-prior)     [prior](maps.md#prior-keyword)
[\\: Each Left](maps.md#each-left-and-each-right)
[/: Each Right](maps.md#each-left-and-each-right)
['  Case](maps.md#case)
</pre>

The iterators (once known as _adverbs_) are native higher-order operators: they take [applicable values](../basics/glossary.md#applicable-value) as arguments and return derived functions.
They are the primary means of iterating in q.

:fontawesome-solid-book-open:
[Iteration](../basics/iteration.md) in q
<br>
:fontawesome-regular-map:
White paper: [Iterators](../wp/iterators/index.md)

!!! detail "Applicable value"

    An applicable value is a q object that can be indexed or applied to arguments: a function (operator, keyword, lambda, or derived function), a list (vector, mixed list, matrix, or table), a file- or process handle, or a dictionary.


For example, the iterator Over (written `/`) uses a value to reduce a list or dictionary.

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

Each Prior, Over, and Scan applied to binary values derive functions with both unary and binary forms.

```q
q)+/[2 3 4]           / unary
9
q)+/[1000000;2 3 4]   / binary
1000009
```

:fontawesome-solid-book-open: 
[Variadic syntax](../basics/variadic.md)


## Postfix application

Like all functions, the iterators can be applied with Apply or with bracket notation. 
But unlike any other functions, they can also be applied postfix. They  almost always are.

```q
q)'[count][("The";"quick";"brown";"fox")]   / ' applied with brackets
3 5 5 3
q)count'[("The";"quick";"brown";"fox")]     / ' applied postfix
3 5 5 3
```

Only iterators can be applied postfix.


!!! important "Regardless of its rank, **a function derived by postfix application is always an infix**."

To apply an infix derived function in any way besides infix, you can use bracket notation, as you can with any function.

```q
q)1000000+/2 3 4       / variadic function applied infix
1000009
q)+/[100000;2 3 4]     / variadic function applied binary with brackets
1000009
q)+/[2 3 4]            / variadic function applied unary with brackets
9
q)txt:("the";"quick";"brown";"fox")
q)count'[txt]          / unary function applied with brackets
3 5 5 4
```

If the derived function is unary or [variadic](../basics/variadic.md), you can also parenthesize it and apply it prefix.

```q
q)(count')txt          / unary function applied prefix
3 5 5 4
q)(+/)2 3 4            / variadic function appled prefix
9
```


## Glyphs

Six glyphs are used to denote iterators. Some are overloaded.

Iterators 

-   in bold type derive **uniform** functions;
-   in italic type, _variadic_ functions.

Subscripts indicate the rank of the value; superscripts, the rank of the _derived function_. (Ranks 4-8 follow the same rule as rank 3.)

glyph | iterator/s
:----:|------------------------------------------
`'`   | ₁ **Case**; **Each**
`\:`  | ₂ **Each Left** ²
`/:`  | ₂ **Each Right** ²
`':`  | ₁ **Each Parallel** ¹ ; ₂ **_Each Prior_** ¹ ²
`/`   | ₁ Converge ¹ ; ₁ Do ² ; ₁ While ² ; ₂ _Reduce_ ¹ ² ; ₃ Reduce ³
`\`   | ₁ Converge ¹ ; ₁ Do ² ; ₁ While ² ; ₂ **_Accumulate_** ¹ ² ; ₃ **Accumulate** ³

Over and Scan, with values of rank >2, derive functions of the same rank as the value.

The overloads are resolved according to the following table of syntactic forms. 


## Two groups of iterators

There are two kinds of iterators: _maps_ and _accumulators_. 

Maps

: distribute the application of their values across the items of a list or dictionary. They are implicitly _parallel_.

Accumulators

: apply their values _successively_: first to the entire (left) argument, then to the result of that evaluation, and so on. With values of rank ≥2 they correspond to forms of _map reduce_ and _fold_ in other languages. 


## Application

A derived function, like any function, can be applied by **bracket notation**. 
Binary derived functions can also be applied **infix**. 
Unary derived functions can also be applied **prefix**. 
Some derived functions are **variadic** and can be applied as either unary or binary functions. 

This gives rise to multiple equivalent forms, tabulated here.
Any function can be applied with bracket notation or with Apply.
So to simplify, such forms are omitted here in favour of prefix or infix application. 
For example, `u'[x]` and `@[u';x]` are valid, but only `(u')x` is shown here.
(Iterators are applied here postfix only.)

The mnemonic keywords `each`, `over`, `peach`, `prior` and `scan` are also shown.

value<br>rank | syntax                                            | name                                           | semantics
:------------:|---------------------------------------------------|------------------------------------------------|------------------------------------------------------
1<br>2<br>3+  | `(u')x`, `u each x`<br>`x b'y`<br>`v'[x;y;z;…]`   | [Each](maps.md#each)                           | apply `u` to each item of `x`<br>apply `g` to corresponding items of `x` and `y`<br>apply `v` to corresponding items of `x`, `y`, `z` …
2             | `x b\:d`                                          | [Each Left](maps.md#each-left-and-each-right)  | apply `b` to `d` and items of `x`
2             | `d b/:y`                                          | [Each Right](maps.md#each-left-and-each-right) | apply `b` to `d` and items of `y`
1             | `(u':)x`, `u peach x`                             | [Each Parallel](maps.md#each-parallel)         | apply `u` to items of `x` in parallel tasks
2             | `(b':)y`,<br>`b prior y`,<br>`d b':y`             | [Each Prior](maps.md#each-prior)               | apply `b` to (`d` and) successive pairs of items of `y`
1             | `int'[x;y;…]`                                     | [Case](maps.md#case)                           | select from `[x;y;…]`
1             | `(u/)d`, `(u\)d`                                  | [Converge](accumulators.md#converge)           | apply `u` to `d` until result converges
1             | `n u/d`, `n u\d`                                  | [Do](accumulators.md#do)                       | apply `u` to `d`, `n` times
1             | `t u/d`, `t u\d`                                  | [While](accumulators.md#while)                 | apply `u` to `d` until `t` of result is 0
1<br>2<br>3+  | `(b/)y`, `b over y`<br>`d b/y`<br>`vv/[d;y;z;…]`  | [Over](accumulators.md#binary-values)     | reduce a list or lists 
1<br>2<br>3+  | `(g\)y`, `g scan y`<br>`d g\y`<br>`vv\[d;y;z;…]`  | [Scan](accumulators.md#binary-values) | scan a list or lists 

Key: 

```txt
d:   data                 
int: int vector         n: int atom ≥0 
v:   value              t: test value
u:   unary value        y: list
b:   binary value       x: list
```

