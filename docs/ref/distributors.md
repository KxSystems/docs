---
keywords: adverb, dictionary, distributive, distributor, each, each both, each left, each parallel, each prior, each right, extender, extension, kdb+, keyword, map, mnemonic, operator, parallel, prior, q, unary
---

# Distributors

`'` `\:` `/:` `':` 





A distributor is an extender that derives a [**uniform**](../basics/glossary.md) extension that applies the map once to each item of a dictionary, a list, or conforming lists. 

There are five distributors. 

glyph | operator      | map rank | extension rank
------|---------------|----------|----------------
`'`   | Each          | any      | same as map
`\:`  | Each Left     | binary   | binary
`/:`  | Each Right    | binary   | binary
`':`  | Each Parallel | unary    | unary
`':`  | Each Prior    | binary   | ambivalent


## Each

_Apply a map item-wise to a dictionary, list, or conforming lists and/or dictionaries._

Syntax: `(m')x`, `x m'y`, `m'[x;y;z]`

An Each extension evaluates its map on each item of a list, dictionary or on corresponding items of conforming lists. The extension has the same rank as the map. 

```q
q)(count')`a`b`c!(1 2 3;4 5;6 7 8 9)        / unary 
a| 3
b| 2
c| 4
```


### `each` keyword

The mnemonic keyword `each` can be used to apply a unary map without parentheses.

```q
q)count each string `Clash`Fixx`The`Who
5 4 3 3
```

<div markdown="1" style="float: right; margin-left: 1em; text-align: center;">
![each-both](../img/each-both.png)  
<small>_Each Both_</small>
</div>

Each applied to a binary map is sometimes called Each Both and can be applied infix.

```q
q)1 2 3 in'(1 0 1;til 100;5 6 7)            / binary, infix 
110b
```

Extensions of ternary and higher-rank maps are applied with brackets.

```q
q){x+y*z}'[1000000;1 0 1;5000 6000 7000]    / ternary
1005000 1000000 1007000
```


## Each Left and Each Right

_Apply a binary map between one argument and each item of the other._


&nbsp;      | Each Left                        | Each Right
------------|:--------------------------------:|:-----------------:
syntax:     | `x m\:y`                         |  `x m/:y`
equivalent: | `(m[;y]')x`                      | `(m[x;]')y`
&nbsp;      | ![Each Left](../img/each-left.png) | ![Each Right](../img/each-right.png)

The extenders Each Left and Each Right take **binary** maps and derive binary functions that apply one argument to each item of the other. Effectively, the extender projects its map on one argument and applies Each.

```q
q)"abcde",\:"XY"             / Each Left
"aXY"
"bXY"
"cXY"
"dXY"
"eXY"
q)"abcde",/:"XY"             / Each Right
"abcdeX"
"abcdeY"
q)m                          / binary map
"abcd"
"efgh"
"ijkl"
q)m[0 1;2 3] ~ 0 1 m\:2 3
1b
q)0 1 m/:2 3
"cg"
"dh"
q)(flip m[0 1;2 3]) ~ 0 1 m/:2 3
1b
```


### Left, right, `cross`

Each Left combined with Each Right resembles the result obtained by [`cross`](cross.md).

```q
q)show a:{x,/:\:x}til 3
0 0 0 1 0 2
1 0 1 1 1 2
2 0 2 1 2 2
q)show b:{x cross x}til 3
0 0
0 1
0 2
1 0
1 1
1 2
2 0
2 1
2 2
q){}0N!a
((0 0;0 1;0 2);(1 0;1 1;1 2);(2 0;2 1;2 2))
q){}0N!b
(0 0;0 1;0 2;1 0;1 1;1 2;2 0;2 1;2 2)
q)raze[a] ~ b
1b
```

!!! warning "Atoms and lists in the domains of these extenders"

    The domains of `\:` and `/:` extend beyond binary maps to include certain atoms and lists. 

    <pre><code class="language-q">
    q)(", "/:)3 5#"quickbrownfoxes"
    "quick, brown, foxes"
    q)(0x0\:)3.14156
    0x400921ea35935fc4
    </code></pre>

    This is [exposed infrastructure](../basics/exposed-infrastructure.md): use the keywords [`vs`](vs.md) and [`sv`](sv.md) instead.


## Each Parallel

<div markdown="1" style="float: right; margin-left: 1em;">
![Each Parallel](../img/each-parallel.png)
</div>

_Assign sublists of the argument list to slave tasks, in which the unary map is applied to each item of the sublist._


Syntax: `(m':)x`

The Each Parallel extender takes a **unary** map as argument and derives a unary function. The extension `m':` divides its list or dictionary argument `x` between [available slave tasks](../basics/cmdline.md#-s-slaves). Each slave task applies the map to each item of its sublist. 

<i class="far fa-hand-point-right"></i> 
Basics: [Command-line option `-s`](../basics/cmdline.md#-s-slaves), 
[Parallel processing](../basics/peach.md)

```bash
$ q -s 2
KDB+ 3.4 2016.06.14 Copyright (C) 1993-2016 Kx Systems
m32/ 2()core 4096MB sjt mark.local 192.168.0.17 NONEXPIRE
```

```q
q)\t ({sum exp x?1.0}' )2#1000000  / each
185
q)\t ({sum exp x?1.0}':)2#1000000  / peach
79
q)peach
k){x':y}
```


### `peach` keyword

The mnemonic keyword `peach` can be used as a mnemonic alternative: e.g. instead of  `(m:')` write `m peach list`.

!!! tip "Higher-rank maps"

    To parallelize a map of rank >1, use [Apply](/ref/apply) to evaluate it on a list of arguments.

    Alternatively, define the map as a function that takes a parameter dictionary as argument, and pass the extension a table of parameters to evaluate.


## Each Prior

<div markdown="1" style="float: right; margin-left: 1em; z-index: 3">
![Each Prior](../img/each-prior.png)
</div>

_Apply a binary map between each item of a list and its preceding item._

Syntax: `(m':)x`, `x m':y`

The Each Prior extender takes a **binary** map and derives an ambivalent function.
The extension applies the map between each item of a list or dictionary and the item prior to it.

```q
q)(-':)1 1 2 3 5 8 13
1 0 1 1 2 3 5
```

The first item of a list has no prior item. 
If the extension is applied as a binary, its left argument is taken as the ‘seed’ – the value preceding the first item. 

```q
q)1950 -': `S`J`C!1952 1954 1960
S| 2
J| 2
C| 6
```

If the extension is applied as a unary, and the map is an operator with an identity element $I$ known to q, $I$ will be used as the seed.

```q
q)(*':)2 3 4                        / 1 is I for *
2 6 12
q)(,':)2 3 4                        / () is I for ,
2
3 2
4 3
q)(-':) `S`J`C!1952 1954 1960       / 0 is I for -
S| 1952
J| 2
C| 6
```

If the extension is applied as a unary, and the map is not an operator with a known identity element, a null of the same type as the argument (`first 0#x`) is used as the seed.

```q
q){x+2*y}':[2 3 4]
0N 7 10
```


### `prior` keyword

The keyword `prior`can be used as a mnemonic alternative to `':`.

```q
q)(-':) 5 16 42 103
5 11 26 61
q)(-) prior 5 16 42 103
5 11 26 61
q)deltas 5 16 42 103
5 11 26 61
```


## Empty lists

A distributive extension is a uniform function. Applied to an empty right argument it returns an empty list without evaluating its map.

```q
q)()~{x+y*z}'[`foo;mt;mt]    / generic empty list ()
1b
```

!!! warning "Watch out for type changes when evaluating lists of unknown length."

```q
q)type (2*')til 5
7h
q)type (2*')til 0
0h
q)type (2*)til 0
7h
```


