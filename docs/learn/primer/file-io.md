---
title: File input and output in kdb+ | Kdb+ database and language primer | Documentation for kdb+ and q
author: Dennis Shasha (shasha@cs.nyu.edu)
description: File input and output in q and kdb+
hero: <i class="fas fa-graduation-cap"></i> Kdb+ database and language primer
---
# Appendix 3: File input and output






Files are identified by symbols beginning with a colon:

```q
`:path/to/name
```

The path need not be specified if the file is in the current directory.

Files are text, binary, or kdb+ data.


## Text files

Write strings directly to a file.

```q
q)`:foofile.txt 0: ("i love";"rock and roll")
`foofil.txt
```

Append to the file: open it, then write to it.

```q
q)show ht: hopen `:foofile.txt`
5i
q)ht "But rock concerts are too loud. "
5i
```

Gosh! The file handle created by [`hopen`](../../ref/hopen.md) is nothing but the integer 5. 
(You may get a different value.)

```q
q)5 "Seriously loud."
5
```

Keyword [`read0`](../../ref/read0.md) returns the file as a list of strings. 

```q
q)read0 `:foofile.txt
"i love"
"rock and roll"
"But rock concerts are too loud. Seriously loud."
```

CSVs are a particularly important kind of text file, for which File Text has the [Load CSV](../../ref/file-text.md#load-csv) form.


<i class="fas fa-book"></i>
[File Text](../../ref/file-text.md),
[`hopen`](../../ref/hopen.md),
[`read0`](../../ref/read0.md)


## Binary files 

Binary files are for non-string data. 
Instead of File Text `0:`, we use [File Binary](../../ref/file-binary.md) `1:`.

Write bytes to file.

```q
q)`:foofilebin 1: 0x6768
`:foofilebin
```

Append much as for a text file.

```q
q)show hb:hopen `:foofilebin
6i
```

Yup, another integer.

```q
q)hb 0x6364
6i
```

And not `read0`, but… yes, [`read1`](../../ref/read1.md).

```q
q)read1 `:foofilebin
0x67686364
```


## Kdb+ files

Kdb+ files are for kdb+ data.

Q makes minimal distinction between files and global variables. Just that colon in the name.

```q
q)onevar:`a`b`c
q)`anothervar set `d`e`f
`anothervar
q)`:tmpfile set `g`h`i
`:tmpfile

q)onevar
`a`b`c
q)anothervar
`d`e`f

q)value `onevar
`a`b`c
q)value `anothervar
`d`e`f
q)value `:tmpfile
`g`h`i
```

!!! tip "The [`value`](../../ref/value.md) and [`get`](../../ref/get.md) keywords are synonyms."

As dictionaries and tables are first-class objects in q, this is an effective way of writing and reading entire tables to and from the file system.

One aspect of q’s power with tables is its ability to operate at depth in lists. 

The minimal distinction between files and global variables means we can write to kdb+ files with [Apply](../../ref/apply.md).
Here we use Apply with the Assign and Join operators.

```q
q).[`:tmpfoo;();:;`a`b`c] / set
`:tmpfoo
q).[`:tmpfoo;();,;`d`e`f] / append
`:tmpfoo
q)value `:tmpfoo
`a`b`c`d`e`f
```


## Parsing text files

We often want to parse data from external text files. Sometimes that data comes in fixed format. Suppose for example we have the file `fooin` with implicit schema: employee ID, name, salary, and age.

```txt
312 smith    3563.45 24
23  john     5821.19 32
9   curtiss  9821.19 51
```

(No blank line at the end, but the file must end with a newline.)

We have (including the trailing blanks) a 4-character integer, a 9-character name, an 8-character float and a 2-digit integer. 

We consult the [datatypes table](../../basics/datatypes.md) to identify the type of each field.

```q
q)("ISFI"; 4 9 8 2) 0: `:fooin
312     23      9
smith   john    curtiss
3563.45 5821.19 9821.19
24      32      51
```

Give it a key and we have a dictionary of vectors. 
Flip that and we have a table.

```q
q)`id`name`salary`age!("ISFI"; 4 9 8 2) 0: `:fooin
id    | 312     23      9
name  | smith   john    curtiss
salary| 3563.45 5821.19 9821.19
age   | 24      32      51

q)show myemp:flip`id`name`salary`age!("ISFI"; 4 9 8 2) 0: `:fooin
id  name    salary  age
-----------------------
312 smith   3563.45 24
23  john    5821.19 32
9   curtiss 9821.19 51

q)select name from myemp where salary > 5000
name
-------
john
curtiss
```

With [`save`](../../ref/save.md), [`set`, and `get`](../../ref/get.md) we can write entire tables and databases to disk.

```q
q)save `:path/to/myemp              / writes myemp to kdb+ file
`:path/to/myemp
q)save `:path/to/myemp.csv          / writes myemp as CSV file
`:path/to/myemp
q)`path/to/employees set `myemp     / writes kdb+ file
q)`emp set `:path/to/employees      / writes global table emp
```

<i class="fas fa-book-open"></i>
[Filesystem](../../basics/files.md)

---
<i class="far fa-hand-point-right"></i>
[Interprocess communication](ipc.md)