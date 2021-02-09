---
title: Functional qSQL | Basics | kdb+ and q documentation
description: The functional forms of delete, exec, select and update are particularly useful for programmatically-generated queries, such as when column names are dynamically produced.
keywords: delete, exec, functional, kdb+, q, select, sql, update
---
# Functional qSQL




The functional forms of [`delete`](../ref/delete.md), [`exec`](../ref/exec.md), [`select`](../ref/select.md) and [`update`](../ref/update.md) are particularly useful for programmatically-generated queries, such as when column names are dynamically produced. 

!!! info "Performance"

    The q interpreter parses `delete`, `exec`, `select`, and `update` into their equivalent functional forms, so there is no performance difference.

The functional forms are

```q
![t;c;b;a]              /update and delete

?[t;i;p]                /simple exec

?[t;c;b;a]              /select or exec
?[t;c;b;a;n]            /select up to n records
?[t;c;b;a;n;(g;cn)]     /select up to n records sorted by g on cn
```

where: 

`t`
: is a table, or the name of a table as a symbol atom. 

`c`
: is the [Where phrase](qsql.md#where-phrase), a list of constraints. 
: Every item in `c` is a triple consisting of a boolean- or int- valued binary function together with its arguments, each an expression containing column names and other variables. The function is applied to the two arguments, producing a boolean vector. The resulting boolean vector selects the rows that yield non-zero results. The selection is performed in the order of the items in `c`, from left to right.

`b`
: is the [By phrase](qsql.md#by-phrase), one of:

    -   the general empty list `()`
    -   boolean atom: `0b` for no grouping; `1b` for distinct
    -   a symbol atom or list naming table column/s
    -   a dictionary of group-by specifications

: The domain of dictionary `b` is a list of symbols that are the key names for the grouping. Its range is a list of column expressions (parse trees) whose results are used to construct the groups. The grouping is ordered by the domain items, from major to minor.

`a`
: is the [Select phrase](../ref/select.md#select-phrase), one of:

    -   the general empty list `()`
    -   a symbol atom: the name of a table column
    -   a parse tree
    -   a dictionary of select specifications (aggregations)

: The domain of dictionary `a` is a list of symbols containing the names of the produced columns. ([QSQL query templates](qsql.md) assign default column names in the result, but here each result column must be named explicitly.) 
: Each item of its range is an evaluation list consisting of a function and its argument/s, each of which is a column name or another such result list. For each evaluation list, the function is applied to the specified value/s for each row and the result is returned. The evaluation lists are resolved recursively when operations are nested.

`i`
: is a list of indexes

`p`
: is a [parse tree](parsetrees.md)

`n`
: is a non-negative integer or infinity, indicating the maximum number of records to be returned

`g`
: is a unary grade function


## Call by name

Columns in `a`, `b` and `c` appear as symbols.

To distinguish symbol atoms and vectors from columns, enlist them.

```q
q)t:([] c1:`a`b`a`c`a`b`c; c2:10*1+til 7; c3:1.1*1+til 7)

q)select from t where c2>35,c1 in `b`c
c1 c2 c3
---------
c  40 4.4
b  60 6.6
c  70 7.7

q)?[t; ((>;`c2;35);(in;`c1;enlist[`b`c])); 0b; ()]
c1 c2 c3
---------
c  40 4.4
b  60 6.6
c  70 7.7
```

Note above that 

-   the columns `c1` and `c2` appear as symbol atoms
-   the symbol vector `` `b`c`` appears as ``enlist[`b`c]``

!!! tip "Use [`enlist`](../ref/enlist.md) to create singletons to ensure appropriate entities are lists."

Different types of `a` and `b` return different types of result for Select and Exec.

```txt
           | b
a          | bool    ()         sym/s   dict
-----------|----------------------------------------
()         | table    dict       -       keyed table
sym        | -        vector     dict    dict
parse tree | -        vector     dict    dict
dict       | table    vector/s   table   table 
```


## `?` Select

```txt
?[t;c;b;a]
```

Where `t`, `c`, `b`, and `a` are as above, returns a table.

```q
q)show t:([]n:`x`y`x`z`z`y;p:0 15 12 20 25 14)
n p
----
x 0
y 15
x 12
z 20
z 25
y 14

q)select m:max p,s:sum p by name:n from t where p>0,n in `x`y
name| m  s
----| -----
x   | 12 12
y   | 15 29
```

:fontawesome-solid-book:
[`select`](../ref/select.md)

Following is the equivalent functional form. Note the use of [`enlist`](../ref/enlist.md) to create singletons, ensuring that appropriate entities are lists.

```q
q)c: ((>;`p;0);(in;`n;enlist `x`y))
q)b: (enlist `name)!enlist `n
q)a: `m`s!((max;`p);(sum;`p))
q)?[t;c;b;a]
name| m  s
----| -----
x   | 12 12
y   | 15 29
```

!!! tip "Degenerate cases"

    -   For no constraints, make `c` the empty list 
    -   For no grouping make `b` a boolean `0b` 
    -   For distinct rows make `b` a boolean `1b` 
    -   To produce all columns of `t` in the result, make `a` the empty list `()`
    
    `select from t` is equivalent to functional form `?[t;();0b;()]`.


### Select distinct

For special case [`select distinct`](../ref/select.md#distinct) specify `b` as `1b`.

```q
q)t:([] c1:`a`b`a`c`b`c; c2:1 1 1 2 2 2; c3:10 20 30 40 50 60)

q)?[t;(); 1b; `c1`c2!`c1`c2]        / select distinct c1,c2 from t
c1 c2
-----
a  1
b  1
c  2
b  2
```

### Rank 5

_Limit result rows_

```txt
?[t;c;b;a;n]
```

Returns as for rank 4, but where `n` is 

-   a non-negative integer or infinity, only the first `n` rows
-   a pair of non-negative integers, up to `n[1]` rows starting with row `n[0]`

```q
q)show t:([] c1:`a`b`c`a; c2:10 20 30 40)
c1 c2
-----
a  10
b  20
c  30
a  40

q)?[t;();0b;();2]                   / select[2] from t
c1 c2
-----
a  10
b  20

q)?[t;();0b;();1 2]                 / select[1 2] from t
c1 c2
-----
b  20
c  30
```


### Rank 6

_Limit result rows and sort by a column_

```txt
?[t;c;b;a;n;(g;cn)]
```

Returns as for rank 5, but where

-   `g` is a unary grading function
-   `cn` is a column name as a symbol atom

sorted by `g` on column `cn`.

```q
q)?[t; (); 0b; `c1`c2!`c1`c2; 0W; (idesc;`c1)]
c1 c2
-----
c  30
b  20
a  10
a  40
```

:fontawesome-solid-street-view:
_Q for Mortals_
[§9.12.1 Functional select](/q4m3/9_Queries_q-sql/#9121-functional-select)


## `?` Exec

The functional form of `exec` is a simplified form of Select that returns a list or dictionary rather than a table.

```txt
?[t;c;b;a]
```

The constraint specification `c` (Where) is as for Select.

```q
q)show t:([] c1:`a`b`c`c`a`a; c2:10 20 30 30 40 40; 
    c3: 1.1 2.2 3.3 3.3 4.4 3.14159; c4:`cow`sheep`cat`dog`cow`dog)
c1 c2 c3      c4
-------------------
a  10 1.1     cow
b  20 2.2     sheep
c  30 3.3     cat
c  30 3.3     dog
a  40 4.4     cow
a  40 3.14159 dog
```

:fontawesome-solid-book:
[`exec`](../ref/exec.md)


### No grouping

`b` is the general empty list.

```txt
b   a      result
--------------------------------------------------------------
()  ()     the last row of t as a dictionary
()  sym    the value of that column
()  dict   a dictionary with keys and values as specified by a
```

```q
q)?[t; (); (); ()]                          / exec last c1,last c2,last c3 from t
c1| `a
c2| 40
c3| 3.14159
c4| `dog

q)?[t; (); (); `c1]                         / exec c1 from t
`a`b`c`c`a`a

q)?[t; (); (); `one`two!`c1`c2]             / exec one:c1,two:c2 from t
one| a  b  c  c  a  a
two| 10 20 30 30 40 40

q)?[t; (); (); `one`two!(`c1;(sum;`c2))]    / exec one:c1,two:sum c2 from t
one| `a`b`c`c`a`a
two| 170
```


### Group by column

`b` is a column name. The result is a dictionary. 

Where `a` is a **column name**, in the result

-   the keys are distinct values of the column named in `b` 
-   the values are lists of corresponding values from the column named in `a`

```q
q)?[t; (); `c1; `c2]     / exec c2 by c1 from t
a| 10 40 40
b| ,20
c| 30 30
```

Where `a` is a **dictionary**, in the result

-   the key is a table with a single anonymous column containing distinct values of the column named in `b` 
-   the value is a table with columns as defined in `a`

```q
q)?[t; (); `c1; enlist[`c2]!enlist`c2]      / exec c2:c2 by c1 from t
 | c2
-| --------
a| 10 40 40
b| ,20
c| 30 30

q)?[t; (); `c1; `two`three!`c2`c3]          / exec two:c2,three:c3 by c1 from t
 | two      three
-| ------------------------
a| 10 40 40 1.1 4.4 3.14159
b| ,20      ,2.2
c| 30 30    3.3 3.3

q)?[t;();`c1;`m2`s3!((max;`c2);(sum;`c3))]  / exec m2:max c2,s3:sum c3 by c1 from t
 | m2  s3
-| -----------
a| 40  8.64159
b| 20  2.2
c| 30  6.6
```


### Group by columns

`b` is a list of column names.

Where `a` is a **column name**, returns a dictionary in which

-   the key is the empty symbol
-   the value is the value of the column/s specified in `a`

```q
q)?[t; (); `c1`c2; `c3]
| 1.1 2.2 3.3 3.3 4.4 3.14159

q)?[t; (); `c1`c2; `c3`c4!((max;`c3);(last;`c4))]
| c3  c4
| -------
| 4.4 dog
```


### Group by a dictionary

`b` is a dictionary. Result is a dictionary in which the key is a table with columns as specified by `b` and 

```txt
b     a     result value
-----------------------------------------------------
dict  ()    last records of table that match each key
dict  sym   corresponding values from the column in a
dict  dict  values as defined in a
```

```q
q)?[t; (); `one`two!`c1`c2; ()]
one two| c1 c2 c3      c4
-------| -------------------
a   10 | a  10 1.1     cow
a   40 | a  40 3.14159 dog
b   20 | b  20 2.2     sheep
c   30 | c  30 3.3     dog
q)/ exec last c1,last c2,last c3,last c4 by one:c1,two:c2 from t

q)?[t; (); enlist[`one]!enlist(string;`c1); ()]
one | c1 c2 c3      c4
----| -------------------
,"a"| a  40 3.14159 dog
,"b"| b  20 2.2     sheep
,"c"| c  30 3.3     dog
q)/ exec last c1,last c2,last c3,last c4 by one:string c1 from t

q)?[t; (); enlist[`one]!enlist `c1; `c2]     / exec c2 by one:c1 from t
one|
---| --------
a  | 10 40 40
b  | ,20
c  | 30 30

q)?[t; (); `one`four!`c1`c4; `m2`s3!((max;`c2);(sum;`c3))]
one four | m2 s3
---------| ----------
a   cow  | 40 5.5
a   dog  | 40 3.14159
b   sheep| 20 2.2
c   cat  | 30 3.3
c   dog  | 30 3.3
```

:fontawesome-solid-street-view:
_Q for Mortals_
[§9.12.2 Functional exec](/q4m3/9_Queries_q-sql/#9122-functional-exec)

<!-- 
In the simplest example of a single result column, the By specification is the empty list and the Aggregate specification is a symbol atom.

```q
q)show t:([]n:`x`y`x`z`z`y;p:0 15 12 20 25 14)
n p
----
x 0
y 15
x 12
z 20
z 25
y 14

q)exec n from t
`x`y`x`z`z`y

q)?[t;();();`n]           / same as previous exec
`x`y`x`z`z`y
```
In the same query with multiple columns, the group-by parameter is the empty list and the aggregate parameter is a dictionary as it would be in a Select. The result is a dictionary rather than a table.

```q
q)exec n,p from t
n| x y  x  z  z  y
p| 0 15 12 20 25 14

q)?[t;();();`n`p!`n`p]    / same as previous exec
n| x y  x  z  z  y
p| 0 15 12 20 25 14
```

If you wish to group by a single column, specify it as a symbol atom.

```q
q)exec p by n from t
x| 0  12
y| 15 14
z| 20 25

q)?[t;();`n;`p]           / same as previous exec
x| 0  12
y| 15 14
z| 20 25
```

More complex examples of Exec <!-- seem to reduce to the equivalent Select.
 -->


## `?` Simple Exec

```txt
?[t;i;p]
```

Where `t` is not partitioned, another form of Exec.

```q
q)show t:([]a:1 2 3;b:4 5 6;c:7 9 0)
a b c
-----
1 4 7
2 5 9
3 6 0

q)?[t;0 1 2;`a]
1 2 3
q)?[t;0 1 2;`b]
4 5 6
q)?[t;0 1 2;(last;`a)]
3
q)?[t;0 1;(last;`a)]
2
q)?[t;0 1 2;(*;(min;`a);(avg;`c))]
5.333333
```


## `!` Update

```txt
![t;c;b;a]
```

:fontawesome-solid-book:
[`update`](../ref/update.md)

Arguments `t`, `c`, `b`, and `a` are as for Select. 

```q
q)show t:([]n:`x`y`x`z`z`y;p:0 15 12 20 25 14)
n p
----
x 0
y 15
x 12
z 20
z 25
y 14

q)select m:max p,s:sum p by name:n from t where p>0,n in `x`y
name| m  s
----| -----
x   | 12 12
y   | 15 29

q)update p:max p by n from t where p>0
n p
----
x 0
y 15
x 12
z 25
z 25
y 15

q)c: enlist (>;`p;0)
q)b: (enlist `n)!enlist `n
q)a: (enlist `p)!enlist (max;`p)

q)![t;c;b;a]
n p
----
x 0
y 15
x 12
z 25
z 25
y 15
```

The degenerate cases are the same as in Select.

:fontawesome-solid-street-view:
_Q for Mortals_
[§9.12.3 Functional update](/q4m3/9_Queries_q-sql/#9123-functional-update)



## `!` Delete

The functional form of `delete` is a simplified form of Update.

```q
![t;c;0b;a]
```

:fontawesome-solid-book:
[`delete`](../ref/delete.md)

One of `c` or `a` must be empty, the other not. `c` selects which rows will be removed. `a` is a symbol vector with the names of columns to be removed.

```q
q)t:([]c1:`a`b`c;c2:`x`y`z)

q)/following is: delete c2 from t
q)![t;();0b;enlist `c2]
c1
--
a
b
c

q)/following is: delete from t where c2 = `y
q)![t;enlist (=;`c2; enlist `y);0b;`symbol$()]
c1 c2
-----
a  x
c  z
```

:fontawesome-solid-street-view:
_Q for Mortals_
[§9.12.4 Functional delete](/q4m3/9_Queries_q-sql/#9123-functional-delete)


----
:fontawesome-solid-book-open:
[qSQL](qsql.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.12 Functional Forms](/q4m3/9_Queries_q-sql/#912-functional-forms)
<br>
:fontawesome-solid-globe:
[Functional Query Functions](http://www.q-ist.com/2012/10/functional-query-functions.html "q-ist")
