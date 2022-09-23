---
title: QSQL query templates | Basics | kdb+ and q documentation
description: Q-SQL expressions have their own syntax rules, with optional dependent phrases, by, from and where, and can include definitions of new, derived columns. 
keywords: exec, delete, kdb+, q, query, select, sql, update, upsert
---
# QSQL query templates



<div markdown="1" class="typewriter">
[delete](../ref/delete.md)  delete rows or columns from a table
[exec](../ref/exec.md)    return columns from a table, possibly with new columns
[select](../ref/select.md)  return part of a table, possibly with new columns
[update](../ref/update.md)  add rows or columns to a table
</div>

The query templates of qSQL share a query syntax that varies from the [syntax of q](syntax.md) and closely resembles [conventional SQL](https://www.w3schools.com/sql/).
For many use cases involving ordered data it is significantly more expressive.

:fontawesome-brands-wikipedia-w:
[Structured Query Language](https://en.wikipedia.org/wiki/SQL "Wikipedia")


## Template syntax

Below, square brackets mark optional elements; a slash begins a trailing comment.

<div markdown="1" class="typewriter">
select [_L~exp~_]     [_p~s~_] [by _p~b~_] from _t~exp~_ [where _p~w~_]
exec   [distinct] [_p~s~_] [by _p~b~_] from _t~exp~_ [where _p~w~_]
update             _p~s~_  [by _p~b~_] from _t~exp~_ [where _p~w~_]
delete                         from _t~exp~_ [where _p~w~_]        / rows
delete             _p~s~_          from _t~exp~_                   / columns
</div>

A template is evaluated in the following order.

<div markdown="1" class="typewriter">
[From phrase](#from-phrase)        _t~exp~_
[Where phrase](#where-phrase)       _p~w~_
[By phrase](../ref/select.md#by-phrase)          _p~b~_
[Select phrase](../ref/select.md#select-phrase)      _p~s~_
[Limit expression](../ref/select.md#limit-expression)   _L~exp~_
</div>


### From phrase

The From phrase 
<code markdown="1">from _t~exp~_</code> 
is required in all query templates. 

The table expression _t~exp~_ is

-   a table or dictionary (call-by-value)
-   the name of a table or dictionary, in memory or on disk, as a symbol atom (call-by-name)

Examples:

```txt
update c:b*2 from ([]a:1 2;b:3 4)   / call by value
select a,b from t                   / call by value
select a,b from `t                  / call by name
update c:b*2 from `:path/to/db      / call by name
```


### Limit expressions

Limit expressions restrict the results returned by `select` or `exec`. 
(For `exec` there is only one: `distinct`).
They are described in the articles for [`select`](../ref/select.md) and [`exec`](../ref/exec.md).


### Result and side effects

In a `select` query, the result is a table or dictionary. 

In an `exec` query the result is a list of column values, or dictionary.

In an `update` or `delete` query, where the table expression is a call

-   by value, the query returns the modified table or a dictionary 
-   by name, the table or dictionary is amended in place (in memory or on disk) as a side effect, and its name returned as the result

```q
q)t1:t2:([]a:1 2;b:3 4)

q)update a:neg a from t1
a  b
----
-1 3
-2 4
q)t1~t2   / t1 unchanged
1b

q)update a:neg a from `t1
`t1
q)t1~t2   / t1 changed
0b
```


### Phrases and subphrases

_p~s~_, _p~b~_, and _p~w~_ are 
respectively the Select, By, and Where _phrases_.
Each phrase is a comma-separated list of subphrases.

A _subphrase_ is a q expression in which names are resolved with respect to _t~exp~_ and any table/s linked by foreign keys. Subphrases are evaluated in order from the left, but each subphrase expression is evaluated right-to-left in normal q syntax. 

??? tip "To use the Join operator within a subphrase, parenthesize the subphrase."

    ```q
    q)select (id,'4),val from tbl
    x   val
    -------
    1 4 100
    1 4 200
    2 4 300
    2 4 400
    2 4 500
    ```


### Names in subphrases

A name in a subphrase is resolved (in order) as the name of

1.  column or key name
1.  local name in (or argument of) the encapsulating function
1.  global name in the current working namespace – not necessarily the space in which the function was defined

Dot notation allows you to refer to foreign keys. 

:fontawesome-brands-github:
[Suppliers and parts database `sp.q`](https://github.com/KxSystems/kdb/blob/master/sp.q)

```q
q)\l sp.q
+`p`city!(`p$`p1`p2`p3`p4`p5`p6`p1`p2;`london`london`london`london`london`lon..
(`s#+(,`color)!,`s#`blue`green`red)!+(,`qty)!,900 1000 1200
+`s`p`qty!(`s$`s1`s1`s1`s2`s3`s4;`p$`p1`p4`p6`p2`p2`p4;300 200 100 400 200 300)

q)select sname:s.name, qty from sp
sname qty
---------
smith 300
smith 200
smith 400
smith 200
clark 100
smith 100
jones 300
jones 400
blake 200
clark 200
clark 300
smith 400
```

:fontawesome-solid-book-open:
[Implicit joins](joins.md#implicit-joins)

??? tip "You can refer explicitly to [namespaces](../basics/glossary.md#name-namespace)."

    ```q
    select (\`. \`toplevel) x from t
    ```

??? detail "Duplicate names for columns or groups"

    `select` auto-aliases colliding duplicate column names for either `select az,a from t`, or `select a by c,c from t`, but not for `select a,a by a from t`.

    Such a collision throws a `'dup names for cols/groups a` error during parse, indicating the first column name which collides. 
    (Since V4.0 2020.03.17.)

    ```q
    q)parse"select b by b from t"
    'dup names for cols/groups b
      [2]  select b by b from t
           ^
    ```

    The easiest way to resolve this conflict is to explicitly rename columns. e.g. `select a,b by c:a from t`.


When compiling functions, the implicit args `x`, `y`, `z` are visible to the compiler only when they are not inside the Select, By, and Where phrases. The table expression is not masked. This can be observed by taking the [`value`](../ref/value.md) of the function and observing the second item: the args.

```q
q)args:{(value x)1}
q)args{} / no explicit args, so x is a default implicit arg of identity (::)
,`x

q)/from phrase is not masked, y is detected as an implicit arg here
q)args{select from y where a=x,b=z}
`x`y
q)args{[x;y;z]select from y where a=x,b=z} / x,y,z are now explicit args
`x`y`z

q)/call with wrong number of args results in rank error
q){select from ([]a:0 1;b:2 3) where a=x,b=y}[0;2]
'rank
  [0]  {select from ([]a:0 1;b:2 3) where a=x,b=y}[0;2]
       ^

q)/works with explicit args
q){[x;y]select from ([]a:0 1;b:2 3) where a=x,b=y}[0;2]
a b
---
0 2
```


### Computed columns

In a subphrase, a q expression computes a new column or key, and a colon names it. 

```q
q)t:([] c1:`a`b`c; c2:10 20 30; c3:1.1 2.2 3.3)

q)select c1, c3*2 from t
c1 c3
------
a  2.2
b  4.4
c  6.6

q)select c1, dbl:c3*2 from t
c1 dbl
------
a  2.2
b  4.4
c  6.6
```

In the context of a query, the colon names a result column or key. It does not assign a variable in the workspace.

If a computed column or key is not named, q names it if possible as the leftmost term in the column expression, else as `x`. If a computed name is already in use, q suffixes it with `1`, `2`, and so on as needed to make it unique. 

```q
q)select c1, c1, 2*c2, c2+c3, string c3 from t
c1 c11 x  c2   c3
--------------------
a  a   20 11.1 "1.1"
b  b   40 22.2 "2.2"
c  c   60 33.3 "3.3"
```


### Virtual column `i`

A virtual column `i` represents the index of each record, i.e., the row number. 

??? detail "Partitioned tables"

    In a partitioned table `i` is the index (row number) relative to the partition, not the whole table.

Because it is implicit in every table, it never appears as a column or key name in the result. 

```q
q)select i, c1 from t
x c1
----
0 a
1 b
2 c

q)select from t where i in 0 2
c1 c2 c3
---------
a  10 1.1
c  30 3.3
```


### Where phrase

The Where phrase with a boolean list selects records.

```q
q)select from t where 101b
c1 c2 c3
---------
a  10 1.1
c  30 3.3
```

Subphrases specify _successive_ filters.

```q
q)select from t where c2>15,c3<3.0
c1 c2 c3
---------
b  20 2.2

q)select from t where (c2>15) and c3<3.0
c1 c2 c3
---------
a  10 1.1
b  20 2.2
c  30 3.3
```

The examples above return the same result but have different performance characteristics.

In the second example, all `c2` values are compared to 15, and all `c3` values are compared to 3.0. The two result vectors are ANDed together. 

In the first example, only `c3` values corresponding to `c2` values greater than 15 are tested. 

Efficient Where phrases start with their most stringent tests.

??? danger "Querying a partitioned table"

    When querying a partitioned table, the first Where subphrase should select from the value/s used to partition the table. 

    Otherwise, kdb+ will (attempt to) load into memory all partitions for the column/s in the first subphrase.

!!! tip "Use [`fby`](../ref/fby.md) to filter on groups."


## Aggregates

In SQL:

```sql
SELECT stock, SUM(amount) AS total FROM trade GROUP BY stock
```

In q:

```q
q)select total:sum amt by stock from trade
stock| total
-----| -----
bac  | 1000
ibm  | 2000
usb  | 815
```

The column `stock` is a key in the result table.

:fontawesome-solid-book-open:
[Mathematics](../basics/math.md) for more [aggregate functions](https://www.scaler.com/topics/sql/aggregate-function-in-sql/)


## Sorting

Unlike SQL, the query templates make no provision for sorting. 
Instead use [`xasc`](../ref/asc.md#xasc) and [`xdesc`](../ref/desc.md#xdesc) to sort the query results.

As the sorts are stable, they can be combined for mixed sorts.

```q
q)sp
s  p  qty
---------
s1 p1 300
s1 p2 200
s1 p3 400
s1 p4 200
s4 p5 100
s1 p6 100
s2 p1 300
s2 p2 400
s3 p2 200
s4 p2 200
s4 p4 300
s1 p5 400

q)`p xasc `qty xdesc select from sp where p in `p2`p4`p5
s  p  qty
---------
s2 p2 400
s1 p2 200
s3 p2 200
s4 p2 200
s4 p4 300
s1 p4 200
s1 p5 400
s4 p5 100
```


## Performance

-   Select only the columns you will use.
-   Use the most restrictive constraint first.
-   Ensure you have a suitable attribute on the first non-virtual constraint (e.g.`` `p`` or `` `g`` on sym).
-   Constraints should have the unmodified column name on the left of the constraint operator (e.g. where sym in syms,…)
-   When aggregating, use the virtual field first in the By phrase. (E.g. `select .. by date,sym from …`)

!!! tip 

    ``…where `g=,`s  within …``  
    Maybe rare to get much speedup, but if the `` `g `` goes to 100,000 and then `` `s `` is 1 hour of 24 you might see some overall improvement (with overall table of 30 million). 

  :fontawesome-solid-street-view:
  _Q for Mortals_
  [§14.3.6 Query Execution on Partitioned Tables](/q4m3/14_Introduction_to_Kdb%2B/#1436-query-execution-on-partitioned-tables)

## Multithreading

The following pattern will make use of secondary threads via `peach`

```q
select … by sym, … from t where sym in …, … 
```

when `sym` has a `` `g`` or `` `p`` attribute. (Since V3.2 2014.05.02)

It uses [`peach`](../ref/maps.md#each-parallel) for both in-memory and on-disk tables. For single-threaded, this is approx 6&times; faster in memory, 2&times; faster on disk, and uses less memory than previous releases – but mileage will vary. This is also applicable for partitioned DBs as

```q
select … by sym, … from t where date …, sym in …, …
```

:fontawesome-solid-graduation-cap:
[Table counts in a partitioned database](../kb/partition.md#table-counts)


## Special functions

The following functions (essentially `.Q.a0` in `q.k`) receive special treatment within `select`:

```txt
avg     first   prd  
cor     last    sum 
count   max     var  
cov     med     wavg
dev     min     wsum
```

When used explicitly, such that it can recognize the usage, q will perform additional steps, such as enlisting results or aggregating across partitions. However, when wrapped inside another function, q does not know that it needs to perform these additional steps, and it is then left to the programmer to insert them.

```q
q)select sum a from ([]a:1 2 3)
a
-
6
q)select {(),sum x}a from ([]a:1 2 3)
a
-
6
```


## Cond

[Cond](../ref/cond.md) is not supported inside qSQL expressions.

```q
q)u:([]a:raze ("ref/";"kb/"),\:/:"abc"; b:til 6)
q)select from u where a like $[1b;"ref/*";"kb/*"]
'rank
  [0]  select from u where a like $[1b;"ref/*";"kb/*"]
                                  ^
```

Enclose in a lambda

```q
q)select from u where a like {$[x;"ref/*";"kb/*"]}1b
a       b
---------
"ref/a" 0
"ref/b" 2
"ref/c" 4
```

or use the [Vector Conditional](../ref/vector-conditional.md) instead.


## Functional SQL

The interpreter translates the query templates into [functional SQL](funsql.md) for evaluation. The functional forms are more general, and some complex queries require their use. 
But the query templates are powerful, readable, and there is no performance penalty for using them. 

!!! tip "Wherever possible, prefer the query templates to functional forms."


## Stored procedures

Any suitable lambda can be used in a query.

```q
q)f:{[x] x+42}
q)select stock, f amount from trade
stock amount
------------
ibm   542
...
```


## Parameterized queries

Query template expressions can be evaluated in lambdas.

```q
q)myquery:{[tbl; amt] select stock, time from tbl where amount > amt}
q)myquery[trade; 100]
stock time
------------------
ibm   09:04:59.000
...
```

Column names cannot be parameters of a qSQL query. Use [functional qSQL](../basics/funsql.md) in such cases.


## Queries using SQL syntax

Q implements a translation layer from SQL. The syntax is to prepend `s)` to the SQL query.

```q
q)s)select * from trade
```

!!! warning "Only a subset of SQL is supported."


----
:fontawesome-solid-book:
[`fby`](../ref/fby.md),
[`insert`](../ref/insert.md),
[`upsert`](../ref/upsert.md),
<br>
:fontawesome-solid-book-open:
[Functional SQL](funsql.md)
<br>
:fontawesome-solid-graduation-cap:
[Views](../learn/views.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.0 Queries: q-sql](/q4m3/9_Queries_q-sql/#90-overview)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.9.10 Parameterized Queries](/q4m3/9_Queries_q-sql/#999-parameterized-queries)
