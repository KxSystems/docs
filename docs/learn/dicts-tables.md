---
title: Dictionaries & tables
description: How to handle dictionaries and tables in q
keywords: dictionary, kdb+, q, tutorial, table
---
# Dictionaries & tables




A simple table is a list of dictionaries.

To illustrate this, we can create a table out of a dictionary.

```q
q)dict
sym   | `ibm
volume| 100
q)enlist dict
sym volume
----------
ibm 100
```

If we replicate the single item of that list, we get a table with copies of the same row.

```q
q)3 # enlist dict
sym volume
----------
ibm 100
ibm 100
ibm 100
```

A _keyed table_ is not a list. It’s a dictionary. It maps each row in a table of unique keys to a corresponding row in a table of values.

```q
q)kt
sym| volume
---| ------
ibm| 100
amd| 200
```

The key in the dictionary is a table.

```q
q)key kt
sym
---
ibm
amd
```

and so is the value stored in the dictionary.

```q
q)value kt
volume
------
100
200
```

This difference in representation affects the operations that are supported by each kind of table. We can illustrate the differences with an example. Let’s define two keyed tables and two simple ones with the same contents.

```q
q)kt:([sym:`ibm`amd] volume:100 200)
q)ku:([sym:`amd`intel] volume:300 400)

q)t:([]sym:`ibm`amd; volume:100 200)
q)u:([]sym:`amd`intel; volume:300 400)
```

Positional indexing works on simple tables, but not on keyed ones.

```q
q)t[0]
sym   | `ibm
volume| 100
q)kt[0]
'type
```

On the other hand, we can index keyed tables by key.

```q
q)t[`ibm]
`symbol$()
q)kt[`ibm]
volume| 100
q)kt[`notpresent]
volume|
```

The result of the `,` operator depends on the type of table arguments.

```q
q)t,u
sym   volume
------------
ibm   100
amd   200
amd   300
intel 400
q)kt,ku
sym  | volume
-----| ------
ibm  | 100
amd  | 300
intel| 400
q)kt,u
'type
```

And the same is true for table arithmetic.

```q
q)t+u
'type
q)kt+ku
sym  | volume
-----| ------
ibm  | 100
amd  | 500
intel| 400
q)kt+u
sym| volume sym
---| ------------
ibm| 400    amd
amd| 600    intel
```

Finally, let's check the result of `^` ([Fill](../ref/fill.md)).

```q
q)kr:([sym:`ibm`amd]; price:10 20)
q)kt^kr
sym| volume price
---| ------------
ibm| 100    10
amd| 200    20
q)t^kr
sym| sym volume price
---| ----------------
ibm| ibm 100    10
amd| amd 200    20
```

