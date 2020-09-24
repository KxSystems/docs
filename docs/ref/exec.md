---
title: exec keyword | Reference | kdb+ and q documentation
description: exec is a q keyword that returns selected rows and columns from a table. Exec is a q operator that does the same in functional SQL.
author: Stephen Taylor
keywords: kdb+, q, table
---
# `exec`



_Return selected rows and columns from a table_

!!! info "`exec` is a qSQL query template and varies from regular q syntax."

For the Exec operator `?`, see 
:fontawesome-solid-book-open:
[Functional SQL](../basics/funsql.md)



## Syntax

Below, square brackets mark optional elements.

<pre markdown="1" class="language-txt">
exec [distinct] _p<sub>s</sub>_ [by _p<sub>b</sub>_] from _t<sub>exp</sub>_ [where _p<sub>w</sub>_]
</pre>

:fontawesome-solid-book-open:
[qSQL syntax](../basics/qsql.md)


## Select phrase

Where the [Select phrase](../basics/qsql.md#select phrase) 

-   is omitted, returns the last record
-   contains a single column, returns the value of that column
-   contains multiple columns or assigns a column name, returns a dictionary with column names as keys 

```q
q)\l sp.q

q)exec from sp  / last record
s  | `s!0
p  | `p$`p5
qty| 400

q)exec qty from sp  / list 
300 200 400 200 100 100 300 400 200 200 300 400

q)exec amount:qty from sp  / assigns column name
amount| 300 200 400 200 100 100 300 400 200 200 300 400

q)exec (qty;s) from sp  / list per column 
300 200 400 200 100 100 300 400 200 200 300 400
s1  s1  s1  s1  s4  s1  s2  s2  s3  s4  s4  s1

q)exec qty, s from sp  / dict by column name
qty| 300 200 400 200 100 100 300 400 200 200 300 400
s  | s1  s1  s1  s1  s4  s1  s2  s2  s3  s4  s4  s1

q)exec sum qty by s from sp  / dict by key 
s1| 1600
s2| 700
s3| 200
s4| 600

q)exec q:sum qty by s from sp  / xtab:list!table 
  | q
--| ----
s1| 1600
s2| 700
s3| 200
s4| 600

q)exec sum qty by s:s from sp  / table!list 
s |
--| ----
s1| 1600
s2| 700
s3| 200
s4| 600

q)exec qty, s by 0b from sp  / table
qty s
------
300 s1
200 s1
400 s1
200 s1
100 s4
100 s1
300 s2
400 s2
200 s3
200 s4
300 s4
400 s1

q)exec q:sum qty by s:s from sp
s | q
--| ----
s1| 1600
s2| 700
s3| 200
s4| 600
```

Compare the results of `select` and `exec` queries with multiple columns:

-   a `select` query result is a table, and all columns are necessarily the same length
-   an `exec` query result is a dictionary, and column lengths can vary

```q
q)t
name  sex eye
---------------
tom   m   blue
dick  m   green
harry m   blue
jack  m   blue
jill  f   gray
q)select name, distinct eye from t
'length
  [0]  select name, distinct eye from t
       ^
q)exec name, distinct eye from t
name| `tom`dick`harry`jack`jill
eye | `blue`green`gray
```


## Limit expression

`exec distinct` returns only unique items in the first item of the result.

```q
q)exec distinct s,p,s from sp
s | `s$`s1`s4`s2`s3
p | `p$`p1`p2`p3`p4`p5`p6`p1`p2`p2`p2`p4`p5
s1| `s$`s1`s1`s1`s1`s4`s1`s2`s2`s3`s4`s4`s1
```


## Cond

Cond is not supported inside query templates: 
see [qSQL](../basics/qsql.md#cond).



----
:fontawesome-solid-book:
[`delete`](delete.md),
[`select`](select.md),
[`update`](update.md)
<br>
:fontawesome-solid-book-open:
[qSQL](../basics/qsql.md),
[Functional SQL](../basics/funsql.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.4 The `exec` Template](/q4m3/9_Queries_q-sql/#94-the-exec-template)  
