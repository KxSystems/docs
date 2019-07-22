---
title: save, rsave
description: save and rsave are q keywords that save global data to file or splayed to a directory.
author: Stephen Taylor
keywords: directory, global, kdb+, q, rsave, save, splayed, table
---
# `save`, `rsave`

_Save global data to file or splayed to a directory_



## `save`

_Save global data to file_

Syntax: `save x`, `save[x]`

Where `x` is a filename as a symbol, saves the global table to file and returns the filename. 
The file shortname (ignoring path and extension) must match the name of a global table. 
The format used depends on the file extension:

extension | file format
:--------:|---------------------------------
(none)    | binary
csv       | comma-separated values
txt       | plain text
xls       | Excel spreadsheet
xml       | Extensible Markup Language (XML)

```q
q)t:([]x:2 3 5;y:`ibm`amd`intel;z:"npn")
q)save `t            / binary
`:t
q)read0 `:t
"\377\001b\000c\013\000\003\000\000\000x\000y\000z\000\000\..
"\000\003\000\000\000npn"
q)save `t.csv        / CSV
`:t.csv
q)read0 `:t.csv
"x,y,z"
"2,ibm,n"
"3,amd,p"
"5,intel,n"
q)save `t.txt        / text
`:t.txt
q)read0 `:t.txt      / columns are tab separated
"x\ty\tz"
"2\tibm\tn"
"3\tamd\tp"
"5\tintel\tn"
q)save `t.xls        / Excel
`:t.xls
q)read0 `:t.xls
"<?xml version=\"1.0\"?><?mso-application progid=\"Excel.Sheet\"?>"
"<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" x...
q)save `t.xml       / XML
`:t.xml
q)read0 `:t.xml    / tab separated
"<R>"
"<r><x>2</x><y>ibm</y><z>n</z></r>"
"<r><x>3</x><y>amd</y><z>p</z></r>"
"<r><x>5</x><y>intel</y><z>n</z></r>"
"</R>"
```

You can specify a path for the file:

```q
q)save `$"/tmp/t"
`:/tmp/t
```


### Saving local data

To save local data you can do explicitly what `save` is doing implicitly.

```q
q)`:t set t /save in binary format as a single file
q)/ save in binary format as a splayed table 
q)/ (1 file/column, symbols enumerated against the sym file in current dir)
q)`:t/ set .Q.en[`:.;t] 
q)`:t.csv 0:.h.tx[`csv;t] / save in csv format
q)`:t.txt 0:.h.tx[`txt;t] / save in txt format
q)`:t.xml 0:.h.tx[`xml;t] / save in xml format
q)`:t.xls 0:.h.tx[`xls;t] / save in xls format
```



## `rsave`

_Save a table splayed to a directory_

Syntax: `rsave x`, `rsave[x]`

Where `x` is a table name as a symbol, saves the table, splayed to a directory of the same name.
The table must be fully enumerated and not keyed.

The usual and more general way of doing this is to use [`set`](get.md#set), which allows the target directory to be given.

```q
q)\l sp.q
q)rsave `sp           / save splayed table
`:sp/
q)\ls sp
,"p"
"qty"
,"s"
q)`:sp/ set sp        / equivalent to rsave `sp
`:sp/
```


<i class="far fa-hand-point-right"></i> 
[`set`](get.md#set)  
.Q: [`.Q.dpft`](dotq.md#qchk-fill-hdb) (save table), 
[`.Q.Xf`](dotq.md#qxf-create-file) (create file)  
Basics: [File system](../basics/files.md)


