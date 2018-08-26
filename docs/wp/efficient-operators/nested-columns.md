---
title: Nested columns
authors: 
    - Connor Slattery
    - Stephen Taylor
date: August 2018
keywords: columns, kdb+, nested, operators, q
---

# Nested columns



While it is usually best to avoid nested columns, there are
situations where operating on nested data is necessary or may
result in lower execution time for certain queries. 

The main reason for this is that the function `ungroup`, which flattens a table
containing nested columns, is computationally expensive, especially
when you are only dealing with a subset of the entire table. 
There are also other situations where storing the data in a nested structure makes more sense.
For example you may want to use strings, which are lists
of characters, instead of symbols, which are atoms, in order to avoid
a bloated sym file. 
For this reason we will now look at using unary operators to apply functions to a table as a whole, and to apply functions within a select statement.

Unary operators can be used to examine and modify tables. 
To do this, an understanding of how tables are structured is necessary. 
In kdb+, a table is a list of dictionaries.

This means we can apply functions to individual items, just
like any other nested list or dictionary.

```q
q)show a:([]a:`a`b`c`d;b:1 2 3 4;c:(1 2;2 3;3 4;4 5))
a b c
-------
a 1 1 2
b 2 2 3
c 3 3 4
d 4 4 5
q)type a
98h
q)(type')a
99 99 99 99h
q)(type'')a
a   b  c
--------
-11 -7 7
-11 -7 7
-11 -7 7
-11 -7 7
```

We see here that 

-   `type a` returns 98, the type of a table
-   `(type')a` returns the type of each item of the list `a`: the type of ictionaries 
-   `(type'')a` finds the type of each item in the range of each dictionary in `a`: a list of dictionaries, which collapses back to a table showing the type of each field in the table `a`

```q
q)distinct (type'')a
a   b  c
--------
-11 -7 7
```

In this way, the statement can be used to ensure all rows of the
table are the same type. This is useful if your table contains nested
columns, as the `meta` function only looks at the first row of
nested columns. If the table is keyed then the function will only be
applied to the non-key columns in this case.

```q
q)a:([]a:`a`b`c`d;b:1 2 3 4;c:(1 2;2 3;3 4.;4 5))
q)meta a
c| t f a
-| -----
a| s
b| j
c| J
q)distinct (type'')a
a   b  c
--------
-11 -7 7
-11 -7 9
```

Looking only at the results of `meta`, we might conclude the column `c`
contains only integer lists. However `distinct (type'')a` clearly
shows column `c` contains lists of different types, and thus is
not mappable. 
This is a common cause of error when writing to a splayed table.

Dealing with nested data in a table via a select or update statement
often requires the use of unary operators. 
To illustrate this, let us define a table with three columns, two of which are nested.

```q
q)tab:([]sym:`AA`BB`CC;time:3#enlist 09:30+til 30;price:{30?100.0}each til 3)
```

Suppose we want to find the range of each row. 
This can be done easily by defining a range function as:

```q
q)rng:{max[x]-min[x]}
```

We can then make use of this function within a select statement, with Each to apply the function to each row of the table.

```q
q)select sym, (rng')price from tab
sym price
------------
AA  96.3872
BB  95.79704
CC  98.31252
```

Suppose instead we want to find the range of a subset of the data in the table.
One way would be to ungroup the table and then find the range as follows.

```q
q)select rng price by sym from ungroup tab where time within 09:40 09:49
sym| price
---| --------
AA | 77.67457
BB | 80.14611
CC | 67.48254
```

However, it is faster to index into the nested list, as this avoids the costly `ungroup` function.
First find the index of the prices which fall within our time range.

```q
q)inx:where (exec first time from tab) within 09:40 09:49
```

Then use this to index into each price list and apply `rng` to the resulting prices.

```q
q)select sym, (rng')price@\:inx from tab
sym inx
------------
AA  77.67457
BB  80.14611
CC  67.48254
```

This offers a significant improvement in latency over using `ungroup`.

```q
q)\t:10000 select rng price by sym from ungroup tab where time within 09:40 09:49
198
q)\t:10000 inx:where (exec first time from tab) within 09:40
09:49;select sym, (rng')price@\:inx from tab
65
```

If the nested lists are not uniform the code needs to be changed to the following:

```q
q)inx:where each (exec time from tab) within 09:40 09:49
q)select sym, (rng')price@'inx from tab
sym inx
------------
AA  77.67457
BB  80.14611
CC  67.48254
```

