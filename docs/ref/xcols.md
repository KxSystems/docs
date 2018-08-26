# `xcols`




Syntax: `x xcols y`, `xcols[x;y]`

Where 

-   `y` is a simple table (passed by value) 
-   `x` is a symbol vector of some or all of `y`’s column names

returns `y` with `x` as its first column/s.

```q
q)\l trade.q
q)cols trade
`time`sym`price`size
q)trade:xcols[reverse cols trade;trade] / reverse cols and reassign trade
q)cols trade
`size`price`sym`time
q)trade:`sym xcols trade                / move sym to the front
q)cols trade
`sym`size`price`time
```


<i class="far fa-hand-point-right"></i> 
[Dictionaries & tables](../basics/dictsandtables.md),
[`.Q.V`](dotq.md#qv-table-to-dict) (table to dictionary) 
