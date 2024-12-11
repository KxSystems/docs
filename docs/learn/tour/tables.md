---
title: Tables in kdb+ 
author: Conor McCarthy
date: December 2024
description: A brief tour of tables in kdb+/q
---
# Tables in kdb+

This page introduces you to the types of tables which exist in q, how these tables are created and what makes tables in q so powerful.

Unlike in many other programming languages where the tables you encounter are added as a second-class extension to the language, in q they are first-class objects. 

There are 5 types of table that you'll encounter as you learn more about kdb+:

1. Table
1. Keyed Table 
1. Splayed Table
1. Partitioned Table
1. Segmented Table

In this page we will concentrate on the first two of these table types which form the basic building blocks for the more complex tables.

## What is a Table?

At its most basic a table is a mapping between a list of column names which each have an associated list of corresponding column values. This column to list mapping form the basis behind why q tables are described as being column-oriented, this is in contrast to row-oriented tables in most relational databases. Additionally because lists are ordered so are the content of a column.

These two points (column oriented and ordered) in particular help to make kdb+/q extremely efficient at storing, manipulating and retrieving sequential data, which is critically important to interactions with time-series data.

We can generate tables in two ways which illustrate this direct mapping:

1. Creating a table from a dictionary

	```q
	q)dict:`items`sales`prices!(`nut`bolt`cam`cog;6 8 0 3;10 20 15 20)
	items | nut bolt cam cog
	sales | 6   8    0   3  
	prices| 10  20   15  20
	q)tab:flip dict
	q)tab
	items sales prices
	------------------
	nut   6     10
	bolt  8     20
	cam   0     15
	cog   3     20
	```

2. Creating a table by specifying column names and initial values explicitly

	```q
	q)tab2:([]items:`nut`bolt`cam`cog;sales:6 8 0 3;prices:10 20 15 20)
	q)tab~tab2
	1b
	```

The form for the second method, for a table with j primary keys and n columns in total, is:

<div markdown="1" class="typewriter">
t:([] c~1~:v~1~; … ;c~n~:v~n~)
</div>

Here table `t` is defined with column names $c_{1-n}$, and corresponding values $v_{1-n}$. The square brackets are for primary keys, and are required even if there are no primary keys.

Tables in q have a [datatype](datatypes.md) `98h`.

## What is a Keyed Table?

At its most simple a Keyed Table is a dictionary mapping a table of key records to a table of value records. This construct has advantages when retrieving data associated with a particular unique record.

Unlike in SQL where the records in a primary key are unique kdb+ does not enforce this, as such retrieval of all rows in a value table associated with duplicate keys is not possible.

As mentioned despite the name a keyed table has a [datatype](datatypes.md) `99h` and is actually a dictionary.

We can generate a keyed tables in a number of ways:

1. Creating a keyed table from two tables

	```q
	q)k:([]id:1000 1001 1002 1003)
	q)v:([]name:`alice`bob`carol`dave;salary:100 150 200 175)
	q)k!v
	id  | name  salary
	----| ------------
	1000| alice 100   
	1001| bob   150   
	1002| carol 200   
	1003| dave  175   
	```

2. Create a keyed table by specifying column names and initial values explicitly

	```q
	q)([id:1000 1001 1002 1003]name:`alice`bob`carol`dave;salary:100 150 200 175)
	id  | name  salary
	----| ------------
	1000| alice 100
	1001| bob   150
	1002| carol 200
	1003| dave  175
	```

3. Create a keyed table from an existing table using the [`!`](../../ref/overloads/#bang) and [`xkey`](../../ref/keys/#xkey) operator and keyword.

	```q
	q)tab:([]id:1000 1001 1002 1003;name:`alice`bob`carol`dave;salary:100 150 200 175)
	q)1!tab
	id  | name  salary
	----| ------------
	1000| alice 100   
	1001| bob   150   
	1002| carol 200   
	1003| dave  175
	q)`id xkey tab
	id  | name  salary
	----| ------------
	1000| alice 100   
	1001| bob   150   
	1002| carol 200   
	1003| dave  175  
	```

The form for the second method, for a table with `j` primary keys and `n` columns in total, is:

<div markdown="1" class="typewriter">
t:([c~1~:v~1~; … ; c~j~:v~j~] c~j+1~:v~j+1~; … ;c~n~:v~n~)
</div>

Here table `t` is defined with column names $c_{1-n}$, and corresponding values $v_{1-n}. The square brackets are for primary keys.

## Working with tables

There are a number of ways to interact with the table types we've introduced above and you can mix and match them to suit yourself.

- Q-SQL
- Using the q operators/keywords

### Q-SQL

Covered in greater depth when we talk about querying data q makes use of a set of functions for manipulating tables called Q-SQL the name deriving from the similarity of its syntax to SQL and the existence of similar functionality.

q provides users with keywords for [`insert`](../../ref/insert.md) and [`upsert`](../../ref/upsert.md) to allow tables to be augmented while additionally providing access to [`select`](../../ref/select.md), [`exec`](../../ref/exec.md), [`update`](../../ref/update.md) and [`delete`](../../ref/delete.md) operations to allow filtered and modified.

To show these in action we can take a simple example of upserting some data and filtering data using a select. Before we do that let's generate some data to use in the examples

```q
q)cities:([]region:`EMEA`AMER`EMEA;country:`Ireland`USA`UK;city:`Dublin`NYC`London;pop:0.7 8.9 8.2)
```

Firstly let's append some new data to the table, adding this using [`upsert`](../../ref/upsert.md):
 
```q
q)`cities upsert ([]region:`APAC`AMER;country:`Japan`Canada;city:`Osaka`Montreal;pop:2.8 1.8)
`cities
q)cities
region country city     pop
---------------------------
EMEA   Ireland Dublin   0.7
AMER   USA     NYC      8.9
EMEA   UK      London   8.2
APAC   Japan   Osaka    2.8
AMER   Canada  Montreal 1.8
```

We can then filter the data using a [`select`](../../ref/select.md) statement:

```q
q)select from cities where region=`EMEA
region country city   pop
-------------------------
EMEA   Ireland Dublin 0.7
EMEA   UK      London 8.2
```

### Using q operators/keywords

Many functions and operations in q operate directly on q tables or work exclusively with these first class objects.

The [Join](../../ref/join.md) operator `,` catenates lists.

```q
q)1 2 3,10 20
1 2 3 10 20
q)"abc","def"
"abcdef"
```

Two tables are two lists of dictionaries. 

```q
q)ec2,ec1
city         country pop
-----------------------------
Berlin       Germany 3748148
Kyiv         Ukraine 3703100
Madrid       Spain   3223334
Istanbul     Turkey  15067724
Moscow       Russia  12615279
London       UK      9126366
StPetersburg Russia  5383890
```


## Persisting Tables

Any object can be persisted to a file.

```q
q)conts:`Africa`Asia`Australia`Europe`NorthAmerica`SouthAmerica
q)`:path/to/continents set conts
`:path/to/continents
q)get `:path/to/continents
`Africa`Asia`Australia`Europe`NorthAmerica`SouthAmerica

q)`:path/to/ec set ec
`:path/to/ec
q)select from `:path/to/ec where pop>5000000
city         country pop
-----------------------------
Istanbul     Turkey  15067724
Moscow       Russia  12615279
London       UK      9126366
StPetersburg Russia  5383890
```


## Scaling your tables

Tables up to 100 million rows can be _splayed_ (one file for each column) across directories.

If your table is larger – or grows – you can _partition_ it; usually by time period. 

If your table exceeds disk size, you can _segment_ it. (This can also improve I/O performance of a partitioned table.)


:fontawesome-regular-hand-point-right:
<!-- [Files](files.md)
<br>
 -->:fontawesome-solid-book:
[`get`, `set`](../../ref/get.md),
[`save`](../../ref/save.md)
<br>
:fontawesome-solid-graduation-cap:
[Splayed tables](../../kb/splayed-tables.md),
[Partitioned tables](../../kb/partition.md)
<br>
:fontawesome-solid-graduation-cap:
_Q for Mortals_ [§8. Tables](/q4m3/8_Tables/), 
[§14. Introduction to kdb+](/q4m3/14_Introduction_to_Kdb%2B)

## Next Steps

- [Learn how to ingest a CSV file as a common source of your first table data](csvs.md)
