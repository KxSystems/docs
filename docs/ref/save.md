---
title: save, rsave keywords save tables to file | Reference | kdb+ and q documentation
description: save and rsave are q keywords that save global data to file or splayed to a directory.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---

# `save`, `rsave`

_Write global data to file or splayed to a directory_

## `save`

_Write a global variable to file and optionally format data_

```syntax
save x     save[x]
```

Where `x` is a symbol atom or vector of the form `[path/to/]v[.ext]` in which

- `v` is the name of a global variable
- `path/to/` is an optional directory path. `save` overwrites an existing file, or creates the file and any missing parent directories.
- `.ext` is a file extension (optional), which determines the file content format. Options are:
    - no extension for binary format
    - `csv` for comma-separated values
    - `txt` for plain text
    - `xls` for Excel spreadsheet format
    - `xml` for Extensible Markup Language (XML)
    - `json` for JavaScript Object Notation (JSON) Since v3.2 2014.07.31.

writes each global variable `v` to file and returns the filenames.

!!! tip "Loading these formats"

    [`load`](load.md) has no corresponding formats. Use [File Text](file-text.md) instead.

For other data serialization tools, see [`.h`](doth.md).

### Examples

```q
q)t:([]x:2 3 5; y:`ibm`amd`intel; z:"npn")

q)save `t            / binary
`:t
q)read0 `:t
"\377\001b\000c\013\000\003\000\000\000x\000y\000z\000\000\000\003\000\000\00..
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
"<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:ss=\"..

q)save `t.xml        / XML
`:t.xml
q)read0 `:t.xml
"<R>"
"<r><x>2</x><y>ibm</y><z>n</z></r>"
"<r><x>3</x><y>amd</y><z>p</z></r>"
"<r><x>5</x><y>intel</y><z>n</z></r>"
"</R>"

q)save `t.json       / JSON, one object per row
`:t.json
q)read0 `:t.json
"{\"x\":2,\"y\":\"ibm\",\"z\":\"n\"}"
"{\"x\":3,\"y\":\"amd\",\"z\":\"p\"}"
"{\"x\":5,\"y\":\"intel\",\"z\":\"n\"}"

q)save `$"/tmp/t"    / file path
`:/tmp/t

q)a:til 6
q)b:.Q.a
q)save `a`b          / multiple files
`:a`:b
```

Use [`set`](get.md#set) instead to save:

- a variable to a file of a different name
- local data

## `rsave`

_Write a table splayed to a directory_

```syntax
rsave x     rsave[x]
```

Where `x` is a table name as a symbol atom, saves the table, in binary format, splayed to a directory of the same name.
The table must be fully enumerated and not keyed; otherwise, `rsave` signals a `'type` error.

`rsave` creates the directory and any missing parent directories if they do not exist. In an existing directory, it overwrites the files of the same name, but does not remove other files.

### Enumeration requirement

!!! tip "Use set for more control"

    [`set`](get.md#set) is the more general way to save a splayed table, and lets you specify the target directory.

```q
q)sp:([]s:`s1`s2`s1;p:`p1`p1`p2;qty:300 200 400)
q)rsave `sp           / symbol columns are not enumerated
'type
  [0]  rsave `sp           / symbol columns are not enumerated
       ^
q)sp:.Q.en[`:.;sp]    / enumerate against the sym file in the current directory
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

[`set`](get.md#set),
[`.h.tx`](doth.md#htx-filetypes),
[`.Q.dpft`](dotq.md#dpft-save-table) (save table),
[`.Q.Xf`](dotq.md#xf-create-file) (create file)
<br>

[File system](../basics/files.md)
<br>

_Q for Mortals_
[§11.2 Save and Load on Tables](/q4m3/11_IO/#112-save-and-load-on-tables),
[§11.3 Splayed Tables](/q4m3/11_IO/#113-splayed-tables)
