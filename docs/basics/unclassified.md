## `.` (apply)

Syntax: `f . x`  
Syntax: `.[f;x]`

Where `f` is a function of rank $N$ and `x` is a list of count $N$, returns the result of applying `f` to the items of `x` as its arguments, i.e. `f.(x;y;z)` is equivalent to `f[x;y;z]`.

Particularly useful when executing functions of varying rank. In the following, note that defining the binary `execFunction` as `{[fun;param] fun[param]}` would work for `f1` but not `f2`.
```q
q)f1:{x}
q)f2:{x+y}
q)execFunction:{[fun;param] fun . param}
q)execFunction[f1;enlist 1]
1
q)execFunction[f2;(1 2)]
3
```

!!! warning "Applying an operator"
    Where _apply_ is applied infix, and its left argument `f` is an operator, parenthesize `f`.
    <pre><code class="language-q">
    q).[mod;2 3]       / apply applied prefix to an operator
    2
    q)(mod) . 2 3      / apply applied infix to an operator
    2
    q){x mod y} . 2 3  / apply applied infix to a lambda
    2
    q)g:mod
    q)g . 2 3
    2</code></pre>The operator `mod` can itself be applied infix. In the second expression, the parentheses create a noun `(mod)`, which is then parsed as the left argument of the _apply_ operator. In the remaining examples, the lambda and `g` are parsed as nouns.

> _Everything starts from a dot._ – Wassily Kandinsky

<i class="far fa-hand-point-right"></i> _Q for Mortals:_ [6.8 General Application](http://code.kx.com/q4m3/6_Functions/#68-general-application)

## `(::)` (identity)

Syntax: `(::) x`
  
Returns `x`.
```q
q)(::)1
1
```
This can be used in statements applying multiple functions to the same data, if one of the operations desired is "do nothing".
```q
q)(::;avg)@\:1 2 3
1 2 3
2f
```
Similarly, the identity can also be achieved via indexing.
```q
q)1 2 3 ::
1 2 3
```
and used in variants thereof for e.g. amends
```q
q)@[til 10;(::;2 3);2+]
2 3 6 7 6 7 8 9 10 11
```


## `::` (null)

Q does not have a dedicated null type. Instead `::` is used to denote a generic null value. For example, functions that return no value, return `::`.
```q
q)enlist {1;}[]
::
```
We use `enlist` to force display of a null result: a pure `::` is not displayed.

When a unary function is called with no arguments, `::` is passed in.
```q
q)enlist {x}[]
::
```
Since `::` has a type for which no vector variant exists, it is useful to prevent a mixed list from being coerced into a vector when all items happen to be of the same type. (This is important when you need to preserve the ability to add non-conforming items later.)
```
q)x:(1;2;3)
q)x,:`a
'type
```
but
```q
q)x:(::;1;2)
q)x,:`a  / ok
```


## par.txt

File `par.txt` defines a top-level partitioning of a database into directories. Each row of `par.txt` is a directory path. Each such directory would itself be partitioned in the usual way, typically by date. The directories should not be empty. The `par.txt` file should be created in the main database directory.

`par.txt` is used to unify partitions of a database, presenting them as a single database for querying.

This is particularly useful in combination with multithreading. Starting the q process with slave threads (see command line option `-s`), and where each partition in `par.txt` is on a separate local disk:

-   when the q process is started with slave threads, the partitions in `par.txt` are allocated to slaves on a round robin basis, i.e. if q is started with `n` slaves, then partition `p` is given to slave `p` `mod` `n`. This gives maximum parallelization for queries over date ranges.

-   if also, the partitions in `par.txt` are on separate disks, this means that each thread gets its own disk or disks, and there should be no disk contention (i.e. not more than one thread issuing commands to any one disk). Ideally, there should be one disk per thread. Note that this works best where the disks have fully independent access paths cpu-disk controller-disk, but may be of little use with shared access due to disk contention, e.g. with SAN/RAID.

For example, `par.txt` might be:
```
/0/db
/1/db
/2/db
/3/db
```
with directories :
```
~$ls /0/db
2009.06.01 2009.06.05 2009.06.11 ...

~$ls /1/db
2009.06.02 2009.06.06 2009.06.12 ...

...
```

### Some considerations

-   the data should be partitioned correctly across the partitions – i.e. data for a particular date should reside in the partition for that date.  
<i class="far fa-hand-point-right"></i> [`.Q.par`](dotq/#qpar-locate-partition)
-   the slave/directory partitioning is for both read and write.
-   the directories pointed to in `par.txt` may only contain appropriate database subdirectories. Any other content (file or directory) will give an `` `error ``.
-   the same subdirectory name may be in multiple `par.txt` partitions. For example, this would allow symbols to be split, as in A-M on /0/db, N-Z on /1/db (e.g. to work around the 2-billion row limit). Aggregations are handled correctly, as long as data is properly split (not duplicated). Note that in this case, the same day would appear on multiple partitions.

