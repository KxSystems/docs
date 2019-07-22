---
title: select, Select
description: select and Select are (respectively) a q keyword and operator that select all or part of a table, possibly with new columns.
author: Stephen Taylor
keywords: column, kdb+, q, qsql, query, select, sql, table
---
# `select`, `?` Select





_Select all or part of a table, possibly with new columns_


## `select`

Syntax: `select [cols] [by groups] from t [where filters]`

`select` retrieves specified columns from a table. It has many forms; not all are described here. 

A `by` clause with no `cols` specified returns the last row in each group.

```q
q)tbl:([] id:1 1 2 2 2;val:100 200 300 400 500)
q)select by id from tbl
id| val
--| ---
1 | 200
2 | 500
```


### Limiting results

To limit the returned results you can also use these forms:

```q
select[n]
select[m n]
select[order]
select[n;order]
```

where 

-   `n` limits the result to the first `n` rows of the selection if positive, or the last `n` rows if negative 
-   `m` is the number of the first row to be returned: useful for stepping through query results one block of `n` at a time
-   `order` is a column (or table) and sort order: use `<` for ascending, `>` for descending

```q
select[3;>price] from bids where sym=s,size>0
```

This would return the three best prices for symbol `s` with a size greater than 0.

This construct works on in-memory tables but not on memory-mapped tables loaded from splayed or partitioned files. 

Where there is a by-clause, and no sort order is specified, the result is sorted ascending by its key.

!!! tip "Performance characteristic"

    `select[n]` applies the where-clause on all rows of the table, and takes the first `n` rows, before applying the select-clause. So if you are paging it is better to store the result of the query somewhere and `select[n,m]` from there, rather than run the filter again.


### Performance 

-   Select only the columns you will use.
-   Use the most restrictive constraint first.
-   Ensure you have a suitable attribute on the first non-virtual constraint (e.g.`` `p`` or `` `g`` on sym).
-   Constraints should have the unmodified column name on the left of the constraint operator (e.g. where sym in syms,…)
-   When aggregating, use the virtual field first in the by-clause. (E.g. `select .. by date,sym from …`)

!!! tip 

    ``…where `g=,`s  within …``  
    Maybe rare to get much speedup, but if the `` `g `` goes to 100,000 and then `` `s `` is 1 hour of 24 you might see some overall improvement (with overall table of 30 million). 


### Multithreading

The following pattern will make use of slave threads via `peach`

```q
select … by sym, … from t where sym in …, … 
```

when `sym` has a `` `g`` or `` `p`` attribute. (Since V3.2 2014.05.02)

It uses [`peach`](../ref/maps.md#each-parallel) for both in-memory and on-disk tables. For single-threaded, this is approx 6&times; faster in memory, 2&times; faster on disk, and uses less memory than previous releases – but mileage will vary. This is also applicable for partitioned DBs as

```q
select … by sym, … from t where date …, sym in …, …
```


### Special functions

The following functions (essentially `.Q.a0` in `q.k`) receive special treatment within `select`:

`count`, `first`, `last`, `sum`, `prd`, `min`, `max`, `med`, `avg`, `wsum`, `wavg`, `var`, `dev`, `cov`, `cor`

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


!!! warning "Cond is not supported inside q-SQL expressions"

    Enclose in a lambda or use [Vector Conditional](vector-conditional.md) instead.

    <i class="far fa-hand-point-right"></i>
    [q-SQL](../basics/qsql.md#cond)



### Name resolution

Resolution of a name within select/exec/update is as follows:

1.  column name
1.  local name in (or param of) the encapsulating function
1.  global name in the current working namespace – not necessarily the space in which the function was defined

!!! tip 

    You can [refer explicitly to namespaces](../basics/glossary.md#name-namespace):

    <pre><code class="language-q">
    select (\`. \`toplevel) x from t
    </code></pre>


### Implicit arguments

When compiling functions, the implicit args `x`, `y`, `z` are visible to the compiler only when they are not inside the select-, by- and where-clauses. The from-clause is not masked. This can be observed by taking the [`value`](value.md) of the function and observing the second item: the args.

```q
q)args:{(value x)1}
q)args{} / no explicit args, so x is a default implicit arg of identity (::)
,`x
q)/from clause is not masked, y is detected as an implicit arg here
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

<i class="far fa-hand-point-right"></i>
_Q for Mortals_: [§9.3 The `select` Template](/q4m3/9_Queries_q-sql/#93-the-select-template)  
Basics: [qSQL](../basics/qsql.md)



## `?` Select

<i class="far fa-hand-point-right"></i>
For functional Select, see Basics: [Functional qSQL](../basics/funsql.md#select)

