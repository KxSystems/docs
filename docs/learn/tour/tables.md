---
title: Tables in kdb+ 
author: Conor McCarthy
date: December 2024
description: A brief tour of tables in kdb+/q
---
# Tables in kdb+

_This page explains the types of tables in q, how to create them, and their powerful features._

Unlike in many other programming languages where the tables you encounter are added as a second-class extension to the language, in q they are first-class objects. 

Based on their storage and structure, there are 4 types of tables in kdb+:

1. Table
1. Keyed Table 
1. Splayed Table
1. Partitioned Table
1. Segmented Table

When dealing with these forms of tables there is a distinction between in-memory and on-disk datasets. We will deal with these two cases separately.

## In-Memory Tables

In-memory tables live RAM of a process. This memory is volatile and limited in size but allows for fast data retrieval. Typically you will be in a position to generate and access a maximum of 10s of gigabytes of data. As the data stored in RAM is volatile until the data is persisted any exiting of a process will result in the data being lost and will require the data to be regenerated, a task which may be complex.

### What is a Table?

A table is essentially a mapping between column names and their corresponding lists of values. This column-to-list mapping is why q tables are considered column-oriented, unlike the row-oriented tables in most relational databases. Additionally, since lists are ordered, the contents of each column are also ordered.

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

As mentioned, despite the name, a keyed table has a [datatype](datatypes.md) `99h` and is actually a dictionary.

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

## On-disk Data

Unlike in-memory data, on-disk storage provides reassurances that data which persisted will be available on process restart immediately. In this case, the constraints on the size of data which can be stored are limited by the amount of physical disk available which can be on the order of terabytes. On-disk data access and query is typically slower than querying data in RAM but allows for larger than memory queries to be produced and allows individual tables to scale as part of databases.

How your tables are persisted to disk with q varies based on the size of the data you are ultimately looking to query and the data volumes that need to be stored. How the data can be persisted is summarized below:

| Type              | On-Disk Representation                                                                               | Best Used Where                                                                |
| :---------------- | :--------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------- |
| Table Object      | Single binary file                                                                                   | Small data volume with most queries using most columns                         |
| Splayed Table     | Directory of files containing a file per column                                                      | Up to 100 million records                                                      |
| Partitioned Table | A Directory containing multiple folders (partitions) typically dates each containing a splayed table | More than 100 million records or a steadily growing data volume                |
| Segmented Table   | Partitioned tables distributed across multiple disks                                                 | When tables are larger than available disk size or access needs to parallelize |

### Table Object

In-memory objects in q can be persisted to disk as a single binary file, this is the simplest way that you can persist a table.

Persisting both single binary table objects and splayed tables uses the keyword [`set`](../../ref/set.md) passing the file path to which the binary object will be persisted as the first argument. As a simple example

```q
q)table:([]id:neg[1000]?1000;power:1000?1f;voltage:1000?10f)
q)`:object set table
`:object
```

Exiting the process you can now check that the table has been persisted by listing the contents of your working folder

=== "Linux/Mac"

	```bash
	$ ls
	object
	```

=== "Windows"

	```bash
	$ dir
	object
	```

Starting a new q process you can then query the on-disk data by file reference:

```q
q)select from `:object where id>500
id  power      voltage   
-------------------------
769 0.1870281  3.927524  
591 0.6333324  3.017723  
618 0.4418975  5.347096  
645 0.5569152  0.8388858 
541 0.3877172  1.959907
```

### Splayed Table

Medium-sized tables (up to 100 million rows) and those with many columns are best stored on disk [splayed](https://en.wiktionary.org/wiki/splay "Wiktionary"): each column is stored as a separate file, rather than using a single file for the whole table. For example 

```treeview
splay/
├── .d
├── id
├── power
└── voltage
```

The hidden file `.d` lists the columns in the order they appear in the table.

The main advantage of this data saving method is that it enables on-demand access to specific columns needed for a query. By reducing the I/O required for queries, you can handle larger data volumes more efficiently than with binary or in-memory tables.

Persisting a splayed table is very similar to persisting a binary file, the key difference being that the supplied path should be a directory rather than a file.

```q
q)N:1000000
q)table:([]id:neg[N]?N;power:N?1f;voltage:N?10f)
q)`:splay/ set table
```

This table will be persisted in line with the directory view we saw previously.

This data can then be loaded and queried by other q processes as follows:

```q
q)\l splay
q)select 2*voltage from splay where id>500000
```

You can read more about how splayed tables are created and managed you can follow the how-to guide [here](../../kb/splayed-tables.md).

### Partitioned Table

When data volumes exceed 100 million records, accessing and querying individual columns can become time-consuming. A partitioned table addresses this by storing data on disk as a set of splayed tables, each in separate folders logically divided by date, month, year, or long value. For example, you can store a financial trade table across multiple dates in this manner:

```treeview
db
├── 2020.10.04
│   └── trades
│       ├── .d
│       ├── price
│       ├── sym
│       ├── time
│       └── vol
├── 2020.10.05
│   └── trades
..
└── sym
```

When dealing with splayed data the on-demand access to data per column when querying provided advantages in limiting the I/O per query, similarly partitioned database queries provide a second level of filtering. When querying  a partitioned database use of the `where` clause allows us to selectively access data from only the partitions we are interested in. For example taking the table above we could query only for trade data in the `2020.10.04` partition as follows:

```q
q)\l db
q)select max price by sym from trades where date=2020.10.04
```

In this case we will only access data in the following files within the tree view:

```treeview
db
├── 2020.10.04
│   └── trades  
│       ├── price
│       └── sym
└── sym
```

For a guide showing how splayed tables are created and managed you can follow this [How to partition guide](../../kb/partition.md).

### Segmented Table

When your database becomes too large to be stored on an individual disk you can distribute it across multiple storage devices. This is often done for two reasons:

- To allow a database to store more data than available memory on a disk
- To support parallelization of queries 

The root of a segmented database contains only the sym list and a file named `par.txt`. This file provides a mapping which allows you to unify the partitions of a database, presenting them as a single database for querying.

#### The par.txt file

A file `par.txt` defines the top-level partitioning of the database into directories. Each row of `par.txt` is a directory path. Each such directory is itself partitioned in the usual way, typically by date. The directories should not be empty.


```txt
DISK 0             DISK 1                     DISK 2  
db                 db                        db             
├── par.txt        ├── 2020.10.03            ├── 2020.10.04                         
└── sym            │   ├── quotes            │   ├── quotes                         
                   │   │   ├── price         │   │   ├── price                            
                   │   │   ├── sym           │   │   ├── sym                          
                   │   │   └── time          │   │   └── time                           
                   │   └── trades            │   └── trades                         
                   │       ├── price         │       ├── price                            
                   │       ├── sym           │       ├── sym                          
                   │       ├── time          │       ├── time                           
                   │       └── vol           │       └── vol                          
                   ├── 2020.10.05            ├── 2020.10.06                         
                   │   ├── quotes            │   ├── quotes      
               ..                    ..
```

The `par.txt` for the above:


```txt
/1/db
/2/db
```

You can read more about how splayed tables are created and managed you can follow the how-to guide [here](../../database/segment.md).

## Next Steps

- [Learn about CSV file ingestion in q a common source of your first table data](csvs.md)
- Learn about querying your tabular data
