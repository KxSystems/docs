---
title:  Loading from large files | Knowledge Base | kdb+ and q documentation
description: When data in the CSV file is too large to fit into memory, we need to break it into manageable chunks and process them in sequence. 
author: Stephen Taylor
date: October 2020
---
# Loading from large files




The [Load CSV](../ref/file-text.md#load-csv) form of the File Text operator loads a CSV file into a table in memory, from which it can be [serialized](../database/index.md) in various ways.

If the data in the CSV file is too large to fit into memory, we need to break the large CSV file into manageable chunks and process them in sequence. 

Function [`.Q.fs`](../ref/dotq.md#qfs-streaming-algorithm) and its variants help automate this process. `.Q.fs` loops over a file in conveniently-sized chunks of complete records, and applies a function to each chunk. This lets you implement a _streaming algorithm_ to convert a large CSV file into an on-disk database without holding all the data in memory at once.


## Using `.Q.fs`

Suppose our CSV file contains the following:

```csv
2019-10-03, 24.5,  24.51, 23.79, 24.13, 19087300, AMD
2019-10-03, 27.37, 27.48, 27.21, 27.37, 39386200, MSFT
2019-10-04, 24.1,  25.1,  23.95, 25.03, 17869600, AMD
2019-10-04, 27.39, 27.96, 27.37, 27.94, 82191200, MSFT
2019-10-05, 24.8,  25.24, 24.6,  25.11, 17304500, AMD
2019-10-05, 27.92, 28.11, 27.78, 27.92, 81967200, MSFT
2019-10-06, 24.66, 24.8,  23.96, 24.01, 17299800, AMD
2019-10-06, 27.76, 28,    27.65, 27.87, 36452200, MSFT
```

If you call `.Q.fs` with the function `0N!`, you get a list with the rows as elements:

```q
q).Q.fs[0N!]`:file.csv
("2019-10-03,24.5,24.51,23.79,24.13,19087300,AMD";"2019-10-03,27.37,27.48,27...
387
```

You can get a list with the columns as elements like this:

```q
q).Q.fs[{0N!("DFFFFIS";",")0:x}]`:file.csv
(2019.10.03 2019.10.03 2019.10.04 2019.10.04 2019.10.05 2019.10.05 2019.10.06..
387
```

Having that, the next step is to table it:

```q
q)colnames:`date`open`high`low`close`volume`sym
q).Q.fs[{0N! flip colnames!("DFFFFIS";",")0:x}]`:file.csv
+`date`open`high`low`close`volume`sym!(2019.10.03 2019.10.03 2019.10.04 2019...
387
```

And finally we can insert each row into a table

```q
q).Q.fs[{`trade insert flip colnames!("DFFFFIS";",")0:x}]`:file.csv
387
q)trade
date       open  high  low   close volume   sym
------------------------------------------------
2019.10.03 24.5  24.51 23.79 24.13 19087300 AMD
2019.10.03 27.37 27.48 27.21 27.37 39386200 MSFT
2019.10.04 24.1  25.1  23.95 25.03 17869600 AMD
2019.10.04 27.39 27.96 27.37 27.94 82191200 MSFT
2019.10.05 24.8  25.24 24.6  25.11 17304500 AMD
2019.10.05 27.92 28.11 27.78 27.92 81967200 MSFT
2019.10.06 24.66 24.8  23.96 24.01 17299800 AMD
2019.10.06 27.76 28    27.65 27.87 36452200 MSFT
```

The above sequence created the table in memory, but if it is too large to fit, we can insert the rows directly into a table on disk:

```q
q).Q.fs[{`:newfile upsert flip colnames!("DFFFFIS";",")0:x}]`:file.csv
387
q)value `:newfile
date       open  high  low   close volume   sym
------------------------------------------------
2019.10.03 24.5  24.51 23.79 24.13 19087300 AMD
2019.10.03 27.37 27.48 27.21 27.37 39386200 MSFT
2019.10.04 24.1  25.1  23.95 25.03 17869600 AMD
2019.10.04 27.39 27.96 27.37 27.94 82191200 MSFT
2019.10.05 24.8  25.24 24.6  25.11 17304500 AMD
2019.10.05 27.92 28.11 27.78 27.92 81967200 MSFT
2019.10.06 24.66 24.8  23.96 24.01 17299800 AMD
2019.10.06 27.76 28    27.65 27.87 36452200 MSFT
```


Variants of `.Q.fs` extend it to [named pipes](named-pipes.md) and control chunk size.

:fontawesome-solid-book:
[`.Q.fsn`](../ref/dotq.md#qfsn-streaming-algorithm) for chunk size
<br>
:fontawesome-solid-book:
[`.Q.fps`](../ref/dotq.md#qfps-streaming-algorithm),
[`.Q.fpn`](../ref/dotq.md#qfpn-streaming-algorithm) for named pipes

<!-- 
To write to a partitioned database, some utility functions generalizing [`.Q.dpft`](../ref/dotq.md#qdpft-save-table) are useful.

```q
$ cat fs.q
\d .Q

/ extension of .Q.dpft to separate table name & data
/  and allow append or overwrite
/  pass table data in t, table name in n, : or , in g
k)dpfgnt:{[d;p;f;g;n;t]if[~&/qm'r:+en[d]t;'`unmappable];
 {[d;g;t;i;x]@[d;x;g;t[x]i]}[d:par[d;p;n];g;r;<r f]'!r;
 @[;f;`p#]@[d;`.d;:;f,r@&~f=r:!r];n}

/ generalization of .Q.dpfnt to auto-partition and save a multi-partition table
/  pass table data in t, table name in n, name of column to partition on in c
k)dcfgnt:{[d;c;f;g;n;t]*p dpfgnt[d;;f;g;n]'?[t;;0b;()]',:'(=;c;)'p:?[;();();c]?[t;();1b;(,c)!,c]}

\d .

r:flip`date`open`high`low`close`volume`sym!("DFFFFIS";",")0:
w:.Q.dcfgnt[`:db;`date;`sym;,;`stats]
.Q.fs[w r@]`:file.csv
```

```bash
$ q fs.q
```

```q
KDB+ 2.7 2011.11.22 Copyright (C) 1993-2011 Kx Systems
l64/

436
q)\l db
q)stats
date       sym  open  high  low   close volume
------------------------------------------------
2019.10.03 AMD  24.5  24.51 23.79 24.13 19087300
2019.10.03 MSFT 27.37 27.48 27.21 27.37 39386200
2019.10.04 AMD  24.1  25.1  23.95 25.03 17869600
2019.10.04 MSFT 27.39 27.96 27.37 27.94 82191200
2019.10.05 AMD  24.8  25.24 24.6  25.11 17304500
2019.10.05 MSFT 27.92 28.11 27.78 27.92 81967200
2019.10.06 AMD  24.66 24.8  23.96 24.01 17299800
2019.10.06 MSFT 27.76 28    27.65 27.87 36452200
```
 -->

## Data-loading example

Q makes it easy to load data from files (CSV, TXT, binary etc.) into a database. The simplest case is to read a file completely into memory and save it to a table on disk using `.Q.dpft` or [`set`](../ref/get.md#set). However, this is not always possible and different techniques may be required, depending on how the data is presented. 

Ideally data is presented in a form consistent with how it is stored in the database and in file sizes which can be easily read into memory all at once. Loading is fastest when the number of different writes to different database partitions is minimized. 

An example of this in a date-partitioned database with financial data would be a single file per date and per instrument, or a single file per date. A slightly different example might have many small files to be loaded (e.g. minutely bucketed data per date and per instrument), in which case the performance would be maximized by reading many files for the same date at once, and writing in one block to a single date partition.

Unfortunately it is not always possible or is too expensive to structure the input data in a convenient way. The example below considers the techniques required to load data from multiple large CSV files. Each CSV file contains one month of trade data for all instruments, sorted by time. We want to load it into a date-partitioned database with the data parted by instrument. Assume we cannot read the full file into memory.

We must

-   read data in chunks using [`.Q.fsn`](../ref/dotq.md#fsn-streaming-algorithm)
-   append data to splayed tables using manual enumerations and [`upsert`](../basics/qsql.md#upsert)
-   re-sort and set attributes on disk when all the data is loaded
-   write a daily statistics table as a splayed table at the top level of the database

:fontawesome-brands-github:
[KxSystems/cookbook/dataloader/gencsv.q](https://github.com/KxSystems/cookbook/blob/master/dataloader/gencsv.q)
Test CSV generator
<br>
:fontawesome-brands-github: 
[KxSystems/cookbook/dataloader/loader.q](https://github.com/KxSystems/cookbook/blob/master/dataloader/loader.q)
Full loader

!!! aside "The loader could be made more generic, but has been kept simple to preserve clarity."

Unlike other database technologies, you do not need to define the table schema before you load the data, i.e. there is no separate “create” step. The schema is defined by the format of the written data, so the schema is often defined by the data loaders.


### Data loader

A data loader should always produce ample debug information. Each step may take considerable time reading from or writing to disk; best to see what the loader is doing rather than a blank console.

The following structure is fairly common for loaders.

`loaddata`

: A function to load in a chunk of data and write it out to the correct table structures 

: Loads data into the table partitions. The main load is done using `0:`, which can take either data or the name of a file as its right argument. `loaddata` builds a list of partitions that it has modified during the load.


`final`

: A function to do the final tasks once the load is complete.

: Used to re-sort and re-apply attributes after the main load is done. It re-sorts each partitioned table only if necessary. It uses the list of partitions built by `loaddata` to know which tables to modify. It creates a top-level view table (daily) from each partition it has modified.


`loadallfiles`

: The wrapper function which generates the list of files to load, loads them, then invokes `final`. It takes a directory as its argument, to find the files to load. 


### Example

Run `gencsv.q` to build the raw data files. You can modify the config to change the size, location or number of files generated.

```bash
> q gencsv.q 
KDB+ 4.0 2020.10.02 Copyright (C) 1993-2020 Kx Systems
```

```q
2019.02.25T14:21:00.477 writing 1000000 rows to :examplecsv/trades2019_01.csv for date 2019.01.01
2019.02.25T14:21:02.392 writing 1000000 rows to :examplecsv/trades2019_01.csv for date 2019.01.02
2019.02.25T14:21:04.049 writing 1000000 rows to :examplecsv/trades2019_01.csv for date 2019.01.03
2019.02.25T14:21:05.788 writing 1000000 rows to :examplecsv/trades2019_01.csv for date 2019.01.04
2019.02.25T14:21:07.593 writing 1000000 rows to :examplecsv/trades2019_01.csv for date 2019.01.05
2019.02.25T14:21:09.295 writing 1000000 rows to :examplecsv/trades2019_01.csv for date 2019.01.06
...
2019.02.25T14:23:30.795 writing 1000000 rows to :examplecsv/trades2019_03.csv for date 2019.03.28
2019.02.25T14:23:32.611 writing 1000000 rows to :examplecsv/trades2019_03.csv for date 2019.03.29
2019.02.25T14:23:34.404 writing 1000000 rows to :examplecsv/trades2019_03.csv for date 2019.03.30
2019.02.25T14:23:36.113 writing 1000000 rows to :examplecsv/trades2019_03.csv for date 2019.03.31
```

Run `loader.q` to load the data. You might want to modify the config at the top of the loader to change the HDB destination, compression options, and the size of the data chunks read at once.

```bash
> q loader.q 
KDB+ 4.0 2020.10.02 Copyright (C) 1993-2020 Kx Systems
```

```q
2019.02.25T14:24:54.201 **** LOADING :examplecsv/trades2019_01.csv ****
2019.02.25T14:24:55.116 Reading in data chunk
2019.02.25T14:24:55.899 Read 1896517 rows
2019.02.25T14:24:55.899 Enumerating
2019.02.25T14:24:56.011 Writing 1000000 rows to :hdb/2019.01.01/trade/
2019.02.25T14:24:56.109 Writing 896517 rows to :hdb/2019.01.02/trade/
2019.02.25T14:24:56.924 Reading in data chunk
2019.02.25T14:24:57.671 Read 1896523 rows
2019.02.25T14:24:57.671 Enumerating
2019.02.25T14:24:57.759 Writing 103482 rows to :hdb/2019.01.02/trade/
2019.02.25T14:24:57.855 Writing 1000000 rows to :hdb/2019.01.03/trade/
2019.02.25T14:24:57.953 Writing 793041 rows to :hdb/2019.01.04/trade/
2019.02.25T14:24:58.741 Reading in data chunk
2019.02.25T14:24:59.495 Read 1896543 rows
2019.02.25T14:24:59.495 Enumerating
2019.02.25T14:24:59.581 Writing 206958 rows to :hdb/2019.01.04/trade/
2019.02.25T14:24:59.679 Writing 1000000 rows to :hdb/2019.01.05/trade/
2019.02.25T14:24:59.770 Writing 689585 rows to :hdb/2019.01.06/trade/
...
2019.02.25T14:27:50.205 Sorting and setting `p# attribute in partition :hdb/2019.01.01/trade/
2019.02.25T14:27:50.328 Sorting table
2019.02.25T14:27:52.067 `p# attribute set successfully
2019.02.25T14:27:52.067 Sorting and setting `p# attribute in partition :hdb/2019.01.02/trade/
2019.02.25T14:27:52.322 Sorting table
2019.02.25T14:27:55.787 `p# attribute set successfully
2019.02.25T14:27:55.787 Sorting and setting `p# attribute in partition :hdb/2019.01.03/trade/
...
2019.02.25T16:10:26.912 **** Building daily stats table ****
2019.02.25T16:10:26.913 Building dailystats for date 2019.01.01 and path :hdb/2019.01.01/trade/
2019.02.25T16:10:27.141 Building dailystats for date 2019.01.02 and path :hdb/2019.01.02/trade/
2019.02.25T16:10:27.553 Building dailystats for date 2019.01.03 and path :hdb/2019.01.03/trade/
2019.02.25T16:10:27.790 Building dailystats for date 2019.01.04 and path :hdb/2019.01.04/trade/
...
```


## Handling duplicates

The example data loader appends data to existing tables. This may cause potential issues with duplicates – partitioned/splayed tables cannot have keys, and any file loaded more than once will cause the data to be inserted multiple times. There are a few approaches to preventing duplicates:

-   Maintain a table of files which have already been loaded, and do a pre-load check to see if the file has already been loaded. If not already loaded, load it and update the table. The duplicate detection can be done on the file name and/or by generating a MD5 hash for the supplied file. This gives a basic level of protection
-   For each table, define a key and check for duplicates based on that key. This will probably greatly increase the loading time, and may be prone to error. (It is perfectly valid for some datasets to have duplicate rows.)
-   Depending on how the data is presented, it may be possible to do basic duplicate detection by counting the rows already in the database based on certain key fields and comparing with those present in the file. 

An example approach to removing duplicates can be seen in the `builddailystats` function in `loader.q`.


## Parallel loading

The key consideration when doing parallel loading is to ensure separate processes do not touch the same table structures at the same time. The enumeration operation [`.Q.en`](../ref/dotq.md#qen-enumerate-varchar-cols) enforces a locking mechanism to ensure that two processes do not write to the sym file at the same time. Apart from that, it is up to the programmer to manage. 

In this example we can load different files in parallel as we know that the files do not overlap in terms of the partitioned tables that they will write to, provided that we set the `builddaily` flag in the `loadallfiles` function to false. This will ensure parallel loaders do not write to the daily table concurrently. (The daily table would then have to be built in a separate step). Loaders which may write data to the same tables (in the same partitions) at the same time cannot be run safely in parallel.


## Aborting the load

Aborting the load (e.g. Ctrl-c, `kill -9`, and errors such as `wsfull`) is generally bad. The loader may have written some but not all of the data to the database. 

Usually the side effects can be corrected with some manual work, such as re-saving the table without the partially loaded data and running the loader again. 

However, if the data loader is aborted while it is writing to the database (as opposed to reading from the file) then the effects may be trickier to correct as the affected table may have some columns written to and some not, leaving the table as an invalid structure. In this instance it may be possible to recover the data by manually truncating the column files individually.


## In-memory enumeration

With some loader scripts the enumeration step can become a bottleneck. One solution is to enumerate in-memory only, write the data to disk, then update the sym file on disk when done. 

This function will enumerate in-memory rather than on-disk and can be used instead of `.Q.en`:

```q
enm:{@[x;f where 11h=type each x f:key flip 0!x;`sym?]}  
```

This may improve performance, but means loading is no longer parallelizable; and if the loader fails before it completes then all the newly loaded data must be deleted, as the enumerations will have been lost.


## Utilities

Utility script 
:fontawesome-brands-github: 
[KxSystems/kdb/utils/csvguess.q](https://github.com/KxSystems/kdb/blob/master/utils/csvguess.q) 
generates CSV loader scripts automatically. This is especially useful for very wide or long CSV files where it is time-consuming to specify the correct types for each column. This also includes an optimized on-disk sorter, and the ability to create a loader to load and enumerate quickly all the symbol columns, requiring parallel loading processes only to read the sym file.


## Splaying large files

### Enumerating by hand

Recall how to convert a large CSV file into an on-disk database without holding all the data in memory at once:

```q
q)colnames: `date`open`high`low`close`volume`sym
q).Q.fs[{ .[`:newfile; (); ,; flip colnames!("DFFFFIS";",")0:x]}]`:file.csv
387
q)value `:newfile
date       open  high  low   close volume   sym
------------------------------------------------
2019.10.03 24.5  24.51 23.79 24.13 19087300 AMD
2019.10.03 27.37 27.48 27.21 27.37 39386200 MSFT
2019.10.04 24.1  25.1  23.95 25.03 17869600 AMD
2019.10.04 27.39 27.96 27.37 27.94 82191200 MSFT
2019.10.05 24.8  25.24 24.6  25.11 17304500 AMD
2019.10.05 27.92 28.11 27.78 27.92 81967200 MSFT
2019.10.06 24.66 24.8  23.96 24.01 17299800 AMD
2019.10.06 27.76 28    27.65 27.87 36452200 MSFT
...
```

To save splayed, we have to enumerate symbol columns; here, the `sym` column. 

```q
q)sym: `symbol$()
q)colnames: `date`open`high`low`close`volume`sym
q)fn: {.[`:dir/trade/; (); ,; update sym:`sym?sym from flip colnames!("DFFFFIS";",")0:x]}
q).Q.fs[fn;]`:file.csv
387
```

But we also have to save the sym list for when the splayed database is opened.

```q
q)`:dir/sym set sym
`:dir/sym
```

Check this works.

```bash
> q dir
KDB+ 4.0 2020.10.02 Copyright (C) 1993-2020 Kx Systems
m64/ 12()core 65536MB sjt mackenzie.local 127.0.0.1 EXPIRE ..
```
```q
q)\v
`s#`sym`trade
q)sym
`AMD`MSFT
q)select distinct sym from trade
sym
----
AMD
MSFT
```


### Enumerating using `.Q.en`

Recall also how to save a table to disk splayed:

```q
q)`:dir/tr/ set .Q.en[`:dir] tr
`:dir/tr/
```

Instead of doing the steps by hand, we can have `.Q.en` do them.

```q
q)colnames: `date`open`high`low`close`volume`sym
q)fn: {.[`:dir/trade/;(); ,; .Q.en[`:dir]flip colnames!("DFFFFIS";",")0:x]}
q).Q.fs[fn;]`:file.csv
387
```

And we can verify this works.

```bash
> q dir
KDB+ 4.0 2020.10.02 Copyright (C) 1993-2020 Kx Systems
m64/ 12()core 65536MB sjt mackenzie.local 127.0.0.1 EXPIRE ...
```
```q
q)\v
`s#`sym`trade
q)sym
`AMD`MSFT
q)select distinct sym from trade
sym
----
AMD
MSFT
```


## Encrypted data files 

To load encrypted data files (which for security can’t be stored decrypted on disk) into kdb+ and save tables in encrypted format.

1.  Extract encrypted CSV data to named pipe
1.  Read named pipe into kdb+
1.  Save to disk encrypted

```bash
# make pipe
mkfifo named_pipe 
# decrypt to named pipe
openssl enc -aes-256-cbc -d –k password -in trades.csv.dat > named_pipe & 
```
```q
/ read in the data to q
.Q.fps[{`trade insert (“STCCFF”;”,”) 0: x}]`:named_pipe

/ save to disk encrypted AES256CBC
(`:2020.03.05/trade/;17;6;6) set .Q.en[`:.;trade] 
```

:fontawesome-solid-book:
[`set`](../ref/get.md#set), 
[`.Q.fps`](../ref/dotq.md#qfps-streaming-algorithm)
<br>
:fontawesome-solid-laptop:
[Named pipes](../kb/named-pipes.md)


## Bulk Copy Program

Microsoft’s [Bulk Copy Progam](https://docs.microsoft.com/en-us/sql/tools/bcp-utility?view=sql-server-2017) (bcp) is supported using the text format. 

Export:

```q
`t.bcp 0:"\t"0:value flip t  / remove column headings
```

Import:

```q
flip cols!("types";"\t")0:`t.bcp /add headings
```


### Inserting data into SQL Server

Create the table in SQL Server if it does not already exist.  

:fontawesome-brands-github: 
[KxSystems/kdb/c/odbc.k](https://github.com/KxSystems/kdb/blob/master/c/odbc.k)

Once the table exists in SQL Server:

```q
`t.bcp 0:"\t"0:value flip t
\bcp t in t.bcp -c -T
```


----
:fontawesome-regular-map:
[Mass ingestion through data loaders](../wp/data-loaders/index.md)