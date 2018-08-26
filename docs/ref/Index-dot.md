# `.` Index


_Select an item from deep in a list._

Syntax: `L . i`, `.[L;i]` Index

Where

-   `L` is a list, dictionary or table, or a [handle](handle) to one
-   `i` is a list of positive integers and/or symbols

`L . i` returns an item from `L` as specified by successive items in `i`.
The result is found in `L` at depth `count i` as follows. 

The list `i` is a list of successive indexes into `L`. `i[0]` must be in the domain of `L@`. It selects an item of `L`, which is then indexed by `i[1]`, and so on.
```q
( (L@i[0]) @ i[1] ) @ i[2] …
```
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


## Index At

The selections at each level are individual applications of [Index At](index-at): first, item `d@i[0]` is selected, then `(d@i[0])@i[1]`, then `((d@i[0])@ i[1])@ i[2]`, and so on. 

These expressions can be rewritten using [Over](reduce) applied to Index At; the first is `d@/i[0]`, the second is `d@/i[0 1]`, and the third is `d@/i[0 1 2]`. 

In general, for a vector `i` of any count, `L . i` is identical to `L@/i`. 
```q
q)((d @ 1) @ 2) @ 0         / selection in terms of a series of @s
11
q)d @/ 1 2 0                / selection in terms of @-Over
11
```


## Items of i are non-negative integer vectors

Index is **cross-sectional** when the items of `i` are lists. That is, items-at-depth in `L` are indexed for paths made up of all combinations of atoms of `i[0]` and atoms of `i[1]` and atoms of `i[2]`, and so on to the last item of `i`. 

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


## Items of i are rectangular non-negative integer lists

More general cross-sectional indexing occurs when the items of `i` are rectangular lists, not just vectors, but the situation is much like the simpler case of vector items. 

<!-- In particular, the shape of the result is ,/^:'i. FIXME -->


## Nils in i

Nils in `i` mean “select all”: if `i[0]` is nil, then continue on with `d` and the rest of `i`, i.e. `1_i`; if `i[1]` is nil, then for every selection made through `i[0]`, continue on with that selection and the rest of `i`, i.e. `2_i`; and so on. For example, `d .(::;0)` means that the 0th item of every item of `d` is selected.
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
Another example, this time with `i[1]` equal to nil:
```q
q)d . (0 2;::;1 0)
(2 1;5 4)
(14 13;16 15;20 19)
```
Note that `d .(::;0)` is the same as `d .(0 1 2;0)`, but in the last example, there is no value that can be substituted for nil in `(0 2;;1 0)` to get the same result, because when item 0 of `d` is selected, nil acts like `0 1`, but when item 2 of `d` is selected, it acts like `0 1 2`.


## The general case of a non-negative integer list i

In the general case, when the items of `i` are non-negative integer atoms or lists, or nil, the structure of the result can be thought of as cascading structures of the items of `i`. That is, with nils aside, the result is structurally like `i[0]`, except that wherever there is an atom in `i[0]`, the result is structurally like `i[1]`, except that wherever there is an atom in `i[1]`, the result is structurally like `i[2]`, and so on. 

The general case of Index can be defined recursively in terms of [**Index At**](index-at) by partitioning the list `i` into its first item and the rest:
```q
Index:{[d;F;R] 
  $[ F~::; Index[d; first R; 1 _ R];
     0 =count R; d @ F;
     0>type F; Index[d @ F; first R; 1 _ R]
     Index[d;; R]'F ]}
```
That is, `d . i` is `Index[d;first i;1_i]`. 

To work through the definition, start with `F` as the first item of `i` and `R` as the remainder. At each step in the recursion: 

-   if `F` is nil then select all of `d` and continue on, with the first item of the remainder `R` as the new `F` and the remainder of `R` as the new remainder; 
-   otherwise, if the remainder is the empty vector apply Index At (the right argument `F` is now the last item of `i`), and we are done; 
-   otherwise, if `F` is an atom, apply Index At to select that item of `d` and continue on in the same way as when `F` is nil; 
-   otherwise, apply Index with fixed arguments `d` and `R`, but independently to the items of the list `F`.


## Dictionaries and symbolic indexing

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
Consequently, if the kth item of i contains a symbol atom, then all items selected by `d . k # i` must be dictionaries or handles of directories, and therefore all atoms in the `k`th item of `i` must be symbols.

It follows that each item of `i` must be made up entirely of non-negative integer atoms, or entirely of symbol atoms, and if the `k`th item of `i` is made up of symbols, then all items at depth `k` in `d` selected by the first `k` items of `i` must be dictionaries.

Note that if `d` is either a dictionary or handle to a directory then `d . enlist key d` is a list of values of all the entries.


## 1-item list i

In the general case of a one-item list `i`, `d . i` is identical to `d @ first i`.

## Errors

error  | cause
-------|------------------------------------------------------------------
domain | the symbol `d` is not a handle
index  | an atom in `i` is not a valid index to the item-at-depth in `d`
type   | an atom of `i` is not an integer, symbol or nil

