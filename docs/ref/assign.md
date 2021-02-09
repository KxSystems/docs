---
title: Assign operator | Reference | kdb+ and q documentation
description: Name a value in q
author: Stephen Taylor
---
# Assign

_Name a value; amend a named value_


## Simple assign

Syntax: `x:y`

Where `x` is a name and `y` is a value, the value of `y` is associated with the name `x`.

```q
q)a:42        / assign
q)a
42
q)a:3.14159   / amend
```

!!! warning "The Equal operator  `=` tests equality. It has nothing to do with naming or amending values."


## Indexed assign

Syntax: `x[i]:y`

Where 

-   `x` is the name of a list, dictionary or table
-   `i` is a value that indexes `x`

the value of `y` is assigned to `x` at indexes `i`. 
Where `x` is a dictionary, assignment has upsert semantics.

```q
q)d:`tom`dick`harry!1 2 3
q)d[`dick`jane]:100 200
q)d
tom  | 1
dick | 100
harry| 3
jane | 200
```


## Assign through operator

Syntax: `x op:y`, `x[i]op:y`

Where 

-   `x` is a name
-   `i` is a value that indexes `x`
-   `op` is a binary operator with infix syntax and  `x` in its left domain
-   `y` is a value in the right domain of `op`

the value of `x` (at indexes `i` if specified) becomes `x op y`. 

```q
q)s:("the";"quick";"brown";"fox")
q)s[1 2],:("er";"ish")
q)s
"the"
"quicker"
"brownish"
"fox"
```

??? tip "This is syntactic sugar for [Amend At](amend.md)."

    <pre><code class="language-q">
    q)s:("the";"quick";"brown";"fox")
    q)@[s;1 2;,;("er";"ish")]
    "the"
    "quicker"
    "brownish"
    "fox"
    </code></pre>

    The functional form is more general, and extends assignment-through-operator to derived functions, keywords and lambdas.

If `x` is undefined, the [identity element](../basics/glossary.md#identity-element) for `op` is used as a default.

```q
q)bar
'bar
  [0]  bar
       ^
q)bar+:1
q)bar
1
```

----
:fontawesome-solid-book:
[Amend, Amend At](../ref/amend.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§4.6.2 Simple q Amend](/q4m3/4_Operators/#462-simple-q-amend)

