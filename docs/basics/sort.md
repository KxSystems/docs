<i class="far fa-hand-point-right"></i> [Attributes](elements/#attributes), [Dictionaries & tables](dictsandtables)


## `asc`

Syntax: `asc x` (unary, uniform)

**Ascending sort**: where `x` is:

- a simple list, the result is its items in ascending order of value, with the `` `s# `` attribute set, indicating the list is sorted.
- a mixed list, the result items are sorted within datatype.
- a dictionary, the result is sorted by the values and has the `` `s# `` attribute set.
- a table, the result is sorted by the first non-key column and has the `` `s# `` attribute set.

The sort is stable: it preserves order between equals.
```q
q)asc 2 1 3 4 2 1 2
`s#1 1 2 2 2 3 4
```
In a mixed list the boolean is returned first, then the sorted integers, the sorted characters, and then the date.
```q
q)asc (1;1b;"b";2009.01.01;"a";0)
1b
0
1
"a"
"b"
2009.01.01
```
Note how the type numbers are used in a mixed list.
```q
q)asc(2f;3j;4i;5h)
5h
4i
3
2f
q){(asc;x iasc abs t)fby t:type each x}(2f;3j;4i;5h)  / kind of what asc does
5h
4i
3
2f
```
Sorting a table:
```q
q)t:([]a:3 4 1;b:`a`d`s)
q)asc t
a b
---
1 s
3 a
4 d

q)a:0 1
q)b:a
q)asc b
`s#0 1
q)a
`s#0 1
```


## `desc`

Syntax: `desc x` (unary, uniform)

**Descending sort**: returns `x` sorted into descending order. The sort is stable: it preserves order between equals. Where `x` is

-   a simple list the result is sorted, and the `` `s# `` attribute is set.
```q
q)desc 2 1 3 4 2 1 2
4 3 2 2 2 1 1
```
-   a mixed list, the result is sorted within datatype.
```q
q)desc (1;1b;"b";2009.01.01;"a";0)
2009.01.01
"b"
"a"
1
0
1b
```
-   a dictionary or table, the result has the `` `s# `` attribute set on the first key value or column respectively (if possible), and is sorted by that key or column.
```q
q)t:([]a:3 4 1;b:`a`d`s)
q)desc t
a b
---
4 d
3 a
1 s
```


## `iasc`

Syntax: `iasc x` (unary, uniform)

**Indexes of ascending sort**: returns the indices needed to sort list `x` in ascending order. 
```q
q)L:2 1 3 4 2 1 2
q)iasc L
1 5 0 4 6 2 3
q)L iasc L
1 1 2 2 2 3 4
q)(asc L)~L iasc L
1b
```



## `idesc`

Syntax: `idesc x`

**Indexes of descending sort**: returns the indices needed to sort list `x` in descending order. 
```q
q)L:2 1 3 4 2 1 2
q)idesc L
3 2 0 4 6 1 5
q)L idesc L
4 3 2 2 2 1 1
q)(desc L)~L idesc L
1b
```


## `rank`

Syntax: `rank x` (unary, uniform)

**Rank**: returns for each item in `x` the index of where it would occur in the sorted list. 

This is the same as calling [`iasc`](#iasc) twice on the list.
```q
q)rank 2 7 3 2 5
0 4 2 1 3
q)iasc 2 7 3 2 5
0 3 2 4 1
q)iasc iasc 2 7 3 2 5            / same as rank
0 4 2 1 3
q)asc[2 7 3 2 5] rank 2 7 3 2 5  / identity
2 7 3 2 5
q)iasc idesc 2 7 3 2 5           / descending rank
3 0 2 4 1
```


## `xrank`

Syntax: `x xrank y` (binary)

**Group by value**: where `x` is an integer, and `y` is of sortable type, returns a list of length `x` containing the items of `y` grouped by value. If the total number of items is evenly divisible by `x`, then each item of the result will have the same length; otherwise the first items of the result are longer.
```q
q)4 xrank til 8          / equal size buckets
0 0 1 1 2 2 3 3
q)4 xrank til 9          / first bucket has extra
0 0 0 1 1 2 2 3 3
q)
q)3 xrank 1 37 5 4 0 3   / outlier 37 does not get its own bucket
0 2 2 1 0 1
q)3 xrank 1 7 5 4 0 3    / same as above
0 2 2 1 0 1
```
Example using stock data:
```q
q)show t:flip `val`name!((20?20);(20?(`MSFT`ORCL`CSCO)))
val name
--------
17  MSFT
1   CSCO
14  CSCO
13  ORCL
13  ORCL
9   ORCL
...

q)select Min:min val,Max:max val,Count:count i by bucket:4 xrank val from t
bucket| Min Max Count
------| -------------
0     | 0   7   5
1     | 9   12  5
2     | 13  15  5
3     | 15  17  5
```


