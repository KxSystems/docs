---
title: Handling CSVs in kdb+ | A tour of the q programming language | Documentation for kdb+ and the q programming language
author: Stephen Taylor
date: February 2020
description: How to load CSVs as tables and save tables as CSVs.
---
# Comma-separated value files


CSVs are a common format for capturing and transferring data. 
Fields are usually separated by commas; sometimes by other characters, such as Tab. 

:fontawesome-brands-wikipedia-w:
[Comma-separated values](https://en.wikipedia.org/wiki/Comma-separated_values "Wikipedia")


## Load

:fontawesome-solid-download:
[`example.csv`](https://code.kx.com/download/data/example.csv "Download")

Download `example.csv` from the link above to (e.g.) `path/to/example.csv` on your local filesystem. Confirm with `read0`, which returns the contents of a text file as a list of strings.

```q
q)read0 `:path/to/example.csv
"id,price,qty"
"kikb,36.05,90"
"hlfe,96.57,84"
"mcej,91.34,63"
"iemn,57.12,93"
"femn,63.64,54"
"engn,94.56,38"
"edhp,63.31,97"
"ggna,72.39,88"
"mjlg,12.04,58"
"fpjb,34.3,68"
"gfpl,25.34,45"
"jogj,78.67,2"
"gpna,23.08,39"
"njoh,91.46,64"
"aoap,48.38,49"
"bhan,63.2,82"
"enmc,70,40"
"niom,58.92,88"
"nblh,42.9,77"
"jdok,9.42,30"
"plbp,42.38,17"
..
```

The [Load CSV](../../ref/file-text.md#load-csv) operator requires only a list of column types and a delimiter to return the CSV as a table. 

```q
q)show t:("SFI";enlist",") 0: `:path/to/example.csv
id   price qty
--------------
kikb 36.05 90
hlfe 96.57 84
mcej 91.34 63
iemn 57.12 93
femn 63.64 54
engn 94.56 38
edhp 63.31 97
ggna 72.39 88
mjlg 12.04 58
fpjb 34.3  68
gfpl 25.34 45
jogj 78.67 2
gpna 23.08 39
njoh 91.46 64
aoap 48.38 49
bhan 63.2  82
enmc 70    40
niom 58.92 88
nblh 42.9  77
jdok 9.42  30
..
```

The `id` column has been rendered as symbols, `price` as floats, and `qty` as ints. 

:fontawesome-regular-hand-point-right:
[Datatypes](datatypes.md)

Enlisting the delimiter (`enlist","`) had Load CSV interpret the first file line as column names.


## Save

The simplest way to save table `t` as a CSV:

```q
q)save `:path/to/t.csv
`:path/to/t.csv
```

Load CSV is one form of the [File Text](../../ref/file-text.md) operator. 
Two other forms allow us finer control than [`save`](../../ref/save.md).

```q
q)`:path/to/t.tsv 0: "\t" 0: t
`:path/to/t.tsv
```

Above, `"\t" 0: t` uses the [Prepare Text](../../ref/file-text.md#prepare-text) form of the operator to return the table as a list of delimited strings. Here the delimiter is the Tab character `"\t"`. The list of strings becomes the right argument to the [Save Text](../../ref/file-text.md#save-text) form, which writes the strings as the lines of `path/to/t.tsv`.

:fontawesome-solid-book:
[Load Fixed](../../ref/file-text.md#load-fixed) for importing tables from fixed-format text files
<br>
:fontawesome-solid-book:
[Key-Value Pairs](../../ref/file-text.md#key-value-pairs) for interpreting key-value pairs as a dictionary
<br>
:fontawesome-solid-book:
[`.j` namespace](../../ref/dotj.md) for serializing as, and deserializing from, JSON
