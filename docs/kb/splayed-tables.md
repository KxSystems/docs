---
title: Splayed tables
description: Medium-sized tables (up to 100 million rows) are best stored on disk splayed, that is, each column is stored as a separate file, rather than using a single file for the whole table. Tables that have many columns are good candidates for splaying, as most queries access only a small subset of those columns.
keywords: kdb+, q, splayed, table
---
# Splayed tables



Medium-sized tables (up to 100 million rows) are best stored on disk _splayed_, that is, each column is stored as a separate file, rather than using a single file for the whole table. Tables that have many columns are good candidates for splaying, as most queries access only a small subset of those columns.

<i class="far fa-hand-point-right"></i> 
_Q for Mortals_: [§11.3 Splayed Tables](/q4m3/11_IO/#113-splayed-tables), 
[§14 Introduction to Kdb+](/q4m3/14_Introduction_to_Kdb+/)


## How do I save a table to disk as a splayed table?

This saves in a single file

```q
q)`:filename set table
```

This saves the table splayed

```q
q)`:dirname/ set table
```

!!! note

    Tables splayed across a directory must be fully enumerated (no varchar) and not keyed.


## Enumerating varchar columns in a table

If you have a table that contains columns of type symbol with repeated items (i.e., the table is not fully enumerated), trying to save the table splayed will result in a type error.

```q
q)tr
date       open  high  low   close volume    sym
-------------------------------------------------
2006.10.03 24.5  24.51 23.79 24.13 19087300  AMD
2006.10.03 27.37 27.48 27.21 27.37 39386200  MSFT
2006.10.04 24.1  25.1  23.95 25.03 17869600  AMD
2006.10.04 27.39 27.96 27.37 27.94 82191200  MSFT
...
q)`:tr/ set tr
'type
```

The reason is that tables that are splayed across a directory must be fully enumerated and not keyed. The solution is to enumerate columns of type varchar before saving the table splayed. This is done with the function [`.Q.en`](../ref/dotq.md#qen-enumerate-varchar-cols).

```q
q).Q.en[`:dir] tr
date       open  high  low   close volume    sym
-------------------------------------------------
2006.10.03 24.5  24.51 23.79 24.13 19087300  AMD
2006.10.03 27.37 27.48 27.21 27.37 39386200  MSFT
2006.10.04 24.1  25.1  23.95 25.03 17869600  AMD
2006.10.04 27.39 27.96 27.37 27.94 82191200  MSFT
...
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

Finally, it returns a table where columns of varchars are enumerated. Let's check that this is the case:

```q
q)trenum: .Q.en[`:dir] tr
q)trenum.sym
`sym$`AMD`MSFT`AMD`MSFT`AMD`MSFT`AMD`MSFT`AMD`MSFT`AMD`MSFT`AMD`MSFT`AMD`MSFT
```

As you can see, the contents of this column differs from the one in the original table `tr`:

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


## Enumerating nested varchar columns in a table

With V3.0, since 2011.11.25, you can have nested sym vectors,which can be efficiently accessed randomly without loading the whole file.

Prior to V3.4, `.Q.en` did not enumerate nested sym lists; you have to do those manually, e.g.

```q
q)`:/db/2013.01.10/tt/ set .Q.en[`:/db] update c3:{`:sym?raze x;`sym$'x}c3 from t
```


## Loading splayed tables

To load a database containing a splayed table, pass the directory as a parameter to the q console:

```dos
C:\>./q.exe dir
KDB+ 2.4t 2006.07.27 Copyright (C) 1993-2006 Kx Systems
w32/ 1cpu 384MB ...
```
```q
q)sym
`AMD`MSFT
q)trade
date       open  high  low   close volume   sym
------------------------------------------------
2006.10.03 24.5  24.51 23.79 24.13 19087300 AMD
2006.10.03 27.37 27.48 27.21 27.37 39386200 MSFT
...
```

