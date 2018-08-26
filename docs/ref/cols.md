# `cols`




_Column names of a table_

Syntax: `cols x`, `cols[x]`

Where `x` is a table, returns as a symbol vector its column names. 

`x` can be passed by reference or by value.

```q
q)\l trade.q
q)cols trade            /value
 `time`sym`price`size
q)cols`trade            /reference
 `time`sym`price`size
```


<i class="far fa-hand-point-right"></i>
Basics: [Metadata](../basics/metadata.md)