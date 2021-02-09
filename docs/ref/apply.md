---
title: Apply (At), Index (At), Trap (At) | Reference | kdb+ and q documentation
description: Operators Apply (At), Index (At), and Trap (At) apply a funcxtion to one or more arguments, get items at depth in a list, and trap errors.
author: Stephen Taylor
keywords: apply, apply at, index, index at, kdb+, q, trap, trap at
---

[![Kandinsky: circles in a circle](../img/kandinsky-circles-in-a-circle.jpg)](https://en.wikipedia.org/wiki/Wassily_Kandinsky "Wikipedia")
<br>
<small>_Circles in a Circle, 1923_<br><br>Everything begins with a dot.<br>— W.W. Kandinsky</small>
{: style="float: right; max-width: 200px"}

# `.` Apply, Index, Trap<br>`@` Apply At, Index At, Trap At

-   _Apply a function to a list of arguments_
-   _Get items at depth in a list_
-   _Trap errors_



<div style="clear: both"></div>

rank | syntax               | function semantics                  | list semantics
:---:|----------------------|-------------------------------------|---------------
2    | `v . vx`<br>`.[v;vx]` | **Apply**<br>Apply `v` to list `vx` of arguments | **Index**<br>Get item/s `vx` at depth from `v`
2    | `u @ ux`<br>`@[u;ux]` | **Apply At**<br>Apply unary `u` to argument `ux`    | **Index At**<br>Get items `ux` from `u`
3    | `.[g;gx;e]`          | **Trap**<br>Try `g . gx`; catch with `e`        |
3    | `@[f;fx;e]`          | **Trap At**<br>Try `f@fx`; catch with `e`          |

Where

-   `e` is an expression, typically a function
-   `f` is a unary function and `fx` in its domain
-   `g` is a function of rank $n$ and `gx` an atom or list of count $n$ with items in the domains of `g`
-   `v` is a value of rank $n$ (or a handle to one) and `vx` a list of count $n$ with items in the domains of `v`
-   `u` is a unary value (or a handle to one) and `ux` in its domain


## Amend, Amend At

For the ternary and quaternary forms

```txt
.[d; i; u]      @[d; i; u]
.[d; i; v; vy]  @[d; i; v; vy]
```

where 

-   `d` is a list or dictionary, or a handle to a list, dictionary or datafile
-   `i` indexes `d` as `d . i` or `d @ i`
-   `u` is a unary with `d` in its domain
-   `v` is a binary with `d` and `vy` is in its left and right domains

see [Amend and Amend At](amend.md).



## Apply, Index

`v . vx` evaluates value `v` on the $n$ arguments listed in `vx`.

```q
q)add
0 1 2 3
1 2 3 4
2 3 4 5
3 4 5 6
q)add . 2 3         / add[2;3] Index
5
q)(+) . 2 3         / +[2;3] Apply
5
q).[+;2 3]
5
q).[add;2 3]
5
```

If `v` has rank $n$, then `vx` has $n$ items and `v` is evaluated as:

```q
v[vx[0]; vx[1]; …; vx[-1+count vx]]
```

If `v` has rank 2 then `vx` has 2 items and `v` is applied to the first argument `vx[0]` and the second argument `vx[1]`.

```q
v[vx[0];vx[1]]
```

If `v` has 1 argument then `vx` has 1 item and `v` is applied to the argument `vx[0]`.

```q
v[vx[0]]
```

:fontawesome-solid-street-view:
_Q for Mortals_
[§6.5.3 Indexing at Depth](/q4m3/6_Functions/#653-indexing-at-depth)


## Nullaries

Nullaries (functions of rank 0) are handled differently. The pattern above suggests that the empty list `()` would be the argument list to nullary `v`, but `v . ()` is a case of Index, where empty `vx` always selects `v`.

Apply for nullary `v` is denoted by `v . enlist[::]`, i.e. the right argument is the enlisted null.
For example:

```q
q)a: 2 3
q)b: 10 20
q){a + b} . enlist[::]
12 23
```


## Index

`d . i` returns an item from list or dictionary `d` as specified by successive items in list `i`.
The result is found in `d` at depth `count i` as follows.

The list `i` is a list of successive indexes into `d`. `i[0]` must be in the domain of `d@`. It selects an item of `d`, which is then indexed by `i[1]`, and so on.


`( (d@i[0]) @ i[1] ) @ i[2]` …


```q
q)d
(1 2 3;4 5 6 7)
(8 9;10;11 12)
(13 14;15 16 17 18;19 20)
q)d . enlist 1      / select item 1, i.e. d@1
8 9
10
11 12
q)d . 1 2           / select item 2 of item 1
11 12
q)d . 1 2 0         / select item 0 of item 2 of item 1
11
```


### Index At

The selections at each level are individual applications of Index At: first, item `d@i[0]` is selected, then `(d@i[0])@i[1]`, then `((d@i[0])@ i[1])@ i[2]`, and so on.

These expressions can be rewritten using [Over](accumulators.md) applied to Index At; the first is `d@/i[0]`, the second is `d@/i[0 1]`, and the third is `d@/i[0 1 2]`.

In general, for a vector `i` of any count, `d . i` is identical to `d@/i`.

```q
q)((d @ 1) @ 2) @ 0         / selection in terms of a series of @s
11
q)d @/ 1 2 0                / selection in terms of @-Over
11
```


### Cross sections

Index is cross-sectional when the items of `i` are lists. That is, items-at-depth in `d` are indexed for paths made up of all combinations of atoms of `i[0]` and atoms of `i[1]` and atoms of `i[2]`, and so on to the last item of `i`.

The simplest case of cross-sectional index occurs when the items of `i` are vectors. For example, `d .(2 0;0 1)` selects items 0 and 1 from both items 2 and 0:

```q
q)d . (2 0; 0 1)
13 14 15 16 17 18
1 2 3 4 5 6 7
q)count each d . (2 0; 0 1)
2 2
```

Note that items appear in the result in the same order as the indexes appear in `i`.

The first item of `i` selects two items of `d`, as in `d@i[0]`. The second item of `i` selects two items from each of the two items just selected, as in `(d@i[0])@'i[1]`. Had there been a third vector item in `i`, say of count 5, then that item would select five items from each of the four items-at-depth 1 just selected, as in `((d@i[0])@'i[1])@''i[2]`, and so on.

When the items of `i` are vectors the result is rectangular to at least depth `count i`, depending on the regularity of `d`, and the `k`th item of its shape vector is `(count i)[k]` for every `k` less than `count i`. That is, the first `count i` items of the shape of the result are `count each i`.


More general cross-sectional indexing occurs when the items of `i` are rectangular lists, not just vectors, but the situation is much like the simpler case of vector items.

<!-- In particular, the shape of the result is ,/^:'i. FIXME -->


### Nulls in `i`

Nulls in `i` mean “select all”: if `i[0]` is null, then continue on with `d` and the rest of `i`, i.e. `1_i`; if `i[1]` is null, then for every selection made through `i[0]`, continue on with that selection and the rest of `i`, i.e. `2_i`; and so on. For example, `d .(::;0)` means that the 0th item of every item of `d` is selected.

```q
q)d
(1 2 3;4 5 6 7)
(8 9;10;11 12)
(13 14;15 16 17 18;19 20)
q)d . (::;0)
1 2 3
8 9
13 14
```

Another example, this time with `i[1]` equal to null:

```q
q)d . (0 2;::;1 0)
(2 1;5 4)
(14 13;16 15;20 19)
```

Note that `d .(::;0)` is the same as `d .(0 1 2;0)`, but in the last example, there is no value that can be substituted for null in `(0 2;;1 0)` to get the same result, because when item 0 of `d` is selected, null acts like `0 1`, but when item 2 of `d` is selected, it acts like `0 1 2`.


### The general case of a non-negative integer list `i`

In the general case, when the items of `i` are non-negative integer atoms or lists, or null, the structure of the result can be thought of as cascading structures of the items of `i`. That is, with nulls aside, the result is structurally like `i[0]`, except that wherever there is an atom in `i[0]`, the result is structurally like `i[1]`, except that wherever there is an atom in `i[1]`, the result is structurally like `i[2]`, and so on.

The general case of Index can be defined recursively in terms of [**Index At**](#index-at) by partitioning the list `i` into its first item and the rest:

```q
Index:{[d;F;R]
  $[ F~::; Index[d; first R; 1 _ R];
     0 =count R; d @ F;
     0>type F; Index[d @ F; first R; 1 _ R]
     Index[d;; R]'F ]}
```

That is, `d . i` is `Index[d;first i;1_i]`.

To work through the definition, start with `F` as the first item of `i` and `R` as the remainder. At each step in the recursion:

-   if `F` is null then select all of `d` and continue on, with the first item of the remainder `R` as the new `F` and the remainder of `R` as the new remainder;
-   otherwise, if the remainder is the empty vector apply Index At (the right argument `F` is now the last item of `i`), and we are done;
-   otherwise, if `F` is an atom, apply Index At to select that item of `d` and continue on in the same way as when `F` is null;
-   otherwise, apply Index with fixed arguments `d` and `R`, but independently to the items of the list `F`.


### Dictionaries and symbolic indexing

If `i` is a symbol atom then `d` must be a dictionary or handle of a directory on the K-tree, and `d . i` selects the value of the entry named in `i`. For example, if:

```q
dir:`a`b!(2 3 4;"abcdefg")
```

then `` `dir . enlist`b`` is `"abcdefg"` and `` `dir . (`b;1 3 5)`` is `"bdf"`.

If `i` is a list whose items are non-negative integer atoms and symbol atoms, then just like the non-negative integer vector case, `d . i` is a single item at depth `count i` in `d`. The difference is that wherever a symbol appears in `i`, say as the kth item, the selection up to the kth item must produce a dictionary or a handle of a directory. Selection by the kth item is the value of an entry in that dictionary or directory, and further selections go on from there. For example:

```q
q)(1;`a`b!(2 3 4;10 20 30 40)) . (1; `b; 2)
30
```

As we have seen above for the general case, every atom in the `k`th item of `i` must be a valid index of all items at depth `k` selected by `d . k # i`. Moreover, symbols can only select from dictionaries and directories, and integers cannot.
Consequently, if the `k`th item of `i` contains a symbol atom, then all items selected by `d . k # i` must be dictionaries or handles of directories, and therefore all atoms in the `k`th item of `i` must be symbols.

It follows that each item of `i` must be made up entirely of non-negative integer atoms, or entirely of symbol atoms, and if the `k`th item of `i` is made up of symbols, then all items at depth `k` in `d` selected by the first `k` items of `i` must be dictionaries.

Note that if `d` is either a dictionary or handle to a directory then `d . enlist key d` is a list of values of all the entries.


### Step dictionaries

Where `d` is a dictionary, `d@i` or `d[i]` or `d i` returns for each item of `i` that is _outside_ the domain of `d` a null of the same type as the keys.

```q
q)d:`cat`cow`dog`sheep!`chat`vache`chien`mouton
q)d
cat  | chat
cow  | vache
dog  | chien
sheep| mouton
q)d `sheep`snake`cat`ant
`mouton``chat`
q)
q)e:(10*til 10)!til 10
q)e
0 | 0
10| 1
20| 2
30| 3
40| 4
50| 5
60| 6
70| 7
80| 8
90| 9
q)e 80 35 20 -10
8 0N 2 0N
```

A _step dictionary_ has the _sorted_ attribute set.
Its keys are a sorted vector.
Where `s` is a step dictionary, and `i[k]` are the items of `i` that are _outside_ the domain of `d`, the value/s for `d@i@k` are the values for the highest keys that are lower than `i k`.

```q
q)d:`cat`cow`dog`sheep!`chat`vache`chien`mouton
q)ds:`s#d
q)ds~d
1b
q)ds `sheep`snake`cat`ant
`mouton`mouton`chat`
q)
q)es:`s#e
q)es~e
1b
q)es 80 35 20 -10
8 3 2 0N
```

:fontawesome-solid-book:
[Set Attribute](set-attribute.md)
<br>
:fontawesome-solid-globe:
q-rious kdb+: [Step Dictionaries](https://qriouskdb.wordpress.com/2019/01/01/step-dictionaries/)


## Apply At, Index At

`@` is [syntactic sugar](https://en.wikipedia.org/wiki/Syntactic_sugar "Wikipedia") for the case where `u` is a unary and `ux` a 1-item list.
`u@ux` is always equivalent to `u . enlist ux`.

!!! note "Brackets are syntactic sugar"

    The brackets of an argument list are also syntactic sugar. Nothing can be expressed with brackets that cannot also be expressed using `.`.

You can use the derived function `@\:` to apply a list of unary values to the same argument.

```q
q){`o`h`l`c!(first;max;min;last)@\:x}1 2 3 4 22  / open, high, low, close
o| 1
h| 22
l| 1
c| 22
```


## Composition

A sequence of unaries `u`, `v`, `w`… can be composed with Apply At as `u@v@w@`.
All but the last `@` may be elided: `u v w@`. 

```q
q)tc:til count@  / indexes of a list
q)tc "abc"
"0 1 2"
```

The last value in the sequence can have higher rank if projected as a unary by Apply.

```q
q)di:reciprocal(%).  / divide into
q)di 2 3             / divide 2 into 3
1.5
```

:fontawesome-solid-book:
[Compose](compose.md)

## Trap

In the ternary, if evaluation of the function fails, the expression is evaluated.
(Compare try/catch in some other languages.)

```q
q).[+;"ab";`ouch]
`ouch
```

If the expression is a function, it is evaluated on the text of the signalled error.

```q
q).[+;"ab";{"Wrong ",x}]
"Wrong type"
```

For a successful evaluation, the ternary returns the same result as the binary.

```q
q).[+;2 3;{"Wrong ",x}]
5
```


### Trap At

`@[f;fx;e]` is equivalent to `.[f;enlist fx;e]`.

Use Trap At as a simpler form of Trap, for unary values.


### Limit of the trap

Trap catches only errors signalled in the applications of `f` or `g`. Errors in the evaluation of `fx` or `gg` themselves are not caught.

```q
q)@[2+;"42";`err]
`err
q)@[2+;"42"+3;`err]
'type
  [0]  @[2+;"42"+3;`err]
                ^
```


### When `e` is not a function

If `e` is a function it will be evaluated _only_ if `f` or `g` fails. It will however be _parsed_ before any of the other expressions are evaluated.

```q
q)@[2+;"42";{)}]
')
  [0]  @[2+;"42";{)}]
                  ^
```

If `e` is any _other_ kind of expression it will _always_ be evaluated – and _first_, in the usual right-to-left sequence. In this respect Trap and Trap At are unlike try/catch in other languages.

```q
q)@[string;42;a:100] / expression not a function
"42"
q)a // but a was assigned anyway
100
q)@[string;42;{b::99}] / expression is a function
"42"
q)b // not evaluated
'b
  [0]  b
       ^
```

For most purposes, you will want `e` to be a function.

:fontawesome-solid-street-view:
_Q for Mortals_
[§10.1.8 Protected Evaluation](/q4m3/10_Execution_Control/#1018-protected-evaluation)


## Errors signalled

```txt
index    an atom in vx or ux is not an index to an item-at-depth in d
rank     the count of vx is greater than the rank of v
type     v or u is a symbol atom, but not a handle to an value
type     an atom of vx or ux is not an integer, symbol or null
```


----
:fontawesome-solid-book:
[Amend, Amend At](amend.md)