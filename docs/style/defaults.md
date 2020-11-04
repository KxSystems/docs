---
author: Stevan Apter
keywords: argument, default, kdb+, null, q, style
---

# Defaults


## Use null to mean default value

In multidimensional indexing, q uses null (`::`) to mean “all”. 

```q
m[;2 3]            / columns 2 and 3 and all of the rows
```

Follow suit; for example

```q
copy:{[table;fields]
  …
  if[fields~::;fields:til table];
  …
  }
```


## Interpret `()` as none

```q
copy:{[table;fields]
  if[fields~();:()];
  if[fields~::;fields:til table];
  …
  }
```

If the arguments to a function are not independent, order them left-to-right in dependency order. That is, argument `i` restricts the choice made by argument `i-1`. In particular, try to arrange things so that if argument `i` is null, all arguments to the right of `i` are logically null. In the example above, it would be a mistake to order the arguments

```q
copy:{[fields;table]
  …
  }
```


## Let null mean ‘none’ if ‘none’ is the default

```q
foo:{
  if[x~::;x:()]
  …
  }
```

