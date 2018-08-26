# `$` Pad


Syntax: `x$y`, `$[x;y]` 

Where 

-   `x` is a long
-   `y` a string

returns `y` padded to length `x`.
```q
q)10$"foo"
"foo       "
q)-10$"foo"
"       foo"
```

<i class="far fa-hand-point-right"></i> 
[Strings](/basics/strings),
[`$`](ref/overloads/#dollar)