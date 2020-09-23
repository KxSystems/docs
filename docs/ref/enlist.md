---
title: enlist – make a 1-item list | Reference | kdb+ and q documentation
description: enlist is a q keyword that makes a 1-list from its arguments.
author: Stephen taylor
---
# `enlist`

_Make a list._



```txt
enlist x    enlist[x]    enlist[x;y;z;…]
```

Returns a list with its argument/s as items.

The most common use is to make a 1-item list. 
An atom is not a one-item list. `enlist` and `first` convert between the two.

```q
q)a:10
q)b:enlist a
q)c:enlist b
q)type each (a;b;c)
-7 7 0h
q)a~b
0b
q)a~first b
1b
q)b~c
0b
q)b~first c
1b
```

The result has as many items as the keyword is applied to.

```q
q)show a:enlist[til 5;`ibm`goog;"hello"]
0 1 2 3 4
`ibm`goog
"hello"
q)count a
3
```

Unlike user-defined functions, `enlist` is not limited to 8 arguments.

```q
q)count b:enlist[0;`1;"two";3;`four;5;`6;"seven";8;`nine]
10
```

Where `x` is a dictionary, the result is a 1-item table.

```q
q)enlist `a`b`c!(1;2 3; 4)
a b   c
-------
1 2 3 4
```

!!! tip "Atoms to lists"

    To ensure all items in a list are themselves lists and not atoms, use `(),`, which leaves lists unchanged. 

    For example, `{(),x} each foo` converts any atoms in list `foo` into singleton lists.

!!! tip "Assign a 1-item list"

    While `enlist` returns a 1-item list, if all you need to do is assign it to a name not presently defined, you can exploit the fact that `foo,:` does not require `foo` to be defined.

    <pre><code class="language-q">
    q)a:enlist[3]
    q)b,:3
    q)a~b
    1b
    </code></pre>
