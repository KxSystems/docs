---
author: Stevan Apter
keywords: indentation, kdb+, layout, q, style
---

# Indentation


**Indent no more than two spaces within a function.**

```q
foo:{
  a:x+y;
  }
```

Similarly, within control statements, 

```q
if[v=floor n;
  v:()!()];

do[count x;
  a:til count x;
  b:(+/)a];

while[i<5;
  a:f[b;i];
  i:i+1];
```

**Cond statements may pair test and action expressions.**

```q
r::$[v>0;v+1;    / if v>0 increment v
    v<0;v-1;     / if v<0 decrement v
        v]       / if v=0 v
```

**Align lists and symbol-value pairs.**

```q
L:(1 2 3 4 5;
   `one`two`three`four`five)
D:(!/)flip(
           (`one;1);
           (`two;2);
           (`three;3);
           (`four;4);
           (`five;5))
```

Single-space indentation is acceptable.

```q
foo:{
 a:x+y
 :
```

