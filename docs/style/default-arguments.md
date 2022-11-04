---
author: Stevan Apter
keywords: kdb+, q, style
---

# Defaulting the argument list


Functions of zero, one, two and three arguments:

```q
zero:{a+b}
one:{x+10}
two:{x+y}
three:{x+y%z}
```

**Be consistent in your use of `x`, `y`, and `z` to mean the first, second, and third arguments to a function.** 

If you don’t use the default pattern provided by q, avoid using these letters as local variables, or as arguments occupying other positions in the argument list. 
For example:

```q
ugh:{[y;x]
  …

urk:{[a;b]
  x:a+b;
  …
```

