---
title: Splayed tables | Knowledge Base | kdb+ and q documentation
description: Splaying a table stores each column as a separate file, rather than using a single file for the whole table
author: Stephen Taylor
date: October 2020
---
# Splayed tables



Medium-sized tables (up to 100 million rows) are best stored on disk [splayed](https://en.wiktionary.org/wiki/splay "Wiktionary"): each column is stored as a separate file, rather than using a single file for the whole table.

```txt
quotes
├── .d
├── price
├── sym
└── time
```

Hidden file `.d` lists the columns in the order they appear in the table.

Tables that have many columns are good candidates for splaying, as most queries access only a small subset of those columns.

To save a table splayed, use [`set`](../ref/get.md#set) to save it not to a file

```q
q)`:filename set table
`:filename
```

but to a directory

```q
q)`:dirname/ set table
`:dirname/
```

The table must be

-   fully enumerated; i.e. no repeated symbols
-   simple, not keyed

Example:

```q
q)m1:1000000 / 1 million
q)show q:value[countries]`code / country dialling codes
86 91 81 55
q)edpn:{10000000+x?80000000} / eight-digit phone numbers

q) a million calls with times, origin and destination codes and numbers
q)3#calls:([]tim:m1?23:59; occ:m1?q; ono:edpn m1; dcc:m1?q; dno:edpn m1)
tim   occ ono      dcc dno
-------------------------------
09:30 91  56809216 55  10241715
18:16 81  31860713 81  19766096
19:46 55  22477903 55  19899746

q)`:calls/ set calls
`:calls/
```
```bash
❯ tree calls
calls
├── dcc
├── dno
├── occ
├── ono
└── tim

0 directories, 5 files
❯ ls -a calls
.   ..  .d  dcc dno occ ono tim
```


## Nested columns

Nested columns contain items that are not atoms. A nested column can be splayed if and only if it is a compound list: its items are all vectors, i.e. simple lists of the same type:

```q
("quick";"brown";"fox")
3 4#til 12
```

A compound column in a splayed table is represented in the filesystem by two files. One bears the name of the column; the other is the same name suffixed with a `#`.

A common question in designing a table schema is whether to represent text as strings (compound) or symbols (vector). Where many values are repeated, as in stock-exchange codes, symbols have important advantages:

-   atomic semantics in code
-   compact storage
-   fast execution

With fewer repeated values, these advantages dwindle, but the penalty of a bloated sym list remains. Fields such as comments or notes should always be strings.


## Enumerating symbol columns

If a table contains columns of type symbol with repeated items (i.e. the table is not fully enumerated), trying to save it splayed will result in a type error.

```q
q)tr
date       open  high  low   close volume    sym
-------------------------------------------------
2020.10.03 24.5  24.51 23.79 24.13 19087300  AMD
2020.10.03 27.37 27.48 27.21 27.37 39386200  MSFT
2020.10.04 24.1  25.1  23.95 25.03 17869600  AMD
2020.10.04 27.39 27.96 27.37 27.94 82191200  MSFT
..
q)`:tr/ set tr
'type
```

!!! important "Tables splayed across a directory must be fully enumerated and not keyed."

The solution is to enumerate symbol columns before saving the table splayed. This is done with the function [`.Q.en`](../ref/dotq.md#qen-enumerate-varchar-cols).

```q
q).Q.en[`:dir] tr
date       open  high  low   close volume    sym
-------------------------------------------------
2020.10.03 24.5  24.51 23.79 24.13 19087300  AMD
2020.10.03 27.37 27.48 27.21 27.37 39386200  MSFT
2020.10.04 24.1  25.1  23.95 25.03 17869600  AMD
2020.10.04 27.39 27.96 27.37 27.94 82191200  MSFT
..
```

This assigns to the variable `sym` the list of unique symbols in the table:

```q
q)sym
`AMD`MSFT
```

It also creates the directory `dir` with a file in it, named `sym`, with the same contents:

```q
q)\ls dir
"sym"
q)value `:dir/sym
`AMD`MSFT
```

Finally, it returns a table where columns of symbols are enumerated.

```q
q)trenum: .Q.en[`:dir] tr
q)trenum.sym
`sym$`AMD`MSFT`AMD`MSFT`AMD`MSFT`AMD`MSFT`AMD`MSFT`AMD`MSFT`AMD`MSFT`AMD`MSFT
```

The value of this column differs from that of the original table `tr`:

```q
q)tr.sym
`AMD`MSFT`AMD`MSFT`AMD`MSFT`AMD`MSFT`AMD`MSFT`AMD`MSFT`AMD`MSFT`AMD`MSFT
```

The enumerated table can now be saved splayed.

```q
q)`:dir/tr/ set trenum
`:dir/tr/
```

The columns are saved separately, one per file:

```q
q)\ls -a dir/tr
,"."
".."
".d"
"close"
"date"
"high"
"low"
"open"
"sym"
"volume"
```

This can also be done in a single step, without saving the enumerated table into a variable:

```q
q)`:dir/tr/ set .Q.en[`:dir] tr
`:dir/tr/
```

Notice that the sym list is stored separately from the table. If the symbols are common to several tables it may be convenient to write the sym list in their common parent directory.

```q
/db
  sym
  /quotes
  /tr
```

Since table `tr` has a column `sym`, represented by file `db/tr/sym`, one place you _cannot_ write the sym list is in `db/tr`.

:fontawesome-regular-map:
[Working with sym files](../wp/symfiles.md)


???+ detail "Enumerating nested symbol columns"

    Since V3.0 2011.11.25 a splayed table column can hold nested sym vectors.

    Prior to V3.4, `.Q.en` did not enumerate nested sym lists. It had to be done manually, e.g.<pre><code class="language-q">\`:/db/2013.01.10/tt/ set .Q.en[\`:/db] update c3:{\`:sym?raze x;\`sym$'x}c3 from t</code></pre>


## Loading splayed tables

There are various ways to load or read a splayed table.

Start q with the directory:

```bash
❯ q calls
KDB+ 4.0 2020.10.02 Copyright (C) 1993-2020 Kx Systems
m64/ 12()core 65536MB sjt mackenzie.local 127.0.0.1 EXPIRE..
```
```q
q).z.f
`calls
q)calls
tim   occ ono      dcc dno
-------------------------------
17:26 55  13464625 55  47918725
10:26 86  15538442 91  72388386
23:23 81  50209480 91  88260320
..
```

Load the directory:

```q
q)\l calls
`calls
q)system"l calls"
`calls

q)load`calls
`calls
```

‘Loading’ the table in fact maps it to memory. None of it is written into memory by the load itself.

Get the table:

```q
q)get`:calls
tim   occ ono      dcc dno
-------------------------------
17:26 55  13464625 55  47918725
10:26 86  15538442 91  72388386
23:23 81  50209480 91  88260320
..
```

Symbol columns in a splayed table are stored as enumerations of a list `sym`, stored separately from the table.

!!! warning "Retrieving the table without the sym list leaves its symbol columns as bare enumerations."

```q
q)get `:db/tr
date       time  vol   sym price
-----------------------------------
2020.07.03 11:23 12378 0   23.57101
2020.07.02 11:36 63682 1   24.06836
..
q)load `:db/sym
`sym
q)get `:db/tr
date       time  vol   sym  price
------------------------------------
2020.07.03 11:23 12378 APPL 23.57101
2020.07.02 11:36 63682 MSFT 24.06836
..
```

When q loads a directory it loads everything in it that represents a kdb+ object. So it is convenient to store a shared sym list in the root directory of a database.

```txt
/db
  sym
  /quotes
  /tr
```
```bash
> q db
```
```q
KDB+ 4.0 2020.10.02 Copyright (C) 1993-2020 Kx Systems
m64/ 12()core 65536MB sjt mackenzie.local 127.0.0.1 EXPIRE ..

q)sym
`APPL`MSFT`AMD`IBM
q)tr
date       time  vol   inst price
------------------------------------
2020.07.03 11:23 12378 APPL 23.57101
2020.07.02 11:36 63682 MSFT 24.06836
..
```


## Changing the schema of splayed tables

Some keywords do not work with splayed tables, in particular those that change the schema. Here is how to write queries that change the schema.

Consider the following table:

```q
q)tr
date       open  high  low   close volume   sym
------------------------------------------------
2020.10.03 24.5  24.51 23.79 24.13 19087300 AMD
2020.10.03 27.37 27.48 27.21 27.37 39386200 MSFT
..
```

Removing a column is a simple matter:

```q
q)delete volume from tr
date       open  high  low   close sym
---------------------------------------
2020.10.03 24.5  24.51 23.79 24.13 AMD
2020.10.03 27.37 27.48 27.21 27.37 MSFT
..
```

But that does not work with a splayed table:

```q
q)trade
date       open  high  low   close volume   sym
------------------------------------------------
2020.10.03 24.5  24.51 23.79 24.13 19087300 AMD
2020.10.03 27.37 27.48 27.21 27.37 39386200 MSFT
..
q)delete volume from `trade
'splay
q)trade: delete volume from trade
'splay
```

The `.d` file contains the schema of a splayed database:

```q
q)value `:trade/.d
`date`open`high`low`close`volume`sym
```

To remove a column from the schema, we can simply remove the column name from this file:

```q
q).[`:trade/.d;();:;`date`open`high`low`close`sym]
`:trade/.d
```

For the changes to take effect we need to reload the splayed table.

```bash
> q dir
```
```q
KDB+ 4.0 2020.10.02 Copyright (C) 1993-2020 Kx Systems
m64/ 12()core 65536MB sjt mackenzie.local 127.0.0.1 EXPIRE..
q)\v
`s#`sym`trade
q)trade
date       open  high  low   close sym
---------------------------------------
2020.10.03 24.5  24.51 23.79 24.13 AMD
..
```

Notice that the file with the `volume` column has not been deleted. It is just not being used.

```q
q)\ls trade
"close"
"date"
"high"
"low"
"open"
"sym"
"volume"
```

Adding a new column is similar: save the column contents as a file in the directory of the splayed table and update the file `.d`.

```q
q)@[`:trade;`newcol;:;til 8]
`:trade
q).[`:trade/.d;();,;`newcol]
`:trade/.d
```

Verify the changes by loading the splayed table into a q session.

```bash
> q dir
```
```q
KDB+ 4.0 2020.10.02 Copyright (C) 1993-2020 Kx Systems
m64/ 12()core 65536MB sjt mackenzie.local 127.0.0.1 EXPIRE ..

q)trade
date       open  high  low   close sym  newcol
----------------------------------------------
2020.10.03 24.5  24.51 23.79 24.13 AMD  0
2020.10.03 27.37 27.48 27.21 27.37 MSFT 1
2020.10.04 24.1  25.1  23.95 25.03 AMD  2
..
```

---
:fontawesome-solid-database:
[Splaying large files](loading-from-large-files.md#splaying-large files)
<br>
:fontawesome-solid-database:
[Partitioned tables](partition.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_ 
[§11.3 Splayed Tables](/q4m3/11_IO/#113-splayed tables)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_ 
[§14.2 Splayed Tables](/q4m3/14_Introduction_to_Kdb+/#142-splayed tables)

