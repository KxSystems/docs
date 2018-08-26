# `xcol`



_Rename table columns_

Syntax: `x xcol y`

Where 

-   `y` is a table (passed by value) 
-   `x` is a symbol vector of length no greater than `count cols y`

returns `y` with its first `count x` columns renamed. 

```q
q)\l trade.q
q)cols trade
`time`sym`price`size
q)`Time`Symbol xcol trade           / rename first two columns
Time         Symbol price size
------------------------------
09:30:00.000 a      10.75 100
q)trade:`Time`Symbol`Price`Size xcol trade  / rename all and assign
q)cols trade
`Time`Symbol`Price`Size
```


<i class="far fa-hand-point-right"></i> 
[Dictionaries & tables](../basics/dictsandtables.md)