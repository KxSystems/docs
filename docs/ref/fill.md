# `^` Fill




_Replace nulls_

Syntax: `x^y`, `^[x;y]`

Where `x` and `y` are conforming lists or dictionaries
returns `y` with any nulls replaced by the corresponding item of `x`.

```q
q)0^1 2 3 0N
1 2 3 0
q)100^1 2 -5 0N 10 0N
1 2 -5 100 10 100
q)1.0^1.2 -4.5 0n 0n 15
1.2 -4.5 1 1 15
q)`nobody^`tom`dick``harry
`tom`dick`nobody`harry
q)1 2 3 4 5^6 0N 8 9 0N
6 2 8 9 5
```

Integer `x` items are promoted when `y` is float or real.

```q
q)a:11.0 2.1 3.1 0n 4.5 0n
q)type a
9h
q)10^a
11 2.1 3.1 10 4.5 10
q)type 10^a
9h
```

When `x` and `y` are dictionaries, both null and missing values in `y` are filled with those from `x`.

```q
q)(`a`b`c!1 2 3)^`b`c!0N 30
a| 1
b| 2
c| 30
```

<i class="far fa-hand-point-right"></i> 
[`^` Coalesce](coalesce.md) where `x` and `y` are keyed tables 


