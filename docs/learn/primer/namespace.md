---
title: Namespaces in q | Kdb+ database and language primer | Documentation for kdb+ and q
author: Dennis Shasha (shasha@cs.nyu.edu)
description: Namespaces in q
hero: <i class="fas fa-graduation-cap"></i> Kdb+ database and language primer
---
# Appendix 6: Namespaces




The kdb+ session is divided into namespaces. (Sometimes called _directories_ or _contexts_). Namespaces allow you to divide code into modules.

Namespaces can be nested. 
Use dots to indicate the path in such namespaces.

```q
q)b:3       / default namespace
q)c:4       / default namespace

q).cx.b:5   / namespace .cx
q).cx.c:6   / namespace .cx
q).cx.d:17  / namespace .cx

q)key `.cx  / objects in .cx namespace
``b`c`d
```

The default namespace is `` `.``.

```q
q)key `.    / objects in default namespace
`b`c
```

Like a command shell, q always has a current namespace.

```q
q)\d .cx            / enter namespace .cx
q.cx)b
5
q.cx)value `b       / b in this namespace
5
q.cx)value `.`b     / global b
3
q.cx)\d .           / back to default namespace

q)\d                / show current namespace 
`.
```

In any context, 

-   an object in the same context can be referred to by its unqualified name 
-   an object in another namespace can be referred to by its fully-qualified name

The [`\f`](../../basics/syscmds.md#f-functions) and [`\v`](../../basics/syscmds.md#v-variables) system commands list (respectively) the names of functions and variables in the current namespace.

The [`system`](../../ref/system.md) keyword lets you capture these lists.

```q
q)x: system"f"
```


## System namespaces 

System namespaces have single-letter names (all reserved for use by Kx) and contain useful functions, variable and callbacks. 

<i class="fas fa-book"></i>
[`.h` namespace](../../ref/doth.md),
[`.j` namespace](../../ref/dotj.md),
[`.Q` namespace](../../ref/dotq.md),
[`.z` namespace](../../ref/dotz.md)

---

This completes the _Kdb+ Database and Language Primer_.

<i class="far fa-hand-point-right"></i>
[Learn](../index.md)

