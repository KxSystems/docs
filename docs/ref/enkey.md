# `!` Enkey and Unkey


_Make a keyed table from a simple table.
Remove the key/s from a table._

## `!` Enkey

Syntax: `i!t`, `![i;t]` 

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

Syntax: `0!t`, `![0;t]` 

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


<i class="far fa-hand-point-right"></i> 
[Keys](/basics/keys), 
[`key`](key), 
[`keys`](keys), 
[`xkey`](xkey), 
[`!`](overloads/#bang)