---
title: Iterators
date: November 2018
keywords: adverb, extender, extension, kdb+, map, q
---

# Iterators

==DRAFT==

Iterators (formerly known as _adverbs_) are the primary means of iteration in q, and in almost all cases the most efficient way to iterate. Loops are rare in q programs and are almost always candidates for optimization. Mastery of iterators is a core q skill.

The first part of this paper introduces iterators informally. This provides ready access to the two principal forms of iteration: _maps_ and _accumulators_.

The second part of the paper reviews iterators more formally and with greater attention to syntax. We see how iterators apply not only to functions but also to lists, dictionaries and tables. From their syntax we see when parentheses are required, and why. 


## Basics

Iterators are higher-order unary operators: they take a single argument and return a derived function. The single argument is an iterable: a list, dictionary, table, process handle, or function. The derived function iterates its normal application.

Iterators are the only operators that can be applied postfix. They almost always are.

For example, the iterator Scan, written `\`, applied to the Add operator `+` derived the function Add Scan, written `+\`, which extends Add to return cumulative sums. 

```q
q)(+\)2 3 4
2 5 9
```

Applied to the Multiply operator `*` it derives the function Multiply Scan, written `*\`, which returns cumulative products.

```q
q)(*\)2 3 4
2 6 24
```

(Writers of some other programming languages might recognize these uses of Scan as _fold_.)

Another example. The iterator Each, written `'`, applied to the Join operator `,`, derives the function Join Each, written `,'`.

```q
q)a:2 3#"abcdef"
q)b:2 3#"uvwxyz"
q)a,b
"abc"
"def"
"uvw"
"xyz"
q)a,'b
"abcuvw"
"defxyz"
```

Above, `a` and `b` are both 2×3 character matrixes. That is to say, they are both 2-lists, and their items are character 3-lists. While `a,b` joins the two lists to make a 4-list, the derived function Join Each `a,'b` joins their corresponding items to make two character 6-lists. 

Scan and Each are the cores of the accumulator and map iterators. The other iterators are variants of them. 


## Three kinds of iteration


### Atomic iteration

Many native q operators have iteration built into them. They are atomic. They apply to conforming arguments.

```q
q)2+2           / two atoms
4
q)2 3 4+5 6 7   / two lists
7 9 11
q)2+5 6 7       / atom and list
7 8 9
```

<!-- Pairing an atom to every item of a list is called _scalar extension_.  -->

Two arguments conform if they are lists of the same length, or if one or both is an atom. In atomic iteration this definition recurses _to any depth of nesting_. 

```q
q)(1;2;3 4)+( (10 10 10;20 20); 30; ((40 40; (50 50 50; 60)); 70) )
(11 11 11;21 21)
32
((43 43;(53 53 53;63));74)
```

Because atomic iteration burrows deep into nested structure it is not easy to parallelize. A simpler form of it is.


### Maps

The maps apply a function across items of a list or lists. they do not burrow into a nested structure, but simply iterate across its top level. 

```q
q)count ("the";"quick";"brown";"fox")
4
q)(count') ("the";"quick";"brown";"fox")
3 5 5 3
```

The **Each** iterator has four variants. A function derived by **Each Right** `/:` applies its entire left argument to each item of its right argument. Correspondingly, a function derived by **Each Left** `\:` applies its entire right argument to each item of its left argument.

```q
q)"abc",/:"xyz"     / Join Each Right
"abcx"
"abcy"
"abcz"
q)"abc",\:"xyz"     / Join Each Left
"axyz"
"bxyz"
"cxyz"
```

!!! tip "Each Left and Each Right"

    Remember which is which by the direction in which the slash leans.

**Each Prior** takes a binary iterable as its argument. The derived function is unary: it applies the binary between each item of a list (or dictionary) and its preceding item. 
The differences between items in a numeric or temporal vector:

```q
q)(-':)1 1 2 3 5 8 13 21 34     / Subtract Each Prior
1 0 1 1 2 3 5 8 13
```

**Each Parallel** takes a unary argument and applies it, as Each does, to each item in the derived function’s argument. Unlike Each, it partitions its work between any available slave processes. Suppose `analyze` is CPU-intensive and takes a single symbol atom as argument.

```q
q)(analyze':)`ibm`msoft`googl`aapl
```

With a unary function, the mnemonic keyword `each` is generally preferred as a cover for the extender Each. Similarly, `prior` is preferred for Each Prior and `peach` for Each Parallel.

```q
q)count each ("the";"quick";"brown";"fox")
3 5 5 3
q)(-) prior 1 1 2 3 5 8 13 21 34
1 0 1 1 2 3 5 8 13
q)analyze peach `ibm`msoft`googl`aapl
..
```

With map iterators the number of evaluations is the number of top-level items in the derived function’s argument/s. These functions are right-uniform.

The maps:

extender | name          | mnemonic keyword
:-------:|---------------|:---------------:
`'`      | Each          | `each`
`\:`     | Each Left     | 
`/:`     | Each Right    |
`':`     | Each Prior    | `prior`
`':`     | Each Parallel | `peach`
`'`      | Case          |



### Progressive iteration

In progressive iterations the iterator’s argument is evaluated repeatedly, first on the entire (left) argument of the extension, next on the result of that evaluation, and so on. 

The number of evaluations is determined according to the extension’s rank. 

For a **unary** extension, there are three forms:

-   Converge: iterate until a result matches either the previous result or the original argument
-   Do: iterate a specified number of times
-   While: iterate until the result fails a test

```q
q)({x*x}\)0.1                        / Converge
0.1 0.01 0.0001 1e-08 1e-16 1e-32 1e-64 1e-128 1e-256 0
q)5{x*x}\0.1                         / Do
0.1 0.01 0.0001 1e-08 1e-16 1e-32
q)(1e-6<){x*x}\0.1                   / While
0.1 0.01 0.0001 1e-08
```

For derived functions of **higher-rank** the number of evaluations is the count of the right argument/s. For example, the result `r` of applying a ternary extension `f\` to arguments `x`, `y`, and `z`:

```txt
r[0]:f[x;   y 0; z 0]
r[1]:f[r 0; y 1; z 1]
r[2]:f[r 1; y 2; z 2]
..
```

From this we see that the right arguments `y` and `z` must conform and that `count r` – the number of evaluations – is `count[y]|count[z]`.

There are two progressive iterators. 

-   Functions derived by **Scan** `\` return as a list the results of each evaluation. They are thus right-uniform functions: their results conform to their right arguments. They resemble _fold_ in some other programming languages.
-   Functions derived by **Over** `/` perform the same computation as those from Scan, but return only the last result. They resemble _map reduce_ in some other programming languages.

```q
q)(+\)2 3 4    / Add Scan
2 5 9
q)(+/)2 3 4    / Add Over
9
```

For binary arguments of Scan and Over, the mnemonic keywords `scan` and `over` are generally preferred. 

```q
q)(+) scan 2 3 4
2 5 9
q)(+) over 2 3 4
9
```

The accumulators:

extender | name | mnemonic keyword
:-------:|------|:---------------:
`\`      | Scan | `scan`
`/`      | Over | `over`


## Each

FIXME …


## Authors 

Conor Slattery is a Financial Engineer who has designed kdb+ applications for a range of asset classes. Conor is currently working with a New York based investment firm, developing kdb+ trading platforms for the US equity markets.

Stephen Taylor is the Kx Systems librarian. 

An earlier version of this paper was published in 2013 by Slattery as “Efficient use of adverbs”.

