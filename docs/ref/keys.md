# `keys`




_Key column/s of a table_

Syntax: `keys x`, `keys[x]`

Where `x` is a table (by value or reference), returns as a symbol vector the primary key column/s of `x` – empty if none.

```q
q)\l trade.q        / no keys
q)keys trade
`symbol$()
q)keys`trade
`symbol$()
q)`sym xkey`trade   / define a key
q)keys`trade
,`sym
```


<i class="far -fa-hand-point-right"></i>
Basics: [Metadata](../basics/metyadata.md)