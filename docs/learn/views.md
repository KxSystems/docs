---
title: Views in kdb+ – Learn – kdb+ and q documentation
description: A view is a calculation that is re-evaluated only if the values of the underlying dependencies have changed since its last evaluation.
keywords: kdb+, q,view
---
# Views



A view is a calculation that is re-evaluated only if the values of the underlying dependencies have changed since its last evaluation.


## Why use a view?

Views can help avoid expensive calculations by delaying propagation of change until a result is demanded.


## How is a view defined?

Views and their dependencies can be defined only in the default namespace.

The syntax for the definition is

```q
q)viewname::[expression;expression;…]expression
```

!!! warning "Terminating semicolon"

    The result returned by a view is the result of the last expression in the list, just as in a lambda.

    <pre><code class="language-q">
    q)a: til 5
    q)uu:: a
    q)uu
    0 1 2 3 4
    q)vv:: a;
    q)vv
    q)vv ~ (::)
    1b
    q)vv ~ {[];}[]
    1b
    </code></pre>

The following defines a view called `myview` which depends on vars `a` and `b`.

```q
q)myview::a+b
q)a:1
q)b:2
q)myview
3
```

Defining a view does not trigger its evaluation.

A view should not have side-effects, i.e. should not update global variables. Although `;` is permitted at the end of the definition, it would mean the view returns `(::)`. As a view should have no side-effects, returning `(::)` would make the purpose of the view redundant.

A view definition can be spread over multiple lines in a script as long as it is indented accordingly (e.g. exactly like a function definition). e.g.

```bash
$cat v.q
t:([]a:til 10)
myview::select from t
 where a<5 / note this line is indented by one space
$q v.q
KDB+ 3.2 2014.08.26 Copyright (C) 1993-2014 Kx Systems
m64/...
```

```q
q)myview
a
-
0
1
2
3
4
```

Within a lambda, `::` amends a global variable. It does not define a view.

```q
q)x:2
q)y:3
q)v::x+y           /view
q)v
5
q)x:10000
q)v                /depends on x
10003
q){v::x+y}[10;20]  /v now a global variable
q)v
30
q)x:-1000000
q)v                /global variable, no longer depends on x
30
```


## How to list views

Invoke the `views` function (or `\b`) to get a list of the defined views.

```q
q)a::b+c
q)d::b+a
q)views`
`s#`a`d
```


## How to list invalidated views

Invalidated (pending) views are awaiting recalculation.

Invoking `\B` will return a list of pending views.

```q
q)a::b+c
q)\B
,`a
q)b:c:1
q)\B
,`a
q)a
2
q)\B
`symbol$()
```

!!! tip "Splayed tables"

    To use views with splayed tables make sure you invalidate the data when it changes; this can be done for example by reloading the table.


## How to see the definition of a view

The text definition of a view can be seen with ``view `viewname``.

```q
q)a::b+c
q)view`a
"b+c"
```

The following `view` command has the form `` `. `viewName``. Note the space between `` `.`` and `` `viewname``.

```q
q)d::b+a
q)`. `d
b+a
```

`value` on that reveals the underlying representation:

- (last result|::)
- parse-tree
- dependencies
- text

```q
q)value`. `d
::
(+;`b;`a)
`b`a
"b+a"
```

If previously evaluated, the last result can be seen here as the first element.

```q
q)b:1;a:2
q)d
3
q)value`. `d
3
(+;`b;`a)
`b`a
"b+a"
```

A view which uses select/exec/update/delete is worth mentioning as it may not be immediately obvious what dependencies are present. e.g. in the following example, `t` is the only dependency, as `a` and `b` may be columns in `t`, or globals – this is not known until the `select` is evaluated and hence cannot be inferred as dependencies.

```q
q)v::select from t where a in b
q)value`. `v
::
(?;`t;,,(in;`a;`b);0b;())
,`t
"select from t where a in b"
```

If `a` or `b` are globals to be dependencies, a workaround is for these is to be mentioned at the beginning of the definition, e.g.

```q
q)v::a;b;select from t where a in b
q)value`. `v
::
(";";`a;`b;(?;`t;,,(in;`a;`b);0b;()))
`a`b`t
"a;b;select from t where a in b"
```

If a function is used within a view, that does not become a dependency. The following view would not be invalidated unless the `f` were redefined.

```q
q)v::f[]+1
q)f:{42}
q)v
43
q)value`. `v
43
(+;(`f;::);1)
,`f
"f[]+1"
```


## Self-referencing views

Self-referencing views are allowed since V3.2. A self-referencing view is a view that includes itself as part of the calculation. In such a case, the view uses its previous value as part of the evaluation if it exists, otherwise it signals `'loop`. e.g.

```q
q)v::$[b;1;v+1]
q)b:1;0N!v;b:0;v
q)v::$[b;1;v+1]
q)v
'loop
```

From V3.2 view-loop detection is no longer performed during view creation; it is checked during the view recalc.


## Dot notation

Views do not support dot notation.

```q
q)t:.z.p
q)t1::t
q)t.date
2014.09.03
q)t1.date
'nyi
```


## Multithreading

Views must be evalulated on the main thread, otherwise the calculation will signal `'threadview`. E.g. with q using two secondary threads

```bash
$q -s 2
KDB+ 3.2 2014.08.26 Copyright (C) 1993-2014 Kx Systems
m64/...
```

```q
q)a::b+c
q)b:c:1
q){a}peach 0 1
k){x':y}
'threadview
@
{a}':
0 1
q.q))\
q)a
2
q){a}peach 0 1
2 2
```


## Parse

Views are not parsable, e.g. `eval parse "a::b+c"`

---
:fontawesome-solid-book:
[`view`](../ref/view.md), [`views`](../ref/view.md),
[`.z.b`](../ref/dotz.md#zb-dependencies "dependencies"),
[`.z.vs`](../ref/dotz.md#zvs-value-set "value set")
<br>
:fontawesome-solid-book-open:
[`\b`](../basics/syscmds.md#b-views "views"),
[`\B`](../basics/syscmds.md#b-pending-views "pending views")
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§9.9.11 Views](/q4m3/9_Queries_q-sql/#9911-views)
