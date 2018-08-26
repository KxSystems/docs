# `ssr`


Syntax: `ssr[x;y;z]` (prefix, rank-3)

String search (using `ss`) and replace: where

- `x` is a string
- `y` is a pattern
- `z` is a string or a function

returns `x` with each substring matching `y` replaced by:

- `z` if `z` is a string 
- `z[Y]` where `z` is a function and `Y` is the matched substring
```q
q)s:"toronto ontario"
q)ssr[s;"ont";"x"]      / replace "ont" by "x"
"torxo xario"
q)ssr[s;"t?r";upper]    / replace matches by their uppercase
"TORonto onTARio"
```

<i class="far fa-hand-point-right"></i> [Strings](/basics/strings), [Regular expressions](/kb/regex), [`like`](/ref/like), [`ss`](/ref/ss)

