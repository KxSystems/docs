---
authors: 
    - Conor Slattery
    - Stephen Taylor
title: Efficient use of unary operators
date: August 2018
keywords: distribution, Each, Each Both, Each Left, Each Parallel, Each Prior, Each Right, kdb+, operator, q, unary
---

# Distribution operators



The distribution operators are Each and its variants. 

-   Each Left and Each Right are syntactic sugar for `f[x;]'` and `f[;y]'`.
-   Each Parallel has the same semantics as Each but distributes processing across slave tasks.
-   Each Prior applies a binary function between adjacent items of a list or dictionary.

The derivatives are all uniform functions. 
Arguments of non-unary derivatives must conform: they can be either atoms or same-count lists.


## Each


### Unary argument

The derivative applies the function to each element of a list or dictionary.

```q
q)(type')(1;2h;3.2)
-7 -5 -9h
q)(ssr[;"an";"in"]')("thank";"prance";"pants")
"think"
"prince"
"pints"
```

If the function is atomic, Each has no effect.
In fact, this is the definition of atomic. 

!!! info "A function `f` is atomic if `f[x;y;z;…]~f'[x;y;z;…]`."

The keyword `each` can be used to avoid parentheses.

```q
q)type each (1;2h;3.2)
-7 -5 -9h
```


### Binary argument

Each applies a binary function to corresponding items of two list or dictionary arguments.

If both arguments are lists, they must be of the same length.

```q
q) 1 2 3 in' (1 2 3;3 4 5;5 6 7)
100b
q) 1 2 3 in' (1 2 3;3 4 5)
'length
```

Either or both arguments may be atoms. If both, the operator has no effect.

```q
q)1 ~' 1
1b
```

If one of the arguments is an atom, it is treated as a list of the same length as the other argument.

```q
q)1 ~' 1 2 3
100b
```

Each with a binary argument is sometimes called _Each Both_.


### Higher-rank argument

With a function of higher rank, the same rules apply by extension. 
As above, the derivative’s arguments must be conformable: atoms or same-count lists.

```q
q)ssr'[("thank";"prance";"pants");"a";"iiu"]
"think"
"prince"
"punts"
```


## Each Right and Each Left

Each Right `/:` and Each Left `\:` take a **binary** function `f`.

Syntax: `x f/:y`, `x f\:y`

The derivative `f/:` applies `f[x;]` to every item in `y`. 

```q
q)d:`a`b`c!("cow";"sheep";"dog")
q)"a ",/:d
a| "a cow"
b| "a sheep"
c| "a dog"
```

Correspondingly, Each Left applies `f[;y]` to each item of `x`.

```q
q)d,\:" in a field"
a| "cow in a field"
b| "sheep in a field"
c| "dog in a field"
```

!!! tip "See how they lean"

    You can remember which glyph denotes Each Right and which Each Left: the characters ‘lean’ towards the list argument.

Ponder the following identities.

```txt
x f/:y      <==>   (f[x;]')y           Each Right
x f\:y      <==>   (f[;y]')x           Each Left
```

And for atoms `a` and `b`

```txt
a f/:y      <==>   a f'y
x f\:b      <==>   x f'b
```

Find the file handle of each column of a table.

```q
q)`:/mydb/2013.05.01/trade,/:key[`:/mydb/2013.05.01/trade]except `.d
`:/mydb/2013.05.01/trade`sym
`:/mydb/2013.05.01/trade`time
`:/mydb/2013.05.01/trade`price
`:/mydb/2013.05.01/trade`size
`:/mydb/2013.05.01/trade`ex
```

The above statement joins the file handle of the table to each element
in the list of columns, creating five 2-lists. 
Each Right can then be used with `sv` to create the file handles of each column.

```q
q)` sv/: `:/mydb/2013.05.01/trade,/:key[`:/mydb/2013.05.01/trade]except`.d
`:/mydb/2013.05.01/trade/sym
`:/mydb/2013.05.01/trade/time
`:/mydb/2013.05.01/trade/price
`:/mydb/2013.05.01/trade/size
`:/mydb/2013.05.01/trade/ex
```


## Each Parallel

Each Parallel applies a **unary** function `f` to each element of a list or dictionary, using slave threads when available. 

Syntax: `(f':)x`

The result is the same as it would be for `f'`. That is, `f'[x]~f':[x]`.

Slave threads can be set using the `–s` command-line parameter. 
If no slave threads are available, Each Parallel is indistinguishable from Each.

The keyword `peach` can be used to avoid parentheses.

```q
q)count peach d
a| 3
b| 5
c| 3
```


## Each Prior

Each Prior applies a **binary** function to each item of a list or dictionary and to the previous item. For the i-th item of argument list `x`, the corresponding item of `(f':)x` is `f[x[i];x[i-1]]`.

A common use of this is in the `deltas` keyword.

```q
q)deltas
-':
q)deltas 4 8 3 2 2
4 4 -5 -1 0
```

It can also be useful in tracking down errors within lists which
should be identical, e.g. the `.d` files for a table in a partitioned
database. The below example uses the `differ` keyword to check for
inconsistencies in `.d` files. 
(`differ` uses Each Prior and is equivalent to `not ~':`.)

```q
q){1_date where differ get hsym `$"/mydb/",string[x],"/trade/.d"} each date
2013.05.03 2013.05.04
```

In this case the values of the `.d` files are extracted from each
partition. The `differ` keyword, which uses Each Prior, is
then used to compare each item in the list with the item before it. 
If a `.d` file
is different to the previous `.d` file in the list, then that date will
be returned by the above statement. 
The first date returned is dropped, as the first element of the list will be compared to -1-th element of the list, which is always null, and so they will never match. 
For the above example, the `.d` files for the 2013.05.03 and 2013.05.04
partitions are different, and should be investigated further.

!!! detail "Each Prior derivatives are ambivalent"

    Functions derived by Each Prior are ambivalent. 
    They can be applied to one or two arguments, e.g.

    <pre><code class="language-q">
    q)2000-':2010 2013 2015 2020
    10 3 2 5
    </code></pre>

    See the [Each Prior reference](/basics/distribution-operators/#each-prior) for more on this.

The keyword `prior` can be used to avoid parentheses. 
The example below returns all adjacent pairs of the argument list. 
Note that the first element of the first item of the result is null.

```q
q){y,x}prior til 5
  0
0 1
1 2
2 3
3 4
```




