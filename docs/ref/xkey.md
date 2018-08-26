# `xkey`



_Set specified columns as primary keys of a table_

Syntax: `x xkey y`, `xkey[x;y]`

Where symbol atom or vector `x` lists columns in table `y`, which is passed by 

- value, returns 
- reference, updates 

`y` with `x` set as the primary keys.

```q
q)\l trade.q
q)keys trade
`symbol$()            / no primary key
q)`sym xkey trade     / return table with primary key sym
sym| time         price size
---| -----------------------
a  | 09:30:00.000 10.75 100
q)keys trade         / trade has not changed
`symbol$()
q)`sym xkey `trade   / pass trade by reference updates the table in place
`trade
q)keys trade         / sym is now primary key of trade
,`sym
```

<i class="far fa-hand-point-right"></i> 
[Dictionaries & tables](../basics/dictsandtables.md),
[`.Q.ff`](dotq/#qff-append-columns) (append columns)