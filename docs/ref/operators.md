# Operators


==FIXME Replicate top of table from [Reference card](index.md).==


Many non-alphabetic keyboard characters are overloaded.
Operator overloads are resolved by **rank**, and sometimes by the **type** of argument/s. 


## `@` at

rank | syntax          | semantics
:---:|-----------------|-------------------------------
2    | `l@i`, `@[l;i]` | [Index At](index)
2    | `f@y`, `@[f;y]` | [Apply At](apply/#apply-at-for-unary-functions)
3    | `@[f;y;e]`      | [Trap At](apply/#trap)
3    | `@[d;i;u]`      | [Amend At](amend)
4    | `a[d;i;m;my]`   | [Amend At](amend)
4    | `a[d;i;:;y]`    | [Replace At](amend)


## `\` backslash

rank | syntax                 | semantics
:---:|------------------------|---------------------------------------
n/a  | `\`                    | ends multiline comment
n/a  | `\`                    | abort
1    | `(f\)`, `f\[d]`        | [Converge](iterate/#converge)
2    | `n f\d`, `f\[n;d]`     | [Repeat](iterate/#repeat)
2    | `t f\d`, `f\[t;d]`     | [While](iterate/#while)
2    | `x g\y`, `g\[x;y;z;…]` | [Reduce](reduce)

```txt
d: data              n: non-negative integer
f: unary map         t: test map
g: map rank>1        x: atom or vector
                     y, z…: conformable atoms or lists
```


## `!` bang

rank | syntax            | semantics
:---:|-------------------|---------------------------------
2    | `x!y`             | [Dict](dict): make a dictionary
2    | `i!ts`            | [Enkey](enkey/#enkey): make a simple table keyed
2    | `0!tk`            | [Unkey](enkey/#unkey): make a keyed table simple
2    | `noasv!iv`        | [Enumeration](enumeration) from index
2    | `sv!h`            | [Flip Splayed or Partitioned](flip-splayed)
2    | `0N!y`            | [display](show/#display) `y` and return it
2    | `-i!y`            | internal function
4    | `![t;c;b;a]`      | [Update, Delete](/basics/funcsql)

```txt
a: select specifications
b: group-by specifications
c: where-specifications
h: handle to a splayed or partitioned table
i: integer >0
i0: integer ≥0
noasv: symbol atom, the name of a symbol vector
sv: symbol vector
t: table
tk: keyed table
ts: simple table
x,y: same-length lists
```


## `.` dot

rank | syntax              | semantics
:---:|---------------------|---------------------------------------
2    | `l . i`, `.[l;i]`   | [Index](apply)
2    | `g . gx`, `.[g;gx]` | [Apply](apply)
3    | `.[g;gx;e]`         | [Trap](apply/#trap)
3    | `.[d;i;u]`          | [Amend](amend)
4    | `.[d;i;m;my]`       | [Amend](amend)
4    | `.[d;i;:;y]`        | [Replace](amend)



## `$` dollar

rank | example                               | semantics
:---:|---------------------------------------|---------------------------------------
3    | `$[x>10;y;z]`                         | [Cond](cond): conditional evaluation
2    | `"h"$y`, `` `short$y``, `11$y`        | [Cast](cast): cast datatype
2    | `"H"$y`, `-11$y`                      | [Tok](tok): interpret string as data
2    | `x$y`                                 | [Enum](enum): enumerate y from x
2    | `10$"abc"`                            | [Pad](pad): pad string
2    | `(1 2 3f;4 5 6f)$(7 8f;9 10f;11 12f)` | deprecated, use [`mmu`](mmu)


## `#` hash

rank | example         | semantics
:---:|-----------------|---------------------------------
2    | `2 3#til 6`     | [Take](take)
2    | `s#1 2 3`       | [Set Attribute](set-attribute)


## `-` dash

Syntax: immediately left of a number, indicates its negative.
```q
q)neg[3]~-3
1b
```
Otherwise

rank | example         | semantics
:---:|-----------------|-------------------------------------------
2    | `2-3`           | [Subtract](subtract)


## `?` query

rank | example                     | semantics
:---:|-----------------------------|----------------------------------------------------
2    | `"abcdef"?"cab"`            | [Find](find) `y` in `x`
2    | `10?1000`, `5?01b`          | [Roll](roll-deal/#roll)
2    | `-10?1000`, ``-1?`yes`no``  | [Deal](roll-deal/#deal)
2    | `u?v`                       | `v` as an enumeration of `u`: [Enum](enum)
2    | `noav?v`                    | extend an enumeration: [Enum-extend](enum-extend)
3    | `?[11011b;"black";"frame"]` | [Vector Conditional](vector-conditional.md)
4    | `?[t;b;c;a]`                | [Select](/basics/funsql/#select), [Exec](/basics/funsql/#exec)
4    | `?[t;i;x]`                  | [Simple exec](/basics/funsql/#simple-exec)


## `'` quote

rank | syntax                                    | semantics
:---:|-------------------------------------------|-------------------------------------------
1    | `(f')x`, `f'[x]`, `x ff'y`,  `ff'[x;y;…]` | [Each](each): iterate `ff` itemwise
1    | `'msg`                                    | [Signal](signal) an error
1    | `iv'[x;y;…]`                              | [Case](case): successive items from lists
2    | `'[ff;f]`                                 | [Compose](compose) `ff` with `f`

```txt
f:  unary map         msg: symbol or string
ff: map of rank ≥1    x, y: data
iv: int vector
```


## `':` quote-colon

rank | example  | semantics
:---:|----------|-------------------------------------------------------
1    | `f':`    | [Each Parallel](each/#each-parallel) with unary `f`
1    | `g':`    | [Each Prior](each/#each-prior) with binary `g`


## `/` slash

rank | syntax              | semantics
:---:|---------------------|-----------------------------------------
n/a  | `/a comment`        | comment: ignore rest of line
1    | `(f/)y`, `f/[y]`    | [Converge](iterate/#converge) 
1    | `n f/ y`, `f/[n;y]` | [Repeat](iterate/#repeat) 
1    | `t f/ y`, `f/[t;y]` | [While](iterate/#while) 
1    | `(ff/)y`, `ff/[y]`  | [Reduce](reduce): reduce a list or lists

```txt
f: unary map       t: test map     
ff: map rank ≥1    y: list
n: int atom ≥0
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
2    | `3_ til 10`  | [Cut](cut), [Drop](drop)

!!! warning "Names can contain underscores"

    Best practice is to use a space to separate names and the Cut and Drop operators.


## Unary forms

Many of the operators tabulated above have unary forms in k. 

<i class="far fa-hand-point-right"></i> [Exposed infrastructure](/basics/exposed-infrastructure/#unary-forms)


