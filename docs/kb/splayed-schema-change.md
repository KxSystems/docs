---
title: Changing the schema of splayed tables
description: Some of the q queries described elsewhere in the Knowledge Base do not work with splayed tables, in particular those that change the schema. This article explains how to write queries that change the schema.
keywords: kdb+, q, schema, splayed, table
---
# Changing the schema of splayed tables





Some of the q queries described elsewhere in the Knowledge Base do not work with splayed tables, in particular those that change the schema. This article explains how to write queries that change the schema.

Consider the following table:

```q
q)tr
date       open  high  low   close volume   sym
------------------------------------------------
2006.10.03 24.5  24.51 23.79 24.13 19087300 AMD
2006.10.03 27.37 27.48 27.21 27.37 39386200 MSFT
...
```

Removing a column is a simple matter:

```q
q)delete volume from tr
date       open  high  low   close sym
---------------------------------------
2006.10.03 24.5  24.51 23.79 24.13 AMD
2006.10.03 27.37 27.48 27.21 27.37 MSFT
...
```

But that does not work with a splayed table:

```q
q)trade
date       open  high  low   close volume   sym
------------------------------------------------
2006.10.03 24.5  24.51 23.79 24.13 19087300 AMD
2006.10.03 27.37 27.48 27.21 27.37 39386200 MSFT
...
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

```q
./q.exe dir
KDB+ 2.4t 2006.07.27 Copyright (C) 1993-2006 Kx Systems
w32/ 1cpu 384MB ...

q)\v
`s#`sym`trade
q)trade
date       open  high  low   close sym
---------------------------------------
2006.10.03 24.5  24.51 23.79 24.13 AMD
...
```

Notice that the file with the volume column has not been deleted. It is just not being used.

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
q)@[`:trade; `newcol; : ; til 8]
`:trade
q).[`:trade/.d; (); , ; `newcol]
`:trade/.d
```

Verify the changes by loading the splayed table into a q session. 

```bash
$ ./q.exe dir
KDB+ 2.4t 2006.07.27 Copyright (C) 1993-2006 Kx Systems
w32/ 1cpu 384MB ...
```

```q
q)trade
date       open  high  low   close sym  newcol
----------------------------------------------
2006.10.03 24.5  24.51 23.79 24.13 AMD  0
2006.10.03 27.37 27.48 27.21 27.37 MSFT 1
2006.10.04 24.1  25.1  23.95 25.03 AMD  2
...
```

