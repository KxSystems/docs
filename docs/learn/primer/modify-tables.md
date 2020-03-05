---
title: Modifying tables in kdb+ | Kdb+ database and language primer | Documentation for kdb+ and q
author: Dennis Shasha (shasha@cs.nyu.edu)
description: Modifying tables in q and kdb+
hero: <i class="fas fa-graduation-cap"></i> Kdb+ database and language primer
---
# Modifying tables






We’ve already seen how to build tables from dictionaries or from direct statements. SQL 92-style inserts, updates and deletes are also possible. Q adds the notion of upserts as shown earlier.

Make a table with no rows. (A schema.)

```q
q)book:([book: ()] language: (); numprintings: ())
```

!!! tip "Specify types in a schema"

    `()` is the generic empty list, so the table columns in the `book` schema can accept initial values of any type. But usually when specifying a schema, we know what datatypes it is to hold. Setting them explicitly helps the reader, and prevents unexpected data setting an unexpected datatype.

    The best way to specify an empty list of any type is `0#`.

    <pre><code class="language-q">([book: 0#`] language: 0#`; numprintings: 0#0)</code></pre>

<i class="fas fa-book-open"></i>
[Datatypes](../../basics/datatypes.md)

```q
q)insert[`book;(`forwhomthebelltolls; `english; 3)]
,0
q)book
book               | language numprintings
-------------------| ---------------------
forwhomthebelltolls| english  3
```

`insert` is a binary keyword, but it can also be applied with infix syntax.
Since infix syntax is easier to read, we shall use it.

```q
q)`book insert (`salambo; `french; 9)
,1
```

The left (first) argument of `insert` is a symbol naming the table `book`. 
It could also have been the plain name of the table: ``book insert (`salambo;`french;9)``. These are respectively _call-by-name_ and _call-by-value_. 

In qSQL queries, call-by-name operates on the table ‘in place’. In the `insert` query, the result was the number of the row just added. In contrast, call-by-value returns the entire amended table:

```q
q)show book: update language:`French from book where book=`salambo
book               | language numprintings
-------------------| ---------------------
forwhomthebelltolls| english  3
salambo            | French   9
```

!!! tip "When amending a large table, call-by-name allows kdb+ to avoid copying data."

Make a copy of `book`, but with no rows. Insert some rows.

```q
q)show book2:0#book
book| language numprintings
----| ---------------------

q)`book2 insert (`secretwindow; `english; 4)
q)`book2 insert (`salambo; `Fch; 9)
q)`book2 insert(`shining; `english; 2)

q)show book3:book,book2
book               | language numprintings
-------------------| ---------------------
forwhomthebelltolls| english  3
salambo            | Fch      9
secretwindow       | english  4
shining            | english  2
```

In `book3` the language of _Salambo_ has changed from `French` (from `book`) to `Fch` (from `book2`). 

The Join operator (`,`) inserted rows where the key value is new, and replaced them where the key value matched.
These ‘upsert semantics’ work because `book` and `book2` are both keyed tables.

```q
q)count select from book3
4
```

The expression above is similar to SQL-92. 

Recall that a table is a list of dictionaries, that we can mix q and qSQL, and that we can count a list.

```q
q)delete from `book3 where book=`secretwindow
`book3
q)count book3
3
```

<i class="fas fa-book-open"></i>
[qSQL](../../basics/qsql.md)

---
<i class="far fa-hand-point-right"></i>
[Appendix 1: Temporal primitives](temporal-primitives.md)