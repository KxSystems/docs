---
title: Amend, Amend At – Reference – kdb+ and q documentation
description: Operators Amend and Amend At modify one or more items in a list.
keywords: amend, amend at, at, dot, kdb+, q
---
# `.` `@` Amend, Amend At




_Modify one or more items in a list, dictionary or datafile._

```txt
Amend             Amend At         values (d . i) or (d @ i) become

.[d; i; u]        @[d; i; u]       u[d . i]       u'[d @ i]
.[d; i; v; vy]    @[d; i; v; vy]   v[d . i;vy]    v'[d @ i;vy]
```

Where

-   `d` is an atom, list, or a dictionary (**value**); or a **handle** to a list, dictionary or datafile
-   `i` is a list of the indexes of `d` to be amended:
    -   if empty (for `.`) or the general null `::` (for `@`), or if `d` is a non-handle atom, the selection $S$ is `d` ([Amend Entire](#amend-entire))
    -   otherwise $S$ is [`.[d;i]` or `@[d;i]`](apply.md#index)
-   `u` is a unary
-   `v` is a binary, and `vy` is
    -   in the right domain of `v`
    -   unless $S$ is `d`, conformable to $S$ and of the same type

the items in `d` of the selection $S$ are replaced

-   in the ternary, by `u[`$S$`]` for `.` and by `u'[`$S$`]` for `@`
-   in the quaternary, by `v[`$S$`;vy]` for `.` and by `v'[`$S$`;vy]` for `@`

and if `d` is a

-   **value**, returns a copy of it with the item/s at `i` modified
-   **handle**, modifies the item/s of its reference at `i`, and returns the handle

!!! tip "If `v` is Assign (`:`) each item in the selection is replaced by the corresponding item in `vy`."

!!! tip "`u` and `v` can be replaced with values of higher rank using projection or by enlisting their arguments and using [Apply](apply.md)."

See also binary and ternary forms of `.` and `@`
<br>
:fontawesome-solid-book:
[Apply, Apply At, Index, Index At](apply.md)


## Examples


### Amend Entire

If `i` is 

-   the empty list (for `.`)
-   the general null (for `@`)

the selection is the entire value in `d`.

```txt
.[d;();u]     <=>   u[d]            @[d;::;u]     <=>   u'[d]      
.[d;();v;y]   <=>   v[d;y]          @[d;::;v;y]   <=>   v'[d;y]    
```

```q
q).[1 2; (); 3 4 5]
4 5
q).[1 2; (); :; 3 4 5]
3 4 5
q).[1 2; (); ,; 3 4 5]
1 2 3 4 5
q)@[1 2; ::; ,; 3 4 5]
1 2 3 4 5

q)@[1 2; ::; *; 3 4]
3 8
q)@[1 2; ::; 3 4*]
'type
  [0]  @[1 2; ::; 3 4*]
       ^
```


### Single path

If `i` is a non-negative integer vector then the selection is a single item at depth `count i` in `d`.

```q
q)(5 2.14; "abc") . 1 2              / index at depth 2
"c"
q).[(5 2.14; "abc"); 1 2; :; "x"]    / replace at depth 2
5 2.14
"abx"
```


### Cross sections

Where the items of `i` are non-negative integer vectors, they define a cross section.
The result can be understood as a series of single-path amends.

```q
q)d
(1 2 3;4 5 6 7)
(8 9;10;11 12)
(13 14;15 16 17 18;19 20)
q)i:(2 0; 0 1 0)
q)y:(100 200 300; 400 500 600)
q)r:.[d; i; ,; y]
```

Compare `d` and `r`:

```q
q)d                              q)r
(1 2 3;4 5 6 7)                  (1 2 3 400 600;4 5 6 7 500)
(8 9;10;11 12)                   (8 9;10;11 12)
(13 14;15 16 17 18;19 20)        (13 14 100 300;15 16 17 18 200;19 20)
```

The shape of `y` is `2 3`, the same shape as the cross-section selected by `d . i`. The `(j;k)`th item of `y` corresponds to the path `(i[0;j];i[1;k])`. The first single-path Amend is equivalent to:

```q
d: .[d; (i . 0 0; i . 1 0); ,; y . 0 0]
```

(since the amends are being done individually, and the assignment serves to capture the individual results as we go), or:

```q
d: .[d; 2 0; ,; 100]
```

and item `d . 2 0` becomes `13 14,100`, or `13 14 100`.
The next single-path Amend is:

```q
d: .[d; (i . 0 0; i . 1 1); ,; y . 0 1]
```

or

```q
d: .[d; 2 1; ,; 200]
```

and item `d . 2 1` becomes `15 16 17 18 200`.

Continuing in this manner:

-   item `d . 2 0` becomes `13 14 100 300`, modifying the previously modified value `13 14 100`
-   item `d . 0 0` becomes `1 2 3 400`
-   item `d . 0 1` becomes `4 5 6 7 500`
-   item `d . 0 0` becomes `1 2 3 400 600`, modifying the previously modified value `1 2 3 400`


### Replacement

```q
d:((1 2 3; 4 5 6 7)
   (8 9; 10; 11 12)
   (13 14; 15 16 17 18; 19 20))
i:(2 0; 0 1 0)
y:(100 200 300; 400 500 600)
r:.[d; i; :; y]
```

Compare `d` and `r`:

```q
q)d                           q)r
(1 2 3;4 5 6 7)               600 500             / replaced twice; once
(8 9;10;11 12)                (8 9;10;11 12)
(13 14;15 16 17 18;19 20)     (300;200;19 20)     / replaced twice; once; not
```

Note multiple replacements of some items-at-depth in `d`, corresponding to the multiple updates in the earlier example.


### Unary value

The ternary replaces the selection with the results of applying `u` to them.

```q
q)d
(1 2 3;4 5 6 7)
(8 9;10;11 12)
(13 14;15 16 17 18;19 20)
q)i
2 0
0 1 0
q)y
100 200 300
400 500 600
q)r:.[d; i; neg]
```

Compare `d` and `r`:

```q
q)d                            q)r
(1 2 3;4 5 6 7)                (1 2 3;-4 -5 -6 -7)
(8 9;10;11 12)                 (8 9;10;11 12)
(13 14;15 16 17 18;19 20)      (13 14;-15 -16 -17 -18;19 20)
```

Note multiple applications of `neg` to some items-at-depth in `d`, corresponding to the multiple updates in the first example.


### On disk
Certain vectors can be updated directly on disk without the need to fully rewrite the file.
(Since V3.4)

Such vectors must have no attribute, be of a mappable type, not nested, and not compressed.

```q
q)`:data set til 20
q)@[`:data;3 6 8;:;100 200 300]
q)get `:data
0 1 2 100 4 5 200 7 300 9 10 11 12 13 14 15 16 17 18 19
```

<!--
## The general case

In general, `i` can be

-   an atom that is a valid index of `d`, e.g. one of `key d`
-   a list representing paths to items at depth `count i` in `d`

The function proceeds recursively through `i[0]` and `y` as if they were the arguments of a binary atomic function, except that when arriving at an atom in `i[0]`, that value is retained as the first item in a path and the recursion continues on with `i[1]` and the item-at-depth in `y` that had been arrived at the same time as the atom in `i[0]`.

And so on, until arriving at an atom in the last item of `i`. At that point a path `p` into `d` has been created and the item at depth `count i` selected by `p`, namely `d . p`, is replaced by `m[d . p;z]` for binary `m`, or `u[d . p]` for unary `u`, where `z` is the item-at-depth in `y` that had been arrived at the same time as the atom in the last item of `i`.

The general case for binary `v` can be defined recursively by partitioning the index list into its first item and the rest:

```q
Amend:{[d;F;R;v;y]
  $[ nil ~ F; Amend[d; key d; R; v; y];
    0 = count R; @[d; F; v; y];
        @ F; Amend[d @ F; first R; 1_R; v; y];
             Amend[;; R;;]/[d; F; v; y]}
```

FIXME Revise definition: Atom; nil

Note the application of [Over](accumulators.md) to Amend, which requires that whenever `F` is not an atom, either `y` is an atom or `count F` equals `count y`. Over is used to accumulate all changes in the first argument `d`.


## Accumulate

Cases of Amend with a value `u` or `v` are sometimes called Accumulate because the new items-at-depth are computed in terms of the old, as in `.[x; 2 6; +; 1]`, where item 6 of item 2 is incremented by 1.
 -->

## Errors

```txt
domain   d is a symbol atom but not a handle
index    a path in i is not a valid path of d
length   i and y are not conformable
type     an atom of i is not an integer, symbol or nil
type     replacement items of different type than selection
```

----
:fontawesome-solid-book:
[Apply, Apply At, Index, Index At](apply.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§6.8.3 General Form of Function Application](/q4m3/6_Functions/#683-general-form-of-function-application)

<!--
## Functional Amend

==Integrate following with preceding!==

Syntax: `@[x;i;f]`
Syntax: `@[x;i;f;a]`
Syntax: `@[x;i;f;v]`

Where

- `x` is a list (or file symbol, see Tip)
- `i` is an int vector of indexes of `x`
- `f` is a function
- `a` is an atom in the domain of the second argument of `f`
- `v` is a vector in the domain of the second argument of `f`

returns `x` with its values at indexes `i` changed.

For `ind` in `til count i`, `x[i ind]` becomes

```txt
expression   x[i ind]
-----------------------------
@[x;i;f]     f[x i ind]
@[x;i;f;a]   f[x i ind][a]
@[x;i;f;v]   f[x i ind][v ind]
```

```q
q)d:("quick";"";"brown";"fox")
q)@[d;where"b"$count each d;,[;"..."]] / unary f
"quick..."
""
"brown..."
"fox..."
q)d:((1 2 3;4 5 6 7);(8 9;10;11 12);(13 14;15 16 17 18;19 20))
q)@[d;1 1 1;+;3] / binary f
((1 2 3;4 5 6 7);(17 18;19;20 21);(13 14;15 16 17 18;19 20))
```


!!! warning "Projections"

    For a general list `x`, omitting `a` or `v` when `f` is binary returns projections at the indexes `i`:

    <pre><code class="language-q">
    q)0N!@[("ssd";"bsd");0;+];
    (+["ssd"];"bsd")
    </code></pre>
 -->
