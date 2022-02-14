---
author: Stevan Apter
keywords: kdb+, q, style
---

# Parentheses


Avoid unnecessary parentheses. The grammar of q is simple and there is no precedence order for the primitives. For example, the expression to multiply `a` by the sum of `b` and `c`:

```q
a*b+c
```

should not be written

```q
a*(b+c)
```

**Redundant parentheses are visual red herrings.**

Although extra parentheses are useful as training wheels, most q programmers eventually internalize q syntax. 

On encountering a parenthesized expression one assumes the parentheses are necessary.
Do not burden your reader with the task of discovering that they are not. 