## `bin`, `binr`

Syntax: `x bin  y` (atomic)  
Syntax: `x binr y` (atomic)

_Binary search_ returns the index of the _last_ item in `x` which is `<=y`. The result is `-1` for `y` less than the first item of `x`.
`binr` _binary search right_, introduced in V3.0 2012.07.26, gives the index of the _first_ item in `x` which is `>=y`.

It uses a binary-search algorithm, which is generally more efficient on large data than the linear-search algorithm used by `?`.

The items of `x` should be sorted ascending although `bin` does not verify that; if the items are not sorted ascending, the result is undefined. `y` can be either an atom or a simple list of the same type as the left argument.

The result `r` can be interpreted as follows: for an atom `y`, `r` is an integer atom whose value is either a valid index of `x` or `-1`. In general:

    r[i]=-1            iff y[i]<x[0]
    r[i]=i             iff x[i]<=y[i]<x[i+1]

and

    r[j]=x bin y[j]    for all j in index of y

Essentially `bin` gives a half-open interval on the left. `bin` is an atomic function of `y`, i.e. the result has the same shape as `y`.

`bin` also operates on tuples and table columns and is the operator used in the functions `aj` and `lj`.

`bin` and `?` on 3 columns find all equijoins on the first 2 cols and then do `bin` or `?` respectively on the 3rd column. `bin` assumes the 3rd column is sorted within the equivalence classes of the first two column pairs (but need not be sorted overall).
```q
q)0 2 4 6 8 10 bin 5
2
q)0 2 4 6 8 10 bin -10 0 4 5 6 20
-1 0 2 2 3 5
```
If the left argument is not unique the result is not the same as would be obtained with `?`:
```q
q)1 2 3 3 4 bin 2 3
1 3
q)1 2 3 3 4 ? 2 3
1 2
```


## `distinct`

Syntax: `distinct x`

Returns the distinct (unique) items of `x`.
```q
q)distinct 2 3 7 3 5 3
2 3 7 5
```
Returns the distinct rows of a table.
```q
q)distinct flip `a`b`c!(1 2 1;2 3 2;"aba")
a b c
-----
1 2 a
2 3 b
```
It does not use comparison tolerance:
```q
q)\P 14
q)distinct 2 + 0f,10 xexp -13
2 2.0000000000001
```
<i class="far fa-hand-point-right"></i> [`.Q.fu`](dotq/#qfu-apply-unique) (apply unique)

## `?` (find)

Syntax: `x?y` 

Where: 

- `x` is a list
- `y` is any data object

returns the lowest index for which `y` matches an item of `x` – the ‘first occurrence’. If there is no match the result is the count of `x`. Comparisons are exact, and are not subject to comparison tolerance.
```q
q)w:10 -8 3 5 -1 2 3
q)w?-8
1
q)w[1]
-8
q)w?3 / the first occurrence of 3
2
q)w?17 / not found
7
q)w[7]
0N
q)"abcde"?"d"
3
```
_Find_ is type-specific relative to `x`. Where:

- `x` is a simple list and `y` a list whose atoms are all the same type as `x`, the result corresponds to `x` item-by-item.
```q
q)rt:(10 5 -1;-8;3 17)
q)i:w?rt
q)i
(0 3 4;1;2 7)
q)w[i]
(10 5 -1;-8;3 0N)
```

- `x` is a list of lists and `y` is a simple list, items of `x` are matched with the whole of `y`.
```q
q)u:("abcde";10 2 -6;(2 3;`ab))
q)u?10 2 -6
1
q)u?"abcde"
0
```

- where `x` is a mixed list then items of `x` are matched with items of `y`.
```q
q)u?(2 3;`ab)
3 3
```
In this case _find_ matches items of `x` with `2` `3` and `` `ab `` , not `(2 3;`ab) ``.

!!! Note "_Find_ is rank-sensitive"
    `x?y` can’t deal with mixed-rank `x`. If rank `x` is _n_ then `x?y` looks for objects of rank _n_-1.
    <pre><code class="language-q">
    2 3?2 3#til 6  / looks for rank 0 objects
    (0 1 2;4 5)?2 3#til 6 / looks for rank 1 objects
    </code></pre>
    A solution to find ``(2 3;`ab)`` is
    <pre><code class="language-q">
    q)f:{where x~\:y}
    q)f[u;(2 3;`ab)]
    ,2
    </code></pre>

!!! note "Searching tables"
    Where `x` is a table then `y` must be a compatible record (dictionary or list) or table. That is, each column of `x`, paired with the corresponding item of `y`, must be valid arguments of _find_.
    <pre><code class="language-q">
    q)\l sp.q
    q)sp?(`s1;`p4;200)
    3
    q)sp?`s`p`qty!(`s2;`p5;450)
    12
    </code></pre>


## `in`

Syntax: `x in y`

Returns a boolean indicating: 

- where the first item of `y` is an atom, which items of `x` are also items of `y` (list, same count as `x`)
- otherwise, whether `x` is an item of `y` (atom) 

```q
q)1 3 7 6 4 in 5 4 1 6        / which of x are in y
10011b
q)1 2 in (9;(1 2;3 4))        / none of x are in y
00b
q)1 2 in (1 2;9)              / 1 2 is an item of y
1b
q)1 2 in ((1 2;3 4);9)        / 1 2 is not an item of y
0b
q)(1 2;3 4) in ((1 2;3 4);9)  / x is an item of y
1b
```

**Tip**: `in` is often used with `select`:

```q
q)\l sp.q
q)select from p where city in `paris`rome
p | name  color weight city
--| ------------------------
p2| bolt  green 17     paris
p3| screw blue  17     rome
p5| cam   blue  12     paris
```
<i class="far fa-hand-point-right"></i> [`except`](select/#except), [`inter`](select/#inter), [`union`](select/#union), [`within`](#within)


## `within`


Syntax: `x within y` (uniform)

Where `x` is an atom or list of sortable type/s and

- `y` is an ordered pair (i.e. `(</)y` is true) of the same type, the result is a boolean for each item of `x` indicating whether it is within the inclusive bounds given by `y`.
```q
q)1 3 10 6 4 within 2 6
01011b
q)"acyxmpu" within "br"  / chars are ordered
0100110b
q)select sym from ([]sym:`dd`ccc`ccc) where sym within `c`d
sym
---
ccc
ccc
```

- `y` is a pair of lists of length _n_, and `x` a list of length _n_ or an atom, the result is a boolean list of length _n_. 
```q
q)5 within (1 2 6;3 5 7)
010b
q)2 5 6 within (1 2 6;3 5 7)
111b
q)(1 3 10 6 4;"acyxmpu") within ((2;"b");(6;"r"))
01011b
0100110b
```

<i class="far fa-hand-point-right"></i> [`except`](select/#except), [`in`](#in), [`inter`](select/#inter), [`union`](select/#union) 


