# Each adverbs


Various _each_ adverbs

-   apply a unary function to each item of a list
-   apply higher-rank functions between corresponding items of lists
-   apply a function, in parallel slave tasks, to sublists of a list
-   apply a binary function between successive pairs of items in a list

syntax                                     | name          | semantics
-------------------------------------------|---------------|------------------------------------------------------------
`(f')y`, `f'[y]`, `f each y`               | each          | apply `f` to each item of `y`
`x g'y`, `g'[x;y]`                         | each-both     | apply `g` to corresponding items of `x`, `y`, …
`ff'[x;y;z;…]`                             | each          | apply `ff` to items of `x`, `y`, …
`x g\:d`, `g\:[x;d]`                       | each-left     | apply `g` to `d` and items of `x`
`d g/:y`, `g/:[d;y]`                       | each-right    | apply `g` to `d` and items of `y`
`(f':)y`, `f':[y]`                         | each-parallel | apply `f` to items of `y` in parallel tasks
`(g':)y`, `g':[y]`<br>`d g':y`, `g':[d;y]` | each-prior    | apply `g` to (`d` and) successive pairs of items of `y`

Key: 
```
d:  data                 g:   binary function     
ff: function, rank ≥2    x: list
f:  unary function       y: list
```

<i class="far fa-hand-point-right"></i> [Adverbs](/basics/adverbs)


## Each

_Apply a function item-wise to a list or lists._

Syntax: `(f')y`, `f'[y]`, `f each y`, `x g' y`, `h'[x;y;z;…]`

Where 

-   `f` is a unary function
-   `g` is a binary function
-   `h` is a function rank ≥2
-   `x`, `y`, `z`, … conform

The derivative has the same rank as the argument function: 
for a function `ff` of rank _n_, the derivative `ff'` takes `n` arguments.

The derivative `ff'` is an atomic function: its result has the same length as its argument/s. 
The `i`th item of the result is <code>ff[x<sub>i</sub>; y<sub>i</sub>; z<sub>i</sub>; …]</code>.

_Each_ with a **unary** function:
```q
q)(count')("abc";til 7)
3 7
q)count'[("abc";til 7)]
3 7
q)count each ("abc";til 7)
3 7
```
<div markdown="1" style="float: right; margin-left: 1em;">
![each-both](/img/each-both.png)
</div>
_Each_ with a **binary** function is sometimes called **each-both**.
```q
q)0 1 2 3 ,' 10 20 30 40
0 10
1 20
2 30
3 40
q){x+y*z}'[1 2 3;4 5 6;7 8 9]
29 42 57
```
If either `x` or `y` is atomic, it is paired to every item in the other argument/s. 
_Each-both_ then has the same effect as (respectively) [_each-right_](#each-right) and [_each-left_](#each-left).
```q
q)0 1 2 3 ,' 10
0 10
1 10
2 10
3 10
q){x+y*z}'[2;4 5 6;7 8 9]
30 42 56
```
_Each_ makes a function behave like an atomic function. So it has no effect on atomic functions.
```q
q)neg[1 2 3]~neg'[1 2 3]
1b
q)(1 2 3+4 5 6)~1 2 3+'4 5 6
1b
```


## Each-left

<div markdown="1" style="float: right; margin-left: 1em;">
![each-left](/img/each-left.png)
</div>

_Apply a binary function between each item of the left argument and the entire right argument._

Syntax: `x g\: d`, `g\:[x;d]`

Where 

-   `d` is data
-   `g` is a binary function
-   `x` is a list

the derivative `g\:` applies `g` between `d` and each item of `x`.
```q
q)(til 5),\:0 1
0 0 1
1 0 1
2 0 1
3 0 1
4 0 1
```


## Each-right

<div markdown="1" style="float: right; margin-left: 1em;">
![each-right](/img/each-right.png)
</div>

_Apply a function between the entire left argument and each item of the right argument._

Syntax: `d g/: y`, `g/:[d;y]`

Where 

-   `d` is data
-   `g` is a binary function
-   `y` is a list

the derivative `g/:` applies `g` between `x` and each item of `y`.
```q
q)(til 5),/:0 1
0 1 2 3 4 0
0 1 2 3 4 1
```

!!! tip "Left, right, cross"
    _Each-left_ combined with _each-right_
    <pre><code class="language-q">
    q){}0N!(til 4),\:/: til 4
    ((0 0;1 0;2 0;3 0);(0 1;1 1;2 1;3 1);(0 2;1 2;2 2;3 2);(0 3;1 3;2 3;3 3))    </code></pre>
    resembles the result obtained by `cross`
    <pre><code class="language-q">
    q){}0N!cross[til 4;til 4]
    (0 0;0 1;0 2;0 3;1 0;1 1;1 2;1 3;2 0;2 1;2 2;2 3;3 0;3 1;3 2;3 3)
    </code></pre>

    <i class="far fa-hand-point-right"></i> [`cross`](cross)


## Each-parallel

_Assign sublists of the argument list to slave tasks, in which the unary function is applied to each item of the sublist._

![each-parallel](/img/each-parallel.png)

Syntax: `(f':)y`, `f':[y]` 

where `f` is a unary function, the derivative `f':` assigns sublists of `y` to separate slave tasks, and in each task applies `f` to each item of the sublist.
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
<i class="far fa-hand-point-right"></i> [command-line option `-s`](cmdline/#-s-slaves), [parallel processing, `peach`](peach)

!!! tip "Projecting a unary function with apply"
    You can use [_apply_ `.`](dot/#apply) to project a binary or higher-rank function as a unary function of a list of its arguments. The projection can then be combined with an adverb (such as _each-parallel_, [_converge_](iterate/#converge) or [_repeat_](iterate/#repeat)) that takes a unary function as its argument.

    <pre><code class="language-q">
    q)f2:{(0|x-1;x rotate y)} / binary fn, returns 2-list
    q)f1:f2 .                 / unary fn of a 2-list
    q)f1\\[(4;"hello")]        / converge
    4 "hello"
    3 "ohell"
    2 "llohe"
    1 "ohell"
    0 "hello"
    </code></pre>
    Note that for [_converge_](iterate/#converge), the function must return a list of the same length as its rank.


<div markdown="1" style="float: right; margin-left: 1em;">
![each-prior](/img/each-prior.png)
</div>


## Each-prior

_Apply a binary function between each item of a list and its preceding item._

Syntax (unary): `(g':)y`, `g':[y]`  
Syntax (binary): `d g':y`, `g':[d;y]`

Where 

-   `d` is data
-   `g` is a binary function
-   `y` is a list

the derivative `g':` is ambivalent: it may be applied as a unary or a binary function. 

-   As a **binary** the derivative applies `g` between each item of `y` and `x,-1_y`.

-   As a **unary** the derivative defaults the value of `x` to `first 1#0#y`.

```q
q)99,':til 4
0 99
1 0
2 1
3 2
q)(,':)til 4  / x defaults to 0N
0
1 0
2 1
3 2
q)"abc",':"xyz"
"xabc"
"yx"
"zy"
q)0 1-':2 5 9
2 1
3
4
q)0-':2 5 9
2 3 4
q)-':[2 5 9]     /deltas
2 3 4
```
Some different forms of _each-prior_:

form       | example            | application               | rank
-----------|--------------------|---------------------------|------ 
`g':[y]`   | `-':[   1 4 9 16]` | prefix                    | unary
`(g':)y`   | `(-':)  1 4 9 16`  | juxtaposition             | unary
`x g': y`  | `9-':   1 4 9 16`  | infix                     | binary
`g':[x;y]` | `-':[9; 1 4 9 16]` | prefix                    | binary
`g':[x;]y` | `-':[9;]1 4 9 16`  | projection, juxtaposition | binary

