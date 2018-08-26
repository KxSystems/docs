# `view`





_Expression defining a view_

Syntax: `view x`, `view[x]`

Where `x` is a view (by reference), returns the expression defining `x`.

```q
q)v::2+a*3                        / define dependency v
q)a:5
q)v
17
q)view `v                         / view the dependency expression
"2+a*3"
```

<i class="far fa-hand-point-right"></i> 
Tutorials: [Views](../tutorials/views.md)


