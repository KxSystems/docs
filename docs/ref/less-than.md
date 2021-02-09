---
title: Less Than, Up To – Reference – kdb+ and q documentation
description: Less Than and Up To are q operators that compare the values of their arguments.
author: Stephen Taylor
keywords: comparison, kdb+, less-than, less-than-or-equal, q, up to
---
# `<` Less Than<br>`<=` Up To



```txt
x < y    <[x;y]
x <= y   x<=[x;y]
```

Returns `1b` where the underlying value of `x` is less than (or up to) that of `y`.

```q
q)(3;"a")<(2 3 4;"abc")
001b
000b
q)(3;"a")<=(2 3 4;"abc")
011b
111b
```

With booleans:

```q
q)0 1 </:\: 0 1
01b
00b
q)0 1 <=/:\: 0 1
11b
01b
```


## Implicit iteration

Less Than and Up To are [atomic functions](../basics/atomic.md).

```q
q)(10;20 30)<(50 -20;5)
10b
00b
```

They apply to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).

```q
q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 -21 3;4 5 -6)

q)d<=5
a| 011b
b| 111b

q)t<5
a b
---
0 1
1 0
1 1

q)k<5
k  | a b
---| ---
abc| 0 1
def| 1 0
ghi| 1 1
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
[Greater Than, At Least](greater-than.md)
<br>
:fontawesome-solid-book-open:
[Comparison](../basics/comparison.md)
