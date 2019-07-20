---
title: Variadic syntax
description: An applicable value is variadic if its rank is not fixed.
author: Stephen Taylor
keywords: applicable value, binary, kdb+, operator, projection, q, rank, syntax, unary, variadic
---
# Variadic syntax




An [applicable value](glossary.md#applicable-value) is _variadic_ if its rank is not fixed.

Lists and dictionaries of depth ≥2 and tables are variadic.

```q
q)m:4 5#"abcdefghijklmnopqrst"
q)m[1 3]                        / unary
"fghij"
"pqrst"
q)m[1 3;2 4]                    / binary
"hj"
"rt"
q)t:([]name:`Tom`Dick`Harry;city:`London`Paris`Rome)
q)t[`name]                      / unary
`Tom`Dick`Harry
q)t 1                           / unary
name| Dick
city| Paris
q)t[1;`city]                    / binary
`Paris
```

Some operators are variadic, for example [Apply](../ref/apply.md) and [Amend](../ref/amend.md).

Each Prior, Over and Scan applied to binary values derive variadic [functions](../ref/iterators.md).

```q
q)+/[2 3 4]                  / unary
9
q)+/[1000000;2 3 4]          / binary
1000009
q)-':[1952 1954 1960]        / unary
1952 2 6
q)-':[1900;1952 1954 1960]   / binary
52 2 6
```

Keywords defined from such extensions are also variadic.

```q
q)deltas                     / Subtract Each Prior
-':
q)deltas[15 27 93]           / unary
15 12 66
q)deltas[10;15 27 93]        / binary - unsupported
5 12 66
q)-':[10;15 27 93]           / binary - supported
5 12 66
```


## Projection

Variadic values do not project unless the omitted argument/s are specified as nulls in the argument list.

To project a variadic value as a unary, use a 2-item argument list to resolve the binary form.

```q
q)g:+/[100;]       / 2-item argument list resolves the binary form
q)g 2 3 4 5        / the projection is unary
114
```


## Unary forms of binary operators

Many binary operators are variadic: they have unary forms.
The unary form can be selected with a suffixed colon.

```q
q)|[2;til 5]        / binary: maximum
2 2 2 3 4
q)|:[til 5]         / unary: reverse
4 3 2 1 0
```

Binary operators are infixes.

Like an infix extension, the unary form can be parenthesized and applied prefix.

```q
q)2|til 5            / maximum
2 2 2 3 4
q)(|:)"zero"         / reverse
"orez"
q)2#"zero"           / take
"ze"
q)(#:)"zero"         / count
4
```

Unary forms can also be applied by Apply At.

```q
q)|:["zero"]       / bracket notation
"orez"
q)(|:)"zero"       / prefix
"orez"
q)(|:)@"zero"      / apply-at
"orez"
q)@[|:;"zero"]     / apply-at
"orez"
```

!!! warning "Unary forms are poor q style"

    The semantics of the unary and binary forms of an operator are not always closely related. 

    For better legibility, q provides [keywords for unary forms](exposed-infrastructure.md#unary-forms).
    Good q style prefers them. 
    Write `count "zero"`, not `(#:)"zero"`. 
