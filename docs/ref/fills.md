# `fills`




_Return list with nulls replaced by preceding non-nulls_

Syntax: `fills x`, `fills[x]` 

Where `x` is a list, returns `x` with any null items replaced by their preceding non-null values, if any.

`fills` is a uniform function. 

```q
q)fills 0N 2 3 0N 0N 7 0N
0N 2 3 3 3 7 7
```

To back-fill, reverse the list and the result:

```q
q)reverse fills reverse 0N 2 3 0N 0N 7 0N
2 2 3 7 7 7 0N
```

For a similar function on infinities, first replace them with nulls:

```q
q)fills {(x where x=0W):0N;x} 0N 2 3 0W 0N 7 0W
0N 2 3 3 3 7 7
```

