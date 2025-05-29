---
title: save, rsave keywords save tables to file | Reference | kdb+ and q documentation
description: save and rsave are q keywords that save global data to file or splayed to a directory.
author: Stephen Taylor
---
# :fontawesome-solid-database: `save`, `rsave`

_Write global data to file or splayed to a directory_



## `save`

_Write a global variable to file and optionally format data_

```syntax
save x     save[x]
```

Where `x` is a symbol atom or vector of the form `[path/to/]v[.ext]` in which 

-   `v` is the name of a global variable
-   `path/to/` is a file path (optional). If a file
    - exists, it is overwritten
    - does not exist, it is created, with any required parent directories
-   `.ext` is a file extension (optional) which effects the file content format. Options are:
    - `(none)` for binary format
    - `csv` for comma-separated values
    - `txt` for plain text)
    - `xls` for Excel spreadsheet format
    - `xml` for Extensible Markup Language (XML))
    - `json` for JavaScript Object Notation (JSON) Since v3.2 2014.07.31.


writes global variable/s `v` etc. to file and returns the filename/s.

!!! tip "There are no corresponding formats for [`load`](load.md). Instead, use [File Text](file-text.md)."

:fontawesome-regular-hand-point-right:
[.h](doth.md) (data serialization tools)

### Examples

```q
q)t:([]x:2 3 5; y:`ibm`amd`intel; z:"npn")

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
q)save `t.xml        / XML
`:t.xml

q)read0 `:t.xml      / tab separated
"<R>"
"<r><x>2</x><y>ibm</y><z>n</z></r>"
"<r><x>3</x><y>amd</y><z>p</z></r>"
"<r><x>5</x><y>intel</y><z>n</z></r>"
"</R>"

q)save `$"/tmp/t"    / file path
`:/tmp/t

q)a:til 6
q)b:.Q.a
q)save `a`b          / multiple files
`:a`:b
```

Use [`set`](get.md) instead to save

-   a variable to a file of a different name
-   local data

<!-- 
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
 -->
 

## `rsave`

_Write a table splayed to a directory_

```syntax
rsave x     rsave[x]
```

Where `x` is a table name as a symbol atom, saves the table, in binary format, splayed to a directory of the same name.
The table must be fully enumerated and not keyed.

If the file 

-   exists, it is overwritten
-   does not exist, it is created, with any required parent directories


### Limits

!!! tip "The usual and more general way of doing this is to use [`set`](get.md#set), which allows the target directory to be specified."

The following example uses the table `sp` created using the script [`sp.q`](https://raw.githubusercontent.com/KxSystems/kdb/master/sp.q)
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


----
:fontawesome-solid-book: 
[`set`](get.md#set), 
[`.h.tx`](doth.md#htx-filetypes),
[`.Q.dpft`](dotq.md#chk-fill-hdb) (save table), 
[`.Q.Xf`](dotq.md#xf-create-file) (create file)
<br>
:fontawesome-solid-book-open:
[File system](../basics/files.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§11.2 Save and Load on Tables](/q4m3/11_IO/#112-save-and-load-on-tables)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§11.3 Splayed Tables](/q4m3/11_IO/#113-splayed-tables)


