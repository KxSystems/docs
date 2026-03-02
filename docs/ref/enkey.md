---
title: Enkey, Unkey – Reference – KDB-X and q documentation
description: Enkey and Unkey are q operators that respectively convert a simple tableto a keyed table and vice-versa.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: bang, enkey, KDB-X, keyed table, q, table, Unkey
---
# `!` Enkey, Unkey

_Simple to keyed table and vice-versa_




## `!` Enkey

_Make a keyed table from a simple table._

```syntax
i!t    ![i;t]
```

Where

-   `i` is a **positive integer**
-   `t` is a **simple table**, or a handle to one

returns `t` with the first `i` columns as key
```q
q)t:([]a:1 2 3;b:10 20 30;c:`x`y`z)
q)2!t
a b | c
----| -
1 10| x
2 20| y
3 30| z
```


## `!` Unkey

_Remove the key/s from a table._

```syntax
0!t    ![0;t]
```

Where `t` is a **keyed table**, or a handle to one, returns `t` as a simple table, with no keys.
```q
q)t:([a:1 2 3]b:10 20 30;c:`x`y`z)
q)0!t
a b  c
------
1 10 x
2 20 y
3 30 z
```


## Amending in place

For both Enkey and Unkey, if `t` is a table-name, `!` amends the table and returns the name.

```q
q)t:([a:1 2 3]b:10 20 30;c:`x`y`z)
q)0!`t
`t
q)t
a b  c
------
1 10 x
2 20 y
```

----

[`key`](key.md)
<br>

[`keys`](keys.md),
[`xkey`](keys.md#xkey)
<br>

[`!` bang](overloads.md#bang) overloads
<br>

[Tables](faq.md)