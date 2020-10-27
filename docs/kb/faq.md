---
title: Tables in kdb+ | Language | kdb+ and q documentation
description: Tables in kdb+
author: Stephen Taylor
date: October 2020
---
# Tables



A table is a first-class object in q. It is an ordered list of its rows.

Here is a matrix: a list of four vectors.

```q
q)show mat:(`Jack`Jill`Janet;`brown`black`fair;`blue`green`hazel;12 9 14)
Jack  Jill  Janet
brown black fair
blue  green hazel
12    9     14
```

The same information as a column dictionary: each value is a 3-vector.

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

Each row is a dictionary.

```q
q)first t
name| `Jack
hair| `brown
eye | `blue
age | 12
```

A table is an ordered list of same-key dictionaries.

Like any list, its length – the number of its records – is given by `count`.

```q
q)count t
3
```


## Table notation

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


## Table schema

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


## Record order

Relations in SQL are sets. There are no duplicate rows, and rows are not ordered. It is possible to define a cursor on a result set and then manipulate the cursor rows in order, but not in ANSI SQL. 

Kdb+ tables are ordered and may contain duplicates. The order allows a class of very useful [aggregates](../basics/glossary.md#aggregate-function) that are unavailable to the relational database programmer without the cumbersome and poorly performing temporal extensions. 

Where `trade` is a table in timestamp order, because kdb+ tables are ordered, the functions `first` and `last` give open and close prices: 

```q
first trade
last trade
```


## Keyed tables

A kdb+ table is a list and it can contain duplicates. 

A kdb+ keyed table is a dictionary. Its key is a table of the key column/s. Its value is a table of the non-key columns. 

In table notation, write the key field/s inside the square brackets. 
For a simple table of financial markets and their addresses:

```q
q)market:([name:`symbol$()] address:())
```

If market names are not unique, the country name could be part of the primary key.

```q
q)market:([name:`symbol$(); country:`symbol$()] address:())
```

!!! tip "An alternative to using multiple columns as a primary key is to  a column of unique int IDs"


## Foreign keys

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



## Inserting records

```q
`trade insert (`ibm; 1001; 122.5; 500; 09:04:59:000)
```

Alternative syntax:

```q
insert [`trade] (`ibm; 1001; 122.5; 500; 09:04:59:000)
insert [`trade; (`ibm; 1001; 122.5; 500; 09:04:59:000)]
```


### Bulk insert

The right argument to `insert` above is a list. It can also be a table having the same column names as the first argument.

```q
q)`trade insert trade
```


### List values

Table columns can contain list values.

```q
q)table:([stock:()] price:())
q)insert[`table; (`intel; enlist (123.2; 120.4; 131.0))]
q)table
stock| price
-----| ---------------
intel| 123.2 120.4 131
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


## Indexing a table

Selecting the i<sup>th</sup> row in a table is complex in SQL, but easy in q. 

The pseudo column `i` represents the row index, which can be used in [queries](../basics/qsql.md).

```q
q)select from trade where i=17
stock price amount time
---------------------------------------
ibm   122.5 50     09:04:59.000
```

The `select` expression returns a table with a single row. 

```q
q)trade[17]
stock | `ibm
price | 122.5
amount| 500
time  | 09:04:59.000
```

Indexing a table with an atom returns a dictionary.

!!! detail "Indexing cannot be used on a keyed table, which is a dictionary."

It is also easy to access, say, the second-to-last row.

```q
trade[(count trade) - 2]
```

Indexing at depth can be used to read a column within a specific row.

```q
trade[17; `stock]
```

Also useful for updates.

```q
trade[17; `amount] : 15
```


### Index out of range

If we use `select`, the result is a table with no rows.

```q
q)select from trade where i = 300000
stock price amount time
---------------------------------------
```

If we use indexing, the result is a dictionary containing null values.

```q
q)trade 300000
stock | `
market| `market$`
price | 0n
amount| 0N
time  | 0Nt
```


### Head and tail of a table

Use the [Take](../ref/take.md) operator `#`.

```q
q)3#trade
stock market price amount time
---------------------------------------
ibm   nyse   122.5 50     09:04:59.000
...
```

gives the first 3 rows, and

```q
q)-3#trade
stock market price    amount time
---------------------------------------
intel lse    130.3029 45     09:34:29.000 0
...
```

gives the last three rows.

Note that Take treats a list as circular if the number of items to take is longer than the list.

```q
q)7#2 3 5
2 3 5 2 3 5 2
```

An alternative is to use [`sublist`](../ref/sublist.md), which takes only as many rows as are available.

```q
q)count trade
10
q)count 3 sublist trade
3
q)count 30 sublist trade
10
```

:fontawesome-solid-book:
[Limit expressions in `select`](../ref/select.md#limit-expression)


## Table to set

Use [`distinct`](../ref/distinct.md) to remove duplicate records, and `count` to count them.

```q
distinct trade
count distinct trade
```


## Aggregate column values

In SQL:

```sql
select stock, sum(amount) as total from trade group by stock
```

In q:

```q
q)select total:sum amount by stock from trade
stock| total
-----| -----
ibm  | 1550
intel| 75
```

The column `stock` is a key in the result table.

:fontawesome-solid-book:
[The By phrase in `select` queries](../ref/select.md#by-phrase)


## Row-number column

The pseudo-column `i` represents the row index.

```q
q)select rowno:i, stock from trade
rowno stock
-----------
0     intel
1     ibm
2     ibm
..
```


## Delete rows

```q
trade: delete from trade where stock=`ibm     
```

`delete` returns a table, but does not modify the `trade` table in place. The assignment accomplishes that. 

An alternative that updates the table in place:

```q
delete from `trade where stock=`ibm       
```


## Update values

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


## Replace null values

Use the [Fill](../ref/fill.md) operator `^`. 
For example, the following replaces all nulls in column `amount` by zeroes.

```q
trade.amount: 0^trade.amount      
```


## Parameterized queries

`select`, `update`, and `delete` expressions can be evaluated in lambdas. 

```q
q)myquery:{[tbl; amt] select stock, time from tbl where amount > amt}
q)myquery[trade; 100]
stock time
------------------
ibm   09:04:59.000
...
```

Column names cannot be parameters of a qSQL query. Use [functional queries](../basics/funsql.md) in such cases.


## Stored procedures

Any suitable lambda can be used in a query. 

```q
q)f:{[x] x+42}
q)select stock, f amount from trade
stock amount
------------
ibm   542
...
```


## Queries using SQL syntax

Q implements a translation layer from SQL. The syntax is to prepend `s)` to the SQL query. 

```q
q)s)select * from trade
```

!! warning "Only a subset of SQL is supported."


## Write table to disk

```q
save `:trade                / write table trade to eponymous file in current directory
q)`:../filename set trade   / write table trade to filename in parent directory
```

:fontawesome-solid-book:
[`set`](../ref/get.md#set)
<br>
:fontawesome-solid-database:
[Persisting tables to the filesystem](../database/index.md)


## Read a table from disk

```q
load `:../trade             / load table trade from eponymous file in parent dir
trade: get `:../filename  / set table trade from filename in parent dir
```

:fontawesome-solid-book:
[`get`](../ref/get.md)


## Export a table as a CSV

```q
save `:trade.csv
`:../trade.csv set trade
```


## Import a CSV file as a table

Suppose `data.csv` with columns of type int, string and int:

```csv
a,b,c
0,hea,481
10,dfi,579
20,oil,77
```

```q
q)show table: ("ISI"; enlist ",") 0:`data.csv
a   b   c
-----------
0   hea 481
10  dfi 579
20  oil 77
```

:fontawesome-solid-book: 
[`0:` File Text](../ref/file-text.md#load-csv) 

If the CSV file contains data but no column names:

```csv
0,hea,481
10,dfi,579
20,oil,77
```

We can read the columns:

```q
q)("ISI";",") 0:`data.csv
0   10  20
hea dfi oil
481 579 77
```

Create a column dictionary and flip it:

```q
table: flip `a`b`c!("ISI";",") 0:`data.csv
```

!!! warning "Column names must not be the null symbol <code>&#96;</code>"


## Export a table as a text file

```q
q)save `:trade.txt
```

:fontawesome-solid-book: 
[`save`](../ref/save.md)


## Access a table from an MDB file via ODBC

From Windows, load `odbc.k` into your q session, and then load the MDB file.

```dos
C:>q w32\odbc.k
```

```q
q)h: .odbc.load `mydb.mdb
```

This loads the entire database, which may consist of several tables. Use `.odbc.tables` to list the tables.

```q
q).odbc.tables  h
`aa`bb`cc`dd`ii`nn      
```

Use `.odbc.eval` to evaluate SQL commands via ODBC.

```q
q).odbc.eval[h;"select * from aa"]
```


## Execute a q script as a shebang script

```bash
$ more ./test.q
#!/usr/bin/env q
2+3
\\
$ chmod +x ./test.q
$ ./test.q
KDB+ 3.1 2013.11.20 Copyright (C) 1993-2013 Kx Systems
l64/ ...
5
```

:fontawesome-solid-globe: 
[Shebang](https://en.wikipedia.org/wiki/Shebang_(Unix) "wikipedia")


---
:fontawesome-solid-book:
[Syntax of `select`](../ref/select.md)
<br>
:fontawesome-solid-book:
[QSQL query templates](../basics/qsql.md)
<br>
:fontawesome-solid-database:
[Persisting tables to the filesystem](../database/index.md)

