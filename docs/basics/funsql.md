---
title: Functional qSQL | Basics | kdb+ and q documentation
description: The functional forms of delete, exec, select and update are particularly useful for programmatically-generated queries, such as when column names are dynamically produced.
keywords: delete, exec, functional, kdb+, q, select, sql, update
author: [Peter Storeng, Stephen Taylor, Simon Shanks]
---
# Functional qSQL




The functional forms of [`delete`](../ref/delete.md), [`exec`](../ref/exec.md), [`select`](../ref/select.md) and [`update`](../ref/update.md) are particularly useful for programmatically-generated queries, such as when column names are dynamically produced. 

Functional form is an alternative to using a [qSQL template](qsql.md) to construct a query. For example, the folowing are equivalent:
```q
q)select n from t
q)?[t;();0b;(enlist `n)!enlist `n]
```

!!! info "Performance"

    The q interpreter parses `delete`, `exec`, `select`, and `update` into their equivalent functional forms, so there is no performance difference.



The functional forms are

```syntax
![t;c;b;a]              /update and delete

?[t;i;p]                /simple exec

?[t;c;b;a]              /select or exec
?[t;c;b;a;n]            /select up to n records
?[t;c;b;a;n;(g;cn)]     /select up to n records sorted by g on cn
```

where: 

* `t`  is a table, or the name of a table as a symbol atom. 
* `c` is the [Where phrase](qsql.md#where-phrase), a list of constraints.  
Every constraint in `c` is a [parse tree](parsetrees.md) representing an expression to be evaluated; the result of each being a boolean vector. The parse tree consists of a function followed by a list of its arguments, each an expression containing column names and other variables. Represented by symbols, it distinguishes actual symbol constants by enlisting them. The function is applied to the arguments, producing a boolean vector that selects the rows. The selection is performed in the order of the items in `c`, from left to right: only rows selected by one constraint are evaluated by the next.
<!-- : Every item in `c` is a triple consisting of a boolean- or int- valued binary function together with its arguments, each an expression containing column names and other variables. The function is applied to the two arguments, producing a boolean vector. The resulting boolean vector selects the rows that yield non-zero results. The selection is performed in the order of the items in `c`, from left to right. -->
* `b` is the [By phrase](qsql.md#by-phrase).  
The domain of dictionary `b` is a list of symbols that are the key names for the grouping. Its range is a list of column expressions (parse trees) whose results are used to construct the groups. The grouping is ordered by the domain items, from major to minor.
`b` is one of:
    -   the general empty list `()`
    -   boolean atom: `0b` for no grouping; `1b` for distinct
    -   a symbol atom or list naming table column/s
    -   a dictionary of group-by specifications   
* `a` is the [Select phrase](../ref/select.md#select-phrase).
The domain of dictionary `a` is a list of symbols containing the names of the produced columns. [QSQL query templates](qsql.md) assign default column names in the result, but here each result column must be named explicitly.  
Each item of its range is an evaluation list consisting of a function and its argument(s), each of which is a column name or another such result list. For each evaluation list, the function is applied to the specified value(s) for each row and the result is returned. The evaluation lists are resolved recursively when operations are nested.  
`a` is one of
    -   the general empty list `()`
    -   a symbol atom: the name of a table column
    -   a parse tree
    -   a dictionary of select specifications (aggregations)
* `i` is a list of indexes
* `p` is a [parse tree](parsetrees.md)
* `n` is a non-negative integer or infinity, indicating the maximum number of records to be returned
* `g` is a unary grade function


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

```syntax
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

```syntax
?[t;c;b;a;n]
```

Returns as for rank 4, but where `n` is 

-   an integer or infinity, only the first `n` rows, or the last if `n` is negative
-   a pair of non-negative integers, up to `n[1]` rows starting with row `n[0]`

```q
q)show t:([] c1:`a`b`c`a; c2:10 20 30 40)
c1 c2
-----
a  10
b  20
c  30
a  40

q)?[t;();0b;();-2]                   / select[-2] from t
c1 c2
-----
c  30
a  40

q)?[t;();0b;();1 2]                 / select[1 2] from t
c1 c2
-----
b  20
c  30
```


### Rank 6

_Limit result rows and sort by a column_

```syntax
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
[§9.12.1 Functional select](https://code.kx.com/q4m3/9_Queries_q-sql/#9121-functional-select)


## `?` Exec

_A simplified form of Select that returns a list or dictionary rather than a table._

```syntax
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
[§9.12.2 Functional exec](https://code.kx.com/q4m3/9_Queries_q-sql/#9122-functional-exec)

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

```syntax
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

```syntax
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
[§9.12.3 Functional update](https://code.kx.com/q4m3/9_Queries_q-sql/#9123-functional-update)



## `!` Delete

_A simplified form of Update_

```syntax
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
[§9.12.4 Functional delete](https://code.kx.com/q4m3/9_Queries_q-sql/#9124-functional-delete)


## Conversion using parse

Applying [parse](parsetrees.md) to a qSQL statement written as a string will return the internal representation of the functional form. 
With some manipulation this can then be used to piece together the functional form in q. 
This generally becomes more difficult as the query becomes more complex and requires a deep understanding of what kdb+ is doing when it parses qSQL form.

An example of using parse to convert qSQL to its corresponding functional form is as follows:
```q
q)t:([]c1:`a`b`c; c2:10 20 30)
q)parse "select c2:2*c2 from t where c1=`c"
?
`t
,,(=;`c1;,`c)
0b
(,`c2)!,(*;2;`c2)

q)?[`t; enlist (=;`c1;enlist `c); 0b; (enlist `c2)!enlist (*;2;`c2)]
c2
--
60
```

### Issues converting to functional form

To convert a `select` query to a functional form one may attempt to
apply the `parse` function to the query string:

```q
q)parse "select sym,price,size from trade where price>50"
?
`trade
,,(>;`price;50)
0b
`sym`price`size!`sym`price`size
```

As we know, `parse` produces a parse tree and since some of the elements may themselves be parse trees we can’t immediately take the output of parse and plug it into the form `?[t;c;b;a]`. After a little playing around with the result of `parse` you might eventually figure out that the correct functional form is as follows.

```q
q)funcQry:?[`trade;enlist(>;`price;50);0b;`sym`price`size! `sym`price`size]

q)strQry:select sym,price,size from trade where price>50 q)
q)funcQry~strQry
1b
```

This, however, becomes more difficult as the query statements become more complex:

```q
q)parse "select count i from trade where 140>(count;i) fby sym"
?
`trade
,,(>;140;(k){@[(#y)#x[0]0#x
1;g;:;x[0]'x[1]g:.=y]};(enlist;#:;`i);`sym))
0b
(,`x)!,(#:;`i)
```

In this case, it is not obvious what the functional form of the above query should be, even after applying `parse`.

There are three issues with this parse-and-“by eye” method to convert to the equivalent functional form. We will cover these in the next three subsections.


#### Parse trees and eval

The first issue with passing a `select` query to `parse` is that each returned item is in unevaluated form. As [discussed here](parsetrees.md#eval-and-value), simply applying `value` to a parse tree does not work. However, if we evaluate each one of the arguments fully, then there would be no nested parse trees. We could then apply `value` to the result:

```q
q)eval each parse "select count i from trade where 140>(count;i) fby sym"
?
+`sym`time`price`size!(`VOD`IBM`BP`VOD`IBM`IBM`HSBC`VOD`MS..
,(>;140;(k){@[(#y)#x[0]0#x
1;g;:;x[0]'x[1]g:.=y]};(enlist;#:;`i);`sym))
0b
(,`x)!,(#:;`i)
```

The equivalence below holds for a general qSQL query provided as a string:

```q
q)value[str]~value eval each parse str
1b
```

In particular:

```q
q)str:"select count i from trade where 140>(count;i) fby sym"

q)value[str]~value eval each parse str
1b
```

In fact, since within the functional form we can refer to the table by name we can make this even clearer. Also, the first item in the result of `parse` applied to a `select` query will always be `?` (or `!` for a `delete`or `update` query) which cannot be evaluated any further. So we don’t need to apply `eval` to it.

```q
q)pTree:parse str:"select count i from trade where 140>(count;i) fby sym"
q)@[pTree;2 3 4;eval]
?
`trade
,(>;140;(k){@[(#y)#x[0]0#x
1;g;:;x[0]'x[1]g:.=y]};(enlist;#:;`i);`sym))
0b
(,`x)!,(#:;`i)
q)value[str] ~ value @[pTree;2 3 4;eval]
1b
```


#### Variable representation in parse trees

Recall that in a parse tree a variable is represented by a symbol containing its name. So to represent a symbol or a list of symbols, you must use `enlist` on that expression. In k, `enlist` is the unary form of the comma operator in k:

```q
q)parse"3#`a`b`c`d`e`f"
#
3
,`a`b`c`d`e`f
q)(#;3;enlist `a`b`c`d`e`f)~parse"3#`a`b`c`d`e`f"
1b
```

This causes a difficulty. As [discussed above](#variadic-operators), q has no unary syntax for operators.

Which means the following isn’t a valid q expression and so returns an error.

```q
q)(#;3;,`a`b`c`d`e`f)
',
```

In the parse tree we receive we need to somehow distinguish between k’s unary `,` (which we want to replace with `enlist`) and the binary Join operator, which we want to leave as it is.


#### Explicit definitions in `.q` are shown in full

The `fby` in the `select` query above is represented by its full k
definition.

```q
q)parse "fby"
k){@[(#y)#x[0]0#x 1;g;:;x[0]'x[1]g:.=y]}
```

While using the k form isn’t generally a problem from a functionality perspective, it does however make the resulting functional statement difficult to read.


### The solution

We will write a function to automate the process of converting a `select` query into its equivalent functional form.

This function, `buildQuery`, will return the functional form as a string.

```q
q)buildQuery "select count i from trade where 140>(count;i) fby sym"
"?[trade;enlist(>;140;(fby;(enlist;count;`i);`sym));0b;
  (enlist`x)! enlist (count;`i)]"
```

When executed it will always return the same result as the `select` query from which it is derived:

```q
q)str:"select count i from trade where 140>(count;i) fby sym"
q)value[str]~value buildQuery str
1b
```

And since the same logic applies to `exec`, `update` and `delete` it will be able to convert to their corresponding functional forms also.

To write this function we will solve the three issues outlined above:

1.  parse-tree items may be parse trees
2.  parse trees use k’s unary syntax for operators
3.  q keywords from `.q.` are replaced by their k definitions

The first issue, where some items returned by `parse` may themselves be parse trees is easily resolved by applying `eval` to the individual items.

The second issue is with k’s unary syntax for `,`. We want to replace it with the q keyword `enlist`. To do this we define a function that traverses the parse tree and detects if any element is an enlisted list of symbols or an enlisted single symbol. If it finds one we replace it with a string representation of `enlist` instead of `,`.

```q
ereptest:{ //returns a boolean
  (1=count x) and ((0=type x) and 11=type first x) or 11=type x}
ereplace:{"enlist",.Q.s1 first x}
funcEn:{$[ereptest x;ereplace x;0=type x;.z.s each x;x]}
```

Before we replace the item we first need to check it has the
correct form. We need to test if it is one of:

-   An enlisted list of syms. It will have type `0h`, count 1 and the type of its first item will be `11h` if and only if it is an enlisted list of syms.
-   An enlisted single sym. It will have type `11h` and count 1 if and only if it is an enlisted single symbol.

The `ereptest` function above performs this check, with `ereplace` performing the replacement.

!!! tip "Console size"

    `.Q.s1` is dependent on the size of the console so make it larger if necessary.

Since we are going to be checking a parse tree which may contain parse trees nested to arbitrary depth, we need a way to check all the elements down to the base level.

We observe that a parse tree is a general list, and therefore of type `0h`. This knowledge combined with the use of `.z.s` allows us to scan a parse tree recursively. The logic goes: if what you have passed into `funcEn` is a parse tree then reapply the function to each element.

To illustrate we examine the following `select` query.

```q
q)show pTree:parse "select from trade where sym like \"F*\",not sym=`FD"
?
`trade
,((like;`sym;"F*");(~:;(=;`sym;,`FD))) 0b
()

q)x:eval pTree 2         //apply eval to Where clause
```

Consider the Where clause in isolation.

```q
q)x //a 2-list of Where clauses
(like;`sym;"F*")
(~:;(=;`sym;,`FD))

q)funcEn x
(like;`sym;"F*")
(~:;(=;`sym;"enlist`FD"))
```

Similarly we create a function which will replace k functions with
their q equivalents in string form, thus addressing the third issue above.

```q
q)kreplace:{[x] $[`=qval:.q?x;x;string qval]}
q)funcK:{$[0=t:type x;.z.s each x;t<100h;x;kreplace x]}
```

Running these functions against our Where clause, we see the k
representations being converted to q.

```q
q)x
(like;`sym;"F*")
(~:;(=;`sym;,`FD))

q)funcK x //replaces ~: with “not”
(like;`sym;"F*")
("not";(=;`sym;,`FD))
```

Next, we make a slight change to `kreplace` and `ereplace` and combine them.

```q
kreplace:{[x] $[`=qval:.q?x;x;"~~",string[qval],"~~"]}
ereplace:{"~~enlist",(.Q.s1 first x),"~~"}
q)funcEn funcK x
(like;`sym;"F*") ("~~not~~";(=;`sym;"~~enlist`FD~~"))
```

The double tilde here is going to act as a tag to allow us to differentiate from actual string elements in the parse tree. This allows us to drop the embedded quotation marks at a later stage inside the `buildQuery` function:

```q
q)ssr/[;("\"~~";"~~\"");("";"")] .Q.s1 funcEn funcK x
"((like;`sym;\"F*\");(not;(=;`sym;enlist`FD)))"
```

thus giving us the correct format for the Where clause in a functional select. By applying the same logic to the rest of the parse tree we can write the `buildQuery` function.

```q
q)buildQuery "select from trade where sym like \"F*\",not sym=`FD"
"?[trade;((like;`sym;\"F*\");(not;(=;`sym;enlist`FD)));0b;()]"
```

One thing to take note of is that since we use reverse lookup on the `.q` namespace and only want one result we occasionally get the wrong keyword back.

```q
q)buildQuery "update tstamp:ltime tstamp from z"
"![z;();0b;(enlist`tstamp)!enlist (reciprocal;`tstamp)]"

q).q`ltime
%:
q).q`reciprocal
%:
```

These instances are rare and a developer should be able to spot when they occur. Of course, the functional form will still work as expected but could confuse readers of the code.


#### Fifth and sixth arguments

Functional select also has ranks 5 and 6; i.e. fifth and sixth arguments.

:fontawesome-regular-hand-point-right:
_Q for Mortals_: [§9.12.1 Functional queries](/q4m3/9_Queries_q-sql/#9121-functional-select)

We also cover these with the `buildQuery` function.

```q
q)buildQuery "select[10 20] from trade"
"?[trade;();0b;();10 20]"
q)//5th parameter included
```

The 6th argument is a column and a direction to order the results by. Use `<` for ascending and `>` for descending.

```q
q)parse"select[10;<price] from trade"
?
`trade
()
0b
()
10
,(<:;`price)

q).q?(<:;>:)
`hopen`hclose

q)qfind each ("<:";">:")   //qfind defined above
hopen
hclose
```

We see that the k function for the 6th argument of the functional form is `<:` (ascending) or `>:` (descending). At first glance this appears to be `hopen` or `hclose`. In fact in earlier versions of q, `iasc` and `hopen` were equivalent (as were `idesc` and `hclose`). The definitions of `iasc` and `idesc` were later altered to signal a rank error if not applied to a list.

```q
q)iasc
k){$[0h>@x;'`rank;<x]}

q)idesc
k){$[0h>@x;'`rank;>x]}

q)iasc 7
'rank
```

Since the columns of a table are lists, it is irrelevant whether the functional form uses the old or new version of `iasc` or `idesc`.

The `buildQuery` function handles the 6th argument as a special case so will produce `iasc` or `idesc` as appropriate.

```q
q)buildQuery "select[10 20;>price] from trade"
"?[trade;();0b;();10 20;(idesc;`price)]"
```

The full `buildQuery` function code is as follows:

```q
\c 30 200
tidy:{ssr/[;("\"~~";"~~\"");("";"")] $[","=first x;1_x;x]}
strBrk:{y,(";" sv x),z}

//replace k representation with equivalent q keyword
kreplace:{[x] $[`=qval:.q?x;x;"~~",string[qval],"~~"]}
funcK:{$[0=t:type x;.z.s each x;t<100h;x;kreplace x]}

//replace eg ,`FD`ABC`DEF with "enlist`FD`ABC`DEF"
ereplace:{"~~enlist",(.Q.s1 first x),"~~"}
ereptest:{(1=count x) and ((0=type x) and 11=type first x) or 11=type x}
funcEn:{$[ereptest x;ereplace x;0=type x;.z.s each x;x]}

basic:{tidy .Q.s1 funcK funcEn x}

addbraks:{"(",x,")"}

//Where clause needs to be a list of Where clauses,
//so if only one Where clause, need to enlist.
stringify:{$[(0=type x) and 1=count x;"enlist ";""],basic x}

//if a dictionary, apply to both keys and values
ab:{
  $[(0=count x) or -1=type x; .Q.s1 x;
    99=type x; (addbraks stringify key x ),"!",stringify value x;
    stringify x] }

inner:{[x]
  idxs:2 3 4 5 6 inter ainds:til count x;
  x:@[x;idxs;'[ab;eval]];
  if[6 in idxs;x[6]:ssr/[;("hopen";"hclose");("iasc";"idesc")] x[6]];
  //for select statements within select statements
  x[1]:$[-11=type x 1;x 1;[idxs,:1;.z.s x 1]];
  x:@[x;ainds except idxs;string];
  x[0],strBrk[1_x;"[";"]"] }

buildQuery:{inner parse x}
```



----
:fontawesome-solid-book-open:
[qSQL](qsql.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.12 Functional Forms](https://code.kx.com/q4m3/9_Queries_q-sql/#912-functional-forms)
<br>
:fontawesome-solid-globe:
[Functional Query Functions](http://www.q-ist.com/2012/10/functional-query-functions.html "q-ist")
