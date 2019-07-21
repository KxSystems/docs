---
title: Frequently-asked questions about kdb+
description: Frequently-asked questions about kdb+
keywords: aggregate, csv, delete, export, faq, kdb+, mdb, null, odbc, q, script, shebang, sql, update, upsert
---
# Frequently-asked questions about kdb+



## How do q tables differ from SQL relations ?

Relations in SQL are sets. That is, there are no duplicate rows and rows are not ordered. It is possible to define a cursor on a result set and then manipulate the cursor rows in order, but that can’t be done in ANSI SQL. Kdb+ tables are ordered and may contain duplicates. The order allows a class of very useful [aggregates](../basics/glossary.md#aggregate-function) that are unavailable to the relational database programmer without the cumbersome and poorly performing temporal extensions. Because kdb+ tables are ordered, the functions `first` and `last` give open and close prices. Where `trade` is a table: 

```q
q)first trade
```

and

```q
q)last trade
```


## How do I create a table?

Following the SQL convention, tables are created by naming the items and initializing the items as empty lists. For example, the following expression creates a table with four columns (stock, price, amount and time), and assigns it to `trade`.

```q
q)trade:([] stock:(); price:(); amount:(); time:())
```

Each of the table columns is defined to be an empty list: `()`. 

In this table, the [datatype](../basics/datatypes.md) of the columns is not defined. The first record inserted into the table determines the datatype of each column. Subsequent inserts may only insert values of this type, or else a type error is signalled.

This creates a table in memory. 

<i class="far fa-hand-point-right"></i> 
[How do I write a table to disk?](#how-do-i-write-a-table-to-disk)

Tables can also be created functionally with q primitive functions. 

<i class="far fa-hand-point-right"></i> 
Basics: [Dictionaries and tables](../basics/dictsandtables.md), 
[Q-SQL](../basics/qsql.md), 
[Functional SQL](../basics/funsql.md)


## Can I define the type of the columns when I create a table?

Yes. A type descriptor can be specified for each column:

```q
q)trade:([] stock:`symbol$(); price:`float$(); amount:`int$(); time:`time$())
```

<i class="far fa-hand-point-right"></i> 
Basics: [Datatypes](../basics/datatypes.md)


## Can I give the column values when creating a table?

Yes, you can give values to initialize the items. By default, item names are taken from corresponding variable names.

```q
q)stock:`ibm`bac`usb
q)price:121.3 5.76 8.19
q)amount:1000 500 800
q)time:09:03:06.000 09:03:23.000 09:04:01.000
q)trade:([]stock;price;amt:amount;time)
q)trade
stock price amt  time
-----------------------------
ibm   121.3 1000 09:03:06.000
bac   5.76  500  09:03:23.000
usb   8.19  800  09:04:01.000
```


## How do I define a table with a primary key field?

Just write the field definition inside the square brackets. For instance, this is a simple table of financial markets and their addresses (such as the NYSE, the LSE, etc).

```q
q)market:([name:`symbol$()] address:())
```


## Can the primary key consist of more than one field?

Yes. For instance, if market names are not unique, the country name can be part of the primary key.

```q
q)market:([name:`symbol$(); country:`symbol$()] address:())
```

!!! tip

    An alternative to using multiple columns as a primary key is to add to the table a column of unique values (e.g. integers).


## Can I specify foreign keys for a table?

Yes.

Foreign keys in SQL provide referential integrity. Namely, an attempt to insert a foreign key value that is not in the primary key will fail. This is also true in q.

Imagine that we want to record in our trades table the market (NYSE, LSE, etc) where each trade has been done.

The primary key of the markets table is a foreign key in the trades table.

```q
q)trade:([] stock:`symbol$(); market:`market$(); price:`float$(); amount:`int$(); time:`time$())
```


## How do I insert a record into a table?

```q
q)`trade insert (`ibm; 122.5; 500; 09:04:59:000)
```

An alternative syntax for insertions is

```q
q)insert [`trade](`ibm; 122.5; 500; 09:04:59:000)
```

and

```q
q)insert [`trade; (`ibm; 122.5; 500; 09:04:59:000)]
```


## Can I insert multiple records into a table?

Yes. This is called a _bulk insert_. The second argument to `insert` in the previous question is a list. It can also be a table having the same column names as the first argument.

```q
q)`trade insert trade
```


## What is an `upsert`?

```q
q)`trade upsert (`ibm; 122.5; 50; 09:04:59:000)
```

If the table is not keyed, the above is equivalent to an _insert_. For a keyed table, it’s an _update_ if the key exists in the table and an _insert_ otherwise.

An alternative syntax for `upsert` is to use the operator `,:`

```q
q)trade ,: (`ibm; 122.5; 50; 09:04:59:000)
```

`upsert` can also take a table as an argument.

```q
trade ,: trade
```


## Can a column contain list values?

Yes.

```q
q)table:([stock:()] price:())
q)insert[`table; (`intel; enlist (123.2; 120.4; 131.0))]
q)table
stock| price
-----| ---------------
intel| 123.2 120.4 131
```


## How do I find out how many rows are in a table?

Use the function `count`.

```q
q)count trade
```


## How can I access the i<sup>th</sup> row in a table?

This is complex in SQL, but easy in q. The keyword `i` represents the row index, which can be used in queries.

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

Indexing cannot be used on a keyed table, as the following example demonstrates.

```q
q)tab: ([stock:()] price:())
q)insert[`tab; (`ibm; 109.5)]
,0
q)tab
stock| price
-----| -----
ibm  | 109.5
q)tab[0]
'type
```

It’s also easy to access, say, the second-to-last row.

```q
q)trade[(count trade) - 2]
```

Indexing at depth can be used to read a column within a specific row

```q
q)trade[17; `stock]
```

This is useful for updates too:

```q
q)trade[17; `amount] : 15
```


## When accessing the i-th row in a table, what happens if the index is invalid?

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


## How can I access the first or last n rows in a table?

One way is to use the Take operator `#`.

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


## How do I get the rows in a table as a set (no duplicates)?

Use the function [`distinct`](../ref/distinct.md).

```q
q)distinct trade
```

And the following gives the number of distinct rows

```q
q)count distinct trade
```


## What is the syntax of `select` in q?

`select` expressions have the following general form.

```q
select [columns] [by columns] from table [where conditions] 
```

The result of a select expression is a table. For instance:

```q
q)select stock, amount from trade
stock amount
------------
ibm   500
...
```

In their simplest form, select expressions extract subtables. However, it is also possible for them to compute new columns or rename existing ones.

```q
q)select stock,newamount:amount+10 from trade where price>100
stock newamount
---------------
ibm   510
...
```


## How do I aggregate column values?

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


## How can I add a column with the row number to a table?

The keyword `i` represents the row index.

```q
q)select rowno:i, stock from trade
rowno stock
-----------
0     intel
1     ibm
2     ibm
...
```


## How do I delete rows from a table?

```q
q)trade: delete from trade where stock=`ibm     
```

`delete` returns a table, but does not modify the `trade` table in place. The assignment accomplishes that. An alternative that updates the table in place is the following:

```q
q)delete from `trade where stock=`ibm       
```


## How do I update values in a table?

In SQL:

```sql
UPDATE trade SET amount=42+amount WHERE stock='ibm'
```

In q:

```q
q)trade: update amount:42+amount from trade where stock=`ibm
```

`update` returns a table, but does not modify the underlying table. The assignment accomplishes that. Or more simply:

```q
q)update amount+42 from `trade where stock=`ibm
```

`update` modifies the table in place like `delete` deletes in place if a symbol is given as the table name. Also note the default column names. 

<i class="far fa-hand-point-right"></i> 
Basics: [qSQL](../basics//qsql.md)


## How do I replace null values by something else?

Use the [Fill](../ref/fill.md) operator `^`. For instance, the following replaces all nulls in column `amount` by zeroes.

```q
q)trade.amount: 0^trade.amount      
```


## What are parameterized queries?

Select, update and delete expressions can be evaluated in defined functions. 

```q
q)myquery:{[tbl; amt] select stock, time from tbl where amount > amt}
q)myquery[trade; 100]
stock time
------------------
ibm   09:04:59.000
...
```

Column names cannot be parameters of a qSQL query. Use [functional queries](../basics/funsql.md) in such cases.


## Does q use stored procedures?

Any suitable user-defined function can be used in a query. 

```q
q)f:{[x] x+42}
q)select stock, f amount from trade
stock amount
------------
ibm   542
...
```


## Can I write a query using SQL syntax against q tables?

Yes. Q implements a translation layer from SQL. The syntax is to prepend `s)` to the SQL query. 

```q
q)s)select * from trade
```

Only a subset of SQL is supported.
<!--FIXME link to definition of subset.-->


## How do I write a table to disk?

```q
q)`:filename set trade
```

Or alternatively

```q
q)save `:trade
```

You can also specify a directory:

```q
q)`:../filename set trade
```


## How do I read a table from disk?

```q
q)trade: get `:filename
```

Or alternatively,

```q
q)trade: value `:filename
```


## How do I export a table to a CSV file?

```q
q)save `:trade.csv
```


## How do I import a CSV file into a table?

Assume a file data.csv with columns of type int, string and int.

```csv
a,b,c
0,hea,481
10,dfi,579
20,oil,77
```

Then, the following expression does the trick:

```q
q)table: ("ISI"; enlist ",") 0:`data.csv
q)table
a   b   c
-----------
0   hea 481
10  dfi 579
20  oil 77
```

<i class="far fa-hand-point-right"></i> 
[`0:` File Text](../ref/file-text.md) 


## What if the CSV file contains data but no column names?

For instance:

```csv
0,hea,481
10,dfi,579
20,oil,77
```

We can read the columns like this:

```q
q)Cols: ("ISI";",") 0:`data.csv
q)Cols
0   10  20
hea dfi oil
481 579 77
```

And we can create the table by first creating a dictionary and flipping it:

```q
q)table: flip `a`b`c!Cols
```

!!! warning

    Column names must not be the null symbol <code>&#96;</code>.


## How do I export a table to a text file?

```q
q)save `:trade.txt
```

<i class="far fa-hand-point-right"></i> 
[`save`](../ref/save.md)


## How do I access a table from an MDB file via ODBC?

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


## Can I execute q as a shebang script?

Yes. Since V2.4, q ignores the first line if it begins with `#!`.

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

<i class="fas fa-external-link-alt"></i> 
[Shebang (Unix)](http://en.wikipedia.org/wiki/Shebang_(Unix))
