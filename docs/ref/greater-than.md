---
title: Greater Than, At Least – Reference – kdb+ and q documentation
description: Greater Than and At Least are q operators that compare their arguments.
author: Stephen Taylor
keywords: comparison, greater-than, greater-than-or-equal, kdb+, q
---
# `>` Greater Than <br>`>=` At Least



```txt
x > y    >[x;y]
x >= y   >=[x;y]
```

Returns `1b` where the underlying value of `x` is greater than (or at least) that of `y`.

```q
q)(3;"a")>(2 3 4;"abc")
100b
000b
q)(3;"a")>=(2 3 4;"abc")
110b
100b
```

With booleans:

```q
q)0 1 >/:\: 0 1
00b
10b
q)0 1 >=/:\: 0 1
10b
11b
```


## Implicit iteration

Greater Than and At Least are [atomic functions](../basics/atomic.md).

```q
q)(10;20 30)>(50 -20;5)
01b
11b
```

They apply to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).

```q
q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 -21 3;4 5 -6)

q)d>=5
a| 100b
b| 010b

q)t>5
a b
---
1 0
0 0
0 0

q)k>5
k  | a b
---| ---
abc| 1 0
def| 0 0
ghi| 0 0
```


## Range and domain

```txt
    b g x h i j e f c s p m d z n u v t
----------------------------------------
b | b . b b b b b b b . b b b b b b b b
g | . b . . . . . . . . . . . . . . . .
x | b . b b b b b b b . b b b b b b b b
h | b . b b b b b b b . b b b b b b b b
i | b . b b b b b b b . b b b b b b b b
j | b . b b b b b b b . b b b b b b b b
e | b . b b b b b b b . b b b b b b b b
f | b . b b b b b b b . b b b b b b b b
c | b . b b b b b b b . b b b b b b b b
s | . . . . . . . . . b . . . . . . . .
p | b . b b b b b b b . b b b b b b b b
m | b . b b b b b b b . b b b . . . . .
d | b . b b b b b b b . b b b b . . . .
z | b . b b b b b b b . b . b b b b b b
n | b . b b b b b b b . b . . b b b b b
u | b . b b b b b b b . b . . b b b b b
v | b . b b b b b b b . b . . b b b b b
t | b . b b b b b b b . b . . b b b b b
```

Range: `b`


----
:fontawesome-solid-book:
[Less Than, Up To](less-than.md)
<br>
:fontawesome-solid-book-open:
[Comparison](../basics/comparison.md)
