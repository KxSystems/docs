---
title: Overloaded glyphs | Reference | kdb+ and q documentation
description: Many non-alphabetic keyboard characters are overloaded by q. This page tabulates their different forms. 
author: Stephen Taylor
---
# Overloaded glyphs





Many non-alphabetic keyboard characters are overloaded.
Operator overloads are resolved by **rank**, and sometimes by the **type** of argument/s.


## `@` at

rank | syntax          | semantics
:---:|-----------------|-------------------------------
2    | `l@i`, `@[l;i]` | [Index At](apply.md#index)
2    | `f@y`, `@[f;y]` | [Apply At](apply.md#apply-at-index-at)
3    | `@[f;y;e]`      | [Trap At](apply.md#trap)
3    | `@[d;i;u]`      | [Amend At](amend.md)
4    | `@[d;i;m;my]`   | [Amend At](amend.md)
4    | `@[d;i;:;y]`    | [Replace At](amend.md)


## `\` backslash

rank | syntax                 | semantics
:---:|------------------------|---------------------------------------
n/a  | `\`                    | ends multiline comment
n/a  | `\`                    | abort
1    | `(u\)`, `u\[d]`        | [Converge](accumulators.md#converge)
2    | `n u\d`, `u\[n;d]`     | [Do](accumulators.md#do)
2    | `t u\d`, `u\[t;d]`     | [While](accumulators.md#while)
2    | `x v\y`, `v\[x;y;z;…]` | [map-reduce](accumulators.md#binary-iterators)

```txt
d: data                   n: non-negative integer atom
u: unary value            t: test value
v: value rank>1           x: atom or vector
                          y, z…: conformable atoms or lists
```


## `!` bang

rank | syntax            | semantics
:---:|-------------------|---------------------------------
2    | `x!y`             | [Dict](dict.md): make a dictionary
2    | `i!ts`            | [Enkey](enkey.md): make a simple table keyed
2    | `0!tk`            | [Unkey](enkey.md#unkey): make a keyed table simple
2    | `noasv!iv`        | [Enumeration](enumeration.md) from index
2    | `sv!h`            | [Flip Splayed or Partitioned](flip-splayed.md)
2    | `0N!y`            | [display](display.md) `y` and return it
2    | `-i!y`            | [internal function](../basics/internal.md)
4    | `![t;c;b;a]`      | [Update, Delete](../basics/funsql.md)

```txt
a: select specifications
b: group-by specifications
c: where-specifications
h: handle to a splayed or partitioned table
i: integer >0
noasv: symbol atom, the name of a symbol vector
sv: symbol vector
t: table
tk: keyed table
ts: simple table
x,y: same-length lists
```


## `:` colon

<div markdown="1" class="typewriter">
a:42   [assign](../basics/syntax.md) 
:42    [explicit return](../basics/function-notation.md#explicit-return)
</div>


## `:` colon colon

<div markdown="1" class="typewriter">
v::select from t where a in b     [define a view](../learn/views.md)
global::42                        [amend a global from within a lambda](../basics/function-notation.md#name-scope)
::                                [Identity](identity.md)
::                                [Null](identity.md#null)
</div>


## `-` dash

Syntax: immediately left of a number, indicates its negative.
```q
q)neg[3]~-3
1b
```
Otherwise

rank | example         | semantics
:---:|-----------------|-------------------------------------------
2    | `2-3`           | [Subtract](subtract.md)


## `.` dot

rank | syntax              | semantics
:---:|---------------------|---------------------------------------
2    | `l . i`, `.[l;i]`   | [Index](apply.md#apply-index)
2    | `g . gx`, `.[g;gx]` | [Apply](apply.md#apply-index)
3    | `.[g;gx;e]`         | [Trap](apply.md#trap)
3    | `.[d;i;u]`          | [Amend](amend.md)
4    | `.[d;i;m;my]`       | [Amend](amend.md)
4    | `.[d;i;:;y]`        | [Replace](amend.md)

In the [Debugger](../basics/debug.md), push the stack.


## `$` dollar

rank | example                               | semantics
:---:|---------------------------------------|---------------------------------------
3    | `$[x>10;y;z]`                         | [Cond](cond.md): conditional evaluation
2    | `"h"$y`, `` `short$y``, `11h$y`       | [Cast](cast.md): cast datatype
2    | `"H"$y`, `-11h$y`                     | [Tok](tok.md): interpret string as data
2    | `x$y`                                 | [Enumerate](enumerate.md): enumerate `y` from `x`
2    | `10$"abc"`                            | [Pad](pad.md): pad string
2    | `(1 2 3f;4 5 6f)$(7 8f;9 10f;11 12f)` | dot product, matrix multiply, [`mmu`](mmu.md)


## `#` hash

rank | example         | semantics
:---:|-----------------|---------------------------------
2    | `2 3#til 6`     | [Take](take.md)
2    | `s#1 2 3`       | [Set Attribute](set-attribute.md)


## `?` query

rank | example                     | semantics
:---:|-----------------------------|----------------------------------------------------
2    | `"abcdef"?"cab"`            | [Find](find.md) `y` in `x`
2    | `10?1000`, `5?01b`          | [Roll](deal.md#roll-and-deal)
2    | `-10?1000`, ``-1?`yes`no``  | [Deal](deal.md#roll-and-deal)
2    | `0N?1000`, ``0N?`yes`no``   | [Permute](deal.md#permute)
2    | `x?v`                       | extend an enumeration: [Enum Extend](enum-extend.md)
3    | `?[11011b;"black";"flock"]`   | [Vector Conditional](vector-conditional.md)
3    | `?[t;i;p]`                  | [Simple Exec](../basics/funsql.md#simple-exec)
4    | `?[t;c;b;a]`                | [Select](../basics/funsql.md#select), [Exec](../basics/funsql.md#exec)
5    | `?[t;c;b;a;n]`              | [Select](../basics/funsql.md#rank-5)
6    | `?[t;c;b;a;n;(g;cn)]`       | [Select](../basics/funsql.md#rank-6)


## `'` quote

rank | syntax                                    | semantics
:---:|-------------------------------------------|-------------------------------------------
1    | `(u')x`, `u'[x]`, `x b'y`,  `v'[x;y;…]` | [Each](maps.md#each): iterate `u`, `b` or `v` itemwise
1    | `'msg`                                    | [Signal](signal.md) an error
1    | `int'[x;y;…]`                              | [Case](maps.md#case): successive items from lists
2    | `'[u;v]`                                 | [Compose](compose.md) `u` with `v`

```txt
u:  unary value         int:  int vector
b:  binary value        msg:  symbol or string
v: value of rank ≥1     x, y: data
```


## `':` quote-colon

rank | example  | semantics
:---:|----------|-------------------------------------------------------
1    | `u':`    | [Each Parallel](maps.md#each-parallel) with unary `u`
1    | `b':`    | [Each Prior](maps.md#each-prior) with binary `b`


## `/` slash

rank | syntax              | semantics
:---:|---------------------|-----------------------------------------
n/a  | `/a comment`        | comment: ignore rest of line
1    | `(u/)y`, `u/[y]`    | [Converge](accumulators.md#converge)
1    | `n u/ y`, `u/[n;y]` | [Do](accumulators.md#do)
1    | `t u/ y`, `u/[t;y]` | [While](accumulators.md#while)
1    | `(v/)y`, `v/[y]`    | [map-reduce](accumulators.md#binary-values): reduce a list or lists

```txt
u: unary value              t: test value
v: value rank ≥1            y: list
n: non-negative int atom
```

Syntax: a space followed by `/` begins a **trailing comment**. Everything to the right of `/` is ignored.

```q
q)2+2 / we know this one
4
```

A `/` at the beginning of a line marks a **comment line**. The entire line is ignored.

```q
q)/nothing in this line is evaluated
```

In a script, a line with a solitary `/` marks the beginning of a **multiline comment**. A multiline comment is terminated by a `\` or the end of the script.

```q
/
A script to add two numbers.
Version 2018.1.19
\
2+2
/
That's all folks.
```


## `_` underscore

rank | example      | semantics
:---:|--------------|-------------------------
2    | `3_ til 10`  | [Cut](cut.md), [Drop](drop.md)

!!! warning "Names can contain underscores"

    Best practice is to use a space to separate names and the Cut and Drop operators.


## Unary forms

Many of the operators tabulated above have unary forms in k.

:fontawesome-regular-hand-point-right: [Exposed infrastructure](../basics/exposed-infrastructure.md#unary-forms)


