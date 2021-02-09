---
title: Tables in kdb+ | Language | kdb+ and q documentation
description: Tables in kdb+
author: Stephen Taylor
date: October 2020
---
# Tables



<div markdown="1" class="typewriter">
[cols](../ref/cols.md)     column names             [ungroup](../ref/ungroup.md)  normalize
[meta](../ref/meta.md)     metadata                 [xasc](../ref/asc.md#xasc)     sort ascending
[xcol](../ref/cols.md#xcol)     rename cols              [xdesc](../ref/desc.md#xdesc)    sort descending
[xcols](../ref/cols.md#xcols)    re-order cols            [xgroup](../ref/xgroup.md)   group by values in selected cols
[insert](../ref/insert.md)   insert records           [xkey](../ref/keys.md#xkey)     sset cols as primary keys
[upsert](../ref/upsert.md)   add/insert records       [xdesc](../ref/desc.md#xdesc)    sort descending
[! Enkey, Unkey](../ref/enkey.md)  add/remove keys

[**qSQL query templates**](../basics/qsql.md):   [select](../ref/select.md)   [exec](../ref/exec.md)   [update](../ref/update.md)   [delete](../ref/delete.md)
</div>


Tables are first-class objects in q.

??? important "A table is an ordered list of its rows."

    Relations in SQL are sets. There are no duplicate rows, and rows are not ordered. It is possible to define a cursor on a result set and then manipulate the cursor rows in order. (Not in ANSI SQL.)

    Kdb+ tables are ordered and may contain duplicates. The order allows a class of very useful [aggregates](../basics/glossary.md#aggregate-function) that are unavailable to the relational database programmer without the cumbersome and poorly-performing temporal extensions.

Because kdb+ tables are ordered, for a table `trade` in timestamp order, the functions `first` and `last` give open and close prices:

```q
q)first trade
stock| `ibm
price| 121.3
amt  | 1000
time | 09:03:06.000

q)last trade
stock| `msft
price| 78.52
amt  | 200
time | 16:59:39.000
```


## Construction


### Flip a column dictionary

Here is a matrix: a list of four vectors.

```q
q)show mat:(`Jack`Jill`Janet;`brown`black`fair;`blue`green`hazel;12 9 14)
Jack  Jill  Janet
brown black fair
blue  green hazel
12    9     14
```

The same information as a [column dictionary](../basics/dictsandtables.md#column-dictionaries): each value is a 3-vector.

```q
q)`name`hair`eye`age!mat
name| Jack  Jill  Janet
hair| brown black fair
eye | blue  green hazel
age | 12    9     14
```

Flipped, it is a table.

```q
q)show t:flip`name`hair`eye`age!mat
name  hair  eye   age
---------------------
Jack  brown blue  12
Jill  black green 9
Janet fair  hazel 14
```

Each row is a [dictionary](../basics/dictsandtables.md).

```q
q)first t
name| `Jack
hair| `brown
eye | `blue
age | 12
```

!!! important "A table is an ordered list of same-key dictionaries."

Like any list, its length – the number of its records – is given by `count`.

```q
q)count t
3
```


### Table notation

The same table can be defined with table notation:

```q
q)t~([]name:`Jack`Jill`Janet;hair:`brown`black`fair;eye:`blue`green`hazel;age:12 9 14)
1b
```

By default, column names are taken from corresponding variable names.

```q
q)stock:`ibm`bac`usb
q)price:121.3 5.76 8.19
q)amount:1000 500 800
q)time:09:03:06.000 09:03:23.000 09:04:01.000

q)show trade:([]stock;price;amt:amount;time)
stock price amt  time
-----------------------------
ibm   121.3 1000 09:03:06.000
bac   5.76  500  09:03:23.000
usb   8.19  800  09:04:01.000
```

Columns get the datatypes of the values assigned them.

```q
q)meta trade
c    | t f a
-----| -----
stock| s
price| f
amt  | j
time | t
```

Unlike SQL, there is no need to first declare the types of the columns.


### Dict Each Right

If your records are in a row-order matrix, Dict Each Right (`!/:`) will make each row a like dictionary – and a table is a list of like dictionaries.

```q
q)mat
`ibm 121.3 1000 09:03:06.000
`bac 5.76  500  09:03:23.000
`usb 8.19  800  09:04:01.000

q)`stock`price`amt`time !/: mat
stock price amt  time
-----------------------------
ibm   121.3 1000 09:03:06.000
bac   5.76  500  09:03:23.000
usb   8.19  800  09:04:01.000
```


### Read from disk

Use [Load CSV](../ref/file-text.md#load-csv) to load a CSV file as a table; more generally, [File Text](../ref/file-text.md) for reading data from text files.

For reading tables persisted to the filesystem, see [Database: persisting tables in the filesystem](../database/index.md)



### Compound columns

Any list of the right length can become a column of a table, and its items can be any kdb+ objects – including tables.

Most table columns are vectors: simple lists of uniform type.
This is generally most efficient for storage and query execution.

A table column of uniform type but with vector items is called a _compound list_. A book index is a familiar example.

```q
q)term:`$("analytical engine";"Babbage, Charles";"difference engine")
q)pages:(5 17 324;1 5 17;17 359)
q)([]term;pages)
term              pages
--------------------------
analytical engine 5 17 324
Babbage, Charles  1 5 17
difference engine 17 359
```

Above, the `term` column is a symbol vector and the `pages` column is a compound list.

In the result of [`meta`](../ref/meta.md) its compound nature is indicated by its type code in upper case.

```q
q)meta([]term;pages)
c    | t f a
-----| -----
term | s
pages| J
```

??? danger "`meta` does not read the entire table."

    The `meta` keyword samples only the top of each column.
    You cannot rely on it to determine whether a column is simple, compound or mixed.


### Table schema

An empty table can be created by initializing each column as the general empty list.

```q
q)meta trade:([] stock:(); price:(); amount:(); time:())
c     | t f a
------| -----
stock |
price |
amount|
time  |
```

In this table, the [datatype](../basics/datatypes.md) of each column is _mixed_. The first record then inserted into the table sets the datatypes of the columns. Subsequent inserts may only insert values of the same type; otherwise a `type` error is signalled, which can be trapped and handled.

This requires the table to start with the correct column types, so it is often better to initialize a table with empty columns of the correct type.

```q
q)meta trade:([] stock:`$(); price:`float$(); `long$amount:(); `time$time:())
c     | t f a
------| -----
stock | s
price | f
amount| j
time  | t
```


### Keyed tables

A kdb+ table is a list and it can contain duplicates.

A kdb+ keyed table is a [dictionary](../basics/dictsandtables.md).

-   Its key is a table of the key column/s.
-   Its value is a table of the non-key columns.

In table notation, write the key field/s inside the square brackets.
For a simple table of financial markets and their addresses:

```q
q)market:([name:`symbol$()] address:())
```

??? danger "When constructing a table key, ensure its items are unique."

    To protect performance, kdb+ does not ensure key items are unique.

    But there is no use case for duplicate key items, which make operation results unpredictable.

If market names are not unique, the country name could be part of the primary key.

```q
q)market:([name:`symbol$(); country:`symbol$()] address:())
```

!!! tip "An alternative to using multiple columns as a primary key is a column of unique integer IDs"

:fontawesome-solid-book:
[`keys`](../ref/keys.md), [`xkey`](../ref/keys.md) get, set key columns of a table


### Foreign keys

Foreign keys in SQL provide referential integrity: an attempt to insert a foreign key value that is not in the primary key will fail. This is also true in q.

Suppose we want to record in our `trades` table the market (NYSE, LSE, etc) where each trade has been executed.

We make the primary key of the `markets` table a foreign key in the `trades` table.

```q
q)name:`$("Stock Exchange";"Boersen";"NYSE")
q)country:`$("United Kingdom";"Denmark";"United States")
q)city:`$("London";"Copenhagen";"New York")
q)id:1001 1002 1003
q)show market:([id]name;country;city)
id  | name           country        city
----| ----------------------------------------
1001| Stock Exchange United Kingdom London
1002| Boersen        Denmark        Copenhagen
1003| NYSE           United States  New York

q)trade:([]
    stock:`symbol$();
    market:`market$();
    price:`float$();
    amount:`int$();
    time:`time$() )
```

Only primary keys of keyed tables can be used as a foreign key.
But there are other ways to link table columns.

:fontawesome-solid-database:
[Linking columns](../kb/linking-columns.md)
<br>
:fontawesome-regular-map:
[The application of foreign keys and linked columns in kdb+](../wp/foreign-keys.md)


## Indexing a table


### Column indexing

If a table is a flipped dictionary, it is unsurprising we can also index the table by column names.

```q
q)trade `stock`amt
ibm  bac usb ibm  bac usb
1000 500 800 1000 500 800
```


### Row indexing

Selecting the i<sup>th</sup> row in a table is complex in SQL, but easy in q.

The pseudo column `i` represents the row index.
It can be used in [queries](../basics/qsql.md).

The `select` expression returns a table with a single row.
```q
q)select from trade where i=5
stock price amt time
----------------------------
usb   8.19  800 09:04:01.000
```

Indexing a table with an atom returns a dictionary.

```q
q)trade[5]
stock| `usb
price| 8.19
amt  | 800
time | 09:04:01.000
```

!!! detail "Row indexing cannot be used on a keyed table, which is a dictionary."

It is also easy to access, say, the second-to-last row.

```q
q)trade[(count trade) - 2]
stock| `bac
price| 5.76
amt  | 500
time | 09:03:23.000
```

We see at last the dual nature of a table.
It is _both_

-   a list of named same-length columns
-   a list of like (same-key) dictionaries

And we can index it either way – or both, which is indexing at depth.

```q
q)trade 1                   / index by row
stock| `bac
price| 5.76
amt  | 500
time | 09:03:23.000

q)trade `price              / index by column
121.3 5.76 8.19

q)trade[1 0;`stock`amt]     / index at depth
`bac 500
`ibm 1000
```

Its items are dictionaries and, as a table is a list of like dictionaries, any sublist of the table is – also a table.

```q
q)trade 1 0
stock price amt  time
-----------------------------
bac   5.76  500  09:03:23.000
ibm   121.3 1000 09:03:06.000
```


### Indexing at depth

Indexing at depth can be used to read a column within a specific row.

```q
trade[5;`stock]
`usb
```

Also useful for updates.

```q
trade[5;`amt]:15
```

:fontawesome-solid-book:
[Apply/Index at depth](../ref/apply.md)


### Index out of range

If we use `select`, the result is a table with no rows.

```q
q)select from trade where i = 300000
stock price amount time
---------------------------------------
```

If we use indexing, the result is a dictionary containing null values.

```q
q)trade 30000
stock| `
price| 0n
amt  | 0N
time | 0Nt
```


### Indexing a keyed table

There are two ways to index a keyed table.

First, with a single row from its key, returning a dictionary.

```q
q)flip{x cols x}key kt
dick
jane
jack
jill
john
q)kt `john
dob| 1990.11.16
sex| `m

q)flip{x cols x}key ku
Tom NYC
Jo  LA
Tom Lagos
q)ku `Tom`Lagos
eye| brown
sex| m
```

Second, with a sublist from its key, returning a list of dictionaries, which is a table.

```q
q)ku ([]city:`LA`Lagos; name:`Jo`Tom)
eye   sex
---------
blue  f
brown m
```


!!! tip "qSQL and Functional SQL"

    The foregoing describes dictionaries and tables in terms of lists and indexes.
    [Functional SQL](../basics/funsql.md) extends the concepts through the query operators `?` and `!`.

    If you are familiar with SQL, you will find [qSQL queries](../basics/qsql.md) more readable.

----

:fontawesome-solid-book-open:
[Functional SQL](../basics/funsql.md),
[qSQL](../basics/qsql.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§8. Tables](/q4m3/8_Tables/)


## List operations

A table is an ordered list.
Many list operators work.


### Take and Drop

For the head and tail of a table use the [Take](../ref/take.md) operator `#`.

```q
q)2#trade                       / take first two records
stock price amt  time
-----------------------------
ibm   121.3 1000 09:03:06.000
bac   5.76  500  09:03:23.000

q)-2#trade                      / take last two records
stock price amt time
----------------------------
bac   5.76  500 09:03:23.000
usb   8.19  15  09:04:01.000

q)-2 _ trade                    / drop last two records
stock price amt  time
-----------------------------
ibm   121.3 1000 09:03:06.000
bac   5.76  500  09:03:23.000
usb   8.19  800  09:04:01.000
ibm   121.3 1000 09:03:06.000
```

Note that Take treats a list as circular if the number of items to take is longer than the list.

```q
q)7#2 3 5
2 3 5 2 3 5 2
```

An alternative is to use [`sublist`](../ref/sublist.md), which takes only as many rows as are available.

```q
q)count trade
6
q)count 3 sublist trade
3
q)count 30 sublist trade
6
```

:fontawesome-solid-book:
[Limit expressions in `select`](../ref/select.md#limit-expression)

You can also take selected columns.

```q
q)`price`amt#trade
price amt
----------
121.3 1000
5.76  500
8.19  800
121.3 1000
5.76  500
8.19  15
```


### Join and Join Each

The [Join](../ref/join.md) operator `,` catenates two lists – and tables are lists.
The table columns need not be in the same order.

```q
q)trade,([]time:10:32:17.000 10:35:45.000;stock:`msft`aapl;amt:1500 750;price:17.5 103.2)
stock price amt  time
-----------------------------
ibm   121.3 1000 09:03:06.000
bac   5.76  500  09:03:23.000
usb   8.19  800  09:04:01.000
ibm   121.3 1000 09:03:06.000
bac   5.76  500  09:03:23.000
usb   8.19  15   09:04:01.000
msft  17.5  1500 10:32:17.000
aapl  103.2 750  10:35:45.000
```

Join Each joins pairs of dictionaries and so has upsert semantics.

```q
q)trade,'([]year:2019+til 6;exch:6?`NYSE`LSE;amt:999)
stock price amt time         year exch
--------------------------------------
ibm   121.3 999 09:03:06.000 2019 NYSE
bac   5.76  999 09:03:23.000 2020 LSE
usb   8.19  999 09:04:01.000 2021 NYSE
ibm   121.3 999 09:03:06.000 2022 LSE
bac   5.76  999 09:03:23.000 2023 NYSE
usb   8.19  999 09:04:01.000 2024 LSE
```

There are many other [join keywords](../basics/joins.md).


### List alternatives to queries

Many qSQL queries are equivalent to simple list operations.

```q
select from trade where i=5           / trade[5]
select stock,amt from trade           / `stock`amt#trade
select from trade where stock=`ibm    / trade where `ibm=trade`stock
```


## Amending a table

### Inserting records

```q
`trade insert (`ibm; 1001; 122.5; 500; 09:04:59:000)
```

Alternative syntax:

```q
insert [`trade] (`ibm; 1001; 122.5; 500; 09:04:59:000)
insert [`trade; (`ibm; 1001; 122.5; 500; 09:04:59:000)]

q)table:([stock:()] price:())
q)insert[`table; (`intel; enlist (123.2; 120.4; 131.0))]
q)table
stock| price
-----| ---------------
intel| 123.2 120.4 131
```


### Bulk insert

The right argument to `insert` above is a list. It can also be a table having the same column names as the first argument.

```q
q)`trade insert trade
```



### Upsert

```q
q)`trade upsert (`ibm; 122.5; 50; 09:04:59:000)
```

For a simple table (not keyed) the above is equivalent to an `insert`.
For a keyed table, it is an `update` if the key exists in the table and an `insert` otherwise.

An alternative syntax for `upsert` is to use the operator `,:`

```q
q)trade ,: (`ibm; 122.5; 50; 09:04:59:000)
```

`upsert` can also take a table as an argument.

```q
trade ,: trade
```


### Delete rows

```q
trade: delete from trade where stock=`ibm
```

`delete` returns a table, but does not modify the `trade` table in place. The assignment accomplishes that.

An alternative that updates the table in place:

```q
delete from `trade where stock=`ibm
```


### Update values

In SQL:

```sql
UPDATE trade SET amount=42+amount WHERE stock='ibm'
```

In q:

```q
trade: update amount:42+amount from trade where stock=`ibm
```

`update` returns a table, but does not modify the underlying table. The assignment accomplishes that. Alternatively:

```q
update amount+42 from `trade where stock=`ibm
```

`update` modifies the table in place much like `delete` deletes in place if a symbol is given as the table name. Also note the default column names.


### Replace null values

Use the [Fill](../ref/fill.md) operator `^`.
For example, the following replaces all nulls in column `amount` by zeroes.

```q
trade.amount: 0^trade.amount
```


### Table to set

Use [`distinct`](../ref/distinct.md) to remove duplicate records, and `count` to count them.

```q
distinct trade
count distinct trade
```


---
:fontawesome-solid-book-open:
[qSQL query templates](../basics/qsql.md)
<br>
:fontawesome-solid-book-open:
[Functional qSQL](../basics/funsql.md)
<br>
:fontawesome-solid-database:
[Database: persisting tables to the filesystem](../database/index.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§8. Tables](/q4m3/8_Tables/)
