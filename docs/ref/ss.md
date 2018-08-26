# `ss`


Syntax: `x ss y`, `ss[x;y]` (infix or prefix, binary)

String search: returns position/s of substring `y` within string `x`.
```q
q)"We the people of the United States" ss "the"
3 17
```
It also supports some of the pattern-matching capabilities of `like`.
```q
q)s:"toronto ontario"
q)s ss "ont"
3 8
q)s ss "[ir]o"
2 13
q)s ss "t?r"
0 10
```

<i class="far fa-hand-point-right"></i> [Strings](/basics/strings), [Regular expressions](/kb/regex), [`like`](/ref/like), [`ssr`](/ref/ssr)

