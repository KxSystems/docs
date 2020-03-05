---
title: Table formation and access | Kdb+ database and language primer | Documentation for kdb+ and q
author: Dennis Shasha (shasha@cs.nyu.edu)
description: Introduction to the kdb+ database and q language, used for Dennis Sasha’s college classes
hero: <i class="fas fa-graduation-cap"></i> Kdb+ database and language primer
---
# Tables




A table is just a list of similar dictionaries. Since the keys are all the same they are shown just once at the top.

```q
q)d1:`name`salary`dob!(`Tom;30;1984.07.05)
q)d2:`name`salary`dob!(`Dick;35;1979.09.15)
q)d3:`name`salary`dob!(`Harry;40;1960.11.16)
q)(d1;d2;d3)
name  salary dob
-----------------------
Tom   30     1984.07.05
Dick  35     1979.09.15
Harry 40     1960.11.16
```


## Construction

There are more convenient ways to make a table. One is table notation.

```q
q)([]name:`Tom`Dick`Harry; salary:30 35 40; dob:1984.05.07 1979.09.15 1960.11.16)
name  salary dob
-----------------------
Tom   30     1984.05.07
Dick  35     1979.09.15
Harry 40     1960.11.16
```

Here we see the table specified as three named vectors. Most table columns _are_ vectors (i.e. of homogenous type), and this is how kdb+ represents them internally. 

Think of a table as _both_ a list of dictionaries, _and_ a list of named vectors.

That suggests another way to make a table.

```q
q)show d:`name`salary`dob ! (`Tom`Dick`Harry;30 35 40;1984.07.05 1979.9.15 1960.11.16)
name  | Tom        Dick       Harry
salary| 30         35         40
dob   | 1984.07.05 1979.09.15 1960.11.16

q)show t:flip d
name  salary dob
-----------------------
Tom   30     1984.07.05
Dick  35     1979.09.15
Harry 40     1960.11.16
```

Above, `d` is a dictionary in which all the values are same-length vectors. 
Flipping it returns a table.

!!! tip "Flip" 

    Understand the word _flip_ as suggesting the swapping of columns for rows in the geometrical sense described here. If you like linear algebra, think matrix transposition. 

    The reason this ‘flipped’ representation is convenient is that we can index the table as if were an array. There are other advantages as well.

You will be able to accomplish much of what you need to get done in q using qSQL queries, drawing on your knowledge of SQL.

When you need to, you will also be able to work with table columns as vectors, using q’s powerful vector operations.


## Order and indexing

Like dictionaries, and unlike SQL tables, q tables are _ordered_.

```q
q)first t
name  | `Tom
salary| 30
dob   | 1984.07.05
q)t[0]
name  | `Tom
salary| 30
dob   | 1984.07.05
```

Thinking of the table as a list of dictionaries, it is unsurprising that an item is a dictionary. 

And two items?

```q
q)t 2 0
name  salary dob
-----------------------
Harry 40     1960.11.16
Tom   30     1984.07.05
```

Thinking of the table as a list of dictionaries, it is unsurprising that a list of two dictionaries is – another table. 

We can also index a table by its column names.

```q
q)t `salary
30 35 40
q)t `name`dob
Tom        Dick       Harry
1984.07.05 1979.09.15 1960.11.16
```

Indexing `t` with a single column name `salary` returns the salary column as a vector.

Indexing `t` with two column names returns a list of two same-length vectors – a matrix. 

Indexing `t` with both item and column name selects an atom.

```q
q)t[1;`dob]
1979.09.15

q)t[2 0;`name`dob]
`Harry 1960.11.16
`Tom   1984.07.05
```

Indexing `t` with lists of items and column names returns a matrix. 


## Key fields

Now let’s look at the implications of having a key field.

```q
q)u:t
q)`name xname `u
'xname
  [0]  `name xname `u
             ^
q)`name xkey `u
`u
q)u
name | salary dob
-----| -----------------
Tom  | 30     1984.07.05
Dick | 35     1979.09.15
Harry| 40     1960.11.16
```

Table `u` is a copy of `t` in which the `name` column has been declared as a key. 

That means we can now index `u` with a value from the `name` column.

```q
q)u `Tom
salary| 30
dob   | 1984.07.05
```

The display for `u` looks a bit like a dictionary, but with a 1-column table as the key. Anything in that?

```q
q)key u
name
-----
Tom
Dick
Harry
```

Oh, yes. And since `` u `Tom`` is a dictionary, then the value of dictionary `u` would be a _list_ of dictionaries – a table.

```q
q)value u
salary dob
-----------------
30     1984.07.05
35     1979.09.15
40     1960.11.16
```


## Operations on tables

Make a table of employee salaries and make the names the key.

```q
q)e2:select name,salary from t
q)`name xkey `e2
`e2
q)e2
name | salary
-----| ------
Tom  | 30
Dick | 35
Harry| 40
```

Double everyone’s salary!

```q
q)e2+e2
name | salary
-----| ------
Tom  | 60
Dick | 70
Harry| 80
```

Just kidding. But note that all fields are updated. 

We could also have multiplied the table by 2.

```q
q)e2*2
name | salary
-----| ------
Tom  | 60
Dick | 70
Harry| 80
```

Instead, hire a PA and two q programmers.

```q
q)show e3:e2,([name:`Alice`Ted`Carol]salary:130 15 235)
name | salary
-----| ------
Tom  | 30
Dick | 35
Harry| 40
Alice| 130
Ted  | 15
Carol| 235
```

Give raises to the first employees.

```q
q)e3+([name:`Tom`Harry`Dick]salary: 5 4 6)
name | salary
-----| ------
Tom  | 35
Dick | 41
Harry| 44
Alice| 130
Ted  | 15
Carol| 235
```

Upsert semantics at work again. 

Oops. Forgot Anne.

```q
q)`e3 insert(`Anne;50) / this will be the 7th tuple
,6
q)e3
name | salary
-----| ------
Tom  | 30
Dick | 35
Harry| 40
Alice| 130
Ted  | 15
Carol| 235
Anne | 50
```


## qSQL

```q
q)show mytab:([]x: 1 2 3; y: 10 20 30)
x y
----
1 10
2 20
3 30

q)select x from mytab where y = 20
x
-
2

q)select x,y from mytab where y < 21
x y
----
1 10
2 20
```

These last two return tables, single and double column. 
Sometimes we don't want to return a table, but some simpler type. 
In that case, we use the verb [`exec`](../../ref/exec.md).

```q
q)exec x from mytab where y < 21
1 2
```

<i class="fas fa-book-open"></i>
[qSQL](../../basics/qsql.md)


## Multiple keys

Here are two create-table statements. 
Both have columns `a` and `b` as keys, as indicated by the brackets. 
(The closing right bracket obviates the need for a semi-colon.)

```q
q)show 1:([a:2 3 4 5; b:30 40 30 40] c:10 20 30 40)
a b | c
----| --
2 30| 10
3 40| 20
4 30| 30
5 40| 40

q)show t2:([a:2 3 2 3; b:30 30 40 40] c:4 2 8 9)
a b | c
----| -
2 30| 4
3 30| 2
2 40| 8
3 40| 9
```

As with the keyed table `e2` above, `t1` and `t2` are displayed, and can be thought of, as dictionaries in which both the key and the value are tables.

```q
q)t1-t2
a b | c
----| --
2 30| 6
3 40| 11
4 30| 30
5 40| 40
3 30| -2
```

The first entry is the result of subtracting 10-4. 
The second is 20-9. 
In both cases the keys match. 
The next two entries `(4;30)` and `(5;40)` are present only in `t`. 
The last two are present only in `u`. 


## Remove keys

`0!t` eliminates the keys from `t`. This is sometimes useful.
```q
q)show z:0!t
a b  c
-------
2 30 10
3 40 20
4 30 30
5 40 40
```

---
<i class="far fa-hand-point-right"></i>
[Operations](operations.md)