---
title: Splaying large files
description: Elsewhere we give a recipe for turning larger-than-RAM CSV files into tables, and for saving tables to disk splayed. This recipe shows how to combine both.
keywords: file, large, kdb+, q, splay
---
# Splaying large files



[Elsewhere](loading-from-large-files.md "loading from large files") we give a recipe for turning larger-than-RAM CSV files into tables, and for saving tables to disk splayed. This recipe shows how to combine both.


## Enumerating by hand

Recall the recipe to convert a large CSV file into an on-disk database without holding the data in memory all at once:

```q
q)colnames: `date`open`high`low`close`volume`sym
q).Q.fs[{ .[`:newfile; (); ,; flip colnames!("DFFFFIS";",")0:x]}]`:file.csv
387j
q)value `:newfile
date       open  high  low   close volume   sym
------------------------------------------------
2006.10.03 24.5  24.51 23.79 24.13 19087300 AMD
2006.10.03 27.37 27.48 27.21 27.37 39386200 MSFT
2006.10.04 24.1  25.1  23.95 25.03 17869600 AMD
2006.10.04 27.39 27.96 27.37 27.94 82191200 MSFT
2006.10.05 24.8  25.24 24.6  25.11 17304500 AMD
2006.10.05 27.92 28.11 27.78 27.92 81967200 MSFT
2006.10.06 24.66 24.8  23.96 24.01 17299800 AMD
2006.10.06 27.76 28    27.65 27.87 36452200 MSFT
...
```

In order to save splayed, we have to enumerate varchar columns. In our case, it is the `sym` column. This can be done as follows:

```q
q)sym: `symbol$()
q)colnames: `date`open`high`low`close`volume`sym
q).Q.fs[{ .[`:dir/trade/; (); ,; update sym:`sym?sym from flip colnames!("DFFFFIS";",")0:x]}]`:file.csv
387j
```

But we also have to save the symbols so that they can be found when the splayed database is opened:

```q
q)`:dir/sym set sym
`:dir/sym
```

Let’s check that this works:

```dos
./q.exe dir
KDB+ 2.4t 2006.07.27 Copyright (C) 1993-2006 Kx Systems
w32/ 1cpu 384MB ...
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


## Enumerating using `.Q.en`

Recall also how to save a table to disk splayed:

```q
q)`:dir/tr/ set .Q.en[`:dir] tr
`:dir/tr/
```

Instead of doing the separate steps by hand, we can have `.Q.en` do them for us:

```q
q)colnames: `date`open`high`low`close`volume`sym
q).Q.fs[{ .[`:dir/trade/; (); ,; .Q.en[`:dir] flip colnames!("DFFFFIS";",")0:x]}]`:file.csv
387j
```

And we can verify that this works too:

```dos
./q.exe dir
KDB+ 2.4t 2006.07.27 Copyright (C) 1993-2006 Kx Systems
w32/ 1cpu 384MB ...
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
