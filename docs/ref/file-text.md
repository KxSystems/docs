---
title: File Text
description: File Text is a q operator that reads or writes text files.
author: Stephen Taylor
keywords: file, kdb+, q, read, text, write
---
# `0:` File Text

_Read or write a text file_




The operator `0:` has six forms:

syntax                        | semantics
------------------------------|-------------------------
`delimiter 0: table`          | Prepare Text
`filehandle 0: strings`       | Save Text
`(types;delimiter) 0: y`      | Load CSV
`(types;delimiter;flag) 0: y` | Load CSV
`(types; widths) 0: y`        | Load Fixed
`x 0: string`                 | Key-value Pairs


## Prepare Text

Syntax: `delimiter 0: t`, `0:[delimiter;t]`

Where 

-   `delimiter` is a char atom 
-   `t` is a table

returns a list of character strings containing text representations of the rows of `t` separated by `delimiter`. 

```q
q)csv 0: ([]a:1 2 3;b:`x`y`z)
"a,b"
"1,x"
"2,y"
"3,z"

q)"|" 0: (`a`b`c;1 2 3;"xyz")
"a|1|x"
"b|2|y"
"c|3|z"
```

Any cells containing `delimiter` will be embraced with `"` and any embedded `"` doubled.

```q
q)t:([]x:("foo";"bar,baz";"qu\"ux";"fred\",barney"))
q)t
x
---------------
"foo"
"bar,baz"
"qu\"ux"
"fred\",barney"
q)-1@","0:t;
x
foo
"bar,baz"
qu"ux
"fred"",barney"
```

<!--
Test to see if file _handles_ actually work in the following, all the examples are file _symbols_.
-->


## Save Text

Syntax: `filehandle 0: strings`, `0:[filehandle;strings]`

Where 

-   `filehandle` is a file handle
-   `strings` a list of character strings

`strings` are saved as lines in the file. The result of [Prepare Text](#prepare-text) can be used as `strings`.

```q
q)`:test.txt 0: enlist "text to save"
`:test.txt
q)`:status.txt 0: string system "w"
`:status.txt
```


## Load CSV

Syntax: `(types;delimiter     ) 0: y`, `0:[(types;delimiter);y]`  
Syntax: `(types;delimiter;flag) 0: y`, `0:[(types;delimiter;flag);y]`

Where `y` is a _file descriptor_, a string, or a list of strings, returns a vector or matrix interpreted from the content of `y`, where

-   `types` is a list of [types](../basics/datatypes.md#primitive-datatypes) in upper case,
-   `delimiter` is a char atom or 1-item list,
-   `flag` (optional, default `0`, since V3.4) is a long atom indicating whether line-returns may be embedded in strings: `0` or `1`. 

If `delimiter` is enlisted, the first row of the content of `y` is read as column names and the result is a table; otherwise the result is a list of values for each column.

```q
/load 2 columns from space-delimited file with header 
q)t:("SS";enlist" ")0:`:/tmp/txt
```

Use optional arg `flag` to allow line returns embedded within strings.

```q
q)("I*";",";1)0:("0,\"ab\nc\"";"1,\"def\"")
0       1
"ab\nc" "def"
```

Where `y` is a string and `delimiter` an atom, returns a single list of the data split and parsed accordingly. 

```q
q)("DT";",")0:"20130315,185540686"
2013.03.15
18:55:40.686
```


## Load Fixed

Syntax: `(types; widths) 0: y`, `0:[(types;widths);y]`

Where `y` is a _file descriptor_ (see above) or a list of strings, returns a vector or matrix interpreted from the content of `y`, where 

-   `types` is a list of [types](../basics/datatypes.md#primitive-datatypes) in upper case
-   `widths` is an int vector of field widths

```q
q)sum("DT";8 9)0:enlist"20130315185540686"
,2013.03.15D18:55:40.686000000
q)("DT";8 9)0:("20130315185540686";"20130315185540686")
2013.03.15   2013.03.15
18:55:40.686 18:55:40.686
q)dates:("Tue, 04 Jun 2013 07:00:13 +0900";"Tue, 04 Jun 2013 07:00:13 -0500")
q)sum(" Z T";5 20 1 5)0:dates
2013.06.04T16:00:13.000 2013.06.04T02:00:13.000
```

Load Fixed expects either a `\n` after every record, or none at all.

```q
/reads a text file containing fixed-length records
q)t:("IFC D";4 8 10 6 4) 0: `:/q/Fixed.txt 
```


!!! tip "Tips for Load CSV and Load Fixed"

    -   To load a field as a nested character column or list rather than symbol use `"*"` as the identifier
    -   To omit a field from the load use `" "`.


## Key-value Pairs

Syntax: `x 0: string`, `0:[x;string]`

Where `x` is a 3- or 4-char string: 

```txt
key-type
field-separator
[asterisk]
record-separator
```

and `key-type` is `S` for symbol, `I` for integer, or `J` for long, returns a 2-row matrix of the keys and values. 

```q
q)"S=;"0:"one=1;two=2;three=3"
one  two  three
,"1" ,"2" ,"3"

q)"S:/"0:"one:1/two:2/three:3"
one  two  three
,"1" ,"2" ,"3"

q)"I=;"0:"1=first;2=second;3=third"
1       2        3
"first" "second" "third"

q)s:"8=FIX.4.2\0019=339\00135=D\00134=100322\00149=JM_TEST1\00152=20130425-06:46:46.387"
q)(!/)"I=\001"0:s
8 | "FIX.4.2"
9 | "339"
35| ,"D"
34| "100322"
49| "JM_TEST1"
52| "20130425-06:46:46.387"
```

The inclusion of an asterisk as the third character allows the delimiter character to appear harmlessly in quoted strings. (Since V3.5.)

```q
q)0N!"I=*,"0:"5=\"hello,world\",6=1";
(5 6i;("hello,world";,"1"))
q)0N!"J=*,"0:"5=\"hello,world\",6=1";
(5 6;("hello,world";,"1"))
q)0N!"S=*,"0:"a=\"hello,world\",b=1";
(`a`b;("hello,world";,"1"))
```

<i class="far fa-hand-point-right"></i> 
[Casting](../basics/casting.md), 
[Datatypes](../basics/datatypes.md), 
[File system](../basics/files.md),
[How do I import a CSV file into a table](../kb/faq.md#how-do-i-import-a-csv-file-into-a-table)

